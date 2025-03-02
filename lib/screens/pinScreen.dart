/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'package:credential_manager/credential_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fusion_wallet/common_widgets/customNamPad.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_dot/pin_dot.dart';

class PinScreen extends StatefulWidget {
  final Function(String)? onPinConfirm;
  final Function(bool)? onBiometric;
  final bool isSignin;
  const PinScreen(
      {super.key,
      required this.onPinConfirm,
      required this.isSignin,
      this.onBiometric});
  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _pinController = TextEditingController();

  // late AnimationController _controller;

  final _errorMessage = ''.obs;

  AppController appController = Get.find<AppController>();

// Set text
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pinController.clear();

    if (widget.isSignin) {
      _checkCredentials();
    } else if (appController.enabledBiometric.value) {
      _checkBiometrics();
    }
  }

  Future<void> _checkBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    if (canAuthenticateWithBiometrics) {
      try {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Confirm your identity',
            options: const AuthenticationOptions(biometricOnly: true));
        widget.onBiometric?.call(didAuthenticate);
      } catch (e) {
        widget.onBiometric?.call(false);
      }
    }
  }

  _checkCredentials() async {
    final CredentialManager credentialManager = CredentialManager();
    if (!credentialManager.isSupportedPlatform) return;
    try {
      await credentialManager.init(
        preferImmediatelyAvailableCredentials: false,
      );

      Credentials credential = await credentialManager.getCredentials(
        fetchOptions: FetchOptionsAndroid(passwordCredential: true),
      );

      if (credential.passwordCredential == null) return;
      var pin = credential.passwordCredential!.password;
      if (pin == null) return;
      _pinController.text = pin;
      process_pin(pin);
    } on CredentialException catch (e) {
      // Handle the error
      print(e);
    }
  }

  void _showError() async {
    _errorMessage.value = "Invalid PIN";

    // Vibrate
    HapticFeedback.heavyImpact();

    // Shake animation
    try {
      // _controller.forward();
    } on TickerCanceled {
      // Animation was interrupted
    }
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  void process_pin(String pin) {
    var key = WalletContext.hashData(data: pin);
    appController.decryptMnemonic(key).then((data) {
      if (data == null) {
        _showError();
        _pinController.clear();
      } else {
        _errorMessage.value = '';
        widget.onPinConfirm?.call(data);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: primaryAltBackgroundColor.value,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getTranslated(context, "Enter PIN") ?? "Enter PIN",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getTranslated(context, "Enter PIN") ?? "Enter PIN",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: headingColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Column(
                      children: [
                        PinDot(
                          size: 17,
                          length: 6,
                          controller: _pinController,
                          inactiveColor: primaryAltBackgroundColor.value,
                          activeColor: primaryAltColor.value,
                          borderColor: _errorMessage.value.isNotEmpty
                              ? Colors.red
                              : primaryAltColor.value,
                        ),
                        if (_errorMessage.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _errorMessage.value,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontFamily: "dmsans",
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                Column(
                  children: [
                    CustomNumPad(
                      buttonSize: Get.width / 5,
                      delete: () {
                        if (_pinController.text.isNotEmpty) {
                          _pinController.text = _pinController.text
                              .substring(0, _pinController.text.length - 1);
                        }
                      },
                      onSubmit: () {
                        var pin = _pinController.text;
                        process_pin(pin);
                        // print("8888888888888888888888888888888");
                      },
                      controller: _pinController,
                      maxLength: 6,
                      onBiometric: () {
                        _checkBiometrics();
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            getTranslated(context, "Cancel") ?? "Cancel",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: primaryAltColor.value,
                              fontFamily: "dmsans",
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 66,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

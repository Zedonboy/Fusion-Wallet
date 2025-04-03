/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';

import 'package:universal_web/web.dart' as web;
import 'package:universal_web/js_interop.dart' as js;

import '../../constants/colors.dart';

class VerifyPassword extends StatefulWidget {
  const VerifyPassword({
    super.key, 
    this.onPasswordVerified,
    this.onBiometricVerified,
    this.autoTriggerBiometric = false,
  });
  
  final Function(String)? onPasswordVerified;
  final Function(bool)? onBiometricVerified;
  final bool autoTriggerBiometric;

  @override
  State<VerifyPassword> createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPassword> {
  TextEditingController passController = TextEditingController();
  var passError = ''.obs;
  var isVerifying = false.obs;
  bool canAuthenticateWithBiometrics = false;
  // final LocalAuthentication auth = LocalAuthentication();
  final appController = Get.find<AppController>();
  bool isDeviceSupported = false;
  
  @override
  void initState() {
    super.initState();
    checkBiometricAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(height: 60),
                    Text(
                      'Verify Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: headingColor.value,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 311,
                      child: Text(
                        'Please enter your password to continue.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: labelColorPrimaryShade.value,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    InputFieldPassword(
                      headerText: "",
                      hintText: "Password",
                      textController: passController,
                      onChange: (value) {
                        if (value != null && value != '') {
                          passError.value = '';
                        }
                      },
                    ),
                    CommonWidgets.showErrorMessage(passError.value),
                  ],
                ),
                Column(
                  children: [
                    BottomRectangularBtn(
                      onTapFunc: () async {
                        verifyPassword();
                      },
                      btnTitle: "Verify",
                      isLoading: isVerifying.value,
                      isDisabled: isVerifying.value,
                    ),
                    SizedBox(height: 16),
                    if (appController.enabledBiometric.value)
                      TextButton(
                        onPressed: () {
                          checkBiometricAvailability();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fingerprint,
                              color: primaryAltColor.value,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Use Biometrics",
                              style: TextStyle(
                                color: primaryAltColor.value,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 32),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyPassword() async {
    if (passController.text.isEmpty) {
      passError.value = 'Please enter your password';
      return;
    }

    isVerifying.value = true;
    
    try {
      // Hash the password similar to PIN processing
      var key = WalletContext.hashData(data: passController.text);
      
      // Try to decrypt the mnemonic with the password
      var decryptedData = await appController.decryptMnemonic(key);
      
      if (decryptedData == null) {
        passError.value = 'Invalid password';
        HapticFeedback.heavyImpact(); // Provide haptic feedback for error
      } else {
        // Password verified successfully
        if (widget.onPasswordVerified != null) {
          widget.onPasswordVerified!(decryptedData);
        } else {
          Get.back(result: 'verified');
        }
      }
    } catch (e) {
      passError.value = 'Verification failed';
      print('Password verification error: $e');
    } finally {
      isVerifying.value = false;
    }
  }

  Future<void> checkBiometricAvailability() async {
    if (kIsWeb) {
      // For web platform, check if Credential Management API is available
      try {
        
        final cred = await web.window.navigator.credentials.get(web.CredentialRequestOptions(password: true, mediation: "required")).toDart;
        // Check if the Credential Management API is available in the browser
        if (cred != null) {
          final credData = cred as web.PasswordCredentialData;
          passController.text = credData.password;
          verifyPassword();
        }
      } catch (e) {
        print('Web Credential API support check error: $e');
      }
    } else {
     //
    }
  }
  
  @override
  void dispose() {
    passController.dispose();
    super.dispose();
  }
}
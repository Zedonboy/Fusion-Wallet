/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/createWallet/createWalletStep2.dart';
import 'package:fusion_wallet/screens/importFromSeed.dart';
import 'package:fusion_wallet/screens/pinCreateScreen.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordCreateScreen extends StatefulWidget {
  final WalletCreationType next_screen;

  const PasswordCreateScreen({super.key, required this.next_screen});

  @override
  State<PasswordCreateScreen> createState() => _PasswordCreateScreenState();
}

class _PasswordCreateScreenState extends State<PasswordCreateScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final appController = Get.find<AppController>();
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;
  var isCreating = false.obs;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handlePasswordSubmission() {
    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password cannot be empty';
      return;
    }
    
    if (passwordController.text.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
      return;
    }
    
    // Validate confirm password
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      return;
    }
    
    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      return;
    }
    
    // All validations passed
    isCreating.value = true;
    
    // Password created successfully
    showToast("Password Created Successfully");
    
    if (widget.next_screen == WalletCreationType.create) {
      Get.bottomSheet(
        clipBehavior: Clip.antiAlias,
        isScrollControlled: true,
        backgroundColor: primaryAltBackgroundColor.value,
        shape: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32),
            topLeft: Radius.circular(32)
          )
        ),
        secureYourWalletBottomSheet()
      );
    } else {
      Get.off(() => ImportFromSeed(
        pin: passwordController.text,
      ));
    }
    
    isCreating.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: primaryBackgroundColor.value,
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
                          getTranslated(context, "Create Password") ?? "Create Password",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getTranslated(context, "Secure your wallet") ?? "Secure your wallet",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: headingColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      getTranslated(context, "This password will unlock your wallet only on this device") ?? 
                      "This password will unlock your wallet only on this device",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Password field
                    InputFieldPassword(
                      headerText: getTranslated(context, "New Password") ?? "New Password",
                      hintText: getTranslated(context, "Enter password") ?? "Enter password",
                      textController: passwordController,
                      onChange: (value) {
                        if (value != null && value != '') {
                          passwordError.value = '';
                        }
                      },
                    ),
                    CommonWidgets.showErrorMessage(passwordError.value),
                    
                    const SizedBox(height: 16),
                    
                    // Confirm password field
                    InputFieldPassword(
                      headerText: getTranslated(context, "Confirm Password") ?? "Confirm Password",
                      hintText: getTranslated(context, "Confirm password") ?? "Confirm password",
                      textController: confirmPasswordController,
                      onChange: (value) {
                        if (value != null && value != '') {
                          confirmPasswordError.value = '';
                        }
                      },
                    ),
                    CommonWidgets.showErrorMessage(confirmPasswordError.value),
                  ],
                ),
                
                Spacer(),
                
                Column(
                  children: [
                    BottomRectangularBtn(
                      onTapFunc: _handlePasswordSubmission,
                      btnTitle: getTranslated(context, "Create") ?? "Create",
                      isLoading: isCreating.value,
                      isDisabled: isCreating.value,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        getTranslated(context, "Cancel") ?? "Cancel",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: primaryAltColor.value,
                          fontFamily: "dmsans",
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget secureYourWalletBottomSheet() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: shapeDecorationDarkColor.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Get.width,
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Secure Your Wallet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Stack(
            children: [
              SizedBox(
                height: 300,
                width: Get.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          "assets/images/Vector 2.png",
                          height: 90,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/Vector 1 (1).png",
                          height: 200,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: SizedBox(
                  height: 300,
                  width: Get.width,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/image-aspect-raito.png",
                        height: 200,
                        width: 200,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          SizedBox(
            width: 311,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        '''Don't risk losing your funds. protect your wallet by saving your ''',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'Seed Phrase',
                    style: TextStyle(
                      color: primaryAltColor.value,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: ' in a place you trust.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            width: 311,
            child: Text(
              '''It's the only way to recover your wallet if you get locked out of the app or get a new device.''',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: () {
              Get.back();
              Get.bottomSheet(
                clipBehavior: Clip.antiAlias,
                isScrollControlled: true,
                backgroundColor: primaryAltBackgroundColor.value,
                shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(32),
                        topLeft: Radius.circular(32))),
                seedPhraseBottomSheet(),
              );
            },
            child: Container(
              width: Get.width,
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: ShapeDecoration(
                color: primaryAltColor.value,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      color: textDarkColor.value,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0.09,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget seedPhraseBottomSheet() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: shapeDecorationDarkColor.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Get.width,
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'What is a "Seed Phrase"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          SizedBox(
            width: Get.width,
            child: Text(
              '''A seed phrase is a set of twelve words that contains all the information about your wallet, including your funds. It's like a secret code used to access your entire wallet.\n\nYou must keep your seed phrase secret and safe. If someone gets your seed phrase, they'll gain control over your accounts.\n\nSave it in a place where only you can access it.\nIf you lose it, not even MetaMask can help you recover it.''',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          GestureDetector(
            onTap: () {
              Get.off(() => CreaateWalletStep2(
                    password: passwordController.text,
                  ));
            },
            child: Container(
              width: Get.width,
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: ShapeDecoration(
                color: primaryAltColor.value,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Understood',
                    style: TextStyle(
                      color: textDarkColor.value,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0.09,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }

  // Optional: Add biometric setup similar to PinCreateScreen
  Future<void> enableBiometric(BuildContext context, bool val) async {
    final LocalAuthentication auth = LocalAuthentication();
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final isDeviceSupported = await auth.isDeviceSupported();
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    
    if (isDeviceSupported && canAuthenticateWithBiometrics) {
      try {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to enable biometric login',
          options: const AuthenticationOptions(
            useErrorDialogs: false, 
            stickyAuth: true
          ),
        ).then((value) async {
          if (value == true) {
            await sharedPref.setBool('FingerPrintEnable', val);
            setState(() {
              appController.enabledBiometric.value = val;
            });
          }
          return value;
        });
        
        await auth.stopAuthentication();
      } on PlatformException catch (e) {
        print('Biometric error: $e');
      }
    } else {
      await sharedPref.setBool('FingerPrintEnable', val);
      setState(() {
        appController.enabledBiometric.value = val;
      });
    }
  }
} 
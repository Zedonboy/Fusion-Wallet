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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fusion_wallet/common_widgets/bottomNavBar.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/deferred_prompt.dart' as deferred_prompt;
import 'package:fusion_wallet/screens/PasswordCreateScreen.dart';

import 'package:fusion_wallet/screens/VerifyPassword.dart';
import 'package:fusion_wallet/screens/pinCreateScreen.dart';
import 'package:fusion_wallet/screens/pinScreen.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
// import '../commonWidgets/bottomNav/bottomNavBar.dart';
// import '../commonWidgets/navCustom.dart';

const ONCHAIN_WEB = bool.fromEnvironment('ONCHAIN_WEB', defaultValue: false);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryAltBackgroundColor.value,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 100,
              ),
              Image.asset("assets/images/splash_banner.png"),
              // SvgPicture.asset("assets/svg/banner.svg"),
              Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        if (kIsWeb) {
                          Get.to(() => PasswordCreateScreen(next_screen: WalletCreationType.import));
                        } else {
                          Get.to(() => PinCreationScreen(
                              next_screen: WalletCreationType.import));
                        }
                      },
                      child: Container(
                        width: Get.width,
                        height: 48,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: ShapeDecoration(
                          color: cardcolor.value,
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
                              'Import Using Seed Phrase',
                              style: TextStyle(
                                color: primaryAltColor.value,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0.09,
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (kIsWeb) {
                          Get.to(() => PasswordCreateScreen(
                              next_screen: WalletCreationType.create,
                            ));
                        } else {
                          Get.to(() => PinCreationScreen(
                              next_screen: WalletCreationType.create,
                            ));
                        }
                      },
                      child: Container(
                        width: Get.width,
                        height: 48,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              'Create a New Wallet',
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
                      )),
                  SizedBox(height: 36),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  AppController appController = Get.find<AppController>();
  @override
  void initState() {
    appController.load();
    // TODO: implement initState
    super.initState();
    redirect();
  }

  redirect() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    final storage = FlutterSecureStorage();

    if (ONCHAIN_WEB && kIsWeb) {
      Get.offAll(() => deferred_prompt.OnchainSignInScreen());
      return;
    }

    if (await storage.containsKey(key: 'encrypted_mnemonic')) {
      if (kIsWeb) {
        Get.offAll(() => VerifyPassword(onPasswordVerified: (p0) {
              final wallet = Wallet.fromSeed(seedPhrase: p0);
              appController.active_wallet.value = wallet;

              Get.offAll(() => BottomBar());
        },));

      } else {
        Get.offAll(
          () => PinScreen(
            onPinConfirm: (p0) {
              final wallet = Wallet.fromSeed(seedPhrase: p0);
              appController.active_wallet.value = wallet;

              Get.offAll(() => BottomBar());
              // Get.offAll(() => HomeScreen());
            },
            // onBiometric: (didAuth) {},
            onBiometric: (didAuth, phrase) {
              if (didAuth) {
                final wallet = Wallet.fromSeed(seedPhrase: phrase!);
                appController.active_wallet.value = wallet;

                Get.offAll(() => BottomBar());
              }
            },
          ),
        );
      }
    } else {
      Get.offAll(() => SplashScreen());
    }

    // if (sharedPref.containsKey('FingerPrintEnable') &&
    //     sharedPref.getBool('FingerPrintEnable') == true) {

    // } else if (await storage.containsKey(key: 'password')) {
    //   Get.offAll(() => BottomBar());
    // } else {
    //   Get.offAll(() => SplashScreen());
    // }
    // Future.delayed(Duration(milliseconds: 500), () async {

    // });
  }

  @override
  Widget build(BuildContext context) {
    // return PinScreen();
    return Scaffold(
      backgroundColor: primaryAltBackgroundColor.value,
    );
  }
}

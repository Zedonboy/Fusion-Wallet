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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fusion_wallet/screens/openLink.dart';
import 'package:fusion_wallet/screens/resetApp.dart';
import 'package:fusion_wallet/screens/secretRecoveryPhrase.dart';
import 'package:fusion_wallet/screens/splashScreen.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fusion_wallet/controllers/deferred_prompt.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool userFaceId = true;
  bool isPasscode = true;

  final appController = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: [
            SizedBox(
              height: 16,
            ),
            Container(
              width: Get.width,
              height: 44,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0)),
              child: Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Settings',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 0.09,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              width: Get.width,
              padding: EdgeInsets.all(16),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: cardcolor.value,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFF242438)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Builder(builder: (context) {
                    if (ONCHAIN_WEB) {
                      return SizedBox.shrink();
                    } else {
                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     PageTransition(
                          //         duration: Duration(milliseconds: 100), type: PageTransitionType.topToBottom, child: SecretRecoveryPharase()));

                          Get.to(SecretRecoveryPharase());
                        },
                        child: Container(
                          height: 40,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: ShapeDecoration(
                                      color: Color(0x1970ECEF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(),
                                          child: SvgPicture.asset(
                                              "assets/svg/solar_key-broken.svg"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Show Secret Recovery Phrase',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: lightTextColor.value,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 0.12,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(),
                                child: Icon(Icons.arrow_forward_ios_outlined,
                                    size: 18, color: lightTextColor.value),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF242438),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Get.to(OpenLink(
                        url: 'https://github.com/Zedonboy/Fusion-Wallet/issues',
                        fromPage: 'Help & Support',
                      ));
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: ShapeDecoration(
                                  color: Color(0x1970ECEF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: SvgPicture.asset(
                                          "assets/svg/material-symbols_help-outline.svg"),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Help & Support',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: lightTextColor.value,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0.12,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Icon(Icons.arrow_forward_ios_outlined,
                                size: 18, color: lightTextColor.value),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF242438),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Get.to(OpenLink(
                        url: 'https://fusionwallet.me/',
                        fromPage: 'About',
                      ));
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: ShapeDecoration(
                                  color: Color(0x1970ECEF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: SvgPicture.asset(
                                          "assets/svg/arrow-3.svg"),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'About Fusion Wallet',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: lightTextColor.value,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0.12,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Icon(Icons.arrow_forward_ios_outlined,
                                size: 18, color: lightTextColor.value),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              width: Get.width,
              padding: EdgeInsets.all(16),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: cardcolor.value,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFF242438)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: cardcolor.value,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/svg/faceID.svg'),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Enable Biometric',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: lightTextColor.value,
                                        fontSize: 14,
                                        fontFamily: 'DM Sans',
                                        fontWeight: FontWeight.w400,
                                        height: 0.12,
                                      ),
                                    ),
                                    FlutterSwitch(
                                      width: 50.0,
                                      height: 25.0,
                                      valueFontSize: 20.0,
                                      toggleSize: 20.0,
                                      value:
                                          appController.enabledBiometric.value,
                                      borderRadius: 30.0,
                                      toggleColor: lightColor,
                                      activeColor: primaryAltColor.value,
                                      inactiveColor: labelColor.value,
                                      padding: 2.0,
                                      showOnOff: false,
                                      onToggle: (val) {
                                        appController.enabledBiometric.value =
                                            val;
                                        enableBiometric(context, val);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF242438),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Get.to(ResetApp(), transition: Transition.rightToLeft);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/resetApp.svg'),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: cardcolor.value,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Reset App',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFFFF5C5C),
                                          fontSize: 14,
                                          fontFamily: 'DM Sans',
                                          fontWeight: FontWeight.w400,
                                          height: 0.12,
                                        ),
                                      ),
                                      SizedBox(width: 142),
                                      Container(
                                        width: 24,
                                        height: 24,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(),
                                        child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 18,
                                            color: lightTextColor.value),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Builder(builder: (context) {
                    if (ONCHAIN_WEB) {
                      return GestureDetector(
                        onTap: () {
                         onchain_logout();
                        },
                        child: Row(
                          children: [
                           
                            Expanded(
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: cardcolor.value,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Logout',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFFFF5C5C),
                                              fontSize: 14,
                                              fontFamily: 'DM Sans',
                                              fontWeight: FontWeight.w400,
                                              height: 0.12,
                                            ),
                                          ),
                                          SizedBox(width: 142),
                                          Container(
                                            width: 24,
                                            height: 24,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(),
                                            child: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                size: 18,
                                                color: lightTextColor.value),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  enableBiometric(context, val) async {
    final LocalAuthentication auth = LocalAuthentication();
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final isDeviceSupported = await auth.isDeviceSupported();
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (isDeviceSupported && canAuthenticateWithBiometrics) {
      try {
        final bool didAuthenticate = await auth
            .authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(
              useErrorDialogs: false, stickyAuth: true),
        )
            .then((value) async {
          if (value == true) {
            await sharedPref.setBool('FingerPrintEnable', val);
            setState(() {
              appController.enabledBiometric.value = val;
            });
          }
          return value;
        });
        print('didAuth============$didAuthenticate');
        await auth.stopAuthentication();
      } on PlatformException catch (e) {
        print('ex============$e');
      }
    } else {
      await sharedPref.setBool('FingerPrintEnable', val);
      setState(() {
        appController.enabledBiometric.value = val;
      });
    }
  }
}

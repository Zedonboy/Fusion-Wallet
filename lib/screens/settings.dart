/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fusion_wallet/screens/NotificationSettingScreen.dart';
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
  final appController = Get.find<AppController>();
  
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Settings",
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
                SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      // Security Section
                      Container(
                        width: Get.width,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: inputFieldBackgroundColor2.value,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(width: 1, color: inputFieldBackgroundColor.value)
                        ),
                        child: Column(
                          children: [
                            // Secret Recovery Phrase
                            Builder(builder: (context) {
                              if (ONCHAIN_WEB) {
                                return SizedBox.shrink();
                              } else {
                                return Column(
                                  children: [
                                    _buildSettingItem(
                                      containerColor: appController.isDark.value ? Color(0xff1A2B56) : inputFieldBackgroundColor.value,
                                      iconAsset: "assets/images/solar_wallet-outline.png",
                                      title: "Show Secret Recovery Phrase",
                                      onTap: () => Get.to(SecretRecoveryPharase()),
                                      showToggle: false,
                                    ),
                                    _buildDivider(),
                                  ],
                                );
                              }
                            }),
                            
                            // Help & Support
                            _buildSettingItem(
                              containerColor: appController.isDark.value ? Color(0xff1A2B56) : inputFieldBackgroundColor.value,
                              iconAsset: "assets/images/helpandsupport.png",
                              title: "Help & Support",
                              onTap: () => Get.to(OpenLink(
                                url: 'https://github.com/Zedonboy/Fusion-Wallet/issues',
                                fromPage: 'Help & Support',
                              )),
                              showToggle: false,
                            ),
                            _buildDivider(),
                            
                            // About Fusion Wallet
                            _buildSettingItem(
                              containerColor: appController.isDark.value ? Color(0xff1A2B56) : inputFieldBackgroundColor.value,
                              iconAsset: "assets/images/aboutCryptoWallet.png",
                              title: "About Fusion Wallet",
                              onTap: () => Get.to(OpenLink(
                                url: 'https://fusionwallet.me/',
                                fromPage: 'About',
                              )),
                              showToggle: false,
                            ),
                            _buildDivider(),
                            
                            // Biometric Authentication
                            _buildSettingItem(
                              containerColor: appController.isDark.value ? Color(0xff1A2B56) : inputFieldBackgroundColor.value,
                              iconAsset: "assets/images/securityAndPrivacy.png",
                              title: "Enable Biometric",
                              showToggle: true,
                              toggleValue: appController.enabledBiometric.value,
                              onToggle: (val) {
                                appController.enabledBiometric.value = val;
                                enableBiometric(context, val);
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Notifications Section
                      Container(
                        width: Get.width,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: inputFieldBackgroundColor2.value,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(width: 1, color: inputFieldBackgroundColor.value)
                        ),
                        child: Column(
                          children: [
                            // OnChain Notifications
                            _buildSettingItem(
                              containerColor: appController.isDark.value ? Color(0xff1A2B56) : inputFieldBackgroundColor.value,
                              iconAsset: "assets/images/notifications.png",
                              title: "OnChain Notification Settings",
                              showToggle: false,
                              onTap: () => Get.to(NotificationSettingScreen(), transition: Transition.rightToLeft),
                            ),
                            _buildDivider(),
                            
                            // Reset App
                            _buildSettingItem(
                              containerColor: appController.isDark.value ? Color(0xff1A2B56) : inputFieldBackgroundColor.value,
                              // iconAsset: "assets/svg/resetApp.svg",
                              iconWidget: SvgPicture.asset("assets/svg/resetApp.svg", color: Color(0xFFFF5C5C)),
                              title: "Reset App",
                              titleColor: Color(0xFFFF5C5C),
                              onTap: () => Get.to(ResetApp(), transition: Transition.rightToLeft),
                              showToggle: false,
                              
                            ),
                            
                            // Logout (Web only)
                            Builder(builder: (context) {
                              if (ONCHAIN_WEB) {
                                return Column(
                                  children: [
                                    _buildDivider(),
                                    _buildSettingItem(
                                      containerColor: appController.isDark.value ? Color(0xff1A2B56) : inputFieldBackgroundColor.value,
                                      iconAsset: "assets/images/2fa.png",
                                      title: "Logout",
                                      titleColor: Color(0xFFFF5C5C),
                                      onTap: () => onchain_logout(),
                                      showToggle: false,
                                    ),
                                  ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    String? iconAsset,
    Widget? iconWidget,
    required String title,
    Color? titleColor,
    Color? containerColor,
    VoidCallback? onTap,
    bool showToggle = false,
    bool? toggleValue,
    Function(bool)? onToggle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        color: Colors.transparent,
        child: Row(
          children: [
            // Icon section
            if (iconWidget != null)
              iconWidget
            else if (iconAsset != null)
              Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: containerColor ?? (appController.isDark.value ? Color(0xff1A2B56) : inputFieldBackgroundColor.value),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Center(
                  child: Image.asset(
                    iconAsset,
                    color: appController.isDark.value ? Color(0xffA2BBFF) : headingColor.value,
                  ),
                ),
              ),
            SizedBox(width: 12),
            
            // Title section
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor ?? headingColor.value,
                  fontSize: 14,
                  fontFamily: 'dmsans',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            
            // Toggle or arrow section
            if (showToggle && toggleValue != null && onToggle != null)
              FlutterSwitch(
                activeColor: appController.isDark.value ? primaryBackgroundColor.value : primaryColor.value,
                inactiveColor: appController.isDark.value ? primaryBackgroundColor.value : headingColor.value,
                width: 40.0,
                toggleColor: appController.isDark.value ? Color(0xffA2BBFF) : primaryBackgroundColor.value,
                height: 20.0,
                valueFontSize: 10.0,
                toggleSize: 18.0,
                value: toggleValue,
                borderRadius: 16.0,
                padding: 2.0,
                showOnOff: false,
                onToggle: onToggle,
              )
            else
              Icon(
                Icons.arrow_forward_ios_outlined,
                size: 18,
                color: headingColor.value
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
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
      ],
    );
  }

  enableOnChainNotifications(context, val) async {
    FirebaseMessaging messaging_service = FirebaseMessaging.instance;

    if(Platform.isAndroid){
      final notificationPermission = await messaging_service.requestPermission(provisional: true);
      if(notificationPermission.authorizationStatus == AuthorizationStatus.authorized){
        final fcmToken = await messaging_service.getToken();
        
        print('notificationPermission============$notificationPermission');
      }
    }
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

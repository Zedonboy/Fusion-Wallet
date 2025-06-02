/**
 * Copyright (C) 2025 Fusion Wallet
 * 
 * This file is part of Fusion Wallet.
 * 
 * Fusion Wallet is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Fusion Wallet is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Fusion Wallet.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
// import 'package:fusion_wallet/controllers/deferred_prompt_web.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/src/rust/api/notification_service.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  var loading = false.obs;
  var app_permissions = <CanisterPermission>[].obs;
  final appController = Get.find<AppController>();
  // List<Map<String, dynamic>> appNotificationsx = [
  //   {
  //     "appName": "Uniswap",
  //     "domain": "app.uniswap.org",
  //     "status": "Enabled",
  //     "icon": "assets/images/uniswap.png",
  //     "lastNotification": "2 days ago"
  //   },
  //   {
  //     "appName": "OpenSea",
  //     "domain": "opensea.io",
  //     "status": "Enabled",
  //     "icon": "assets/images/opensea.png",
  //     "lastNotification": "5 hours ago"
  //   },
  //   {
  //     "appName": "Aave",
  //     "domain": "app.aave.com",
  //     "status": "Disabled",
  //     "icon": "assets/images/aave.png",
  //     "lastNotification": "1 week ago"
  //   },
  //   {
  //     "appName": "Compound",
  //     "domain": "app.compound.finance",
  //     "status": "Enabled",
  //     "icon": "assets/images/compound.png",
  //     "lastNotification": "3 days ago"
  //   },
  //   {
  //     "appName": "SushiSwap",
  //     "domain": "app.sushi.com",
  //     "status": "Disabled",
  //     "icon": "assets/images/sushiswap.png",
  //     "lastNotification": "2 weeks ago"
  //   },
  //   {
  //     "appName": "1inch",
  //     "domain": "app.1inch.io",
  //     "status": "Enabled",
  //     "icon": "assets/images/1inch.png",
  //     "lastNotification": "Yesterday"
  //   },
  // ];

  fetch_app_permissions() async {
    final service = appController.ic_service!.createNotificationService();
    loading.value = true;
    try {
      final permissions = await service.getCanisterPermissions();
      app_permissions.value = permissions;
    } catch (e) {
      print(e);
    } finally {
      loading.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (appController.notificationsEnabled.value) {
      fetch_app_permissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: primaryBackgroundColor.value,
          floatingActionButton: FloatingActionButton(
            onPressed: appController.notificationsEnabled.value
                ? () {
                    showAddPermissionBottomSheet(context);
                  }
                : () {
                    showToast("Please enable notifications first");
                  },
            backgroundColor: appController.notificationsEnabled.value
                ? primaryAltColor.value
                : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryAltBackgroundColor.value,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 16,
                                color: darkBlueColor.value,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "${getTranslated(context, "Notification Settings") ?? "Notification Settings"}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: darkBlueColor.value,
                              fontFamily: "dmsans",
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${getTranslated(context, appController.notificationsEnabled.value ? "On" : "Off") ?? (appController.notificationsEnabled.value ? "On" : "Off")}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: lightTextColor.value,
                              fontFamily: "dmsans",
                            ),
                          ),
                          SizedBox(width: 8),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: appController.notificationsEnabled.value,
                              onChanged: (value) async {
                                appController.notificationsEnabled.value =
                                    value;
                                if (!value) {
                                  var token = await FirebaseMessaging.instance
                                      .getToken();
                                  if (token != null) {
                                    try {
                                      await FirebaseMessaging.instance
                                          .deleteToken();
                                      final service = appController.ic_service!
                                          .createNotificationService();
                                      await service.removeDeviceToken(
                                          token: token);
                                    } catch (e) {
                                      print(e);
                                      showToast(
                                          "Failed revoke notification permission");
                                      appController.notificationsEnabled.value =
                                          !value;
                                    }
                                  }
                                  return;
                                }

                                try {
                                  final notification_settings =
                                      await FirebaseMessaging.instance
                                          .requestPermission(provisional: true);
                                  if (notification_settings
                                          .authorizationStatus !=
                                      AuthorizationStatus.authorized) {
                                    appController.notificationsEnabled.value =
                                        false;
                                    return;
                                  }
                                  var fcmtoken;
                                  if (Platform.isAndroid) {
                                    fcmtoken = await FirebaseMessaging.instance
                                        .getToken();
                                  } else if (kIsWeb) {
                                    fcmtoken = await FirebaseMessaging.instance
                                        .getToken(
                                            vapidKey:
                                                "BBINmbRDeR2QwM6PeLgWQHGQkYNWaTZcf6kYL4TpcL1EHLGh3t6ip4BLRAv_5FGiiyx_ioh07UaJAaDMj5KJGCU");
                                  } else if (Platform.isIOS) {
                                    fcmtoken = await FirebaseMessaging.instance
                                        .getAPNSToken();
                                  }

                                  final service = appController.ic_service!
                                      .createNotificationService();

                                  await service.addDeviceToken(
                                      token: fcmtoken!);

                                  fetch_app_permissions();
                                } catch (e) {
                                  appController.notificationsEnabled.value =
                                      !appController.notificationsEnabled.value;
                                  print(e);
                                }
                              },
                              activeColor: Colors.white,
                              activeTrackColor: Color(0xff0FC085),
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Text(
                          "${getTranslated(context, "Apps with notification permissions") ?? "Apps with notification permissions"}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: darkBlueColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (!appController.notificationsEnabled.value) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_off,
                                size: 48,
                                color: lightTextColor.value,
                              ),
                              SizedBox(height: 16),
                              Text(
                                getTranslated(context,
                                        "Notifications are disabled") ??
                                    "Notifications are disabled",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: darkBlueColor.value,
                                  fontFamily: "dmsans",
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                getTranslated(context,
                                        "Enable notifications to manage app permissions") ??
                                    "Enable notifications to manage app permissions",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: lightTextColor.value,
                                  fontFamily: "dmsans",
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (loading.value) {
                        return ListView.separated(
                          itemCount: 3,
                          padding: EdgeInsets.only(bottom: 20),
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 12);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return notificationSkeletonWidget();
                          },
                        );
                      }

                      if (app_permissions.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 48,
                                color: lightTextColor.value,
                              ),
                              SizedBox(height: 16),
                              Text(
                                getTranslated(context, "No app permissions") ??
                                    "No app permissions",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: darkBlueColor.value,
                                  fontFamily: "dmsans",
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                getTranslated(context,
                                        "Apps you grant notification permissions will appear here") ??
                                    "Apps you grant notification permissions will appear here",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: lightTextColor.value,
                                  fontFamily: "dmsans",
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: app_permissions.length,
                        padding: EdgeInsets.only(bottom: 20),
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 12);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          final permission = app_permissions[index];
                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    appOptionsBottomSheet(context, index),
                              );
                            },
                            child: Container(
                              width: Get.width,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: inputFieldBackgroundColor2.value,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      width: 1,
                                      color: inputFieldBackgroundColor.value)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: inputFieldBackgroundColor
                                                  .value,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                (permission.appInfo.name ??
                                                    "App")[0],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: darkBlueColor.value,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            "${permission.appInfo.name ?? "App"}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: darkBlueColor.value,
                                              fontFamily: "dmsans",
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Status indicator
                                      Container(
                                        height: 20,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        decoration: BoxDecoration(
                                            color: permission.enabled
                                                ? Color(0xff0FC085)
                                                : Color(0xffC03A0F),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: Text(
                                            "${permission.enabled ? "Enabled" : "Disabled"}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  primaryBackgroundColor.value,
                                              fontFamily: "dmsans",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 7),
                                  Divider(
                                      color: inputFieldBackgroundColor.value,
                                      height: 1,
                                      thickness: 1),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${getTranslated(context, "Domain") ?? "Domain"}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: lightTextColor.value,
                                              fontFamily: "dmsans",
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            "${permission.appInfo.domain ?? "Domain"}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: headingColor.value,
                                              fontFamily: "dmsans",
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${getTranslated(context, "Canister ID") ?? "Canister ID"}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: lightTextColor.value,
                                              fontFamily: "dmsans",
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            "${permission.canisterId ?? "Canister ID"}",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: headingColor.value,
                                              fontFamily: "dmsans",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void showProcessingDialog(String message) {
    Get.dialog(
      Dialog(
        backgroundColor: shapeDecorationDarkColor.value,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: primaryAltColor.value,
              ),
              SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget appOptionsBottomSheet(BuildContext context, int index) {
    final permission = app_permissions[index];
    bool isEnabled = permission.enabled;

    return Container(
      height: Get.height * 0.4,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      decoration: BoxDecoration(
        color: primaryBackgroundColor.value,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${permission.appInfo.name ?? "App"} ${getTranslated(context, "Options") ?? "Options"}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: headingColor.value,
                  fontFamily: "dmsans",
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.clear,
                  color: headingColor.value,
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                // Toggle notification option
                if (!isEnabled)
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      showProcessingDialog("Enabling Notifications..");

                      try {
                        final service = appController.ic_service!
                            .createNotificationService();
                        service.updateAppPermission(
                            appId: permission.canisterId, permission: true);

                        setState(() {
                          permission.enabled = true;
                        });
                      } catch (err) {
                        showToast("Failed to enable notifications");
                      } finally {
                        Get.back();
                      }
                    },
                    child: Container(
                      width: Get.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            width: 1, color: inputFieldBackgroundColor.value),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: primaryAltBackgroundColor.value,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.notifications_active,
                              color: Color(0xff0FC085),
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated(
                                          context, "Enable Notifications") ??
                                      "Enable Notifications",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: headingColor.value,
                                    fontSize: 13,
                                    fontFamily: 'dmsans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  getTranslated(context,
                                          "Allow this app to send you notifications") ??
                                      "Allow this app to send you notifications",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: lightTextColor.value,
                                    fontSize: 12,
                                    fontFamily: 'dmsans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Disable notification option
                if (isEnabled)
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      showProcessingDialog("Disabling Notifications..");

                      try {
                        final service = appController.ic_service!
                            .createNotificationService();
                        service.updateAppPermission(
                            appId: permission.canisterId, permission: false);

                        setState(() {
                          permission.enabled = false;
                        });
                      } catch (err) {
                        showToast("Failed to disable notifications");
                      } finally {
                        Get.back();
                      }
                    },
                    child: Container(
                      width: Get.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            width: 1, color: inputFieldBackgroundColor.value),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: primaryAltBackgroundColor.value,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.notifications_off,
                              color: Color(0xffC03A0F),
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated(
                                          context, "Disable Notifications") ??
                                      "Disable Notifications",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: headingColor.value,
                                    fontSize: 13,
                                    fontFamily: 'dmsans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  getTranslated(context,
                                          "Stop receiving notifications from this app") ??
                                      "Stop receiving notifications from this app",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: lightTextColor.value,
                                    fontSize: 12,
                                    fontFamily: 'dmsans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: 12),

                // Remove permission option
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: primaryBackgroundColor.value,
                          title: Text(
                            "Remove Permission",
                            style: TextStyle(
                              color: darkBlueColor.value,
                              fontFamily: "dmsans",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          content: Text(
                            "Are you sure you want to remove notification permissions for ${permission.appInfo.name ?? "App"}?",
                            style: TextStyle(
                              color: lightTextColor.value,
                              fontFamily: "dmsans",
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: lightTextColor.value,
                                  fontFamily: "dmsans",
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();

                                try {
                                  final service = appController.ic_service!
                                      .createNotificationService();
                                  service.removeAppPermission(
                                      appId: permission.canisterId);
                                } catch (err) {}

                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Remove",
                                style: TextStyle(
                                  color: Color(0xffC03A0F),
                                  fontFamily: "dmsans",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          width: 1, color: inputFieldBackgroundColor.value),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: primaryAltBackgroundColor.value,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: Color(0xffC03A0F),
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getTranslated(context, "Remove Permission") ??
                                    "Remove Permission",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xffC03A0F),
                                  fontSize: 13,
                                  fontFamily: 'dmsans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                getTranslated(context,
                                        "Remove this app's notification permissions completely") ??
                                    "Remove this app's notification permissions completely",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: lightTextColor.value,
                                  fontSize: 12,
                                  fontFamily: 'dmsans',
                                  fontWeight: FontWeight.w400,
                                ),
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
        ],
      ),
    );
  }

  Widget notificationSkeletonWidget() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: inputFieldBackgroundColor2.value,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: inputFieldBackgroundColor.value),
      ),
      child: Skeletonizer(
        effect: ShimmerEffect(
          baseColor: Colors.grey.withOpacity(0.8),
          highlightColor: Colors.grey.withOpacity(0.5),
        ),
        enabled: true,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: inputFieldBackgroundColor.value,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      width: 100,
                      height: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
                Container(
                  width: 60,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 7),
            Divider(
                color: inputFieldBackgroundColor.value,
                height: 1,
                thickness: 1),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 12,
                      color: Colors.white,
                    ),
                    SizedBox(height: 3),
                    Container(
                      width: 120,
                      height: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 80,
                      height: 12,
                      color: Colors.white,
                    ),
                    SizedBox(height: 3),
                    Container(
                      width: 60,
                      height: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showAddPermissionBottomSheet(BuildContext context) {
    final canisterIdController = TextEditingController();
    final nameController = TextEditingController();
    final domainController = TextEditingController();
    final iconUrlController = TextEditingController();
    var isAdding = false.obs;
    var isExpanded = false.obs;

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.8,
        ),
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        decoration: BoxDecoration(
          color: primaryBackgroundColor.value,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, "Add Permission") ??
                        "Add Permission",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: headingColor.value,
                      fontFamily: "dmsans",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.clear,
                      color: headingColor.value,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              InputFields(
                headerText:
                    getTranslated(context, "Canister ID") ?? "Canister ID",
                hintText: getTranslated(context, "Enter Canister ID") ??
                    "Enter Canister ID",
                hasHeader: true,
                textController: canisterIdController,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                child: Text(
                  "By adding a Canister ID, you authorize this canister to send onchain push notifications to this device",
                  style: TextStyle(
                    fontSize: 12,
                    color: lightTextColor.value,
                    fontFamily: "dmsans",
                  ),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  isExpanded.value = !isExpanded.value;
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: primaryAltBackgroundColor.value,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: inputFieldBackgroundColor.value,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Additional App Information (Optional)",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: headingColor.value,
                          fontFamily: "dmsans",
                        ),
                      ),
                      Icon(
                        isExpanded.value
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: headingColor.value,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: isExpanded.value ? null : 0,
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          InputFields(
                            headerText: "App Name",
                            hintText: "Enter app name",
                            hasHeader: true,
                            textController: nameController,
                          ),
                          SizedBox(height: 16),
                          InputFields(
                            headerText: "Domain",
                            hintText: "Enter domain (e.g., app.example.com)",
                            hasHeader: true,
                            textController: domainController,
                          ),
                          SizedBox(height: 16),
                          InputFields(
                            headerText: "Icon URL",
                            hintText: "Enter icon URL",
                            hasHeader: true,
                            textController: iconUrlController,
                          ),
                        ],
                      ),
                    ),
                  )),
              SizedBox(height: 32),
              Obx(() => BottomRectangularBtn(
                    onTapFunc: () async {
                      if (canisterIdController.text.isEmpty) {
                        showToast("Please enter a Canister ID");
                        return;
                      }

                      isAdding.value = true;
                      try {
                        final service = appController.ic_service!
                            .createNotificationService();
                        await service.updateAppPermission(
                          appId: canisterIdController.text,
                          permission: true,
                        );
                        Get.back();
                        fetch_app_permissions();
                        showToast("Permission added successfully");
                      } catch (e) {
                        showToast("Failed to add permission");
                      } finally {
                        isAdding.value = false;
                      }
                    },
                    btnTitle: getTranslated(context, "Add Permission") ??
                        "Add Permission",
                    isLoading: isAdding.value,
                    isDisabled: isAdding.value,
                  )),
              SizedBox(height: 32),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'dart:async';
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/common_widgets/PulsatingBattery.dart';
import 'package:fusion_wallet/common_widgets/backupWidget.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/extensions.dart';
import 'package:fusion_wallet/controllers/uri_handler.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/CanisterMetricScreen.dart';
import 'package:fusion_wallet/screens/NotificationScreen.dart';
import 'package:fusion_wallet/screens/PosScreen.dart';
import 'package:fusion_wallet/screens/QRcodeScreen.dart';
import 'package:fusion_wallet/screens/importCanister.dart';
import 'package:fusion_wallet/screens/receiveScreen.dart';
import 'package:fusion_wallet/screens/selectToken.dart';
import 'package:fusion_wallet/screens/sendScreens/sendScreen.dart';
import 'package:fusion_wallet/screens/splashScreen.dart';
import 'package:fusion_wallet/screens/tokenScreen.dart';
import 'package:fusion_wallet/screens/tokenScreenOption/option.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:fusion_wallet/types/UpdateChecker.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import 'package:fusion_wallet/controllers/deferred_prompt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_widgets/inputField.dart';

// import '../nfts/nftsScreen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  var isVisible = false.obs;
  var isBackupReminderVisible = true.obs;

  Worker? _worker;
  Worker? _worker2;
  StreamSubscription<RemoteMessage>? _messageStream;

  static const List<Tab> myTabs = <Tab>[
    Tab(
      child: Text(
        'Tokens',
        style: TextStyle(
          color: Color(0xff5C87FF),
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          height: 0.08,
        ),
      ),
    ),
    Tab(
      child: Text(
        'Canisters',
        style: TextStyle(
          color: Color(0xff5C87FF),
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          height: 0.08,
        ),
      ),
    ),
  ];

  late TabController _tabController;

  AppController appController = Get.find<AppController>();

 

  void _handleInitialMessage(RemoteMessage message) {

  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleInitialMessage(initialMessage);
    }
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    _messageStream = FirebaseMessaging.onMessageOpenedApp.listen(_handleInitialMessage);
    
  }

  @override
  void dispose() {
    super.dispose();
    _worker?.dispose();
    _worker2?.dispose();
    _messageStream?.cancel();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);

    print( "Notifications: ${appController.new_notification.value}");

    setupInteractedMessage();

    _worker = ever(appController.new_notification, (data) {
      print( "Notifications: $data");
      setState(() {
        
      });
    });

    _worker2 = ever(appController.token_data_map, (data) {
      print( "Token Data Map: $data");
      setState(() {
        
      });
    });

    final app_links = AppLinks();


    app_links.uriLinkStream.listen((uri) {
      handle_uri_path(uri);
    });



    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      final notify_service =
          appController.ic_service!.createNotificationService();
      try {
        await notify_service.addDeviceToken(token: token);
      } catch (e) {
        print("Error: $e");
      }
      // print("Token: $token");
    });



    if (!kIsWeb) {
      UpdateChecker.checkForUpdate(context);
      appController.check_token_balances();
    }
  }

  String calc_total_worth() {
    // Get AppController instance
    final appController = Get.find<AppController>();

    double totalWorth = 0.0;

    // Iterate through all tokens
    for (var token in appController.tokens_map.values) {
      final tokenData = appController.token_data_map[token.tokenAddress];
      if (tokenData != null) {
        // Skip if we have invalid price data
        if (tokenData.price == null || tokenData.price! <= 0) continue;

        // Convert balance to decimal value considering token decimals
        double decimalAmount =
            tokenData.balance.toDouble() / pow(10, token.tokenDecimal ?? 8);

        // Calculate worth for this token and add to total
        totalWorth += decimalAmount * (tokenData.price ?? 0);
      }
    }

    // Format the total worth
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 6,
    );

    String formatted = formatter.format(totalWorth);

    // Remove trailing zeros after decimal
    if (formatted.contains('.')) {
      var parts = formatted.split('.');
      var cents = parts[1].replaceAll(RegExp(r'0+$'), '');

      if (cents.isEmpty) {
        return parts[0];
      }
      return '${parts[0]}.$cents';
    }

    return formatted;
  }

  void show_dialog(String message){
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

  @override
  Widget build(BuildContext context) {
    if (appController.active_wallet.value == null) {
      showToast("No active Account");
      Get.back();
      return SizedBox();
    }

    var addr = appController.active_wallet.value!.toIcpPrincipal();

    return Obx(() => Scaffold(
          backgroundColor: primaryBackgroundColor.value,
          body: SafeArea(
              child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 22, vertical: 20),
                          child: Column(
                            children: [
                              // SizedBox(height: 40,),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      copyToClipboard(addr).then((value) => {
                                            showToast(
                                                "Principal Copied Successfully")
                                          });
                                      // Get.to(SettingsScreen());
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.all(2),
                                            child: Text(
                                              address_shortener(addr),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: headingColor.value,
                                                  fontFamily: "dmsans"),
                                            )),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        // Icon(
                                        //   Icons.keyboard_arrow_down,
                                        //   color: headingColor.value,
                                        // )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          isVisible.value == true
                                              ? isVisible.value = false
                                              : isVisible.value = true;
                                        },
                                        child: Container(
                                          height: 32,
                                          width: 32,
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: appController
                                                          .isDark.value ==
                                                      true
                                                  ? Color(0xff1A2B56)
                                                  : inputFieldBackgroundColor
                                                      .value,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: isVisible == true
                                              ? Icon(
                                                  Icons.visibility_outlined,
                                                  color: headingColor.value,
                                                  size: 17,
                                                )
                                              : SvgPicture.asset(
                                                  "assets/svgs/hideBalance.svg",
                                                  color: appController
                                                              .isDark.value ==
                                                          true
                                                      ? Color(0xffA2BBFF)
                                                      : headingColor.value),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      InkWell(
                                          onTap: () {
                                           
                                            Get.to(() => NotificationScreen());
                                          },
                                          child: Container(
                                            height: 32,
                                            width: 32,
                                            // padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: appController
                                                            .isDark.value ==
                                                        true
                                                    ? Color(0xff1A2B56)
                                                    : inputFieldBackgroundColor
                                                        .value,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: Icon(
                                                    Icons
                                                        .notifications_none_outlined,
                                                    color: appController
                                                                .isDark.value ==
                                                            true
                                                        ? Color(0xffA2BBFF)
                                                        : headingColor.value,
                                                    size: 20,
                                                  ),
                                                ),
                                                appController
                                                    .new_notification.value ?
                                                  Positioned(
                                                    right: 0,
                                                    top: 0,
                                                    child: Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ) : SizedBox.shrink(),
                                              ],
                                            ),
                                          )),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Builder(builder: (context) {
                                        if (ONCHAIN_WEB &&
                                            appController
                                                    .onchain_wallet_canister_metric !=
                                                null) {
                                          final metric = appController
                                              .onchain_wallet_canister_metric;

                                          final cyclesBalance =
                                              metric!.cyclesBalance;
                                          final formattedCycles =
                                              normalizeBalance(
                                                  cyclesBalance, 12);

                                          final cycle_decimal =
                                              double.parse(formattedCycles);

                                          var battery_widget;
                                          var pulsate = false;
                                          if (cycle_decimal >= 3.5) {
                                            battery_widget = Icon(
                                              Icons.battery_full,
                                              color: Colors.green,
                                              size: 32,
                                            );
                                          } else if (cycle_decimal >= 3.0) {
                                            battery_widget = Icon(
                                              Icons.battery_5_bar,
                                              color: Colors.lime,
                                              size: 32,
                                            );
                                          } else if (cycle_decimal >= 2.5) {
                                            battery_widget = Icon(
                                              Icons.battery_4_bar,
                                              color: Colors.yellow,
                                              size: 32,
                                            );
                                          } else if (cycle_decimal >= 2.0) {
                                            battery_widget = Icon(
                                              Icons.battery_3_bar,
                                              color: Colors.orange,
                                              size: 32,
                                            );
                                          } else if (cycle_decimal >= 1.5) {
                                            battery_widget = Icon(
                                              Icons.battery_2_bar,
                                              color: Colors.red,
                                              size: 32,
                                            );
                                            pulsate = true;
                                          } else if (cycle_decimal >= 1.0) {
                                            battery_widget = Icon(
                                              Icons.battery_1_bar,
                                              color: Colors.red,
                                              size: 32,
                                            );
                                            pulsate = true;
                                          } else {
                                            battery_widget = Icon(
                                              Icons.battery_0_bar,
                                              color: Colors.red,
                                              size: 32,
                                            );
                                            pulsate = true;
                                          }

                                          // Create a widget that will display the battery icon horizontally
                                          // If pulsate is true, we'll add a pulsating animation
                                          Widget batteryIndicator;

                                          // Rotate the battery icon to lie horizontally
                                          final rotatedBatteryIcon =
                                              Transform.rotate(
                                            angle: -pi /
                                                2, // Rotate 90 degrees counter-clockwise
                                            child: battery_widget,
                                          );

                                          if (pulsate) {
                                            // Use a simple opacity animation for pulsating effect
                                            batteryIndicator =
                                                PulsingBatteryIcon(
                                                    battery:
                                                        rotatedBatteryIcon);
                                          } else {
                                            batteryIndicator =
                                                rotatedBatteryIcon;
                                          }

                                          return InkWell(
                                            onTap: () {
                                              Get.to(() => CanisterMetricScreen(
                                                  canisterMetric: metric));
                                            },
                                            child: batteryIndicator,
                                          );
                                        }

                                        return SizedBox.shrink();
                                      }),
                                      
                                      InkWell(
                                          onTap: () async {
                                            final url = await Get.to(() => QRcodeScreen());
                                            if (url != null) {
                                              
                                              final uri = Uri.parse(url);
                                              if(uri.scheme != "fusion"){
                                                showToast("Invalid QR Code");
                                                return;
                                              }
                                              await handle_uri_path(uri);
                                            } else {
                                              showToast("Invalid QR Code");
                                            }
                                          },
                                          child: Container(
                                            height: 32,
                                            width: 32,
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: appController
                                                            .isDark.value ==
                                                        true
                                                    ? Color(0xff1A2B56)
                                                    : inputFieldBackgroundColor
                                                        .value,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: SvgPicture.asset(
                                                "assets/svgs/ion_qr-code.svg",
                                                color: appController
                                                            .isDark.value ==
                                                        true
                                                    ? Color(0xffA2BBFF)
                                                    : headingColor.value),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 32,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isVisible.value == true
                                      ? Text(
                                          "*****",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 56,
                                            fontWeight: FontWeight.w600,
                                            color: appController.isDark.value ==
                                                    true
                                                ? Color(0xffFDFCFD)
                                                : primaryAltColor.value,
                                            fontFamily: "dmsans",
                                          ),
                                        )
                                      : Text(
                                          calc_total_worth(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 50,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xffFDFCFD),
                                            fontFamily: "dmsans",
                                          ),
                                        ),
                                ],
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(
                                          clipBehavior: Clip.antiAlias,
                                          isScrollControlled: true,
                                          backgroundColor:
                                              appController.isDark.value == true
                                                  ? Color(0xffA2BBFF)
                                                  : primaryAltBackgroundColor
                                                      .value,
                                          shape: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(32),
                                                  topLeft:
                                                      Radius.circular(32))),
                                          selectToken(
                                        onSelect: (p0) {
                                          Get.back();
                                          Get.to(() => SendScreen(token: p0));
                                        },
                                      ));
                                      // Get.to(SelectTokenScreen());
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 56,
                                          width: 56,
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              color: Color(0xFF1A2B56),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Center(
                                              child: SvgPicture.asset(
                                                  "assets/svgs/sendIcon.svg",
                                                  height: 28,
                                                  width: 28,
                                                  color: appController
                                                              .isDark.value ==
                                                          true
                                                      ? Color(0xFFA2BBFF)
                                                      : primaryAltBackgroundColor
                                                          .value)),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          getTranslated(context, "Send") ??
                                              "Send",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: appController.isDark.value ==
                                                    true
                                                ? Color(0xffFDFCFD)
                                                : primaryAltColor.value,
                                            fontFamily: "dmsans",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(
                                          clipBehavior: Clip.antiAlias,
                                          isScrollControlled: true,
                                          backgroundColor:
                                              appController.isDark.value == true
                                                  ? Color(0xffA2BBFF)
                                                  : primaryAltBackgroundColor
                                                      .value,
                                          shape: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(32),
                                                  topLeft:
                                                      Radius.circular(32))),
                                          selectToken(onSelect: (token) {
                                        Get.back();
                                        var addr = appController
                                            .active_wallet.value
                                            ?.toIcpPrincipal();

                                        if (addr == null) {
                                          showToast(
                                              "No Address or Principal ID found");
                                          return;
                                        }
                                        Get.to(ReceiveScreen(
                                            token: token, address: addr));
                                      }));
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 56,
                                          width: 56,
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              color:
                                                  appController.isDark.value ==
                                                          true
                                                      ? Color(0xFF1A2B56)
                                                      : primaryAltColor.value,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Center(
                                              child: SvgPicture.asset(
                                                  "assets/svgs/receiveicon.svg",
                                                  height: 28,
                                                  width: 28,
                                                  color: appController
                                                              .isDark.value ==
                                                          true
                                                      ? Color(0xFFA2BBFF)
                                                      : primaryAltBackgroundColor
                                                          .value)),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          getTranslated(context, "Receive") ??
                                              "Receive",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: appController.isDark.value ==
                                                    true
                                                ? Color(0xffFDFCFD)
                                                : primaryAltColor.value,
                                            fontFamily: "dmsans",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(
                                          clipBehavior: Clip.antiAlias,
                                          isScrollControlled: true,
                                          backgroundColor:
                                              appController.isDark.value == true
                                                  ? Color(0xffA2BBFF)
                                                  : primaryAltBackgroundColor
                                                      .value,
                                          shape: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(32),
                                                  topLeft:
                                                      Radius.circular(32))),
                                          selectToken(onSelect: (token) {
                                        Get.back();
                                        var addr = appController
                                            .active_wallet.value
                                            ?.toIcpPrincipal();

                                        if (addr == null) {
                                          showToast(
                                              "No Address or Principal ID found");
                                          return;
                                        }
                                        Get.to(() => PosScreen(token: token));
                                      }));
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 56,
                                          width: 56,
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              color:
                                                  appController.isDark.value ==
                                                          true
                                                      ? Color(0xFF1A2B56)
                                                      : primaryAltColor.value,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Center(
                                              child: SvgPicture.asset(
                                                  "assets/svgs/pos.svg",
                                                  height: 28,
                                                  width: 28,
                                                  color: appController
                                                              .isDark.value ==
                                                          true
                                                      ? Color(0xFFA2BBFF)
                                                      : primaryAltBackgroundColor
                                                          .value)),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          getTranslated(context, "PoS") ??
                                              "PoS",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: appController.isDark.value ==
                                                    true
                                                ? Color(0xffFDFCFD)
                                                : primaryAltColor.value,
                                            fontFamily: "dmsans",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     // Get.bottomSheet(
                                  //     //     clipBehavior: Clip.antiAlias,
                                  //     //     isScrollControlled: true,
                                  //     //     backgroundColor: primaryAltBackgroundColor.value,
                                  //     //     shape: OutlineInputBorder(
                                  //     //         borderSide: BorderSide.none,
                                  //     //         borderRadius: BorderRadius.only(
                                  //     //             topRight: Radius.circular(32),
                                  //     //             topLeft: Radius.circular(32))),
                                  //     //     selectTokenForBuy());
                                  //   },
                                  //   child: Column(
                                  //     children: [
                                  //       Container(
                                  //         height: 56,
                                  //         width: 56,
                                  //         padding: EdgeInsets.all(16),
                                  //         decoration: BoxDecoration(
                                  //             color: appController.isDark.value == true
                                  //                 ? Color(0xFF1A2B56)
                                  //                 : primaryAltColor.value,
                                  //             borderRadius: BorderRadius.circular(15)),
                                  //         child: Center(
                                  //             child: SvgPicture.asset(
                                  //           "assets/svgs/bolt.svg",
                                  //           height: 28,
                                  //           width: 28,
                                  //           color: appController.isDark.value == true
                                  //               ? Color(0xFFA2BBFF)
                                  //               : primaryAltBackgroundColor.value,
                                  //         )),
                                  //       ),
                                  //       SizedBox(
                                  //         height: 12,
                                  //       ),
                                  //       Text(
                                  //         getTranslated(context, "Fusion") ?? "Fusion",
                                  //         textAlign: TextAlign.start,
                                  //         style: TextStyle(
                                  //           fontSize: 16,
                                  //           fontWeight: FontWeight.w600,
                                  //           color: appController.isDark.value == true
                                  //               ? Color(0xffFDFCFD)
                                  //               : primaryAltColor.value,
                                  //           fontFamily: "dmsans",
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),

                              if (kIsWeb &&
                                  deferredPrompt != null &&
                                  isBackupReminderVisible.value)
                                BackupReminderWidget(onClose: () {
                                  isBackupReminderVisible.value = false;
                                }),

                              // Expanded(
                              //     child: TabBarView(
                              //   // physics: NeverScrollableScrollPhysics(),
                              //   controller: _tabController,
                              //   children: [tokenTab(), canisterTab()],
                              // ))
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            tabs: myTabs,
                            controller: _tabController,
                            dividerColor: primaryAltBackgroundColor.value,
                            indicatorColor: primaryColor.value,
                          ),
                        ),
                        pinned: true,
                      )
                    ];
                  },
                  // padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                  body: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 0),
                    child: TabBarView(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                            key: PageStorageKey("tokenTab"), child: tokenTab()),
                        SingleChildScrollView(
                            key: PageStorageKey("canisterTab"),
                            child: canisterTab())
                      ],
                    ),
                  ))),
        ));
  }

  Widget canisterTab() {
    return Column(
      children: [
        Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(),
              GestureDetector(
                onTap: () {
                  Get.to(ImportCanister());
                },
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '+ Add Canister',
                        style: TextStyle(
                          color: primaryColor.value,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() => appController.canister_map.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: appController.canister_map.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 12,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  final canister =
                      appController.canister_map.values.elementAt(index);
                  return Container(
                      height: 72,
                      width: Get.width,
                      // padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: inputFieldBackgroundColor2.value,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(width: 1, color: primaryAltBgColor2)),
                      child: Material(
                          clipBehavior: Clip.antiAlias,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                              onTap: () {
                                Get.to(() => CanisterMetricScreen(
                                    canisterMetric: canister));
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    // Status indicator
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: canister.status.toLowerCase() ==
                                                "running"
                                            ? Color(
                                                0xff56CDAD) // Green for running
                                            : canister.status.toLowerCase() ==
                                                    "stopping"
                                                ? Color(
                                                    0xff9E9E9E) // Grey for stopping
                                                : Color(
                                                    0xffE53935), // Red for stopped
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        canister.canisterName ?? canister.canisterId,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: appController
                                                                      .isDark
                                                                      .value ==
                                                                  true
                                                              ? Color(
                                                                  0xffFDFCFD)
                                                              : primaryAltColor
                                                                  .value,
                                                          fontFamily: "dmsans",
                                                        ),
                                                      ),
                                                      Text(
                                                        canister.status,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: canister.status
                                                                      .toLowerCase() ==
                                                                  "running"
                                                              ? Color(
                                                                  0xff56CDAD) // Green for running
                                                              : canister.status
                                                                          .toLowerCase() ==
                                                                      "stopping"
                                                                  ? Color(
                                                                      0xff9E9E9E) // Grey for stopping
                                                                  : Color(
                                                                      0xffE53935), // Red for stopped
                                                          fontFamily: "dmsans",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Memory: ${formatBytes(canister.memorySize)}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              lightAltTextColor
                                                                  .value,
                                                          fontFamily: "dmsans",
                                                        ),
                                                      ),
                                                      Text(
                                                        "Cycles: ${normalizeBalance(canister.cyclesBalance, 12, maxDecimalPlaces: 2)}T",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Color(0xff56CDAD),
                                                          fontFamily: "dmsans",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ))));
                },
              )),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.code,
            size: 60,
            color: lightAltTextColor.value.withOpacity(0.5),
          ),
          SizedBox(height: 20),
          Text(
            "No Canisters Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: appController.isDark.value
                  ? Color(0xffFDFCFD)
                  : primaryAltColor.value,
              fontFamily: "dmsans",
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Import a canister to manage and monitor its status, memory usage, and cycles.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: lightAltTextColor.value,
              fontFamily: "dmsans",
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Get.to(ImportCanister());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor.value,
              foregroundColor: textDarkColor.value,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Import Canister",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: "dmsans",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tokenTab() {
    return Column(
      children: [
        Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(),
              GestureDetector(
                onTap: () {
                  Get.to(SelectTokenScreen());
                },
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '+ Manage token',
                        style: TextStyle(
                          color: primaryColor.value,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: appController.tokens_map.length,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 12,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return Obx(
              () => Container(
                  height: 72,
                  width: Get.width,
                  // padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: inputFieldBackgroundColor2.value,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(width: 1, color: primaryAltBgColor2)),
                  child: Material(
                      clipBehavior: Clip.antiAlias,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                          onTap: () {
                            switch (appController.tokens_map.values
                                .elementAt(index)
                                .tokenAddress) {
                              case "um5iw-rqaaa-aaaaq-qaaba-cai":
                                Get.to(() => TokenScreen(
                                      token: appController.tokens_map.values
                                          .elementAt(index),
                                      option: CyclesScreenOption(),
                                    ));
                                break;
                              default:
                                Get.to(() => TokenScreen(
                                      token: appController.tokens_map.values
                                          .elementAt(index),
                                    ));
                            }
                            // move to Coin page.
                            // move to Coin page.
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: lightColor),
                                  child: appController.token_image_map[
                                      appController.tokens_map.values
                                          .elementAt(index)
                                          .tokenAddress],
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    () {
                                                      final wToken =
                                                          appController
                                                              .tokens_map.values
                                                              .elementAt(index);
                                                      return wToken.symbol;
                                                    }(),
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: appController
                                                                  .isDark
                                                                  .value ==
                                                              true
                                                          ? Color(0xffFDFCFD)
                                                          : primaryAltColor
                                                              .value,
                                                      fontFamily: "dmsans",
                                                    ),
                                                  ),
                                                  RichText(
                                                    textAlign: TextAlign.start,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: () {
                                                            final wToken =
                                                                appController
                                                                    .tokens_map
                                                                    .values
                                                                    .elementAt(
                                                                        index);
                                                            final tokenData =
                                                                appController
                                                                        .token_data_map[
                                                                    wToken
                                                                        .tokenAddress];
                                                            if (tokenData ==
                                                                null) {
                                                              return "---";
                                                            }

                                                            return normalizeBalance(
                                                                tokenData
                                                                    .balance,
                                                                wToken.tokenDecimal ??
                                                                    8);
                                                          }(),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: appController
                                                                        .isDark
                                                                        .value ==
                                                                    true
                                                                ? const Color(
                                                                    0xffFDFCFD)
                                                                : primaryAltColor
                                                                    .value,
                                                            fontFamily:
                                                                "dmsans",
                                                          ),
                                                        ),
                                                        // TextSpan(
                                                        //   text:
                                                        //       "${appController.tokens[index].symbol}",
                                                        //   style:
                                                        //       TextStyle(
                                                        //     fontSize:
                                                        //         12, // Smaller font size for USDT
                                                        //     fontWeight:
                                                        //         FontWeight
                                                        //             .w600,
                                                        //     color: appController
                                                        //                 .isDark
                                                        //                 .value ==
                                                        //             true
                                                        //         ? const Color(
                                                        //             0xffFDFCFD)
                                                        //         : primaryAltColor
                                                        //             .value,
                                                        //     fontFamily:
                                                        //         "dmsans",
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    () {
                                                      final wToken =
                                                          appController
                                                              .tokens_map.values
                                                              .elementAt(index);

                                                      final tokenData =
                                                          appController
                                                                  .token_data_map[
                                                              wToken
                                                                  .tokenAddress];
                                                      if (tokenData == null) {
                                                        return "---";
                                                      }
                                                      return tokenData
                                                          .formattedPrice;
                                                    }(),
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: lightAltTextColor
                                                          .value,
                                                      fontFamily: "dmsans",
                                                    ),
                                                  ),
                                                  Text(
                                                    () {
                                                      final wToken =
                                                          appController
                                                              .tokens_map.values
                                                              .elementAt(index);

                                                      final tokenData =
                                                          appController
                                                                  .token_data_map[
                                                              wToken
                                                                  .tokenAddress];
                                                      if (tokenData == null) {
                                                        return "---";
                                                      }
                                                      return calculateUsdWorth(
                                                          tokenData.balance,
                                                          wToken.tokenDecimal ??
                                                              8,
                                                          tokenData.price);
                                                    }(),
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xff56CDAD),
                                                      fontFamily: "dmsans",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )))),
            );
          },
        ),
      ],
    );
  }

  Widget selectToken({Function(WalletToken)? onSelect}) {
    final searchController = TextEditingController();
    final isSearching = false.obs;
    var filteredTokens = appController.tokens_map.values;
    var listLength = appController.tokens_map.length.obs;
    Future? queryFuture;
    void performSearch(String query) {
      queryFuture?.ignore();
      isSearching.value = true;

      //Simulate network delay
      queryFuture = Future.microtask(() {
        print(query);
        filteredTokens = appController.tokens_map.values
            .where((token) =>
                token.symbol.toLowerCase().contains(query.toLowerCase()))
            .toList();
        listLength.value = filteredTokens.length;
        isSearching.value = false;
      });
    }

    return Container(
      height: Get.height * 0.95,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      color: primaryAltBgColor2,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getTranslated(context, "Choose Token") ?? "Choose Token",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: headingColor.value,
                  fontFamily: "dmsans",
                ),
              ),
              GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.clear, color: headingColor.value))
            ],
          ),
          SizedBox(height: 16),
          InputFields(
            textController: searchController,
            hintText: "Type Token Name",
            icon: isSearching.value
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primaryAltColor.value,
                    ))
                : Image.asset("assets/images/Search.png"),
            onChange: (query) => performSearch(query),
          ),
          SizedBox(height: 24),
          Expanded(
            child: Obx(() => ListView.separated(
                  itemCount: listLength.value,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final token = filteredTokens.elementAt(index);
                    return GestureDetector(
                      onTap: () => onSelect?.call(token),
                      child: Container(
                        height: 72,
                        width: Get.width,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: appController.isDark.value
                              ? Colors.transparent
                              : inputFieldBackgroundColor.value,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              width: 1, color: inputFieldBackgroundColor.value),
                        ),
                        child: Row(
                          children: [
                            Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: inputFieldBackgroundColor.value),
                                child: appController
                                    .token_image_map[token.tokenAddress]),
                            SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                token.symbol,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: appController
                                                          .isDark.value
                                                      ? headingColor.value
                                                      : primaryAltColor.value,
                                                  fontFamily: "dmsans",
                                                ),
                                              ),
                                              Text(
                                                () {
                                                  final wToken = appController
                                                      .tokens_map.values
                                                      .elementAt(index);
                                                  final tokenData =
                                                      appController
                                                              .token_data_map[
                                                          wToken.tokenAddress];
                                                  if (tokenData == null) {
                                                    return "---";
                                                  }

                                                  return normalizeBalance(
                                                      tokenData.balance,
                                                      wToken.tokenDecimal ?? 8);
                                                }(),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: appController
                                                          .isDark.value
                                                      ? headingColor.value
                                                      : primaryAltColor.value,
                                                  fontFamily: "dmsans",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}

// Helper class for the persistent tab bar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22),
      color: primaryBackgroundColor.value,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

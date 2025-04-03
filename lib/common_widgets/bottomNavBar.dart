/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */


import 'package:fusion_wallet/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/screens/homeScreen.dart';
import 'package:fusion_wallet/screens/nfts/nftsScreen.dart';
import 'package:fusion_wallet/screens/settings.dart';
import 'package:fusion_wallet/screens/swapScreen.dart';
import 'package:get/get.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  List pages = [
    HomeScreen(),
    // NftDetails(),
    NftsScreen(),
    SwapScreen(),
    SettingsScreen()

    // TransactionScreen(),
    // Profile(
    // fromPage: 'bottomNav',
// ),
  ];
  AppController appController = Get.find<AppController>();
  DateTime? lastPressed;
  late DateTime currentBackPressTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    appController.selectedBOttomTabIndex.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: true,
        child: Scaffold(
          // backgroundColor: Colors.black,
          bottomNavigationBar: Obx(
            () => Container(
              height: 70,
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: headingColor.value.withOpacity(0.02), width: 1),
                  ),
                  color: appController.isDark.value
                      ? Color(0xff1A1930)
                      : primaryColor.value),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            //print("appController.isHyptics.value ${appController.isHyptics.value}");

                            appController.selectedBOttomTabIndex.value = 0;
                          },
                          child: SizedBox(
                            // color:  primaryBackgroundColor.value,
                            height: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // appController.isDark == true
                                //     ?
                                appController.selectedBOttomTabIndex.value == 0
                                    ? SvgPicture.asset(
                                        "assets/svgs/selectedHome.svg",
                                        color: greenCardColor.value,
                                      )
                                    : SvgPicture.asset(
                                        "assets/svgs/unselectedHome.svg",
                                        color:
                                            appController.isDark.value == true
                                                ? Color(0xff6C7CA7)
                                                : headingColor.value,
                                      ),
                                SizedBox(
                                  height: 5,
                                ),
                                appController.selectedBOttomTabIndex.value == 0
                                    ? Container(
                                        height: 6,
                                        width: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: greenCardColor.value,
                                        ),
                                      )
                                    : SizedBox(
                                        height: 0,
                                        width: 0,
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            appController.selectedBOttomTabIndex.value = 1;
                          },
                          child: SizedBox(
                            // color:  primaryBackgroundColor.value,
                            height: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // appController.isDark == true
                                //     ?
                                appController.selectedBOttomTabIndex.value == 1
                                    ? SvgPicture.asset(
                                        "assets/svgs/nftSelected.svg",
                                        color:
                                            appController.isDark.value == true
                                                ? greenCardColor.value
                                                : primaryAltColor.value,
                                      )
                                    : SvgPicture.asset(
                                        "assets/svgs/nftunSelected.svg",
                                        color:
                                            appController.isDark.value == true
                                                ? Color(0xff6C7CA7)
                                                : headingColor.value,
                                      ),
                                SizedBox(
                                  height: 5,
                                ),
                                appController.selectedBOttomTabIndex.value == 1
                                    ? Container(
                                        height: 6,
                                        width: 6,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xff76CF56),
                                                  Color(0xff55DDAF)
                                                ])),
                                      )
                                    : SizedBox(
                                        height: 0,
                                        width: 0,
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            appController.selectedBOttomTabIndex.value = 2;
                          },
                          child: SizedBox(
                            // color:  primaryBackgroundColor.value,
                            height: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // appController.isDark == true
                                //     ?
                                appController.selectedBOttomTabIndex.value == 2
                                    ? SvgPicture.asset(
                                        "assets/svgs/swapSelected.svg",
                                        color:
                                            appController.isDark.value == true
                                                ? greenCardColor.value
                                                : primaryAltColor.value,
                                      )
                                    : SvgPicture.asset(
                                        "assets/svgs/swapSelected.svg",
                                        color:
                                            appController.isDark.value == true
                                                ? Color(0xff6C7CA7)
                                                : Color(0xff1A2B56),
                                      ),
                                SizedBox(
                                  height: 5,
                                ),
                                appController.selectedBOttomTabIndex.value == 2
                                    ? Container(
                                        height: 6,
                                        width: 6,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xff76CF56),
                                                  Color(0xff55DDAF)
                                                ])),
                                      )
                                    : SizedBox(
                                        height: 0,
                                        width: 0,
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: InkWell(
                      //     onTap: () async {
                      //       appController.selectedBOttomTabIndex.value = 3;
                      //     },
                      //     child: SizedBox(
                      //       // color:  primaryBackgroundColor.value,
                      //       height: 40,
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           // appController.isDark == true
                      //           //     ?
                      //           appController.selectedBOttomTabIndex.value == 3
                      //               ? appController.isDark.value == true
                      //                   ? SvgPicture.asset(
                      //                       "assets/svgs/Activity.svg",
                      //                     )
                      //                   : SvgPicture.asset(
                      //                       "assets/svgs/Group 62915.svg",
                      //                     )
                      //               : SvgPicture.asset(
                      //                   "assets/svgs/unselectedHistory.svg",
                      //                   color:
                      //                       appController.isDark.value == true
                      //                           ? Color(0xff6C7CA7)
                      //                           : headingColor.value,
                      //                 ),
                      //           SizedBox(
                      //             height: 5,
                      //           ),
                      //           appController.selectedBOttomTabIndex.value == 3
                      //               ? Container(
                      //                   height: 6,
                      //                   width: 6,
                      //                   decoration: BoxDecoration(
                      //                       shape: BoxShape.circle,
                      //                       gradient: LinearGradient(
                      //                           begin: Alignment.topCenter,
                      //                           end: Alignment.bottomCenter,
                      //                           colors: [
                      //                             Color(0xff76CF56),
                      //                             Color(0xff55DDAF)
                      //                           ])),
                      //                 )
                      //               : SizedBox(
                      //                   height: 0,
                      //                   width: 0,
                      //                 )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            appController.selectedBOttomTabIndex.value = 3;
                          },
                          child: SizedBox(
                            // color:  primaryBackgroundColor.value,
                            height: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.settings,
                                  color: appController.selectedBOttomTabIndex.value == 3
                                      ? greenCardColor.value
                                      : Color(0xff6C7CA7),
                                ),
                                // appController.isDark == true
                                //     ?
                                // appController.selectedBOttomTabIndex.value == 4
                                //     ? SvgPicture.asset(
                                //         "assets/svgs/selectedProfile.svg",
                                //         color:
                                //             appController.isDark.value == true
                                //                 ? greenCardColor.value
                                //                 : primaryAltColor.value,
                                //       )
                                //     : SvgPicture.asset(
                                //         "assets/svgs/unselectedProfile.svg",
                                //         color:
                                //             appController.isDark.value == true
                                //                 ? Color(0xff6C7CA7)
                                //                 : headingColor.value,
                                //       ),
                                SizedBox(
                                  height: 5,
                                ),
                                appController.selectedBOttomTabIndex.value == 3
                                    ? Container(
                                        height: 6,
                                        width: 6,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xff76CF56),
                                                  Color(0xff55DDAF)
                                                ])),
                                      )
                                    : SizedBox(
                                        height: 0,
                                        width: 0,
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: pages.elementAt(appController.selectedBOttomTabIndex.value),
        ),
      ),
    );
  }
}

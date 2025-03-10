/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/extensions.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/receiveScreen.dart';
import 'package:fusion_wallet/screens/selectToken.dart';
import 'package:fusion_wallet/screens/sendScreens/sendScreen.dart';
import 'package:fusion_wallet/screens/settings.dart';
import 'package:fusion_wallet/screens/tokenScreen.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:fusion_wallet/types/UpdateChecker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common_widgets/inputField.dart';

// import '../nfts/nftsScreen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isVisible = false.obs;

  AppController appController = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
    // UpdateChecker.checkForUpdate(context);
    appController.check_token_balances();
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
        if (tokenData.price <= 0) continue;

        // Convert balance to decimal value considering token decimals
        double decimalAmount =
            tokenData.balance.toDouble() / pow(10, token.tokenDecimal ?? 8);

        // Calculate worth for this token and add to total
        totalWorth += decimalAmount * tokenData.price;
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

  @override
  Widget build(BuildContext context) {
    if (appController.active_wallet.value == null) {
      showToast("No active Account");
      Get.back();
      return SizedBox();
    }
    return Obx(
      () => Scaffold(
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            children: [
              // SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      // Get.to(SettingsScreen());
                    },
                    child: Row(
                      children: [
                        
                        Text(
                          "Main",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
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
                              color: appController.isDark.value == true
                                  ? Color(0xff1A2B56)
                                  : inputFieldBackgroundColor.value,
                              borderRadius: BorderRadius.circular(8)),
                          child: isVisible == true
                              ? Icon(
                                  Icons.visibility_outlined,
                                  color: headingColor.value,
                                  size: 17,
                                )
                              : SvgPicture.asset("assets/svgs/hideBalance.svg",
                                  color: appController.isDark.value == true
                                      ? Color(0xffA2BBFF)
                                      : headingColor.value),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          var addr = appController.active_wallet.value!
                              .toIcpPrincipal();
                          copyToClipboard(addr).then((value) =>
                              {showToast("Principal Copied Successfully")});
                        },
                        child: Container(
                          height: 32,
                          width: 32,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: appController.isDark.value == true
                                  ? Color(0xff1A2B56)
                                  : inputFieldBackgroundColor.value,
                              borderRadius: BorderRadius.circular(8)),
                          child: SvgPicture.asset(
                              "assets/svgs/u_copy-landscape.svg",
                              color: appController.isDark.value == true
                                  ? Color(0xffA2BBFF)
                                  : headingColor.value),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      // InkWell( TODO (Qr Code scanner)
                      //     onTap: () {},
                      //     child: Container(
                      //       height: 32,
                      //       width: 32,
                      //       padding: EdgeInsets.all(8),
                      //       decoration: BoxDecoration(
                      //           color: appController.isDark.value == true
                      //               ? Color(0xff1A2B56)
                      //               : inputFieldBackgroundColor.value,
                      //           borderRadius: BorderRadius.circular(8)),
                      //       child: SvgPicture.asset(
                      //           "assets/svgs/ion_qr-code.svg",
                      //           color: appController.isDark.value == true
                      //               ? Color(0xffA2BBFF)
                      //               : headingColor.value),
                      //     ))
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
                            color: appController.isDark.value == true
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                          clipBehavior: Clip.antiAlias,
                          isScrollControlled: true,
                          backgroundColor: appController.isDark.value == true
                              ? Color(0xffA2BBFF)
                              : primaryAltBackgroundColor.value,
                          shape: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  topLeft: Radius.circular(32))), selectToken(
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
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: SvgPicture.asset(
                                  "assets/svgs/sendIcon.svg",
                                  height: 28,
                                  width: 28,
                                  color: appController.isDark.value == true
                                      ? Color(0xFFA2BBFF)
                                      : primaryAltBackgroundColor.value)),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          getTranslated(context, "Send") ?? "Send",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: appController.isDark.value == true
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
                          backgroundColor: appController.isDark.value == true
                              ? Color(0xffA2BBFF)
                              : primaryAltBackgroundColor.value,
                          shape: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  topLeft: Radius.circular(32))),
                          selectToken(onSelect: (token) {
                        Get.back();
                        var addr =
                            appController.active_wallet.value?.toIcpPrincipal();

                        if (addr == null) {
                          showToast("No Address or Principal ID found");
                          return;
                        }
                        Get.to(ReceiveScreen(token: token, address: addr));
                      }));
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: appController.isDark.value == true
                                  ? Color(0xFF1A2B56)
                                  : primaryAltColor.value,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: SvgPicture.asset(
                                  "assets/svgs/receiveicon.svg",
                                  height: 28,
                                  width: 28,
                                  color: appController.isDark.value == true
                                      ? Color(0xFFA2BBFF)
                                      : primaryAltBackgroundColor.value)),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          getTranslated(context, "Receive") ?? "Receive",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: appController.isDark.value == true
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
                  //     // Get.to(SwapScreen());
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
                  //             child: SvgPicture.asset("assets/svgs/swap.svg",
                  //                 height: 28,
                  //                 width: 28,
                  //                 color: appController.isDark.value == true
                  //                     ? Color(0xFFA2BBFF)
                  //                     : primaryAltBackgroundColor.value)),
                  //       ),
                  //       SizedBox(
                  //         height: 12,
                  //       ),
                  //       Text(
                  //         getTranslated(context, "Swap") ?? "Swap",
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
                height: 32,
              ),
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
                    Text(
                      'Tokens',
                      style: TextStyle(
                        color: primaryColor.value,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0.08,
                      ),
                    ),
                    SizedBox(width: 10),
                    // TextButton.icon(
                    //   onPressed: () {
                    //     Get.to(SelectTokenScreen());
                    //   },
                    //   icon: Icon(Icons.add, size: 16),
                    //   label: Text("Import token"),
                    //   style: TextButton.styleFrom(
                    //     foregroundColor: primaryColor.value,
                    //   ),
                    // ),
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
                              '+ Import token',
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
                            border: Border.all(
                                width: 1, color: primaryAltBgColor2)),
                        child: Material(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                                onTap: () {
                                  Get.to(() => TokenScreen(
                                        token: appController.tokens_map.values
                                            .elementAt(index),
                                      ));
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
                                                          () {
                                                            final wToken =
                                                                appController
                                                                    .tokens_map
                                                                    .values
                                                                    .elementAt(
                                                                        index);
                                                            return wToken
                                                                .symbol;
                                                          }(),
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
                                                            fontFamily:
                                                                "dmsans",
                                                          ),
                                                        ),
                                                        RichText(
                                                          textAlign:
                                                              TextAlign.start,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: () {
                                                                  final wToken = appController
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                                            return tokenData
                                                                .formattedPrice;
                                                          }(),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                lightAltTextColor
                                                                    .value,
                                                            fontFamily:
                                                                "dmsans",
                                                          ),
                                                        ),
                                                        Text(
                                                          () {
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
                                                            return calculateUsdWorth(
                                                                tokenData
                                                                    .balance,
                                                                wToken.tokenDecimal ??
                                                                    8,
                                                                tokenData
                                                                    .price);
                                                          }(),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xff56CDAD),
                                                            fontFamily:
                                                                "dmsans",
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
          ),
        ),
      ),
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

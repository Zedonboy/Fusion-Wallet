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

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/futureImageWidget.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/extensions.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/TokenCalculator.dart';
import 'package:fusion_wallet/screens/sendScreens/sendScreen.dart';
import 'package:fusion_wallet/src/rust/api/ic_wallet_service.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:fusion_wallet/src/rust/frb_generated.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  var loading_top_bal = false.obs;
  var loading_bottom_bal = false.obs;
  var top_balance = 0.00.obs;
  var bottom_balance = 0.00.obs;
  var is_fetching_quote = false.obs;
  var slippage = RxDouble(-1.0);
  var loading_swap = false.obs;
  // var custom_slippage = 1.0.obs;
  Timer? _debounceTimer;

  // Add these variables to store quote information
  var quote_mid_price = 0.0.obs;
  var quote_output_amount = "0".obs;
  var quote_estimated_fee_amount = BigInt.from(0).obs;
  Rx<WalletToken> top = Rx(WalletContext.getInitialSupportedTokens()[0]);
  Rx<WalletToken> bottom = Rx(WalletContext.getInitialSupportedTokens()[1]);

  AppController appController = Get.find<AppController>();
  TextEditingController topController = TextEditingController();
  TextEditingController bottomController = TextEditingController();
  FocusNode top_focus = FocusNode();
  FocusNode bottom_focus = FocusNode();

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadInitialSlippage();
    fetchQuoteForAmount("0");

    // Add listeners for text controllers
    topController.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        if (topController.text.isNotEmpty && top_focus.hasFocus) {
          fetchQuoteForAmount(topController.text);
        }
      });
    });

    bottomController.addListener(() {
      if (bottomController.text.isNotEmpty &&
          !is_fetching_quote.value &&
          !top_focus.hasFocus) {
        try {
          final bottom_amount = double.parse(bottomController.text);
          final top_amount = bottom_amount / quote_mid_price.value;

          topController.text = top_amount.toStringAsFixed(6);
        } catch (e) {
          print("Error calculating reverse amount: $e");
        }
      }
    });

    ever(top, (token) {
      var token_data = appController.token_data_map[token.tokenAddress];
      fetchQuoteForAmount("0");
      if (token_data == null) {
        final ic_service = appController.ic_service;
        final account = appController.active_wallet.value?.toIcpPrincipal();
        if (ic_service == null || account == null) return;
        loading_top_bal.value = true;
        ic_service.getBalance(token: token, account: account).then((bal) {
          top_balance.value =
              double.tryParse(normalizeBalance(bal, token.tokenDecimal ?? 8)) ??
                  0.00;
        }).catchError((err) {
          top_balance.value = 0.00;
        }).whenComplete(() {
          loading_top_bal.value = false;
        });
        // call ic for balance
      } else {
        final bal = token_data.balance;
        top_balance.value =
            double.tryParse(normalizeBalance(bal, token.tokenDecimal ?? 8)) ??
                0.00;
      }
    });

    ever(bottom, (token) {
      var token_data = appController.token_data_map[token.tokenAddress];
      fetchQuoteForAmount("0");
      if (token_data == null) {
        final ic_service = appController.ic_service;
        final account = appController.active_wallet.value?.toIcpPrincipal();
        if (ic_service == null || account == null) return;
        loading_bottom_bal.value = true;
        ic_service.getBalance(token: token, account: account).then((bal) {
          bottom_balance.value =
              double.tryParse(normalizeBalance(bal, token.tokenDecimal ?? 8)) ??
                  0.00;
        }).catchError((err) {
          bottom_balance.value = 0.00;
        }).whenComplete(() {
          loading_bottom_bal.value = false;
        });
        // call ic for balance
      } else {
        final bal = token_data.balance;
        bottom_balance.value =
            double.tryParse(normalizeBalance(bal, token.tokenDecimal ?? 8)) ??
                0.00;
      }
    });
  }

  // void loadInitialSlippage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final slippage_val = prefs.getDouble('swap_slippage');
  //   print("slippage_val: $slippage_val");
  //   if (slippage_val != null) {
  //     slippage.value = slippage_val;
  //   }
  // }

  void saveSlippage(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('swap_slippage', value);
    slippage.value = value;
  }

  Future<void> fetchQuoteForAmount(String amount) async {
    if (appController.ic_service == null) return;
    is_fetching_quote.value = true;

    try {
      final ic_service = appController.ic_service!;
      final pay_amount = BigInt.from(
          double.parse(amount) * pow(10, top.value.tokenDecimal ?? 8));

      final quote_reply = await ic_service.swapQuote(
          payToken: top.value,
          receiveToken: bottom.value,
          payAmount: pay_amount);

      // print("quote_reply: ${quote_reply.estimatedPayAmount}");

      quote_mid_price.value = quote_reply.midPrice;
      quote_estimated_fee_amount.value = quote_reply.estimatedFeeAmount;

      quote_output_amount.value = normalizeBalance(
          quote_reply.receiveAmount, bottom.value.tokenDecimal ?? 8);

      bottomController.text = quote_output_amount.value;
    } catch (e) {
      print("Error fetching quote for amount: $e");
      showToast("Error fetching quote");
    } finally {
      is_fetching_quote.value = false;
    }
  }

  updateCustomSlippage(bool increase) {
    if (increase) {
      slippage.value = (slippage.value + 0.1).toPrecision(2);
    } else {
      if (slippage.value > 0.1) {
        slippage.value -= (slippage.value - 0.1).toPrecision(2);
      }
    }
    saveSlippage(slippage.value);
    return slippage.value;
  }

  @override
  Widget build(BuildContext context) {
   
    return Obx(() => Scaffold(
          backgroundColor: primaryBackgroundColor.value,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        getTranslated(context, "Swap Tokens") ?? "Swap Tokens",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: darkBlueColor.value,
                          fontFamily: "dmsans",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "You pay",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: headingColor.value,
                                    fontFamily: "dmsans",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              // height: 172,
                              width: Get.width,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: inputFieldBackgroundColor2.value,
                                  border: Border.all(
                                      width: 1,
                                      color: inputFieldBackgroundColor.value)),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.bottomSheet(
                                          clipBehavior: Clip.antiAlias,
                                          isScrollControlled: true,
                                          backgroundColor:
                                              primaryBackgroundColor.value,
                                          shape: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(32),
                                                  topLeft:
                                                      Radius.circular(32))),
                                          selectToken(onSelect: (token) {
                                        top.value = token;
                                        Get.back();
                                      }));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: lightColor),
                                              child: appController
                                                          .token_image_map[
                                                      top.value.tokenAddress] ??
                                                  FutureAdaptiveImage(
                                                    imageUrl:
                                                        top.value.imageUrl ??
                                                            "",
                                                  ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  top.value.symbol,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    color: headingColor.value,
                                                    fontFamily: "dmsans",
                                                  ),
                                                ),
                                                if (loading_top_bal.value)
                                                  Skeletonizer(
                                                      effect: PulseEffect(
                                                        from: Colors.grey
                                                            .withOpacity(0.2),
                                                        to: Colors.grey
                                                            .withOpacity(0.8),
                                                      ),
                                                      child: Text(
                                                        "${getTranslated(context, "Available") ?? "Available"}: 12",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: lightTextColor
                                                              .value,
                                                          fontFamily: "dmsans",
                                                        ),
                                                      ))
                                                else
                                                  Text(
                                                    "${getTranslated(context, "Available") ?? "Available"}: ${top_balance.value}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          lightTextColor.value,
                                                      fontFamily: "dmsans",
                                                    ),
                                                  )
                                              ],
                                            )
                                          ],
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          color: headingColor.value,
                                          size: 25,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Divider(
                                    color: inputFieldBackgroundColor.value,
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: TextFormField(
                                        controller: topController,
                                        cursorColor: primaryColor.value,
                                        textAlign: TextAlign.start,
                                        focusNode: top_focus,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: false, decimal: true),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "0",
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                          hintStyle: TextStyle(
                                            color: labelColorPrimaryShade.value,
                                            // fontSize: 36,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        onChanged: (v) {
                                          // amountErr.value = '';
                                        },
                                      )),
                                      Container(
                                        height: 24,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: lightTextColor.value,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              topController.text =
                                                  top_balance.string;
                                            },
                                            child: Text(
                                              "MAX",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: "dmsans",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            showTokenCalculator(top.value);
                                            // Get.to(CodeScanner1());
                                          },
                                          child: SvgPicture.asset(
                                              "assets/svgs/calculator.svg"))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      FutureBuilder(
                                          future: WalletContext.getTokenWorth(
                                              tokenSymbol: top.value.symbol,
                                              amount: double.tryParse(
                                                      topController.text) ??
                                                  0.0),
                                          builder: (context, snapshot) {
                                            if(snapshot.connectionState == ConnectionState.done) {
                                              return Text("(≈${snapshot.data})",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: lightTextColor.value,
                                                  fontFamily: "dmsans",
                                                ));
                                            }

                                            return Skeletonizer(
                                                effect: PulseEffect(
                                                  from: Colors.grey
                                                      .withOpacity(0.2),
                                                  to: Colors.grey
                                                      .withOpacity(0.8),
                                                ),
                                                child: Text("(≈\$0.07)",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: lightTextColor.value,
                                                      fontFamily: "dmsans",
                                                    )));
                                          })
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SWap ICon
                                Container(
                                  height: 40,
                                  width: 40,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: primaryAltBgColor2,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: is_fetching_quote.value
                                      ? CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  primaryAltColor.value),
                                          strokeWidth: 2,
                                        )
                                      : SvgPicture.asset(
                                          "assets/svgs/convert.svg"),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "You receive",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: headingColor.value,
                                    fontFamily: "dmsans",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              // height: 158,
                              width: Get.width,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: inputFieldBackgroundColor2.value,
                                  border: Border.all(
                                      width: 1,
                                      color: inputFieldBackgroundColor.value)),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.bottomSheet(
                                          clipBehavior: Clip.antiAlias,
                                          isScrollControlled: true,
                                          backgroundColor:
                                              primaryBackgroundColor.value,
                                          shape: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(32),
                                                  topLeft:
                                                      Radius.circular(32))),
                                          selectToken(onSelect: (token) {
                                        bottom.value = token;
                                        Get.back();
                                      }));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: primaryBackgroundColor
                                                      .value),
                                              child:
                                                  appController.token_image_map[
                                                          bottom.value
                                                              .tokenAddress] ??
                                                      FutureAdaptiveImage(
                                                        imageUrl: bottom.value
                                                                .imageUrl ??
                                                            "assets/images/usd.png",
                                                      ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  bottom.value.symbol,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    color: headingColor.value,
                                                    fontFamily: "dmsans",
                                                  ),
                                                ),
                                                if (loading_bottom_bal.value)
                                                  Skeletonizer(
                                                      effect: PulseEffect(
                                                        from: Colors.grey
                                                            .withOpacity(0.2),
                                                        to: Colors.grey
                                                            .withOpacity(0.8),
                                                      ),
                                                      child: Text(
                                                        "${getTranslated(context, "Available") ?? "Available"}: 12",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: lightTextColor
                                                              .value,
                                                          fontFamily: "dmsans",
                                                        ),
                                                      ))
                                                else
                                                  Text(
                                                    "${getTranslated(context, "Available") ?? "Available"}: ${bottom_balance.value}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          lightTextColor.value,
                                                      fontFamily: "dmsans",
                                                    ),
                                                  )
                                              ],
                                            )
                                          ],
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          color: headingColor.value,
                                          size: 25,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Divider(
                                    color: inputFieldBackgroundColor.value,
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: TextFormField(
                                        controller: bottomController,
                                        cursorColor: primaryColor.value,
                                        textAlign: TextAlign.start,
                                        enabled: !is_fetching_quote.value,
                                        focusNode: bottom_focus,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: false, decimal: true),
                                        style: TextStyle(
                                          color: is_fetching_quote.value
                                              ? Colors.grey
                                              : Colors.white,
                                          fontSize: 32,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "0",
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                          hintStyle: TextStyle(
                                            color: labelColorPrimaryShade.value,
                                            // fontSize: 36,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        onChanged: (v) {
                                          // amountErr.value = '';
                                        },
                                      )),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      FutureBuilder(
                                          future: WalletContext.getTokenWorth(
                                              tokenSymbol: bottom.value.symbol,
                                              amount: double.tryParse(
                                                      bottomController.text) ??
                                                  0.0),
                                          builder: (context, snapshot) {
                                            if(snapshot.connectionState == ConnectionState.done) {
                                              return Text("(≈${snapshot.data})",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: lightTextColor.value,
                                                  fontFamily: "dmsans",
                                                ));
                                            }

                                            return Skeletonizer(
                                                effect: PulseEffect(
                                                  from: Colors.grey
                                                      .withOpacity(0.2),
                                                  to: Colors.grey
                                                      .withOpacity(0.8),
                                                ),
                                                child: Text("(≈\$0.07)",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: lightTextColor.value,
                                                      fontFamily: "dmsans",
                                                    )));
                                          })
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                          // height: 148,
                          width: Get.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: inputFieldBackgroundColor2.value,
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
                                      Text(
                                        getTranslated(
                                                context, "Swap Details") ??
                                            "Swap Details",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: headingColor.value,
                                          fontFamily: "dmsans",
                                        ),
                                      )
                                    ],
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_up_outlined,
                                    color: headingColor.value,
                                    size: 25,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                color: inputFieldBackgroundColor.value,
                                height: 1,
                                thickness: 1,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                 
                                  Row(
                                    children: [
                                      Text(
                                        "${getTranslated(context, "Avg Quote Fee") ?? "Avg Quote Fee"} ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: headingColor.value,
                                          fontFamily: "dmsans",
                                        ),
                                      ),
                                      SvgPicture.asset(
                                          "assets/svgs/Question.svg")
                                    ],
                                  ),
                                  if (is_fetching_quote.value)
                                    Skeletonizer(
                                        effect: PulseEffect(
                                          from: Colors.grey.withOpacity(0.2),
                                          to: Colors.grey.withOpacity(0.8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              quote_mid_price
                                                  .toStringAsFixed(6)
                                                  .removeTrailingZeroes(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: headingColor.value,
                                                fontFamily: "dmsans",
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              bottom.value.symbol,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: headingColor.value,
                                                fontFamily: "dmsans",
                                              ),
                                            )
                                          ],
                                        ))
                                  else
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          quote_mid_price
                                              .toStringAsFixed(6)
                                              .removeTrailingZeroes(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: headingColor.value,
                                            fontFamily: "dmsans",
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          bottom.value.symbol,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: headingColor.value,
                                            fontFamily: "dmsans",
                                          ),
                                        )
                                      ],
                                    )
                                ],
                              ),
                              SizedBox(
                                height: 11,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${getTranslated(context, "Routing Fee") ?? "Routing Fee"} ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: headingColor.value,
                                          fontFamily: "dmsans",
                                        ),
                                      ),
                                      SvgPicture.asset(
                                          "assets/svgs/Question.svg")
                                    ],
                                  ),
                                  Text(
                                    "${quote_estimated_fee_amount.value / BigInt.from(10).pow(top.value.tokenDecimal ?? 8)}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: headingColor.value,
                                      fontFamily: "dmsans",
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 11,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${getTranslated(context, "Swap Provider/Strategy") ?? "Swap Provider"} ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: headingColor.value,
                                          fontFamily: "dmsans",
                                        ),
                                      ),
                                      SvgPicture.asset(
                                          "assets/svgs/Question.svg")
                                    ],
                                  ),
                                  Text(
                                    "KongSwap/Approval",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: headingColor.value,
                                      fontFamily: "dmsans",
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 11,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(
                                            context, "Slippage Tolerance") ??
                                        "Slippage Tolerance",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: headingColor.value,
                                      fontFamily: "dmsans",
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        
                                        slippage.value < 0
                                            ? "Auto"
                                            : "${slippage.value}%",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: headingColor.value,
                                          fontFamily: "dmsans",
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.bottomSheet(
                                              clipBehavior: Clip.antiAlias,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  primaryBackgroundColor.value,
                                              shape: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  32),
                                                          topLeft:
                                                              Radius.circular(
                                                                  32))),
                                              slippageSettings());
                                        },
                                        child: SvgPicture.asset(
                                          "assets/svgs/mingcute_settings-6-line.svg",
                                          height: 32,
                                          width: 32,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      BottomRectangularBtn(
                          onTapFunc: () {
                            Get.bottomSheet(
                                clipBehavior: Clip.antiAlias,
                                isScrollControlled: true,
                                backgroundColor: primaryBackgroundColor.value,
                                shape: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(32),
                                        topLeft: Radius.circular(32))),
                                confirmSwap());
                          },
                          btnTitle: topController.text.isNotEmpty &&
                                  double.tryParse(topController.text) != null &&
                                  double.parse(topController.text) >
                                      top_balance.value
                              ? "Insufficient Funds"
                              : "Swap",
                          isDisabled: loading_swap.value ||
                              topController.text.isEmpty ||
                              double.tryParse(topController.text) == null ||
                              double.parse(topController.text) >
                                  top_balance.value,
                          isLoading: loading_swap.value),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget selectToken({Function(WalletToken)? onSelect}) {
    final tokens_map = {
      for (var element in WalletContext.getAllSupportedTokens())
        element.tokenAddress: element
    };
    tokens_map.addAll(appController.tokens_map);
    final searchController = TextEditingController();
    final isSearching = false.obs;
    var filteredTokens = tokens_map.values;
    var listLength = tokens_map.length.obs;
    Future? queryFuture;
    void performSearch(String query) {
      queryFuture?.ignore();
      isSearching.value = true;

      //Simulate network delay
      queryFuture = Future.microtask(() {
        print(query);
        filteredTokens = tokens_map.values
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
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: lightColor),
                                child: FutureAdaptiveImage(
                                    imageUrl: token.imageUrl ??
                                        'assets/images/usd.png')),
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

  void showTokenCalculator(WalletToken token) {
    Get.bottomSheet(
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      backgroundColor: primaryBackgroundColor.value,
      shape: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(32), topLeft: Radius.circular(32))),
      TokenCalculator(
        token: token,
        tokenPrice:
            appController.token_data_map[token.tokenAddress]?.price ?? 0.0,
      ),
    );
  }

  Widget confirmSwap() {
    return Container(
      // height: 520,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      color: primaryBackgroundColor.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 162,
            width: Get.width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: inputFieldBackgroundColor2.value,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, "You Pay") ?? "You Pay",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",
                      ),
                    ),
                    Text(
                      getTranslated(context, "You Get") ?? "You Get",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          NumberFormat('#,###.#######')
                              .format(double.tryParse(topController.text) ?? 0),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          top.value.symbol,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: lightTextColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          NumberFormat('#,###.#######').format(
                              double.tryParse(bottomController.text) ?? 0),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          bottom.value.symbol,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: lightTextColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "(≈\$0.07)",
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         fontSize: 11,
                //         fontWeight: FontWeight.w600,
                //         color: lightTextColor.value,
                //         fontFamily: "dmsans",
                //       ),
                //     ),
                //     Text(
                //       "(≈\$0.07)",
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         fontSize: 11,
                //         fontWeight: FontWeight.w600,
                //         color: lightTextColor.value,
                //         fontFamily: "dmsans",
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: inputFieldBackgroundColor.value,
                  height: 1,
                  thickness: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, "From") ?? "From",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",
                      ),
                    ),
                    Text(
                      getTranslated(context, "To") ?? "To",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                              color: inputFieldBackgroundColor.value,
                              shape: BoxShape.circle),
                          child: FutureAdaptiveImage(
                              imageUrl: top.value.imageUrl ??
                                  'assets/images/usd.png'),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          top.value.symbol,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                              color: inputFieldBackgroundColor.value,
                              shape: BoxShape.circle),
                          child: FutureAdaptiveImage(
                              imageUrl: bottom.value.imageUrl ??
                                  'assets/images/usd.png'),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          bottom.value.symbol,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            // height:70,
            width: Get.width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: inputFieldBackgroundColor2.value,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, "Quote") ?? "Quote",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",
                      ),
                    ),
                    Text(
                      getTranslated(context, "Slippage Tolerance") ??
                          "Slippage Tolerance",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "1 ${top.value.symbol} ≈",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: headingColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          "${NumberFormat('#,###.#######').format(quote_mid_price.value)} ${bottom.value.symbol}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: lightTextColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          slippage.value < 0
                              ? "Auto"
                              : "${slippage.value.toStringAsFixed(2)}%",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
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
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 40,
          ),
          BottomRectangularBtn(
              onTapFunc: () {
                Get.back();
                swap();
              },
              btnTitle: "Confirm Swap"),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  swap() async {
    final ic_service = appController.ic_service;
    if (ic_service == null) {
      return;
    }
    try {
      loading_swap.value = true;
      final top_amount = BigInt.from(double.parse(topController.text) *
              pow(10, top.value.tokenDecimal ?? 8));
      final amt = top_amount +
          (top.value.transferFee);

      final allowance = await ic_service.getAllowance(
          token: top.value,
          owner: appController.active_wallet.value!.toIcpPrincipal(),
          spender: "2ipq2-uqaaa-aaaar-qailq-cai");

      var allowance_expired = false;
      // Check if allowance has expired
      if (allowance.expiresAt != null) {
        final currentTime =
            BigInt.from(DateTime.now().millisecondsSinceEpoch * 1000000);
        if (allowance.expiresAt! < currentTime) {
          print(
              "Allowance has expired. Current time: $currentTime, Expiry time: ${allowance.expiresAt}");
          // Set allowance to zero since it has expired
          allowance_expired = true;
        }
      }

      if (allowance.allowance < amt || allowance_expired) {
        final expires_at =
            DateTime.now().add(Duration(minutes: 1)).millisecondsSinceEpoch *
                1000000;
        final height = await ic_service.approve(
            token: top.value,
            spender: "2ipq2-uqaaa-aaaar-qailq-cai", // kong swap id
            amount: amt,
            expiresAt: BigInt.from(expires_at));
        print("approve response: $height");
      }

      final response = await ic_service.swap(
          payToken: top.value,
          receiveToken: bottom.value,
          payAmount: top_amount,
          slippage: slippage.value < 0 ? null : slippage.value);

      Get.bottomSheet(
          clipBehavior: Clip.antiAlias,
          isScrollControlled: true,
          backgroundColor: primaryBackgroundColor.value,
          shape: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32), topLeft: Radius.circular(32))),
          swapCompleted(response));
    } catch (e) {
      Get.snackbar("Error Swapping", e.toString(),
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(8),
          duration: Duration(seconds: 6),
          icon: Icon(Icons.error, color: Colors.red[900]));
      showToast("Error Swapping");
      print(e);
    } finally {
      loading_swap.value = false;
    }
  }

  Widget swapCompleted(SwapResponse response) {
    final pay_symbol = response.paySymbol;
    final receive_symbol = response.receiveSymbol;
    final pay_amount = response.payAmount;
    final receive_amount = response.receiveAmount;

    final decimal_receive =
        receive_amount / BigInt.from(pow(10, bottom.value.tokenDecimal ?? 8));
    final decimal_pay =
        pay_amount / BigInt.from(pow(10, top.value.tokenDecimal ?? 8));
    final receive_amount_str =
        NumberFormat('#,###.########').format(decimal_receive);
    final pay_amount_str = NumberFormat('#,###.########').format(decimal_pay);
    return Container(
      // height: 430,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      color: primaryAltBackgroundColor.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120,
            width: 120,
            padding: EdgeInsets.all(17),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: inputFieldBackgroundColor2.value),
            child: SvgPicture.asset("assets/svgs/shield-tick.svg"),
          ),
          SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getTranslated(context, "Swap has been completed") ??
                    "Swap has been completed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: headingColor.value,
                  fontFamily: "dmsans",
                ),
              ),
            ],
          ),

          SizedBox(
            height: 3,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: getTranslated(context, "You just swapped") ??
                  "You just swapped",
              style: TextStyle(
                  fontSize: 14,
                  color: lightTextColor.value,
                  fontFamily: 'Spectral',
                  fontWeight: FontWeight.w400),
              children: <TextSpan>[
                TextSpan(
                  text: ' $pay_amount_str $pay_symbol ',
                  style: TextStyle(
                      fontSize: 13,
                      color: headingColor.value,
                      fontFamily: 'dmsans',
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(text: getTranslated(context, "to get") ?? "to get"),
                TextSpan(
                  text: ' $receive_amount_str $receive_symbol ',
                  style: TextStyle(
                      fontSize: 13,
                      color: headingColor.value,
                      fontFamily: 'dmsans',
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                    text: getTranslated(context, "successfully.") ??
                        "successfully."),
              ],
            ),
          ),
          SizedBox(
            height: 32,
          ),

          BottomRectangularBtn(
              onTapFunc: () {
                Get.back();
                // Get.to(TransactionScreen());
              },
              btnTitle: "Close"),
          SizedBox(
            height: 12,
          ),

          // SizedBox(height: 24,),
        ],
      ),
    );
  }

  Widget slippageSettings() {
    var mini_slippage = slippage;

    return Obx(() => Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          color: primaryAltBackgroundColor.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, "Slippage Settings") ??
                        "Slippage Settings",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
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
                      ))
                ],
              ),
              SizedBox(
                height: 32,
              ),

              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: getTranslated(context,
                          "Your transaction will fail if the price changes more than the slippage. The recommended default is") ??
                      "Your transaction will fail if the price changes more than the slippage. The recommended default is",
                  style: TextStyle(
                      fontSize: 14,
                      color: lightTextColor.value,
                      fontFamily: 'Spectral',
                      fontWeight: FontWeight.w400),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' 1%  ',
                      style: TextStyle(
                          fontSize: 14,
                          color: headingColor.value,
                          fontFamily: 'dmsans',
                          fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text:
                          '- ${getTranslated(context, "too high of a value will result in an unfavorable trade.") ?? "too high of a value will result in an unfavorable trade."}',
                      // style: TextStyle(fontSize: 13, color: headingColor.value, fontFamily: 'dmsans', fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 32,
              ),

              // Auto Slippage Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, "Auto Slippage") ?? "Auto Slippage",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: headingColor.value,
                      fontFamily: "dmsans",
                    ),
                  ),
                  FlutterSwitch(
                    width: 50.0,
                    height: 25.0,
                    valueFontSize: 20.0,
                    toggleSize: 20.0,
                    value: mini_slippage.value < 0,
                    borderRadius: 30.0,
                    toggleColor: lightColor,
                    activeColor: primaryAltColor.value,
                    inactiveColor: labelColor.value,
                    padding: 2.0,
                    showOnOff: false,
                    onToggle: (val) {
                      
                      if (val) {
                        saveSlippage(-1.0);
                        mini_slippage.value = -1.0;
                      } else {
                        saveSlippage(1.0);
                        mini_slippage.value = 1.0;
                      }
                    },
                  ),
                ],
              ),

              SizedBox(height: 16),

              if (mini_slippage.value > 0) ...[
                SizedBox(
                  width: 197,
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          mini_slippage.value = updateCustomSlippage(false);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: ShapeDecoration(
                            color: primaryColor.value,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Center(
                              child: Container(
                            height: 2,
                            width: 10,
                            color: Colors.white,
                          )),
                        ),
                      ),
                      SizedBox(width: 32),
                      Text(
                        mini_slippage.value.toStringAsFixed(1),
                        style: TextStyle(
                          color: Color(0xff76CF56),
                          fontSize: 24,
                          fontFamily: 'dmsans',
                          fontWeight: FontWeight.w700,
                          height: 0.06,
                        ),
                      ),
                      SizedBox(width: 32),
                      InkWell(
                        onTap: () {
                          mini_slippage.value = updateCustomSlippage(true);
                        },
                        child: Container(
                          padding: EdgeInsets.all(7.50),
                          decoration: ShapeDecoration(
                            color: primaryColor.value,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                CustomSlidingSegmentedControl<int>(
                  fromMax: true,
                  customSegmentSettings: CustomSegmentSettings(
                    radius: 100,
                    hoverColor: inputFieldBackgroundColor2.value,
                    borderRadius: BorderRadius.circular(100),
                    highlightColor: inputFieldBackgroundColor2.value,
                    splashColor: inputFieldBackgroundColor2.value,
                  ),
                  isShowDivider: false,
                  isStretch: true,
                  initialValue: max(1, min(slippage.value.toInt(), 4)),
                  children: {
                    1: Text(
                      '1%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: headingColor.value,
                        fontSize: 14,
                        fontFamily: 'dmsans',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    2: Text(
                      '2%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: headingColor.value,
                        fontSize: 14,
                        fontFamily: 'dmsans',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    3: Text(
                      '3%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: headingColor.value,
                        fontSize: 14,
                        fontFamily: 'dmsans',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    4: Text(
                      '5%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: headingColor.value,
                        fontSize: 14,
                        fontFamily: 'dmsans',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )
                  },
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          width: 1, color: inputFieldBackgroundColor2.value)),
                  thumbDecoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xff76CF56),
                      Color(0xff55DDAF),
                    ]),
                    color: primaryColor.value,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInToLinear,
                  onValueChanged: (v) {
                    var f = v == 4 ? 5 : v;
                    saveSlippage(f.toDouble().toPrecision(1));
                  },
                ),
              ] else ...[
                // Show current auto slippage value
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: inputFieldBackgroundColor2.value,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getTranslated(
                                context, "Using optimal slippage from DEX") ??
                            "Using optimal slippage from DEX",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: headingColor.value,
                          fontFamily: "dmsans",
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(
                height: 32,
              ),

              BottomRectangularBtn(
                  onTapFunc: () {
                    Get.back();
                    // Get.bottomSheet(
                    //     clipBehavior: Clip.antiAlias,
                    //     isScrollControlled: true,
                    //     backgroundColor: primaryBackgroundColor.value,
                    //     shape: OutlineInputBorder(
                    //         borderSide: BorderSide.none,
                    //         borderRadius: BorderRadius.only(
                    //             topRight: Radius.circular(32),
                    //             topLeft: Radius.circular(32))),
                    //     swapCompleted());

                    // Get.to(TransactionScreen());
                  },
                  btnTitle: "Close"),
              // SizedBox(height: 8,),
              //
              // BottomRectangularBtn(
              //     onlyBorder: true,
              //     color: Colors.transparent,
              //     onTapFunc: (){
              //       Get.back();
              //       Get.back();
              //
              //
              //     }, btnTitle: "Cancel"),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ));
  }
}

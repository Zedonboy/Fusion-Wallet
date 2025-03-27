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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/VerifyPassword.dart';
import 'package:fusion_wallet/screens/pinScreen.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

// import '../codeScanner.dart';
class ConformationScreen extends StatefulWidget {
  WalletToken token;
  String to_addr;
  double amount = 0.0;
  ConformationScreen(
      {super.key, required this.token, required this.to_addr, this.amount = 0});

  @override
  State<ConformationScreen> createState() => _ConformationScreenState();
}

class _ConformationScreenState extends State<ConformationScreen> {
  TextEditingController nameAddreeC = TextEditingController();
  TextEditingController amountC = TextEditingController();
  AppController appController = Get.find<AppController>();
  var isOpen = true.obs;
  var isSending = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String calculate_final_amount(double amount, int decimals, BigInt fee) {
    // Multiply by 10^decimals
    // BigInt multiplier = BigInt.from(10).pow(decimals);
    BigInt result = BigInt.from(amount * pow(10, decimals));

    result = result + fee;

    return normalizeBalance(result, decimals);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, "Confirmation") ??
                              "Confirmation",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 32,
                            width: 32,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: inputFieldBackgroundColor.value,
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(
                              Icons.clear,
                              size: 18,
                              color: headingColor.value,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Text(
                      getTranslated(context, "Confirm Transfer") ??
                          "Confirm Transfer",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: headingColor.value,
                        fontFamily: "dmsans",
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      getTranslated(context,
                              "We care about your privacy.  Please make sure that you want to transfer money.") ??
                          "We care about your privacy.  Please make sure that you want to transfer money.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          // height:350,
                          width: Get.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                              color: inputFieldBackgroundColor2.value,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 32,
                              ),
                              // Text(
                              //   "Edrixc Jaye",
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(
                              //     fontSize: 24,
                              //     fontWeight: FontWeight.w700,
                              //     color: headingColor.value,
                              //     fontFamily: "dmsans",

                              //   ),

                              // ),
                              // SizedBox(height: 12,),
                              Text(
                                address_shortener(widget.to_addr),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: lightTextColor.value,
                                  fontFamily: "dmsans",
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    calculate_final_amount(
                                        widget.amount,
                                        widget.token.tokenDecimal ?? 8,
                                        BigInt.zero),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                      color: headingColor.value,
                                      fontFamily: "dmsans",
                                    ),
                                  ),
                                  Text(
                                    " ${widget.token.symbol}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: lightTextColor.value,
                                      fontFamily: "dmsans",
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(height: 6,),

                              Text(
                                () {
                                  final transferAmt = BigInt.from(widget
                                          .amount *
                                      pow(10, widget.token.tokenDecimal ?? 0));
                                  final price = appController
                                          .token_data_map[
                                              widget.token.tokenAddress]
                                          ?.price ??
                                      -1;
                                  return calculateUsdWorth(transferAmt,
                                      widget.token.tokenDecimal ?? 8, price);
                                }(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: lightTextColor.value,
                                  fontFamily: "dmsans",
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              ),
                              Divider(
                                color: inputFieldBackgroundColor.value,
                                height: 1,
                                thickness: 1,
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(context, "Transfer Fee") ??
                                        "Transfer Fee",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: lightTextColor.value,
                                      fontFamily: "dmsans",
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        normalizeBalance(
                                            widget.token.transferFee,
                                            widget.token.tokenDecimal ?? 8),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: headingColor.value,
                                          fontFamily: "dmsans",
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        widget.token.symbol,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: headingColor.value,
                                          fontFamily: "dmsans",
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(
                                            context, "Total to be sent") ??
                                        "Totak",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: lightTextColor.value,
                                      fontFamily: "dmsans",
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        calculate_final_amount(
                                            widget.amount,
                                            widget.token.tokenDecimal ?? 8,
                                            widget.token.transferFee),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: headingColor.value,
                                          fontFamily: "dmsans",
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        widget.token.symbol,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: headingColor.value,
                                          fontFamily: "dmsans",
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            top: -38,
                            child: SizedBox(
                              width: Get.width - 44,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 75,
                                    width: 75,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: lightColor,
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                primaryBackgroundColor.value)),
                                    child: appController.token_image_map[
                                          widget.token.tokenAddress],
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Column(
                  children: [
                    BottomRectangularBtn(
                      onTapFunc: () {
                        if (kIsWeb) {
                          trigger_pin_sequence();
                        } else {
                          trigger_send_sequence();
                        }
                      },
                      btnTitle: "Send",
                      isLoading: isSending.value,
                      isDisabled: isSending.value,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void start_sending() async {
    isSending.value = true;
    final icService = appController.ic_service;
    if (icService == null) {
      showToast("Error IC subcomponent is invalid");
      return;
    }

    final total =
        BigInt.from(widget.amount * pow(10, widget.token.tokenDecimal ?? 8));

    try {
      // checking if its an ICP with Account Id token Transfer
      if (widget.token.tokenAddress == "ryjl3-tyaaa-aaaaa-aaaba-cai" &&
          WalletContext.verifyAccountId(text: widget.to_addr)) {
        final blockHeigh =
            await icService.icpAccountIdSend(to: widget.to_addr, amount: total);
      } else {
        final blockHeight = await icService.send(
            token: widget.token, to: widget.to_addr, amount: total);
      }

      Get.back();
      Get.bottomSheet(
          clipBehavior: Clip.antiAlias,
          isScrollControlled: true,
          backgroundColor: primaryBackgroundColor.value,
          shape: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32), topLeft: Radius.circular(32))),
          confirmStatus());
    } catch (e) {
      isSending.value = false;
      print(e.toString());
      showToast("Error sending funds");
    }
  }

  void trigger_send_sequence() async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    if (canAuthenticate) {
      try {
        bool didAuth = await auth.authenticate(
            localizedReason: "Confirm your identity",
            options: AuthenticationOptions(biometricOnly: true));
        if (didAuth) {
          start_sending();
        }
      } catch (e) {
        trigger_pin_sequence();
      }
    } else {
      trigger_pin_sequence();
    }
  }

  void trigger_pin_sequence() {
    if (kIsWeb) {
      Get.to(() => VerifyPassword(onPasswordVerified: (p0) {
            Get.back();
            start_sending();
          },));
    } else {
      Get.to(() => PinScreen(
          isSignin: false,
          onPinConfirm: (data) {
            Get.back();
            start_sending();
          },
          onBiometric: (didAuth) {
            if (didAuth) {
              Get.back();
              start_sending();
            }
          },
        ));
    }
  }

  Widget confirmStatus() {
    return Container(
      height: Get.height * 0.6,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      color: primaryBackgroundColor.value,
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff76CF56).withOpacity(0.20),
                      Color(0xff55DDAF).withOpacity(0.20),
                    ]),
                shape: BoxShape.circle),
            child:
                Center(child: SvgPicture.asset("assets/svgs/shield-tick.svg")),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            getTranslated(context, "Transaction Completed") ??
                "Transaction Completed",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: headingColor.value,
              fontFamily: "dmsans",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            getTranslated(context,
                    "Your transaction has been completed, view details in transaction history.") ??
                "Your transaction has been completed, view details in transaction history.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: lightTextColor.value,
              fontFamily: "dmsans",
            ),
          ),
          SizedBox(
            height: 32,
          ),
          // BottomRectangularBtn(
          //     onTapFunc: () {
          //       // Get.to(TransactionScreen());
          //     },
          //     btnTitle: "View History"),
          SizedBox(
            height: 8,
          ),
          BottomRectangularBtn(
              onlyBorder: true,
              color: Colors.transparent,
              onTapFunc: () {
                Get.back();
              },
              btnTitle: "Ok"),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

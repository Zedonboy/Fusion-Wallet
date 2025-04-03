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
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/extensions.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TopUpScreen extends StatefulWidget {
  final String? canisterId;
  
  const TopUpScreen({super.key, this.canisterId});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  TextEditingController topAmountController = TextEditingController();
  AppController appController = Get.find<AppController>();
  var loading_balance = false.obs;
  var loading_xdr_estimate = false.obs;
  var icp_balance = "".obs;
  var xdr_estimate = BigInt.from(0).obs;
  var calculated_cycles = 0.0.obs;
  var is_minting = false.obs;
  var showAsInteger = false.obs;
  var canisterIdController = TextEditingController();
  var canisterIdErr = "".obs;
  // final tokenPrice = 12.50; // Example price - replace with actual token price

  @override
  void initState() {
    super.initState();
    topAmountController.addListener(() {
      final amt = topAmountController.text;
      if (amt.isNotEmpty) {
        final amtDouble = double.tryParse(amt) ?? 0.0;
        final cycles = xdr_estimate.value.toInt() * amtDouble;
        calculated_cycles.value = cycles;
      }
    });

    if (widget.canisterId != null) {
      canisterIdController.text = widget.canisterId!;
    }
    fetch_icp_balance();
  }

  fetch_icp_balance() async {
    final icpToken = WalletContext.getAllSupportedTokens()[1];
    final account = appController.active_wallet.value?.toIcpPrincipal();
    if (account != null) {
      loading_balance.value = true;
      appController.ic_service!
          .getBalance(token: icpToken, account: account)
          .then((value) {
        icp_balance.value =
            normalizeBalance(value, icpToken.tokenDecimal ?? 8);
      }).whenComplete(() {
        loading_balance.value = false;
      });
    }
  }

  Widget buildInputSection() {
    var controller = topAmountController;

    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: primaryAltBackgroundColor.value,
          border: Border.all(width: 1, color: inputFieldBackgroundColor.value)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryBackgroundColor.value),
                    child: Image.asset("assets/images/cycles.png"),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TCycles",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: headingColor.value,
                          fontFamily: "dmsans",
                        ),
                      ),
                      if (loading_balance.value)
                        Skeletonizer(
                          enabled: loading_balance.value,
                          effect: PulseEffect(
                            from: Colors.grey.withOpacity(0.2),
                            to: Colors.grey.withOpacity(0.8),
                          ),
                          child: Text(
                            "${getTranslated(context, "Available") ?? "Available"}: ${"0403"}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: lightTextColor.value,
                              fontFamily: "dmsans",
                            ),
                          ),
                        )
                      else
                        Text(
                          "${getTranslated(context, "Available") ?? "Available"}: ${icp_balance.value}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: lightTextColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                    ],
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  showAsInteger.value = !showAsInteger.value;
                  if (topAmountController.text.isNotEmpty) {
                    double? value = double.tryParse(
                        topAmountController.text.replaceAll(',', ''));
                    if (value != null) {
                      if (showAsInteger.value) {
                        topAmountController.text =
                            (value * 1000000000000).toStringAsFixed(0);
                      } else {
                        topAmountController.text =
                            (value / 1000000000000).toStringAsFixed(2);
                      }
                    }
                  }
                },
                child: Container(
                  height: 28,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: primaryBackgroundColor.value,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: lightTextColor.value.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        showAsInteger.value ? "Cycles" : "Trillion Cycles",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: lightTextColor.value,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.swap_horiz,
                        size: 12,
                        color: lightTextColor.value,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Divider(
              color: inputFieldBackgroundColor.value, height: 1, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: !showAsInteger.value),
                  style: TextStyle(
                    fontSize: showAsInteger.value ? 24 : 36,
                    fontWeight: FontWeight.w700,
                    color: headingColor.value,
                    fontFamily: "dmsans",
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "0",
                    hintStyle: TextStyle(
                      color: headingColor.value.withOpacity(0.5),
                      fontSize: showAsInteger.value ? 24 : 36,
                    ),
                    suffixText: null,
                  ),
                ),
              ),
              InkWell(
                  onTap: () {
                    topAmountController.text = icp_balance.value;
                  },
                  child: Container(
                    height: 24,
                    width: 50,
                    decoration: BoxDecoration(
                        color: lightTextColor.value,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        "Max",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffFFFFFF),
                          fontFamily: "dmsans",
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          height: Get.height * 0.5,
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top Up",
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
                      child: Icon(Icons.clear, color: headingColor.value))
                ],
              ),
              SizedBox(height: 32),
              // Calculator content
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildInputSection(),
                  // buildInputSection(false),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              InputFields(
                  headerText: "Canister Id",
                  hintText: "Canister Id",
                  hasHeader: true,
                  
                  textController: canisterIdController,
                  onChange: (v) {
                    canisterIdErr.value = '';
                  }),
              // Price info

              SizedBox(
                height: 20,
              ),
              BottomRectangularBtn(
                  onTapFunc: () {
                    topup();
                  },
                  btnTitle: "Top Up",
                  isLoading: is_minting.value,
                  isDisabled: is_minting.value)
            ],
          ),
        ));
  }

  topup() async {
    is_minting.value = true;
    final token = WalletContext.getAllSupportedTokens()[1];
    final toAccount = canisterIdController.text;
    var amount = BigInt.zero;

    if(showAsInteger.value){
      final amtStr = topAmountController.text.replaceAll(',', '');
      final amt = BigInt.tryParse(amtStr);
      if (amt == null) {
        showToast("Invalid amount");
        is_minting.value = false;
        return;
      }
      amount = amt;
    }else{
      final amountDouble = double.tryParse(topAmountController.text);
      if (amountDouble == null) {
        showToast("Invalid amount");
        is_minting.value = false;
        return;
      }
      amount = decimalToBlockchainUnits(amountDouble, token.tokenDecimal ?? 8);
    }

    if (amount <= BigInt.zero) {
      showToast("Amount must be greater than 0");
      is_minting.value = false;
      return;
    }
    try {
      
      final cyclesService = appController.ic_service!.createCyclesService();
      final result =
          await cyclesService.withdraw(to: toAccount, amount: amount);
      Get.back();
      Get.bottomSheet(
          clipBehavior: Clip.antiAlias,
          isScrollControlled: true,
          backgroundColor: primaryBackgroundColor.value,
          shape: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32), topLeft: Radius.circular(32))),
          CommonWidgets.confirmStatus("Top-up Successfully",
              "You have successfully top-up cycles to canister"));
    } catch (e) {
      print(e);
      Get.back();
      showToast("Error top-up");
    } finally {
      is_minting.value = false;
    }
  }

  @override
  void dispose() {
    topAmountController.dispose();

    super.dispose();
  }
}

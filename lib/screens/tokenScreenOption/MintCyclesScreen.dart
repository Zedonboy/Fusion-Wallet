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
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/extensions.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MintCyclesScreen extends StatefulWidget {
  MintCyclesScreen({super.key});

  @override
  State<MintCyclesScreen> createState() => _MintCyclesScreenState();
}

class _MintCyclesScreenState extends State<MintCyclesScreen> {
  TextEditingController topAmountController = TextEditingController();
  AppController appController = Get.find<AppController>();
  var loading_balance = false.obs;
  var loading_xdr_estimate = false.obs;
  var icp_balance = "".obs;
  var xdr_estimate = BigInt.from(0).obs;
  var calculated_cycles = 0.0.obs;
  var is_minting = false.obs;
  // final tokenPrice = 12.50; // Example price - replace with actual token price

  @override
  void initState() {
    super.initState();
    topAmountController.addListener(() {
      final amt = topAmountController.text;
      if (amt.isNotEmpty) {
        final amt_double = double.tryParse(amt) ?? 0.0;
        final cycles = xdr_estimate.value.toInt() * amt_double;
        calculated_cycles.value = cycles;
      }
    });
    fetch_icp_balance();
    fetch_xdr_estimate();
  }

  fetch_xdr_estimate() async {
    final account = appController.active_wallet.value?.toIcpPrincipal();
    final cycles_service = appController.ic_service!.createCyclesService();
    loading_xdr_estimate.value = true;
    cycles_service.getIcpXdrConversionRate().then((value) {
      print(value);
      final estimate = value.data.xdrPermyriadPerIcp;
      xdr_estimate.value = estimate;
    }).onError((error, stackTrace) {
      print(error);
    }).whenComplete(() {
      loading_xdr_estimate.value = false;
    });
  }

  fetch_icp_balance() async {
    final icp_token = WalletContext.getAllSupportedTokens()[0];
    final account = appController.active_wallet.value?.toIcpPrincipal();
    if (account != null) {
      loading_balance.value = true;
      appController.ic_service!
          .getBalance(token: icp_token, account: account)
          .then((value) {
        icp_balance.value =
            normalizeBalance(value, icp_token.tokenDecimal ?? 8);
      }).whenComplete(() {
        loading_balance.value = false;
      });
    }
  }

  Widget buildInputSection() {
    var controller = topAmountController;

    return Container(
      // height: 148,
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
                    child: Image.asset("assets/images/icp.png"),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ICP",
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: headingColor.value,
                    fontFamily: "dmsans",
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "0",
                    hintStyle: TextStyle(
                      color: headingColor.value.withOpacity(0.5),
                    ),
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
                    "Cycles Mint",
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
              SizedBox(height: 16),
              // Price info
              Container(
                width: Get.width,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: inputFieldBackgroundColor2.value,
                    border: Border.all(
                        width: 1, color: inputFieldBackgroundColor.value)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Quote per ICP",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: lightTextColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                        Text(
                          "${NumberFormat("#,###").format(xdr_estimate.value.toInt())} Trillion Cycles",
                          style: TextStyle(
                            fontSize: 14,
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
                        Text(
                          "You get",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: lightTextColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                        Text(
                          "${NumberFormat("#,##0.00").format(calculated_cycles.value)} Trillion Cycles",
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
              ),

              SizedBox(
                height: 20,
              ),
              BottomRectangularBtn(
                  onTapFunc: () {
                    mint_cycles();
                  },
                  btnTitle: "Mint Cycles",
                  isLoading: is_minting.value,
                  isDisabled: is_minting.value)
            ],
          ),
        ));
  }

  mint_cycles() async {
    is_minting.value = true;
    final icp_token = WalletContext.getAllSupportedTokens()[0];
    final account_principal =
        appController.active_wallet.value!.toIcpPrincipal();
    final to_account = WalletContext.generateAccountId(
        owner: cycles_minting_canister, subaccount: account_principal);
    final amount = decimalToBlockchainUnits(
        double.tryParse(topAmountController.text) ?? 0,
        icp_token.tokenDecimal ?? 8);
    if (amount <= BigInt.zero) {
      showToast("Amount must be greater than 0");
      is_minting.value = false;
      return;
    }
    // Mint Cycles memo
    final memo = BigInt.from(0x544e494d);

    try {
      final block_height = await appController.ic_service!
          .icpAccountIdSend(to: to_account, amount: amount, memo: memo);
      final cycles_service = appController.ic_service!.createCyclesService();
      final result =
          await cycles_service.notifyMintCycles(blockIndex: block_height);
      Get.back();
      Get.bottomSheet(
          clipBehavior: Clip.antiAlias,
          isScrollControlled: true,
          backgroundColor: primaryBackgroundColor.value,
          shape: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32), topLeft: Radius.circular(32))),
          CommonWidgets.confirmStatus("Minted Successfully",
              "You have successfully minted ${result.minted / BigInt.from(pow(10, 12))} Trillion Cycles."));
    } catch (e) {
      print(e);
      Get.back();
      showToast("Error minting cycles");
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

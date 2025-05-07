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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ChargeScreen extends StatefulWidget {
  WalletToken token;
  String pay_url;
  double amount;
  String? memo;
  ChargeScreen({super.key, required this.token, required this.pay_url, required this.amount, this.memo});

  @override
  State<ChargeScreen> createState() => _ChargeScreenState();
}

class _ChargeScreenState extends State<ChargeScreen> {
  AppController appController = Get.find<AppController>();
  var acc_id = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    acc_id = appController.active_wallet.value!.toAccountIdentifier();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: headingColor.value,
                      size: 18,
                    )),
                SizedBox(
                  width: 8,
                ),
                Text(
                  getTranslated(context, "Charge") ?? "Charge",
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
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Text(
                  "Pay ${widget.amount} ${widget.token.symbol}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: headingColor.value,
                    fontFamily: "dmsans",
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 14,
            ),
            
            SizedBox(
              height: 28,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // QrImageView(data: widget.address, padding: EdgeInsets.all(16), eyeStyle: QrEyeStyle(eyeShape: e),),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: primaryAltBgColor2,
                      border: Border.all(width: 1, color: primaryAltBgColor2)),
                  child: QrImageView(
                    data: widget.pay_url,
                    size: 227,
                    version: QrVersions.auto,
                    backgroundColor: appController.isDark.value == true
                        ? headingColor.value
                        : primaryColor.value,
                  ),
                ),
                // Container(
                //   height: 227,
                //   width: 227,
                //   padding: EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(18),
                //     color: inputFieldBackgroundColor.value,
                //     border: Border.all(width: 1,color: inputFieldBackgroundColor2.value)
                //   ),
                //   child: Image.asset("assets/images/Mask group.png",color: appController.isDark.value==true?headingColor.value:primaryColor.value,),
                // ),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              getTranslated(context,
                      widget.memo ??
                          "Send only the specified coins to this deposit address. This address does NOT support deposit of non-fungible token.") ??
                  widget.memo ??
                  "",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: lightTextColor.value,
                fontFamily: "dmsans",
              ),
            ),
            SizedBox(
              height: 12,
            ),
           
            SizedBox(
              height: 18,
            ),
            
            SizedBox(
              height: 16,
            ),
            
            SizedBox(
              height: 44,
            ),
            
          ],
        ),
      ),
    );
  }
}

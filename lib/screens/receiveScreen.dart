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

class ReceiveScreen extends StatefulWidget {
  WalletToken token;
  String address;
  ReceiveScreen({super.key, required this.token, required this.address});

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
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
                  getTranslated(context, "Receive") ?? "Receive",
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
                Container(
                    height: 28,
                    clipBehavior: Clip.antiAlias,
                    width: 28,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: lightColor),
                    child: appController
                        .token_image_map[widget.token.tokenAddress]),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.token.symbol,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    copyToClipboard(widget.address);
                  },
                  child: Container(
                    // width: 190,
                    height: 33,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: ShapeDecoration(
                      color: Color(0x191C1924),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: cardcolor.value),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          address_shortener(widget.address),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 4),
                        Container(
                          width: 20,
                          height: 20,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: SvgPicture.asset("assets/svg/Icons.svg"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                    data: widget.address,
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
                      "Send only the specified coins to this deposit address. This address does NOT support deposit of non-fungible token.") ??
                  "Send only the specified coins to this deposit address. This address does NOT support deposit of non-fungible token.",
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
            Divider(
              height: 1,
              color: inputFieldBackgroundColor2.value,
            ),
            SizedBox(
              height: 18,
            ),
            Text(
              getTranslated(context, "For Account ID Only") ??
                  "For Account ID Only",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: lightTextColor.value,
                fontFamily: "dmsans",
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    copyToClipboard(acc_id);
                  },
                  child: Container(
                    // width: 190,
                    height: 33,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: ShapeDecoration(
                      color: Color(0x191C1924),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: cardcolor.value),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          address_shortener(acc_id,
                              start_count: 8, end_count: 5),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 4),
                        Container(
                          width: 20,
                          height: 20,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: SvgPicture.asset("assets/svg/Icons.svg"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 44,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Share.share(widget.address);
                    },
                    child: Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: primaryAltColor.value,
                          ),
                          borderRadius: BorderRadius.circular(100)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   "assets/images/share.png",
                          //   height: 20,
                          //   width: 20,
                          // ),
                          Icon(
                            Icons.share,
                            color: primaryAltColor.value,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Share',
                            style: TextStyle(
                              color: primaryAltColor.value,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      copyToClipboard(widget.address).then((_) {
                        showToast("Copied successfully");
                      });
                    },
                    child: Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: primaryAltColor.value,
                          borderRadius: BorderRadius.circular(100)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/copy.png",
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Copy',
                            style: TextStyle(
                              color: textDarkColor.value,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
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
    );
  }
}

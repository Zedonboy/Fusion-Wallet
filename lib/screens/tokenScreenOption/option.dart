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
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/tokenScreenOption/MintCyclesScreen.dart';
import 'package:fusion_wallet/screens/tokenScreenOption/TopUpScreen.dart';
import 'package:get/route_manager.dart';

abstract class TokenScreenOption {
  List<Widget> getOptions(BuildContext context, AppController appController);
}

class CyclesScreenOption extends TokenScreenOption {
  @override
  List<Widget> getOptions(BuildContext context, AppController appController) {
    return [
      GestureDetector(
        onTap: () {
          Get.bottomSheet(
              clipBehavior: Clip.antiAlias,
              isScrollControlled: true,
              backgroundColor: primaryBackgroundColor.value,
              shape: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32),
                      topLeft: Radius.circular(32))),
              MintCyclesScreen());
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
                  child: SvgPicture.asset("assets/svgs/bolt.svg",
                      height: 28, width: 28, color: Color(0xFFA2BBFF))),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              getTranslated(context, "Mint") ?? "Mint",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xffFDFCFD),
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
              backgroundColor: primaryBackgroundColor.value,
              shape: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32),
                      topLeft: Radius.circular(32))),
              TopUpScreen());
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
                  child: SvgPicture.asset("assets/svgs/pump.svg",
                      height: 28, width: 28, color: Color(0xFFA2BBFF))),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              getTranslated(context, "Top-up") ?? "Mint",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xffFDFCFD),
                fontFamily: "dmsans",
              ),
            ),
          ],
        ),
      ),
    ];
  }
}

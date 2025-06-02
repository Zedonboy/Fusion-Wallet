/**
 * Copyright (C) 2025 Fusion Wallet
 * 
 * This file is part of Fusion Wallet.
 * 
 * Fusion Wallet is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Fusion Wallet is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Fusion Wallet.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/deferred_prompt.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:get/get.dart';

class ProvisionScreen extends StatefulWidget {
  const ProvisionScreen({super.key});

  @override
  State<ProvisionScreen> createState() => _ProvisionScreenState();
}

class _ProvisionScreenState extends State<ProvisionScreen> {
  final appController = Get.find<AppController>();
  final walletAddress = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx".obs;

  @override
  void initState() {
    super.initState();
    init_provision_wallet().then((value) {
      if (value != null) {
        walletAddress.value = value;
      } else {
        CommonWidgets().showErrorSnackbar('Error!', 'Error Getting Deposit Address');
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryAltBackgroundColor.value,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Text(
                      'Provision Your Wallet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 311,
                      child: Text(
                        'Deposit at least 1 ICP to the address below to create and deploy your wallet on chain',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primaryColor.value,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "ICP Deposit Address",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: lightAltTextColor.value,
                              fontFamily: "dmsans",
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  copyToClipboard(walletAddress.value);
                                },
                                child: Container(
                                  // width: 190,
                                  height: 33,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: ShapeDecoration(
                                    color: Color(0x191C1924),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 0.50, color: cardcolor.value),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        address_shortener(walletAddress.value),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
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
                                        child: SvgPicture.asset(
                                            "assets/svg/Icons.svg"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          SizedBox(height: 4),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: shapeDecorationDarkColor.value,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Deposit Information',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Minimum Deposit:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '1 ICP',
                                style: TextStyle(
                                  color: primaryAltColor.value,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Service Charge:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '0.6 ICP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Cycles Creation:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '0.4 ICP or more',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.value.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Icon(
                      //   Icons.info_outline,
                      //   color: primaryColor.value,
                      //   size: 18,
                      // ),
                      SizedBox(width: 8),

                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: headingColor.value,
                              fontSize: 11,
                              fontFamily: 'dmsans',
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "Your deposited ICP will be converted to cycles to create a secure private ",
                              ),
                              TextSpan(
                                text: "Onchain Wallet",
                                style: TextStyle(
                                  color: greenColor.value,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: " that leverages ICP ",
                              ),
                              TextSpan(
                                text: "ChainFusion",
                                style: TextStyle(
                                  color: primaryColor.value,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " to generate signatures necessary to communicate and submit transactions to other blockchains, which eliminates the need for seedphrase and its security risks.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    BottomRectangularBtn(
                        onTapFunc: () {
                          // Check if deposit was made and proceed
                          checkProvisionStatus();
                        },
                        btnTitle: "Provision Wallet"),
                    SizedBox(
                      height: 32,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkProvisionStatus() async {
    // In a real implementation, this would check if the deposit was made
    // For now, we'll just show a loading dialog and then proceed

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
                'Checking deposit status...',
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

    try {
      await check_provision_status();
    } catch (e) {
      Get.back();
      print(e);
      CommonWidgets().showErrorSnackbar('Error!', "Error Provisioning Wallet");
    }
  }
}

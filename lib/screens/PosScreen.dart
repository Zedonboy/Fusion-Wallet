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

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/common_widgets/RecentPaymentLinks.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/common_widgets/keyboardDone.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/ChargeScreen.dart';
import 'package:fusion_wallet/src/rust/api/utils.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../controllers/appController.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PosScreen extends StatefulWidget {
  PosScreen({super.key, required this.token});

  final WalletToken token;
  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final appController = Get.find<AppController>();
  TextEditingController toAddressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  var addressErr = ''.obs;
  var amountErr = ''.obs;
  FocusNode numberFocusNode = FocusNode();
  var isOpen = true.obs;
  var paymentLinks = <PaymentLink>[].obs;
  var isLoading = false.obs;
  var _isProcessing = false.obs;
  var _isRequestingLink = false.obs;

  fetch_payments() async {
    isLoading.value = true;
    try {
      final payment = appController.ic_service!.createPaymentService();
      final payments = await payment.getPaymentLink();
      paymentLinks.value = payments.reversed.toList();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isIOS) {
      numberFocusNode.addListener(() {
        bool hasFocus = numberFocusNode.hasFocus;
        if (hasFocus) {
          KeyboardOverlay.showOverlay(context);
        } else {
          KeyboardOverlay.removeOverlay();
        }
      });
    }

    fetch_payments();
  }

  @override
  void dispose() {
    // Clean up the focus node
    numberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: Get.width,
                              // height: 44,
                              decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      height: 32,
                                      width: 32,
                                      padding: EdgeInsets.all(6),
                                      decoration: ShapeDecoration(
                                        color: cardcolor.value,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Pos terminal',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0.09,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     Get.back();
                                  //   },
                                  //   child: Container(
                                  //     padding: EdgeInsets.all(6),
                                  //     decoration: ShapeDecoration(
                                  //       color: cardcolor.value,
                                  //       shape: RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.circular(8)),
                                  //     ),
                                  //     child: Icon(
                                  //       Icons.history,
                                  //       color: Colors.white,
                                  //       size: 30,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Memo:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: toAddressController,
                                    cursorColor: primaryColor.value,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Write Memo",
                                      hintStyle: TextStyle(
                                        color: labelColorPrimaryShade.value,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                    onChanged: (v) {
                                      addressErr.value = '';
                                    },
                                  ),
                                ),
                                SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () async {
                                    final clipboardData =
                                        await Clipboard.getData(
                                            Clipboard.kTextPlain);
                                    toAddressController.text =
                                        clipboardData?.text ?? '';
                                    setState(() {});
                                    addressErr.value = '';
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: ShapeDecoration(
                                      color: Color(0x2670EDEF),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Paste',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4),
                              ],
                            ),
                          ],
                        ),
                        CommonWidgets.showErrorMessage(addressErr.value),
                        SizedBox(
                          height: Get.height * 0.085,
                        ),
                        Container(
                          width: Get.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 12),
                              Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: Get.width,
                                      child: TextFormField(
                                        controller: amountController,
                                        cursorColor: primaryColor.value,
                                        textAlign: TextAlign.center,
                                        focusNode: numberFocusNode,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: false, decimal: true),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "0 ${widget.token.symbol}",
                                          hintStyle: TextStyle(
                                            color: labelColorPrimaryShade.value,
                                            fontSize: 36,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        onChanged: (v) {
                                          amountErr.value = '';
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // GestureDetector(
                              //   onTap: () {
                              //     setState(() {
                              //       amountController.text = '0';
                              //       amountErr.value = '';
                              //     });
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: 16, vertical: 12),
                              //     decoration: ShapeDecoration(
                              //       color: Color(0x1970ECEF),
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(4)),
                              //     ),
                              //     child: Row(
                              //       mainAxisSize: MainAxisSize.min,
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       children: [
                              //         Text(
                              //           'Max',
                              //           style: TextStyle(
                              //             color: primaryColor.value,
                              //             fontSize: 12,
                              //             fontFamily: 'Poppins',
                              //             fontWeight: FontWeight.w500,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: 100,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // final amount = decimalToBlockchainUnits(double.parse(amountController.text), widget.token.tokenDecimal ?? 8);
                                        final pay_url =
                                            "icp:mainnet/${widget.token.tokenAddress}/icrc1_transfer?amount=${amountController.text}&memo=${toAddressController.text}&to=${appController.active_wallet.value!.toIcpPrincipal()}";
                                        final amount = double.tryParse(
                                            amountController.text);
                                        final memo = toAddressController.text;
                                        if (amount == null || amount <= 0) {
                                          amountErr.value = "Invalid amount";
                                          return;
                                        }
                                        Get.to(() => ChargeScreen(
                                              token: widget.token,
                                              pay_url: pay_url,
                                              amount: amount,
                                              memo: memo,
                                            ));
                                      },
                                      child: Container(
                                        height: 50,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: primaryAltColor.value,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Image.asset(
                                            //   "assets/images/share.png",
                                            //   height: 20,
                                            //   width: 20,
                                            // ),
                                            Icon(
                                              Icons.qr_code,
                                              color: primaryAltColor.value,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'Charge',
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
                                      onTap: _isRequestingLink.value ? null : () async {
                                        _isRequestingLink.value = true;
                                        try {
                                          final payment = appController
                                              .ic_service!
                                              .createPaymentService();
                                          final amount = double.tryParse(
                                              amountController.text);
                                          final memo = toAddressController.text;
                                          if (amount == null || amount <= 0) {
                                            showToast("Invalid amount");
                                            return;
                                          }
                                          final qr_data =
                                              "icp:mainnet/${widget.token.tokenAddress}/icrc1_transfer?amount=${amountController.text}&memo=${toAddressController.text}&to=${appController.active_wallet.value!.toIcpPrincipal()}";
                                          final link = PaymentLink(
                                              amount: amountController.text,
                                              qrData: qr_data,
                                              tokenSymbol: widget.token.symbol,
                                              id: "fsf",
                                              memo: memo,
                                              createdAt: BigInt.zero,
                                              recipient: "");
                                          final link_id = await payment
                                              .createPaymentLink(arg: link);
                                          print(link_id);
                                          showToast("Link created");
                                          await fetch_payments();
                                        } finally {
                                          _isRequestingLink.value = false;
                                        }
                                      },
                                      child: Obx(() => Container(
                                        height: 50,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          color: _isRequestingLink.value 
                                            ? primaryAltColor.value.withOpacity(0.5)
                                            : primaryAltColor.value,
                                          borderRadius: BorderRadius.circular(100)
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (_isRequestingLink.value)
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  color: textDarkColor.value,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            else
                                              Icon(Icons.link, color: textDarkColor.value),
                                            SizedBox(width: 8),
                                            Text(
                                              'Request link',
                                              style: TextStyle(
                                                color: textDarkColor.value,
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       getTranslated(
                              //               context, "Recent Payment Links") ??
                              //           "Recent Payment Links",
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(
                              //         fontSize: 15,
                              //         fontWeight: FontWeight.w600,
                              //         color: headingColor.value,
                              //         fontFamily: "dmsans",
                              //       ),
                              //     ),
                              //     GestureDetector(
                              //         onTap: () {
                              //           isOpen.value = !isOpen.value;
                              //         },
                              //         child: Icon(
                              //           isOpen.value == true
                              //               ? Icons.keyboard_arrow_up_sharp
                              //               : Icons.keyboard_arrow_down_sharp,
                              //           size: 27,
                              //           color: headingColor.value,
                              //         ))
                              //   ],
                              // ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(Container(
                      height: 60,
                      color: primaryBackgroundColor.value,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated(context, "Recent Payment Links") ??
                                "Recent Payment Links",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: headingColor.value,
                              fontFamily: "dmsans",
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                isOpen.value = !isOpen.value;
                              },
                              child: Icon(
                                isOpen.value == true
                                    ? Icons.keyboard_arrow_up_sharp
                                    : Icons.keyboard_arrow_down_sharp,
                                size: 27,
                                color: headingColor.value,
                              ))
                        ],
                      ))),
                  pinned: true,
                ),
              ];
            },
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: isOpen.value
                  ? RecentPaymentLinks(
                      isLoading: isLoading.value,
                      paymentLinks: paymentLinks,
                    )
                  : SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget _tabBar;

  _SliverAppBarDelegate(this._tabBar);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 30;
}

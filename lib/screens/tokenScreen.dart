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
import 'package:fusion_wallet/common_widgets/RecentTransactions.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/receiveScreen.dart';
import 'package:fusion_wallet/screens/sendScreens/sendScreen.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:fusion_wallet/src/rust/api/wallet_service.dart';
import 'package:get/get.dart';


// import '../nfts/nftsScreen.dart';
class TokenScreen extends StatefulWidget {
  WalletToken token;
  TokenScreen({super.key, required this.token});

  @override
  State<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  AppController appController = Get.find<AppController>();
  var is_loading = true;
  List<SimpleTransaction> transaction_list = [];

  fetch_transactions() async {
    final icService = appController.ic_service;
    final addr = appController.active_wallet.value!.toIcpPrincipal();
    try {
      final txs = await icService?.getLatestTransactions(
          token: widget.token, accountAddr: addr);
      setState(() {
        is_loading = false;
        transaction_list = txs ?? [];
      });
    } catch (e) {
      print(e.toString());
      showToast("Error fetching transaction");
      setState(() {
        is_loading = false;
        //  transaction_list = txs ?? [];
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fetch_transactions();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: darkBlueColor.value,
                            size: 16,
                          )),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.token.symbol.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: darkBlueColor.value,
                          fontFamily: "dmsans",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              Center(
                child: Container(
                  height: 40,
                  width: 40,
                  clipBehavior: Clip.antiAlias,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lightColor,
                  ),
                  child:
                      appController.token_image_map[widget.token.tokenAddress],
                ),
              ),
              SizedBox(height: 8),
// Balance Display
              Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: () {
                            final tokenData = appController
                                .token_data_map[widget.token.tokenAddress];
                            if (tokenData == null) {
                              return "---";
                            }

                            return normalizeBalance(tokenData.balance,
                                widget.token.tokenDecimal ?? 8);
                          }(),
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w700,
                            color: appController.isDark.value == true
                                ? const Color(0xffFDFCFD)
                                : primaryAltColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 8),
                  Text(
                    () {
                      

                      final tokenData =
                          appController.token_data_map[widget.token.tokenAddress];
                      if (tokenData == null) return "---";
                      return calculateUsdWorth(tokenData.balance,
                          widget.token.tokenDecimal ?? 8, tokenData.price);
                    }(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: lightAltTextColor.value,
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
                      Get.to(() => SendScreen(token: widget.token));
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
                      var addr = switch (widget.token.network) {
                        WalletTokenNetWork.bitcoin =>
                          appController.active_wallet.value?.toBitcoinAddress(),
                        WalletTokenNetWork.internetComputer =>
                          appController.active_wallet.value?.toIcpPrincipal(),
                      };

                      if (addr == null) {
                        showToast("No Address or Principal ID found");
                        return;
                      }
                      Get.to(() =>
                          ReceiveScreen(token: widget.token, address: addr));
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
                  //     Get.to(() => SwapScreen());
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
                  // GestureDetector(
                  //   onTap: (){
                  // Get.to(NftsScreen());
                  //   },
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         height: 56,
                  //         width: 56,
                  //         padding: EdgeInsets.all(12),
                  //         decoration: BoxDecoration(
                  //             color: primaryColor.value,
                  //             borderRadius: BorderRadius.circular(15)
                  //         ),
                  //         child: Center(child: SvgPicture.asset("assets/svgs/buy.svg",height: 28,width: 28,)),
                  //       ),
                  //       SizedBox(height: 12,),
                  //       Text(
                  //         "Nft",
                  //         textAlign: TextAlign.start,
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w600,
                  //           color: primaryColor.value,
                  //           fontFamily: "dmsans",
                  //
                  //         ),
                  //
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              SizedBox(
                height: 32,
              ),

              RecentTransfers(
                isLoading: is_loading,
                transfers: transaction_list,
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fusion_wallet/common_widgets/futureImageWidget.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/importToken.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';

class SelectTokenScreen extends StatefulWidget {
  const SelectTokenScreen({super.key});

  @override
  State<SelectTokenScreen> createState() => _SelectTokenScreenState();
}

class _SelectTokenScreenState extends State<SelectTokenScreen> {
  final AppController appController = Get.find<AppController>();
  final TextEditingController searchController = TextEditingController();
  var all_tokens = <WalletToken>[];
  RxList<WalletToken> filteredTokens = RxList();
  final isSearching = false.obs;
  Future? queryFuture;

  void performSearch(String query) {
    queryFuture?.ignore();
    isSearching.value = true;

    //Simulate network delay
    queryFuture = Future.microtask(() {
      filteredTokens.value = all_tokens
          .where((token) =>
              token.symbol.toLowerCase().contains(query.toLowerCase()) ||
              token.tokenName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      isSearching.value = false;
    });
  }
  // final RxMap<String, bool> tokenStates = <String, bool>{}.obs;

  @override
  void initState() {
    super.initState();
    
    
    // Convert the list to a map for easier lookup
    final alltokensMap = {for (var token in WalletContext.getAllSupportedTokens()) token.tokenAddress: token};
    // Initialize token states based on what's already in the app controller
    for (var token in appController.tokens_map.values) {
      if (alltokensMap.containsKey(token.tokenAddress)) {
        continue;
      } else {
        alltokensMap[token.tokenAddress] = token;
      }
    }
    all_tokens = alltokensMap.values.toList();
    filteredTokens.value = all_tokens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            children: [
              // Header
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
                        getTranslated(context, "Manage Token") ??
                            "Manage Token",
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
                  GestureDetector(
                    onTap: () {
                      Get.off(ImportToken());
                    },
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: inputFieldBackgroundColor2.value),
                      child: Center(
                          child: Icon(
                        Icons.add,
                        color: headingColor.value,
                        size: 20,
                      )),
                    ),
                  )
                ],
              ),
              SizedBox(height: 16),

              // Search Input
              InputFields(
                textController: searchController,
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
                hintText: "Search tokens",
              ),
              SizedBox(height: 24),

              // Token List
              Expanded(
                child: Obx(() => ListView.separated(
                      itemCount: filteredTokens.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final token = filteredTokens[index];
                        final tokenAddress = token.tokenAddress;

                        return Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: inputFieldBackgroundColor2.value,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: 1,
                              color: inputFieldBackgroundColor.value,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: lightColor,
                                    ),
                                    child: FutureAdaptiveImage(
                                        imageUrl: token.imageUrl ??
                                            "assets/images/usd.png"),
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        token.symbol,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: headingColor.value,
                                          fontFamily: "dmsans",
                                        ),
                                      ),
                                      Text(
                                        token.tokenName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: lightTextColor.value,
                                          fontFamily: "dmsans",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              FlutterSwitch(
                                width: 50.0,
                                height: 25.0,
                                valueFontSize: 12.0,
                                toggleSize: 20.0,
                                activeColor: primaryAltColor.value,
                                inactiveColor: inputFieldBackgroundColor.value,
                                value: appController.tokens_map
                                    .containsKey(tokenAddress),
                                onToggle: (val) {
                                  HapticFeedback.lightImpact();
                                  if (val) {
                                    appController.addToken(token);
                                    filteredTokens.refresh();
                                    showToast("${token.symbol} added");
                                  } else {
                                    appController.tokens_map
                                        .remove(tokenAddress);
                                    filteredTokens.refresh();
                                    appController.tokens_map.refresh();
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */


import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/src/rust/api/nft_service.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';

class NFTData {
  final BigInt id;
  final Map<String, CollectMetaValue> properties;
  final WalletCollection collection;

  NFTData(
      {required this.id, required this.collection, required this.properties});
}

class NftDetails extends StatefulWidget {
  final NFTData data;
  const NftDetails({super.key, required this.data});

  @override
  State<NftDetails> createState() => _NftDetailsState();
}

class _NftDetailsState extends State<NftDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: headingColor.value,
                      size: 16,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    
                    getTranslated(context, "${widget.data.collection.symbol} #${widget.data.id}") ??
                        "${widget.data.collection.symbol} #${widget.data.id}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: headingColor.value,
                      fontSize: 15,
                      fontFamily: 'dmsans',
                      fontWeight: FontWeight.w600,
                      height: 0.09,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          widget.data.collection.symbol,
                                          style: TextStyle(
                                            color: headingColor.value,
                                            fontSize: 16.5,
                                            fontFamily: 'dmsans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '#${widget.data.id}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: headingColor.value,
                                              fontSize: 14,
                                              fontFamily: 'dmsans',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Hero(
                                    tag: widget.data.id.toString(),
                                    child: Container(
                                      width: Get.width,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.data.properties["logo"]?.field0.toString() ?? widget.data.collection.imageUrl ??
                                        'https://media.istockphoto.com/id/1372146767/photo/nft-hexagons-pixelated-concept.jpg?b=1&s=612x612&w=0&k=20&c=4dMyZNzeFIAQfDvEL_jHqOa1eUYxsAymj-GwIUxK95Q=',
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.person),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          getTranslated(
                                                  context, "Description") ??
                                              "Description",
                                          style: TextStyle(
                                            color: headingColor.value,
                                            fontSize: 16.5,
                                            fontFamily: 'dmsans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      // Row(
                                      //   mainAxisSize: MainAxisSize.min,
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   crossAxisAlignment:
                                      //       CrossAxisAlignment.center,
                                      //   children: [
                                      //     Image.asset(
                                      //       "assets/images/simple-icons_tether.png",
                                      //       color: headingColor.value,
                                      //       height: 12,
                                      //       width: 12,
                                      //     ),
                                      //     Text(
                                      //       ' 6.64',
                                      //       textAlign: TextAlign.center,
                                      //       style: TextStyle(
                                      //         color: headingColor.value,
                                      //         fontSize: 14,
                                      //         fontFamily: 'dmsans',
                                      //         fontWeight: FontWeight.w700,
                                      //       ),
                                      //     )
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  SizedBox(
                                    width: Get.width,
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          
                                          widget.data.properties['description']?.field0.toString() ?? widget.data.collection.desciption ?? "",
                                          style: TextStyle(
                                            color: lightTextColor.value,
                                            fontSize: 12,
                                            fontFamily: 'dmsans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  child: Text(
                                                    getTranslated(context,
                                                            "Properties") ??
                                                        "Properties",
                                                    style: TextStyle(
                                                      color: headingColor.value,
                                                      fontSize: 16.5,
                                                      fontFamily: 'dmsans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        ListView.separated(
                                            itemBuilder: (builder, index) {
                                              final entry = widget
                                                  .data.properties.entries
                                                  .elementAt(index);
                                              if (entry.key == "logo") {
                                                return null;
                                              }
                                              if (entry.key == "description") {
                                                return null;
                                              }

                                              return SizedBox(
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 80,
                                                      child: Text(
                                                        getTranslated(
                                                                context,
                                                                entry.key
                                                                        .capitalizeFirst ??
                                                                    entry
                                                                        .key) ??
                                                            entry.key,
                                                        style: TextStyle(
                                                          color: lightTextColor
                                                              .value,
                                                          fontSize: 14,
                                                          fontFamily: 'dmsans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      entry.value.field0
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color:
                                                            headingColor.value,
                                                        fontSize: 14,
                                                        fontFamily: 'dmsans',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return SizedBox(height: 12);
                                            },
                                            itemCount:
                                                widget.data.properties.length),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                  getTranslated(context,
                                                          "Canister Id") ??
                                                      "Canister Id",
                                                  style: TextStyle(
                                                    color: lightTextColor.value,
                                                    fontSize: 14,
                                                    fontFamily: 'dmsans',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Material(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  splashColor: Colors.grey
                                                      .withOpacity(0.1),
                                                  highlightColor: Colors.grey
                                                      .withOpacity(0.05),
                                                  onTap: () {
                                                    copyToClipboard(widget
                                                        .data
                                                        .collection
                                                        .tokenAddress);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4,
                                                            vertical: 2),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          address_shortener(
                                                              widget
                                                                  .data
                                                                  .collection
                                                                  .tokenAddress),
                                                          style: TextStyle(
                                                            color: subtextColor
                                                                .value,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'DM Sans',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Icon(Icons.copy,
                                                            size: 12,
                                                            color: subtextColor
                                                                .value),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      // BottomRectangularBtn(
                      //     onTapFunc: () {
                      //       // Navigator.push(context, PageTransition(duration: Duration(milliseconds: 100), type: PageTransitionType.topToBottom, child: SendNftScreen(nft: widget.nft, onSent: (){
                      //       //   widget.onSent.call();
                      //       //   Get.back();
                      //       //
                      //       // },)));
                      //     },
                      //     btnTitle: "Transfer NFT"),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
import 'package:flutter_svg/svg.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/nfts/nftsDetail.dart';
import 'package:fusion_wallet/src/rust/api/nft_service.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CollectionDetailScreen extends StatefulWidget {
  WalletCollection collection;
  CollectionDetailScreen({super.key, required this.collection});

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  final appController = Get.find<AppController>();
  var isLoading = false.obs;
  var count = 0.obs;
  RxList<(BigInt, Map<String, CollectMetaValue>)> items_list = RxList();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  fetch() async {
    if (appController.ic_service == null ||
        appController.active_wallet.value == null) return;
    final account = appController.active_wallet.value!.toIcpPrincipal();
    try {
      isLoading.value = true;
      final nftservice = appController.ic_service!.createCollectionService();
      final items_list = await nftservice.getTokensOwnedByAccount(
          collection: widget.collection, account: account);
      count.value = items_list.length;
      this.items_list.value = items_list;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: primaryBackgroundColor.value,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: inputFieldBackgroundColor2.value),
                          child: Center(
                              child: Icon(
                            Icons.arrow_back_ios_new,
                            color: headingColor.value,
                            size: 20,
                          )),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        getTranslated(context, widget.collection.symbol) ??
                            widget.collection.symbol,
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

                  SizedBox(
                    height: 12,
                  ),

                  Expanded(
                      child: ListView(
                    children: [
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        count.string,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffFDFCFD),
                          fontFamily: "dmsans",
                        ),
                      ),
                      Text(
                        "items",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: lightTextColor.value,
                          fontFamily: "dmsans",
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Text(
                              getTranslated(context, "Description") ??
                                  "Description",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/simple-icons_tether.png",
                                color: headingColor.value,
                                height: 12,
                                width: 12,
                              ),
                              Text(
                                ' 6.64',
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
                      SizedBox(
                        width: Get.width,
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.collection.desciption ?? "",
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
                      SizedBox(
                        height: 16,
                      ),
                      FutureBuilder(
                          future: fetch(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (items_list.isEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/noTransactions.svg'),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      width: Get.width,
                                      child: Text(
                                        'No NFT items',
                                        style: TextStyle(
                                          color: primaryColor.value,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return GridView.builder(
                                  padding: EdgeInsets.only(
                                      top: 0.0,
                                      bottom: 80,
                                      left: 2.0,
                                      right: 2),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 190,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                          crossAxisCount: 2),
                                  itemCount: items_list.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final (id, map) =
                                        items_list.elementAt(index);
                                    return GestureDetector(
                                      onTap: () {
                                        final data = NFTData(
                                            id: id,
                                            collection: widget.collection,
                                            properties: map);
                                        Get.to(NftDetails(
                                          data: data,
                                        ));
                                      },
                                      child: Container(
                                        // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                        decoration: ShapeDecoration(
                                          color:
                                              inputFieldBackgroundColor2.value,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Column(
                                          // mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Hero(
                                              tag: id.toString(),
                                              child: Container(
                                                height: 130,
                                                width: Get.width,
                                                clipBehavior: Clip.antiAlias,
                                                padding: EdgeInsets.zero,
                                                decoration: ShapeDecoration(
                                                  color: Color(0xFFC4C4C4),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(0),
                                                      topRight:
                                                          Radius.circular(10),
                                                      topLeft:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(0),
                                                    ),
                                                  ),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: map["logo"]
                                                          ?.data
                                                          .toString() ??
                                                      widget.collection
                                                          .imageUrl ??
                                                      'https://media.istockphoto.com/id/1372146767/photo/nft-hexagons-pixelated-concept.jpg?b=1&s=612x612&w=0&k=20&c=4dMyZNzeFIAQfDvEL_jHqOa1eUYxsAymj-GwIUxK95Q=',
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        '${widget.collection.symbol} #$id',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: headingColor
                                                              .value,
                                                          fontSize: 11,
                                                          fontFamily: 'dmsans',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                    ],
                                                  ),
                                                  SizedBox(width: 12),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment.spaceBetween,
                                                  //   crossAxisAlignment:
                                                  //       CrossAxisAlignment.end,
                                                  //   children: [
                                                  //     Text(
                                                  //       '#1267',
                                                  //       textAlign: TextAlign.center,
                                                  //       style: TextStyle(
                                                  //         color: headingColor.value,
                                                  //         fontSize: 10,
                                                  //         fontFamily: 'dmsans',
                                                  //         fontWeight: FontWeight.w600,
                                                  //       ),
                                                  //     ),
                                                  //     SizedBox(height: 2),
                                                  //     Row(
                                                  //       children: [
                                                  //         Image.asset(
                                                  //           "assets/images/simple-icons_tether.png",
                                                  //           height: 12,
                                                  //           width: 12,
                                                  //           color: headingColor.value,
                                                  //         ),
                                                  //         Text(
                                                  //           ' 6.64',
                                                  //           textAlign: TextAlign.center,
                                                  //           style: TextStyle(
                                                  //             color: headingColor.value,
                                                  //             fontSize: 11,
                                                  //             fontFamily: 'dmsans',
                                                  //             fontWeight:
                                                  //                 FontWeight.w600,
                                                  //           ),
                                                  //         ),
                                                  //       ],
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            }

                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.5,
                              ),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Skeletonizer(
                                    effect: ShimmerEffect(
                                        baseColor: Colors.grey,
                                        highlightColor: Colors.white),
                                    child: Container(
                                      // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                      decoration: ShapeDecoration(
                                        color: inputFieldBackgroundColor2.value,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        // mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Hero(
                                            tag: index.toString(),
                                            child: Container(
                                              height: 130,
                                              width: Get.width,
                                              clipBehavior: Clip.antiAlias,
                                              padding: EdgeInsets.zero,
                                              decoration: ShapeDecoration(
                                                color: Color(0xFFC4C4C4),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0),
                                                    topRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(0),
                                                  ),
                                                ),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://media.istockphoto.com/id/1372146767/photo/nft-hexagons-pixelated-concept.jpg?b=1&s=612x612&w=0&k=20&c=4dMyZNzeFIAQfDvEL_jHqOa1eUYxsAymj-GwIUxK95Q=',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      "ETH",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color:
                                                            headingColor.value,
                                                        fontSize: 11,
                                                        fontFamily: 'dmsans',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                                  ],
                                                ),
                                                SizedBox(width: 12),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                            );
                          }),
                    ],
                  )),

                  // SizedBox(
                  //   height: 24,
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}

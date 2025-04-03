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
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/nfts/collectionDetail.dart';
import 'package:get/get.dart';

class NftsScreen extends StatefulWidget {
  const NftsScreen({super.key});

  @override
  State<NftsScreen> createState() => _NftsScreenState();
}

class _NftsScreenState extends State<NftsScreen> {
  final appController = Get.find<AppController>();
  TextEditingController addressController = TextEditingController();

  var addressErr = ''.obs;
  var importLoader = false.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget addCollection() {
    return Container(
      width: Get.width,
      height: Get.height * 0.4,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 24,
          ),
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(),
              Text(
                'Import ICRC-7 Token',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0.09,
                ),
              ),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 32,
                  ))
            ],
          ),
          SizedBox(
            height: 32,
          ),
          InputFields(
              headerText: "ICRC-7 Canister Id",
              hintText: "",
              hasHeader: true,
              textController: addressController,
              onChange: (v) {
                addressErr.value = '';
              }),
          CommonWidgets.showErrorMessage(addressErr.value),
          SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 48,
            child: BottomRectangularBtn(
                color: primaryColor.value,
                buttonTextColor: textDarkColor.value,
                onTapFunc: () {
                  verify();
                },
                isLoading: importLoader.value,
                isDisabled: importLoader.value,
                loadingText: 'Processing...',
                btnTitle: 'Import'),
          ),
          SizedBox(
            height: 32,
          )
        ],
      ),
    );
  }

  void verify() {}

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated(context, "Your Collections") ??
                            "Your Collection",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: darkBlueColor.value,
                          fontFamily: "dmsans",
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
                              addCollection());
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

                  Expanded(
                      child: ListView(
                    children: [
                      SizedBox(
                        height: 32.0,
                      ),
                      Text(
                        appController.collection.length.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffFDFCFD),
                          fontFamily: "dmsans",
                        ),
                      ),
                      Text(
                        "collections",
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
                      if (appController.collection.isEmpty)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/svg/noTransactions.svg'),
                            SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              width: Get.width,
                              child: Text(
                                'No NFT Collection',
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
                        )
                      else
                        GridView.builder(
                          padding: EdgeInsets.only(
                              top: 0.0, bottom: 80, left: 2.0, right: 2),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: 190,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  crossAxisCount: 2),
                          itemCount: appController.collection.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final collection = appController.collection.values
                                .elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                Get.to(CollectionDetailScreen(
                                  collection: collection,
                                ));
                              },
                              child: Container(
                                // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                decoration: ShapeDecoration(
                                  color: inputFieldBackgroundColor2.value,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  // mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 130,
                                        width: Get.width,
                                        clipBehavior: Clip.antiAlias,
                                        padding: EdgeInsets.zero,
                                        decoration: ShapeDecoration(
                                          color: Color(0xFFC4C4C4),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(0),
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(0),
                                            ),
                                          ),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: collection.imageUrl ??
                                              'https://media.istockphoto.com/id/1372146767/photo/nft-hexagons-pixelated-concept.jpg?b=1&s=612x612&w=0&k=20&c=4dMyZNzeFIAQfDvEL_jHqOa1eUYxsAymj-GwIUxK95Q=',
                                          fit: BoxFit.fill,
                                        )),
                                    SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                collection.name,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: headingColor.value,
                                                  fontSize: 11,
                                                  fontFamily: 'dmsans',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                            ],
                                          ),
                                          SizedBox(width: 12),
                                          // TODO Show balance.
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
                                          //             fontWeight: FontWeight.w600,
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
                        ),
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

  Widget receiveNft() {
    return Container(
      height: 200,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      color: primaryBackgroundColor.value,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Receive NFT",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: headingColor.value,
                  fontFamily: "dmsans",
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.clear,
                    color: headingColor.value,
                  ))
            ],
          ),
          SizedBox(
            height: 32,
          ),
          Expanded(
            child: ListView(
              children: [
                GestureDetector(
                  onTap: () {
                    // Get.to(ReceiveNftScreen());
                  },
                  child: Container(
                    // height: 61,
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            width: 1, color: inputFieldBackgroundColor.value)),

                    child: Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: inputFieldBackgroundColor.value,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add,
                            color: headingColor.value,
                            size: 20,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getTranslated(context, "Receive NFT") ??
                                    "Receive NFT",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: headingColor.value,
                                  fontSize: 13,
                                  fontFamily: 'dmsans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                getTranslated(context,
                                        "Receive a new collectible in your account...") ??
                                    "Receive a new collectible in your account...",
                                textAlign: TextAlign.start,
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
                          width: 12,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: headingColor.value,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

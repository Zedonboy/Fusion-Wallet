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
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';

class ImportCanister extends StatefulWidget {
  const ImportCanister({super.key});

  @override
  State<ImportCanister> createState() => _ImportCanisterState();
}

class _ImportCanisterState extends State<ImportCanister> {
  final appController = Get.find<AppController>();
  TextEditingController canisterIdController = TextEditingController();
  TextEditingController canisterNameController = TextEditingController();
  var canisterIdErr = ''.obs;
  var canisterNameErr = ''.obs;
  var importLoader = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width,
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          Text(
                            'Import Canister',
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
                            width: 24,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    InputFields(
                        headerText: "Canister Name",
                        hintText: "",
                        hasHeader: true,
                        textController: canisterNameController,
                        onChange: (v) {
                          canisterNameErr.value = '';
                        }),
                    CommonWidgets.showErrorMessage(canisterIdErr.value),
                    SizedBox(
                      height: 16,
                    ),
                    
                    InputFields(
                        headerText: "Canister ID",
                        hintText: "",
                        hasHeader: true,
                        textController: canisterIdController,
                        onChange: (v) {
                          canisterIdErr.value = '';
                        }),
                    CommonWidgets.showErrorMessage(canisterIdErr.value),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.value.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: primaryColor.value,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Note: Your wallet Principal must be a controller of the canister you are importing.',
                              style: TextStyle(
                                color: headingColor.value,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    )
                  ],
                ),
                Column(
                  children: [
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  verify() async {
    if (canisterIdController.text.trim() == '') {
      canisterIdErr.value = 'Please enter a canister ID';
    } else if (canisterNameController.text.trim() == '') {
      canisterNameErr.value = 'Please enter a canister name';
    } else {
      importLoader.value = true;
      final icService = appController.ic_service!;
      final canisterId = canisterIdController.text.trim();
      final canisterName = canisterNameController.text.trim();
      try {
        final canisterMetric = icService.createCanisterInfoService();
        final metric = await canisterMetric.getCanisterStatus(canisterId: canisterId, canisterName: canisterName);
        appController.addCanister(metric);
        showToast("Canister imported successfully");
        Get.back(result: 'added');
      } catch (e) {
        print(e.toString());
        canisterIdErr.value = 'Failed to import canister. Make sure your Principal is a controller.';
        showToast("Error importing canister");
      } finally {
        importLoader.value = false;
      }
    }
  }
}

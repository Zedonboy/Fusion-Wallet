import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';

class CommonWidgets {
  final appController = Get.find<AppController>();

  TextEditingController amountController = new TextEditingController();
  var amountErrBox = ''.obs;

  static Widget showErrorMessage(String errorMessage) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 4.0, bottom: 2),
      child: Text(
        errorMessage,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          fontFamily: 'sfpro',
        ),
      ),
    );
  }

  static Widget confirmationDialogUI(context, a1, a2,
      {String? title, String? description, Function? onConfirm}) {
    return Theme(
      data: Theme.of(context).copyWith(dialogBackgroundColor: cardColor.value),
      child: Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: AlertDialog(
            elevation: 10,
            backgroundColor: cardColor.value,
            shape: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12.0)),
            actionsPadding:
                EdgeInsets.only(left: 18, right: 18, bottom: 18, top: 0),
            title: Center(
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: inputFieldTextColor.value,
                  fontFamily: 'sfpro',
                ),
              ),
            ),
            content: Text(
              description!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: inputFieldTextColor.value,
                fontFamily: 'sfpro',
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              Container(
                height: 38,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: primaryColor.value),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: TextButton(
                  child: Text(
                    description.contains('delete') ? 'Cancel' : 'Skip',
                    style: TextStyle(
                      fontSize: 14,
                      color: inputFieldTextColor.value,
                      fontFamily: 'sfpro',
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: 4),
              Container(
                height: 38,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: primaryColor.value,
                  border: Border.all(width: 1, color: primaryColor.value),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: TextButton(
                  child: Text(
                    description.contains('delete') ? 'Delete' : "Enable",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'sfpro',
                    ),
                  ),
                  onPressed: () async {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget loadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.white.withOpacity(0.75),
      child: Container(
        alignment: Alignment.centerLeft,
        width: 66,
        child: Text(
          'Loading...',
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'sfpro',
              color: inputFieldTextColor.value),
          maxLines: 1,
        ),
      ),
    );
  }

  selectWalletBottomSheet(
    context,
  ) {
    showModalBottomSheet(
      backgroundColor: cardColor.value,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      // isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SafeArea(
            child: Obx(
              () => Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Choose Wallet',
                          style: TextStyle(
                            color: headingColor.value,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 26.0,
                            letterSpacing: 0.36,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Icon(
                              Icons.clear,
                              color: headingColor.value,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            chainSelectionRow(
                                network: 'BTC Wallet',
                                address: '0x000...000',
                                imgName: 'btc'),
                            SizedBox(
                              height: 10,
                            ),
                            chainSelectionRow(
                                network: 'Ethereum Wallet',
                                address: '0x000...000',
                                imgName: 'eth'),
                            SizedBox(
                              height: 10,
                            ),
                            chainSelectionRow(
                                network: 'BSC Wallet',
                                address: '0x000...000',
                                imgName: 'bsc'),
                            SizedBox(
                              height: 10,
                            ),
                            chainSelectionRow(
                                network: 'Tron Wallet',
                                address: '0x000...000',
                                imgName: 'tron'),
                            SizedBox(
                              height: 10,
                            ),
                            chainSelectionRow(
                                network: 'Avalanche Wallet',
                                address: '0x000...000',
                                imgName: 'avx'),
                            SizedBox(
                              height: 10,
                            ),
                            chainSelectionRow(
                                network: 'Fantom Wallet',
                                address: '0x000...000',
                                imgName: 'ftm'),
                            SizedBox(
                              height: 10,
                            ),
                            chainSelectionRow(
                                network: 'Optimism Wallet',
                                address: '0x000...000',
                                imgName: 'op'),
                            SizedBox(
                              height: 25,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget chainSelectionRow(
      {String? network,
      String? address,
      String? imgName,
      Function? onChainSelection}) {
    return GestureDetector(
      onTap: () {
        onChainSelection?.call(network);
        Get.back();
      },
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: inputFieldBackgroundColor.value),
        padding: EdgeInsets.all(12),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/imgs/chains/$imgName.png',
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$network',
                        style: TextStyle(
                          fontFamily: 'sfpro',
                          color: headingColor.value,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          letterSpacing: 0.37,
                        ),
                      ),
                      Text(
                        '$address',
                        style: TextStyle(
                          fontFamily: 'sfpro',
                          color: placeholderColor,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          letterSpacing: 0.44,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: placeholderColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar({
    bool? hasBack,
    String? title,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: [
          if (hasBack != false)
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                color: Colors.transparent,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: lightColor,
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0),
            width: Get.width - (hasBack != false ? 105 : 65),
            child: Text(
              '$title',
              style: TextStyle(
                  fontFamily: 'sfpro',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  fontSize: 26.0,
                  letterSpacing: 0.36,
                  color: lightColor),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/screens/createWallet/createWalletComplete.dart';
import 'package:get/get.dart';

class ConfirmSeedPhrase extends StatefulWidget {
  const ConfirmSeedPhrase({
    super.key,
    required this.password,
    required this.mnemonic,
    required this.mn,
    required this.mne,
  });
  final String password;
  final List<String> mnemonic;
  final List<String> mn;
  final String mne;

  @override
  State<ConfirmSeedPhrase> createState() => _ConfirmSeedPhraseState();
}

class _ConfirmSeedPhraseState extends State<ConfirmSeedPhrase> {
  List<String> shuffled = [];
  late final List<String> mn;
  List<int> randomIndexes = [0].obs;
  var mnemonicListWidget = [
    Container(),
  ].obs;
  var selectedIndexes = [0].obs;
  var verifyErr = ''.obs;
  var mn1 = ''.obs;
  var mn2 = ''.obs;
  var mn3 = ''.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mn = widget.mnemonic;
    randomIndexes.clear();
    randomIndexes = List<int>.generate(11, (i) => i)..shuffle();
    randomIndexes = randomIndexes.take(3).toList();
    print(randomIndexes);
    print(widget.mnemonic);
    mn1.value = widget.mn[randomIndexes[0]];
    mn2.value = widget.mn[randomIndexes[1]];
    mn3.value = widget.mn[randomIndexes[2]];
    print(mn1);
    print(mn2);
    print(mn3);
    createWidget();
  }

  createWidget() {
    selectedIndexes.clear();
    shuffled = widget.mnemonic;
    shuffled.shuffle();
    for (int index = 0; index < shuffled.length; index++) {
      //print('=====> $index');
      mnemonicListWidget.add(Container(
        color: Colors.transparent,
        child: Obx(
          () => GestureDetector(
            onTap: () {
              verifyErr.value = '';
              if (selectedIndexes.length < 3) {
                if (selectedIndexes.contains(index)) {
                  selectedIndexes.remove(index);
                } else {
                  selectedIndexes.add(index);
                }
              } else {
                if (selectedIndexes.contains(index)) {
                  selectedIndexes.remove(index);
                }
              }
              print(selectedIndexes);
              print(index);
            },
            child: Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: ShapeDecoration(
                color: selectedIndexes.contains(index)
                    ? primaryAltColor.value
                    : cardcolor.value,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                shuffled[index],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0.09,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ));
      //mnemonicListWidget.shuffle();
    }
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: Get.width,
                      // height: 44,
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 28.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: ShapeDecoration(
                                      color: primaryAltColor.value,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 121,
                                      height: 4,
                                      decoration: ShapeDecoration(
                                        color: primaryAltColor.value,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 18,
                                    height: 18,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: ShapeDecoration(
                                      color: primaryAltColor.value,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 121,
                                      height: 4,
                                      decoration: ShapeDecoration(
                                        color: primaryAltColor.value,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 18,
                                    height: 18,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: ShapeDecoration(
                                      color: primaryAltColor.value,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            child: Text(
                              '3/3',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0.12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Text(
                      'Confirm Seed Phrase',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.04,
                    ),
                    Container(
                      width: Get.width,
                      height: 168,
                      padding: EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                        bottom: 40,
                      ),
                      decoration: ShapeDecoration(
                        color: shapeDecorationDarkColor.value,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select each word in the order it was presented to you',
                            style: TextStyle(
                              color: labelColorPrimaryShade.value,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: ShapeDecoration(
                                  color: cardcolor.value,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${randomIndexes[0] + 1}. ${selectedIndexes.isNotEmpty ? shuffled[selectedIndexes[0]] : ''}',
                                      style: TextStyle(
                                        color: labelColorPrimaryShade.value,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: ShapeDecoration(
                                  color: cardcolor.value,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${randomIndexes[1] + 1}. ${selectedIndexes.length >= 2 ? shuffled[selectedIndexes[1]] : ''}',
                                      style: TextStyle(
                                        color: labelColorPrimaryShade.value,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: ShapeDecoration(
                                  color: cardcolor.value,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${randomIndexes[2] + 1}. ${selectedIndexes.length >= 3 ? shuffled[selectedIndexes[2]] : ''}',
                                      style: TextStyle(
                                        color: labelColorPrimaryShade.value,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: Get.width,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        //runAlignment: WrapAlignment.start,
                        spacing: 8,
                        runSpacing: 8,
                        children: mnemonicListWidget,
                      ),
                    ),
                    CommonWidgets.showErrorMessage(verifyErr.value),
                  ],
                ),
                Column(
                  children: [
                    BottomRectangularBtn(
                        onTapFunc: () async {
                          print(widget.mn);
                          print(widget.mnemonic);
                          print(randomIndexes);
                          print(widget.mne);
                          // print(shuffled[selectedIndexes[0]]);
                          // print(shuffled[selectedIndexes[1]]);
                          // print(shuffled[selectedIndexes[2]]);

                          if (selectedIndexes.length < 3) {
                            verifyErr.value = 'please verify the mnemonic';
                          } else if (mn1 != shuffled[selectedIndexes[0]] ||
                              mn2 != shuffled[selectedIndexes[1]] ||
                              mn3 != shuffled[selectedIndexes[2]]) {
                            verifyErr.value = 'Mnemonic does not match';
                          } else if (mn1 == shuffled[selectedIndexes[0]] &&
                              mn2 == shuffled[selectedIndexes[1]] &&
                              mn3 == shuffled[selectedIndexes[2]]) {
                            print('VERIFIED NOW CREATE WALLET');
                            Get.to(() => CreateWalletComplete(
                                  passWord: widget.password,
                                  mnemonic: widget.mne,
                                ));
                          }
                        },
                        btnTitle: "Next"),
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
}

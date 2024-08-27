import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../common_widgets/inputFields.dart';
import '../../common_widgets/bottomRectangularbtn.dart';
import '../../common_widgets/commonWidgets.dart';
import '../selectChain/selectChain.dart';

class ImportToken extends StatefulWidget {
  const ImportToken({Key? key}) : super(key: key);

  @override
  State<ImportToken> createState() => _ImportTokenState();
}

class _ImportTokenState extends State<ImportToken> {
  TextEditingController pKeyController = TextEditingController();

  final selectedChain = ''.obs;
  final chainSelectionErr = ''.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.value,
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 110,
                padding: EdgeInsets.only(top: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CommonWidgets()
                        .appBar(hasBack: true, title: 'Import Token'),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                decoration: BoxDecoration(
                  color: primaryBackgroundColor.value,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                constraints: BoxConstraints(
                    minHeight: Get.height - 110, minWidth: Get.width),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              SelectChain(
                                onChainSelection: (value) {
                                  if (value != '') {
                                    selectedChain.value = value;
                                    chainSelectionErr.value = '';
                                  }
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: Get.width,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: inputFieldBackgroundColor.value),
                            padding: EdgeInsets.all(12),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedChain.value == ''
                                        ? 'Network'
                                        : selectedChain.value,
                                    style: TextStyle(
                                        fontFamily: 'sfpro',
                                        color: headingColor.value),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: placeholderColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        CommonWidgets.showErrorMessage(chainSelectionErr.value),
                        Text(
                          'Select your chain from Bitcoin, Tron, Ethereum, Polygon, BNB Smart Chain, Avalanche, Fantom, Optimism.',
                          style: TextStyle(
                              fontFamily: 'sfpro',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                              letterSpacing: 0.37,
                              color: labelColor.value),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Text(
                          'Token Address',
                          style: TextStyle(
                            color: headingColor.value,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'sfpro',
                          ),
                        ),
                        InputFields(
                            headerText: "",
                            hintText: "0x000...000",
                            hasHeader: true,
                            onChange: () {}),
                        SizedBox(
                          height: 14,
                        ),
                        Text(
                          'Token Symbol',
                          style: TextStyle(
                            color: headingColor.value,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'sfpro',
                          ),
                        ),
                        InputFields(
                            headerText: "",
                            hintText: "MATIC",
                            hasHeader: true,
                            onChange: () {}),
                        SizedBox(
                          height: 14,
                        ),
                        Text(
                          'Token Decimal',
                          style: TextStyle(
                            color: headingColor.value,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'sfpro',
                          ),
                        ),
                        InputFields(
                            headerText: "",
                            hintText: "18",
                            hasHeader: true,
                            onChange: () {})
                      ],
                    ),
                    Column(
                      children: [
                        BottomRectangularBtn(
                            onTapFunc: () {
                              Navigator.pop(context);
                            },
                            btnTitle: 'Import'),
                        SizedBox(
                          height: 45,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

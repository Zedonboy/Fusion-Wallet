import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/UI/pages/passwordAndSecutiry/passwordAndSecutity.dart';
import '/UI/pages/selectChain/selectChain.dart';

import '../../../constants/colors.dart';
import '../../common_widgets/inputFields.dart';
import '../../../controllers/appController.dart';
import '../../common_widgets/bottomRectangularbtn.dart';
import '../../common_widgets/commonWidgets.dart';

class ImportWallet extends StatefulWidget {
  ImportWallet({Key? key, this.fromPage}) : super(key: key);
  final String? fromPage;

  @override
  State<ImportWallet> createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  TextEditingController pKeyController = TextEditingController();
  final pKeyError = ''.obs;
  final appController = Get.find<AppController>();

  TextEditingController nameController = TextEditingController();
  final nameError = ''.obs;
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
                        .appBar(hasBack: true, title: 'Import Wallet'),
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
                        Text(
                          'Private Key',
                          style: TextStyle(
                            color: headingColor.value,
                            fontFamily: 'sfpro',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 26.0,
                            letterSpacing: 0.36,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Enter your private key to import the wallet',
                          style: TextStyle(
                              fontFamily: 'sfpro',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                              letterSpacing: 0.37,
                              color: labelColor.value),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: Text(
                            'Private Key',
                            style: TextStyle(
                              color: headingColor.value,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'sfpro',
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          height: 100,
                          child: TextField(
                            maxLines: 4,
                            cursorColor: primaryColor.value,
                            cursorHeight: 20,
                            controller: pKeyController,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'sfpro',
                                color: inputFieldTextColor.value),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'sfpro',
                                  color: appController.isDark.value
                                      ? labelColor.value
                                      : placeholderColor),
                              filled: true,
                              fillColor: inputFieldBackgroundColor.value,
                              hintText: 'Paste your private key',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    color: cardColor.value, width: 0.1),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    color: cardColor.value, width: 0.1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    color: cardColor.value, width: 0.1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: cardColor.value, width: 0.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () async {
                                  ClipboardData? cdata =
                                      await Clipboard.getData(
                                          Clipboard.kTextPlain);
                                  pKeyController.text = cdata?.text ?? '';
                                  setState(() {});
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      color: Colors.transparent,
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(top: 2),
                                      child: SizedBox(
                                        child: SvgPicture.asset(
                                          'assets/svgs/qr-scanner-m.svg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                        CommonWidgets.showErrorMessage(pKeyError.value),
                        SizedBox(
                          height: 5,
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
                              fontSize: 12.0,
                              letterSpacing: 0.37,
                              color: labelColor.value),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        InputFieldsWithSeparateIcon(
                          textController: nameController,
                          headerText: 'Name Your Wallet',
                          hintText: 'Wallet Name',
                          hasHeader: true,
                          onChange: (value) {
                            nameError.value = '';
                          },
                          svg: 'Wallet',
                        ),
                        CommonWidgets.showErrorMessage(nameError.value),
                      ],
                    ),
                    Column(
                      children: [
                        BottomRectangularBtn(
                            onTapFunc: () {
                              if (widget.fromPage == 'Settings') {
                                Get.back();
                              } else {
                                Get.to(PasswordAndSecurity());
                              }
                            },
                            btnTitle: 'Import Wallet'),
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

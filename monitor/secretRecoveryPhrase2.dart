import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class SecretRecoveryPharase2 extends StatefulWidget {
  String mnemonic;
  SecretRecoveryPharase2({super.key, required this.mnemonic});

  @override
  State<SecretRecoveryPharase2> createState() => _SecretRecoveryPharase2State();
}

class _SecretRecoveryPharase2State extends State<SecretRecoveryPharase2> {
  var mnemonicListWidget = [
    Container(),
  ].obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMnemonic();
  }

  getMnemonic() async {
    List<String> _mnemonicList = widget.mnemonic.split(" ");
    print(_mnemonicList.length);
    print(_mnemonicList);
    mnemonicWidget(_mnemonicList);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              SizedBox(height: 24.0,),
              Container(
                width: Get.width,
                // height: 44,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0)),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    Text(
                      'Secret Recovery Phrase',
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
                height: 124,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Write Down Your Seed Phrase',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                width: 311,
                child: Text(
                  '''This is your seed phrase. Write it down on a paper and keep it in a safe place. You'll be asked to re-enter this phrase (in order).''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: labelColorPrimaryShade.value,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: Get.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: mnemonicListWidget,
                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(height: 24,),
              BottomRectangularBtn(onTapFunc: () {
                copyToClipboard(widget.mnemonic);
              }, btnTitle: "Copy")
            ],
          ),
        ),
      ),
    );
  }
  mnemonicWidget(List<String> _mnemonicList) {
    /*List<String> _mnemonicList = _mnemonic.split(" ");
    print(_mnemonicList.length);
    print(_mnemonicList);*/
    mnemonicListWidget.value = [];
    setState(() {
      for (int index = 0; index < _mnemonicList.length; index++) {
        mnemonicListWidget.add(Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: ShapeDecoration(
            color: cardcolor.value,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${index+1}.',
                style: TextStyle(
                  color: labelColorPrimaryShade.value,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0.09,
                ),
              ),
              SizedBox(width: 4),
              Text(
                '${_mnemonicList[index]}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0.09,
                ),
              ),
            ],
          ),
        ));
      }
    });
  }
}

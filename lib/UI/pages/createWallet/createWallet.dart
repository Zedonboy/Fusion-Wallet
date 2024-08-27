import 'package:flutter/material.dart';
import 'package:fusion_wallet/UI/common_widgets/seedPhraseDisplay.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../common_widgets/inputFields.dart';
import '../../common_widgets/bottomRectangularbtn.dart';
import '../../common_widgets/commonWidgets.dart';
import '../passwordAndSecutiry/passwordAndSecutity.dart';

class CreateWallet extends StatefulWidget {
  CreateWallet({Key? key, this.fromPage}) : super(key: key);
  final String? fromPage;

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  TextEditingController nameController = TextEditingController();
  var nameError = ''.obs;
  String seedPhrase = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateSeedPhrase().then((sd) {
      setState(() {
        seedPhrase = sd;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.value,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 110,
              padding: EdgeInsets.only(top: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CommonWidgets().appBar(hasBack: true, title: 'Create Wallet'),
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
                        'Crypto Wallet',
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
                        'The wallet allows users to interact with blockchain networks like Bitcoin, Tron, Ethereum, Polygon, BNB Smart Chain, Avalanche, Fantom, Optimism with a wide range of assets.',
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
                      SeedPhraseDisplay(seedPhrase: seedPhrase),
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
                              // 
                              Get.to(PasswordAndSecurity(seedPhrase: seedPhrase,));
                            }
                          },
                          btnTitle: widget.fromPage == 'Settings'
                              ? 'Create Wallet'
                              : 'Next'),
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
    );
  }
}

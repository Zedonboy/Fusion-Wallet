import 'package:credential_manager/credential_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fusion_wallet/common_widgets/bottomNavBar.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/screens/homeScreen.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';
// import '../commonWidgets/bottomNav/bottomNavBar.dart';
// import '../commonWidgets/commonWidgets.dart';
// import '../commonWidgets/navCustom.dart';

class ImportFromSeed extends StatefulWidget {
  final String pin;
  ImportFromSeed({super.key, required this.pin});

  @override
  State<ImportFromSeed> createState() => _ImportFromSeedState();
}

class _ImportFromSeedState extends State<ImportFromSeed> {
  final appController = Get.find<AppController>();
  TextEditingController mnemonicController = TextEditingController();

  var mnemonicError = ''.obs;
  var importLoader = false.obs;
  var checkBoxErr = ''.obs;
  var isCheck = false.obs;

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),
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
                            'Import From Seed',
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
                    InputFields2(
                        headerText: "",
                        hintText: "****  *****  *****  ***** *****",
                        hasHeader: false,
                        textController: mnemonicController,
                        inputType: TextInputType.multiline,
                        maxLines: 5,
                        onChange: (v) {
                          mnemonicError.value = '';
                        }),
                    CommonWidgets.showErrorMessage(mnemonicError.value),
                  ],
                ),
                Column(
                  children: [
                    /*SizedBox(
                      height: 150,
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sign in with biometric',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Archivo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        FlutterSwitch(
                          width: 50.0,
                          height: 25.0,
                          valueFontSize: 20.0,
                          toggleSize: 20.0,
                          value: appController.enabledBiometric.value,
                          borderRadius: 30.0,
                          toggleColor: lightColor,
                          activeColor: primaryAltColor.value,
                          inactiveColor: labelColor.value,
                          padding: 2.0,
                          showOnOff: false,
                          onToggle: (val) {
                            appController.enabledBiometric.value = val;
                            enableBiometric(context, val);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Checkbox(
                              activeColor: primaryAltColor.value,
                              value: isCheck.value,
                              onChanged: (val) {
                                isCheck.value = val!;
                                checkBoxErr.value = '';
                              }),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: Get.width,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'I understand that Fusion Wallet cannot recover this pin for me. ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Learn more',
                                    style: TextStyle(
                                      color: primaryAltColor.value,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    CommonWidgets.showErrorMessage(checkBoxErr.value),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 6,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Byproceeding, you agree to these ',
                            style: TextStyle(
                              color: labelColorPrimaryShade.value,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'Term and Conditions.',
                            style: TextStyle(
                              color: primaryAltColor.value,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                        height: 48,
                        child: BottomRectangularBtn(
                            color: primaryAltColor.value,
                            buttonTextColor: textDarkColor.value,
                            onTapFunc: () {
                              verifyFields();
                            },
                            isLoading: importLoader.value,
                            loadingText: 'Processing...',
                            btnTitle: 'Import')),
                    /*GestureDetector(
                      onTap: () async {
                        verifyFields();
                      },
                      child: Container(
                        width: Get.width,
                        height: 48,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: ShapeDecoration(
                          color: shapeDecorationColor.value,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Import',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0.09,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),*/
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

  save_to_credential() async {
    final CredentialManager credentialManager = CredentialManager();
    if (credentialManager.isSupportedPlatform) {
      // Platform is supported, initialize the manager
      await credentialManager.init(
        preferImmediatelyAvailableCredentials: true,
      );

      try {
        await credentialManager.savePasswordCredentials(
          PasswordCredential(
            
            password: widget.pin,
          ),
        );
      } on CredentialException catch (e) {
        // Handle the error
        print('Error saving password credential: ${e.message}');
      }
    }
  }

  verifyFields() async {
    importLoader.value = true;
    setState(() {});
    if (mnemonicController.text.trim() == '') {
      mnemonicError.value = 'Please Enter 12 words Secret Phrase';
      importLoader.value = false;
      setState(() {});
    } else if (!WalletContext.verifyMnemonic(
        mnemonic: mnemonicController.text.trim())) {
      mnemonicError.value = 'Invalid Secret Phrase';
      importLoader.value = false;
      setState(() {});
    } else {
      var mnemonic = mnemonicController.text.trim();
      try {
        var wallet = Wallet.fromSeed(seedPhrase: mnemonic);
        appController.encryptAndStoreMnemonic(mnemonic, widget.pin);
        appController.active_wallet.value = wallet;
        await save_to_credential();
        // Get.offAll(() => BottomBar());
        Get.offAll(() => HomeScreen());
      } catch (e) {
        mnemonicError.value = 'Invalid Secret Phrase';
        importLoader.value = false;
      }
    }
  }

  enableBiometric(context, val) async {
    final LocalAuthentication auth = LocalAuthentication();
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final isDeviceSupported = await auth.isDeviceSupported();
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (isDeviceSupported && canAuthenticateWithBiometrics) {
      try {
        final bool didAuthenticate = await auth
            .authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(
              useErrorDialogs: false, stickyAuth: true),
        )
            .then((value) async {
          if (value == true) {
            await sharedPref.setBool('FingerPrintEnable', val);
            setState(() {
              appController.enabledBiometric.value = val;
            });
          }
          return value;
        });
        print('didAuth============$didAuthenticate');
        await auth.stopAuthentication();
      } on PlatformException catch (e) {
        print('ex============$e');
      }
    } else {
      await sharedPref.setBool('FingerPrintEnable', val);
      setState(() {
        appController.enabledBiometric.value = val;
      });
    }
  }
}

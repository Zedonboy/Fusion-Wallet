import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/screens/createWallet/createWalletStep2.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CreaateNewWallet extends StatefulWidget {
  const CreaateNewWallet({super.key});

  @override
  State<CreaateNewWallet> createState() => _CreaateNewWalletState();
}

class _CreaateNewWalletState extends State<CreaateNewWallet> {
  var isCheck = false.obs;

  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  var passError = ''.obs;
  var confirmPassError = ''.obs;
  var checkBoxErr = ''.obs;
  final appController = Get.find<AppController>();

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
                              Get.back();
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
                                        color: shapeDecorationColor.value,
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
                                      color: shapeDecorationColor.value,
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
                                        color: shapeDecorationColor.value,
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
                                      color: shapeDecorationColor.value,
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
                              '1/3',
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
                      'Create Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 311,
                      child: Text(
                        'This password will unlock your Wallet wallet only on this device',
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
                      height: 16,
                    ),
                    InputFieldPassword(
                      headerText: "",
                      hintText: "New Password",
                      textController: passController,
                      onChange: (value) {
                        if (value != null && value != '') {
                          passError.value = '';
                        }
                      },
                    ),
                    CommonWidgets.showErrorMessage(passError.value),
                    InputFieldPassword(
                      headerText: "",
                      hintText: "Confirm Password",
                      textController: confirmPassController,
                      onChange: (value) {
                        if (value != null && value != '') {
                          confirmPassError.value = '';
                        }
                      },
                    ),
                    CommonWidgets.showErrorMessage(confirmPassError.value),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    /*SizedBox(
                      height: 150,
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sign in with Face ID?',
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
                          toggleColor: primaryAltColor.value,
                          activeColor: Color(0xFF242438),
                          inactiveColor: Color(0xFF242438),
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
                                        'I understand that Solana Wallet cannot recover this password for me. ',
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
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                Column(
                  children: [
                    BottomRectangularBtn(
                        onTapFunc: () {
                          verifyPasswords();
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

  Widget secureYourWalletBottomSheet() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: shapeDecorationDarkColor.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Get.width,
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Secure Your Wallet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Stack(
            children: [
              SizedBox(
                height: 300,
                width: Get.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          "assets/images/Vector 2.png",
                          height: 90,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/Vector 1 (1).png",
                          height: 200,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: SizedBox(
                  height: 300,
                  width: Get.width,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/image-aspect-raito.png",
                        height: 200,
                        width: 200,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          SizedBox(
            width: 311,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        '''Don't risk losing your funds. protect your wallet by saving your ''',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'Seed Phrase',
                    style: TextStyle(
                      color: primaryAltColor.value,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: ' in a place you trust.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            width: 311,
            child: Text(
              '''It's the only way to recover your wallet if you get locked out of the app or get a new device.''',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          // GestureDetector(
          //   onTap: () async {
          //     final prefs = await SharedPreferences.getInstance();
          //     prefs.setBool('backReminder', true);
          //     // String mnemonic = bip39.generateMnemonic();
          //     // print("mnemonic $mnemonic");
          //     // bool isValid = bip39.validateMnemonic(mnemonic);
          //     // print("isValid ${bip39.validateMnemonic(mnemonic)}");
          //     if (true) {
          //       // print(mnemonic);
          //       // final keypair = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
          //       // print("keypair ${keypair.address}");
          //       // print("keypair ${keypair.publicKey}");
          //       // print("mnemonic ${mnemonic}");
          //       final storage = FlutterSecureStorage();
          //       await storage.write(
          //           key: 'password', value: passController.text);
          //       // await storage.write(key: 'privKey', value: keypair.address);
          //       // await storage.write(key: 'mnemonic', value: mnemonic);
          //       Navigator.pop(context);
          //       Navigator.pushReplacement(
          //         context,
          //         PageTransition(
          //           duration: Duration(milliseconds: 100),
          //           type: PageTransitionType.topToBottom,
          //           child: BottomBar(),
          //         ),
          //       );
          //     }
          //   },
          //   child: Container(
          //     width: Get.width,
          //     height: 48,
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //     decoration: ShapeDecoration(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(100),
          //       ),
          //     ),
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Text(
          //           'Remind Me Later',
          //           style: TextStyle(
          //             color: primaryAltColor.value,
          //             fontSize: 16,
          //             fontFamily: 'Poppins',
          //             fontWeight: FontWeight.w600,
          //             height: 0.09,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              Get.back();
              Get.bottomSheet(
                clipBehavior: Clip.antiAlias,
                isScrollControlled: true,
                backgroundColor: primaryAltBackgroundColor.value,
                shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(32),
                        topLeft: Radius.circular(32))),
                seedPhraseBottomSheet(),
              );
            },
            child: Container(
              width: Get.width,
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: ShapeDecoration(
                color: primaryAltColor.value,
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
                    'Next',
                    style: TextStyle(
                      color: textDarkColor.value,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0.09,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget seedPhraseBottomSheet() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: shapeDecorationDarkColor.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Get.width,
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'What is a "Seed Phrase"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          SizedBox(
            width: Get.width,
            child: Text(
              '''A seed phrase is a set of twelve words that contains all the information about your wallet, including your funds. It's like a secret code used to access your entire wallet.\n\nYou must keep your seed phrase secret and safe. If someone gets your seed phrase, they'll gain control over your accounts.\n\nSave it in a place where only you can access it.\nIf you lose it, not even MetaMask can help you recover it.''',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          GestureDetector(
            onTap: () {
              Get.off(() => CreaateWalletStep2(
                    password: passController.text,
                  ));
            },
            child: Container(
              width: Get.width,
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: ShapeDecoration(
                color: primaryAltColor.value,
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
                    'Understood',
                    style: TextStyle(
                      color: textDarkColor.value,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0.09,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }

  verifyPasswords() {
    if (passController.text.length < 8) {
      passError.value = 'Minimum length should be 8';
    } else if (!lowerCase.hasMatch(passController.text)) {
      passError.value = 'Minimum 1 lowercase character required';
    } else if (!upperCase.hasMatch(passController.text)) {
      passError.value = 'Minimum 1 uppercase character required';
    } else if (!containsNumber.hasMatch(passController.text)) {
      passError.value = 'Minimum 1 digit required';
    } else if (!hasSpecialCharacters.hasMatch(passController.text)) {
      passError.value = 'Minimum 1 special character required';
    } else if (passController.text != confirmPassController.text) {
      confirmPassError.value = 'Password didn\'t match with the first one.';
    } else if (isCheck.value == false) {
      checkBoxErr.value = 'Please accept our terms & conditions.';
    } else {
      Get.bottomSheet(
          clipBehavior: Clip.antiAlias,
          isScrollControlled: true,
          backgroundColor: primaryAltBackgroundColor.value,
          shape: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32), topLeft: Radius.circular(32))),
          secureYourWalletBottomSheet());
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

  @override
  void dispose() {
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
}

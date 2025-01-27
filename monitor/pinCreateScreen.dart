import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/common_widgets/customNamPad.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/createWallet/createWalletStep2.dart';
import 'package:fusion_wallet/screens/importFromSeed.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import 'package:pin_dot/pin_dot.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum WalletCreationType { create, import }

class PinCreationScreen extends StatefulWidget {
  final WalletCreationType next_screen;

  const PinCreationScreen({super.key, required this.next_screen});

  @override
  State<PinCreationScreen> createState() => _PinCreationScreenState();
}

class _PinCreationScreenState extends State<PinCreationScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isConfirmingPin = false;
  String? _initialPin;
  String _errorMessage = '';
  static const int pinLength = 6;
  final appController = Get.find<AppController>();
  var passError = ''.obs;
  var confirmPassError = ''.obs;

  @override
  void dispose() {
    // _pinController.dispose();
    super.dispose();
  }

  void _handlePinSubmission() {
    if (!_isConfirmingPin) {
      setState(() {
        _initialPin = _pinController.text;
        _isConfirmingPin = true;
        _pinController.clear();
        _errorMessage = '';
      });
    } else {
      if (_initialPin == _pinController.text) {
        // PIN created successfully
        // TODO: Save PIN securely
        showToast("Pin Created Successfully");
        if (widget.next_screen == WalletCreationType.create) {
          Get.bottomSheet(
              clipBehavior: Clip.antiAlias,
              isScrollControlled: true,
              backgroundColor: primaryAltBackgroundColor.value,
              shape: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32),
                      topLeft: Radius.circular(32))),
              secureYourWalletBottomSheet());
        } else {
          Get.off(() => ImportFromSeed(
                pin: _pinController.text,
              ));
        }

        // TODO: Navigate to next screen or handle successful PIN creation
      } else {
        setState(() {
          _errorMessage = 'PINs do not match. Please try again.';
          _pinController.clear();
        });
      }
    }
  }

  void _handleDelete() {
    if (_pinController.text.isNotEmpty) {
      setState(() {
        _pinController.text =
            _pinController.text.substring(0, _pinController.text.length - 1);
      });
    }
  }

  void _handleCancel() {
    if (_isConfirmingPin) {
      setState(() {
        _isConfirmingPin = false;
        _initialPin = null;
        _pinController.clear();
        _errorMessage = '';
      });
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: primaryAltBackgroundColor.value,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isConfirmingPin
                              ? getTranslated(context, "Confirm PIN") ??
                                  "Confirm PIN"
                              : getTranslated(context, "Create PIN") ??
                                  "Create PIN",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: primaryAltColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isConfirmingPin
                              ? getTranslated(context, "Confirm your PIN") ??
                                  "Confirm your PIN"
                              : getTranslated(context, "Enter a new PIN") ??
                                  "Enter a new PIN",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: primaryAltColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    PinDot(
                      size: 17,
                      length: pinLength,
                      controller: _pinController,
                      inactiveColor: primaryAltBackgroundColor.value,
                      activeColor: primaryAltColor.value,
                      borderColor: primaryAltColor.value,
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 32,),
                Column(
                  children: [
                    CustomNumPad(
                      buttonSize: Get.width / 5,
                      delete: _handleDelete,
                      onSubmit: _handlePinSubmission,
                      controller: _pinController,
                      maxLength: pinLength,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _handleCancel,
                      child: Text(
                        _isConfirmingPin
                            ? getTranslated(context, "Back") ?? "Back"
                            : getTranslated(context, "Cancel") ?? "Cancel",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: primaryAltColor.value,
                          fontFamily: "dmsans",
                        ),
                      ),
                    ),
                    // const SizedBox(height: 66),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          //     if(true){

          //       // print(mnemonic);
          //       // final keypair = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
          //       // print("keypair ${keypair.address}");
          //       // print("keypair ${keypair.publicKey}");
          //       // print("mnemonic ${mnemonic}");
          //       final storage = FlutterSecureStorage();
          //       await storage.write(key: 'password', value: passController.text);
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
          //             color: primaryColor.value,
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
          // SizedBox(
          //   height: 16,
          // ),
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
                    password: _pinController.text,
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
}

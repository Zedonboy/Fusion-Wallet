/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'package:credential_manager/credential_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/common_widgets/bottomNavBar.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';

class CreateWalletComplete extends StatefulWidget {
  const CreateWalletComplete(
      {super.key, required this.mnemonic, required this.passWord});
  final String mnemonic;
  final String passWord;

  @override
  State<CreateWalletComplete> createState() => _CreateWalletCompleteState();
}

class _CreateWalletCompleteState extends State<CreateWalletComplete> {
  bool userFaceId = true;
  bool isCheck = false;
  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: ShapeDecoration(
                                    color: primaryAltColor.value,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 18,
                                  height: 18,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: ShapeDecoration(
                                    color: primaryAltColor.value,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 18,
                                  height: 18,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: ShapeDecoration(
                                    color: primaryAltColor.value,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
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
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  SvgPicture.asset("assets/svg/check-select.svg"),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: 311,
                    child: Text(
                      'Congratulations',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: 311,
                    child: Text(
                      '''You've successfully protected your wallet. Remember to keep your seed phrase safe, it's your responsibility!''',
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
                  SizedBox(
                    width: 311,
                    child: Text(
                      'Fusion Wallet cannot recover your wallet should you lose it. You can find your seedphrase in\nSetings > Security & Privacy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: labelColorPrimaryShade.value,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  BottomRectangularBtn(
                      // color: shapeDecorationColor.value,

                      // isDisabled: true,
                      onTapFunc: () {
                        createWallet();
                      },
                      btnTitle: "Take me in"),
                  SizedBox(
                    height: 32,
                  )
                ],
              ),
            ],
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
        preferImmediatelyAvailableCredentials: false,
      );

      try {
        await credentialManager.savePasswordCredentials(
          PasswordCredential(
            username: 'fusion_wallet_user',
            password: widget.passWord,
          ),
        );
      } on CredentialException catch (e) {
        // Handle the error
        print('Error saving password credential: ${e.message}');
      }
    }
  }

  createWallet() async {
    await appController.encryptAndStoreMnemonic(
        widget.mnemonic, widget.passWord);
    Wallet wallet = Wallet.fromSeed(seedPhrase: widget.mnemonic);
    appController.active_wallet.value = wallet;
    await save_to_credential();
    Get.offAll(() => BottomBar());
    // Get.offAll(() => HomeScreen());
  }
}

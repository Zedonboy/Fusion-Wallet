
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fusion_wallet/services/hardwareId.dart';
import 'package:fusion_wallet/services/sharedPrefs.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/UI/common_widgets/inputFields.dart';

import '../../../constants/colors.dart';
import '../../../controllers/appController.dart';
import '../../bottomNavBar/BottomNavBar.dart';
import '../../common_widgets/bottomRectangularbtn.dart';
import '../../common_widgets/commonWidgets.dart';

class PasswordAndSecurity extends StatefulWidget {
  PasswordAndSecurity({Key? key, this.fromPage, this.seedPhrase})
      : super(key: key);

  final String? fromPage;
  final String? seedPhrase;

  @override
  State<PasswordAndSecurity> createState() => _PasswordAndSecurityState();
}

class _PasswordAndSecurityState extends State<PasswordAndSecurity> {
  final appController = Get.find<AppController>();
  TextEditingController passController = TextEditingController();
  var passError = ''.obs;
  var isChecked = false.obs;
  TextEditingController confirmPassController = TextEditingController();
  var confirmPassError = ''.obs;
  var checkBoxErr = ''.obs;
  final LocalAuthentication auth = LocalAuthentication();
  bool canAuthenticateWithBiometrics = false;
  final SharedPref pref = SharedPref();
  final secure_storage = const FlutterSecureStorage();

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
                padding: const EdgeInsets.only(top: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CommonWidgets()
                        .appBar(hasBack: true, title: 'Crypto Wallet'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                decoration: BoxDecoration(
                  color: primaryBackgroundColor.value,
                  borderRadius: const BorderRadius.only(
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
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          widget.fromPage == 'Settings'
                              ? 'Set New Password'
                              : 'Security Password',
                          style: TextStyle(
                            color: headingColor.value,
                            fontFamily: 'sfpro',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 26.0,
                            letterSpacing: 0.36,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.fromPage == 'Settings'
                              ? ''
                              : 'Protection for All Your Wallets & Assets.',
                          style: TextStyle(
                              fontFamily: 'sfpro',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                              letterSpacing: 0.37,
                              color: labelColor.value),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        InputFieldPassword(
                          headerText: 'Password',
                          svg: 'Lock',
                          hintText: '• • • • • • • •',
                          textController: passController,
                          onChange: () {
                            passError.value = '';
                          },
                        ),
                        CommonWidgets.showErrorMessage(passError.value),
                        const SizedBox(
                          height: 10,
                        ),
                        InputFieldPassword(
                          headerText: 'Confirm Password',
                          svg: 'Lock',
                          hintText: '• • • • • • • •',
                          textController: confirmPassController,
                          onChange: () {
                            confirmPassError.value = '';
                          },
                        ),
                        CommonWidgets.showErrorMessage(passError.value),
                        FutureBuilder(
                            future: auth.canCheckBiometrics,
                            builder: (context, snapshot) {
                              if (snapshot.data != null &&
                                  snapshot.data == true) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Biometric',
                                      style: TextStyle(
                                          fontFamily: 'sfpro',
                                          color: headingColor.value),
                                    ),
                                    Switch(
                                      splashRadius: 0.0,
                                      value:
                                          appController.enabledBiometric.value,
                                      activeColor: primaryColor.value,
                                      inactiveThumbColor:
                                          appController.isDark.value
                                              ? inputFieldTextColor.value
                                              : lightColor,
                                      inactiveTrackColor:
                                          placeholderColor.withOpacity(0.65),
                                      onChanged: (value) async {
                                        //enableBiometric(context, value);
                                        pref.saveBool("biometric", value);
                                        appController.enabledBiometric.value =
                                            !appController
                                                .enabledBiometric.value;
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Theme(
                              data:
                                  ThemeData(unselectedWidgetColor: lightColor),
                              child: Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  checkColor: lightColor,
                                  activeColor: primaryColor.value,
                                  value: isChecked.value,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked.value = !isChecked.value;
                                      if (checkBoxErr.value != '') {
                                        checkBoxErr.value = '';
                                      }
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: BorderSide(
                                      color: primaryColor.value, width: 1.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'I accept the terms & policy',
                              style: TextStyle(
                                  fontFamily: 'sfpro', color: labelColor.value),
                            )
                          ],
                        ),
                        CommonWidgets.showErrorMessage(checkBoxErr.value),
                      ],
                    ),
                    Column(
                      children: [
                        BottomRectangularBtn(
                            onTapFunc: () async {
                              pref.saveBool("biometric",
                                  appController.enabledBiometric.value);
                              if (widget.fromPage == 'Settings') {
                                Get.back();
                              } else {
                                if (are_passwords_valid(passController.text,
                                    confirmPassController.text)) {
                                      await appController.save_and_secure_pass(passController.text, widget.seedPhrase!);
                                }

                                if (appController.enabledBiometric.value) {
                                  await appController.save_and_secure_biometric_login(passController.text);
                                }

                                appController.set_wallet_contexts(widget.seedPhrase!);
                                appController.reset_tokens_with_seed_phrase();
                                appController.start_token_update_timer();
                                Get.to(const BottomNavigationBar1());
                              }
                            },
                            btnTitle: widget.fromPage == 'Settings'
                                ? 'Update Password'
                                : 'Create Wallet'),
                        const SizedBox(
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

bool are_passwords_valid(String password, String confirm_pass) {
  if (password == confirm_pass) {
    return true;
  } else {
    return false;
  }
}

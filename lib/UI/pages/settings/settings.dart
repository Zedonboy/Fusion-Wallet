import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import '/UI/pages/changePassword/changePassword.dart';
import '/UI/pages/createWallet/createWallet.dart';
import '/UI/pages/importWallet/importWallet.dart';
import '/UI/pages/wallets/wallets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/colors.dart';
import '../../../controllers/appController.dart';
import '../biomatric/biomatric.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _biomatric = true;

  var _theme = false.obs;
  final appController = Get.find<AppController>();
  @override
  void initState() {
    // TODO: implement initState
    _theme.value = appController.isDark.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          backgroundColor: primaryBackgroundColor.value,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Settings",
                        style: TextStyle(
                            fontFamily: 'sfpro',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 26.0,
                            letterSpacing: 0.37,
                            color: headingColor.value),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Wallets",
                        style: TextStyle(
                            fontFamily: 'sfpro',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                            letterSpacing: 0.37,
                            color: headingColor.value),
                      ),
                      InkWell(
                        onTap: () {
                          _addvaletBottomSheet(context);
                        },
                        child: Text(
                          "+Add",
                          style: TextStyle(
                              fontFamily: 'sfpro',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              letterSpacing: 0.37,
                              color: primaryColor.value),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: _walletContainer(
                        amountInUSD: "0",
                        coinName: "My Multi Coin Wallet",
                        amountInEth: "0",
                        imgName: "assets/imgs/wallet1.png",
                        percentage: "",
                        priceInUSD: "0x000...000",
                        isSelected: true),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: _walletContainer(
                      isSelected: false,
                      amountInUSD: "0",
                      coinName: "Bitcoin Wallet",
                      amountInEth: "0",
                      imgName: "assets/imgs/wallet2.png",
                      percentage: "",
                      priceInUSD: "0x000...000",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: _walletContainer(
                      isSelected: false,
                      amountInUSD: "0",
                      coinName: "USDT",
                      amountInEth: "0",
                      imgName: "assets/imgs/coinImage.png",
                      percentage: "",
                      priceInUSD: "0x000...000",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(Wallets());
                        },
                        child: SizedBox(
                          height: 20,
                          width: 80,
                          child: Center(
                            child: Text(
                              'View All',
                              style: TextStyle(
                                fontFamily: 'sfpro',
                                color: labelColor.value,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                letterSpacing: 0.37,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Security",
                        style: TextStyle(
                            fontFamily: 'sfpro',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                            letterSpacing: 0.37,
                            color: headingColor.value),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _securityAndThemeContainer(
                      onTap: () {
                        Get.to(ChangePassword());
                      },
                      type: "changePassword",
                      leadingIcon: CupertinoIcons.lock,
                      title: "Change Password",
                      subTitle: "Security Password",
                      icon: Icons.navigate_next_sharp,
                      showSwitch: false),
                  Divider(thickness: 1, color: Color(0xffF2F2F2)),
                  // SizedBox(height: 5,),

                  _securityAndThemeContainer(
                      onTap: () {
                        Get.to(BioMatric());
                      },
                      leadingIcon: Icons.fingerprint_outlined,
                      type: "biomatric",
                      title: "Biometric",
                      subTitle: "Unlock with Biometric",
                      showSwitch: true),

                  SizedBox(
                    height: 5,
                  ),

                  Divider(thickness: 1, color: Color(0xffF2F2F2)),

                  SizedBox(
                    height: 5,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "App Theme",
                        style: TextStyle(
                            fontFamily: 'sfpro',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                            letterSpacing: 0.37,
                            color: headingColor.value),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _securityAndThemeContainer(
                      onTap: () {
                        print('jknkjnnkn');
                      },
                      type: "darkmode",
                      leadingIcon: Icons.dark_mode_outlined,
                      title: "Dark Mode",
                      subTitle: "Toggle to switch into Dark Mode",
                      showSwitch: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _walletContainer(
      {String? coinName,
      String? amountInEth,
      String? amountInUSD,
      String? percentage,
      String? priceInUSD,
      String? imgName,
      required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        // Get.to(Send());
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 58,
        decoration: BoxDecoration(
          color: isSelected == true
              ? bSheetbtnColor
              : appController.isDark.value
                  ? cardColor.value
                  : listCardColor.value,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        '$imgName',
                      ),
                    )),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            '$coinName',
                            style: TextStyle(
                              fontFamily: 'sfpro',
                              color: headingColor.value,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              letterSpacing: 0.37,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '$priceInUSD',
                        style: TextStyle(
                          fontFamily: 'sfpro',
                          color: placeholderColor,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          letterSpacing: 0.44,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isSelected == true
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.check,
                        color: primaryColor.value,
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget _securityAndThemeContainer(
      {required String type,
      required IconData leadingIcon,
      String? title,
      String? subTitle,
      IconData? icon,
      bool? showSwitch,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 58,
          decoration: BoxDecoration(
            // color:inputFieldBackgroundColor.value,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: primaryColor.value,
                      ),
                      child: Center(
                        child: Icon(
                          leadingIcon,
                          color: primaryBackgroundColor.value,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              '$title',
                              style: TextStyle(
                                fontFamily: 'sfpro',
                                color: headingColor.value,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                letterSpacing: 0.37,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '$subTitle',
                          style: TextStyle(
                            fontFamily: 'sfpro',
                            color: placeholderColor,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                            letterSpacing: 0.44,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                showSwitch == false
                    ? Icon(
                        icon,
                        color: labelColor.value,
                      )
                    : Container(
                        child: type == "darkmode"
                            ? FlutterSwitch(
                                activeText: "",
                                inactiveText: "",
                                activeColor: primaryColor.value,
                                width: 45.0,
                                height: 23.0,
                                valueFontSize: 10.0,
                                toggleSize: 19.0,
                                value: _theme.value,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: true,
                                onToggle: (val) async {
                                  _theme.value = val;
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  appController.isDark.value = _theme.value;
                                  await prefs.setBool(
                                      'isDarkMode', _theme.value);
                                  appController.changeTheme();
                                },
                              )
                            : FlutterSwitch(
                                activeText: "",
                                inactiveText: "",
                                activeColor: primaryColor.value,
                                width: 45.0,
                                height: 23.0,
                                valueFontSize: 10.0,
                                toggleSize: 19.0,
                                value: _biomatric,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: true,
                                onToggle: (val) {
                                  setState(() {
                                    _biomatric = val;
                                  });
                                },
                              ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _addvaletBottomSheet(BuildContext context) {
    return Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      Container(
        padding: EdgeInsets.all(20),
        height: Get.height * 0.4,
        decoration: BoxDecoration(
            color: cardColor.value,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add Wallet",
                  style: TextStyle(
                      fontFamily: 'sfpro',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 26.0,
                      letterSpacing: 0.44,
                      color: headingColor.value),
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.clear,
                      color: headingColor.value,
                    ))
              ],
            ),
            SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.to(CreateWallet(
                  fromPage: 'Settings',
                ));
              },
              child: Container(
                height: 56,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor.value),
                child: Center(
                  child: Text(
                    "Create Wallet",
                    style: TextStyle(
                        fontFamily: 'sfpro',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        letterSpacing: 0.44,
                        color: primaryBackgroundColor.value),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.to(ImportWallet(
                  fromPage: 'Settings',
                ));
              },
              child: Container(
                height: 56,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: primaryColor.value),
                    borderRadius: BorderRadius.circular(10),
                    color: primaryBackgroundColor.value),
                child: Center(
                  child: Text(
                    "Import Wallet",
                    style: TextStyle(
                        fontFamily: 'sfpro',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        letterSpacing: 0.44,
                        color: primaryColor.value),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

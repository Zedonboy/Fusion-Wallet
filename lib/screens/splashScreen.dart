
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/screens/homeScreen.dart';
import 'package:fusion_wallet/screens/pinCreateScreen.dart';
import 'package:fusion_wallet/screens/pinScreen.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
// import '../commonWidgets/bottomNav/bottomNavBar.dart';
// import '../commonWidgets/navCustom.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryAltBackgroundColor.value,
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 100,
              ),
              Image.asset("assets/images/splash_banner.png"),
              // SvgPicture.asset("assets/svg/banner.svg"),
              Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.to(() => PinCreationScreen(
                            next_screen: WalletCreationType.import));
                      },
                      child: Container(
                        width: Get.width,
                        height: 48,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: ShapeDecoration(
                          color: cardcolor.value,
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
                              'Import Using Seed Phrase',
                              style: TextStyle(
                                color: primaryAltColor.value,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0.09,
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                      onTap: () {
                        Get.to(() => PinCreationScreen(
                              next_screen: WalletCreationType.create,
                            ));
                      },
                      child: Container(
                        width: Get.width,
                        height: 48,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              'Create a New Wallet',
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
                      )),
                  SizedBox(height: 36),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  AppController appController = Get.find<AppController>();
  @override
  void initState() {
    appController.load();
    // TODO: implement initState
    super.initState();

    redirect();
  }

  redirect() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    final storage = FlutterSecureStorage();

    if (await storage.containsKey(key: 'encrypted_mnemonic')) {
      Get.offAll(
        () => PinScreen(
          onPinConfirm: (p0) {
            final wallet = Wallet.fromSeed(seedPhrase: p0);
            appController.active_wallet.value = wallet;

            // Get.offAll(() => BottomBar());
            Get.offAll(() => HomeScreen());
          },
          // onBiometric: (didAuth) {},
          isSignin: true,
        ),
      );
    } else {
      Get.offAll(() => SplashScreen());
    }

    // if (sharedPref.containsKey('FingerPrintEnable') &&
    //     sharedPref.getBool('FingerPrintEnable') == true) {

    // } else if (await storage.containsKey(key: 'password')) {
    //   Get.offAll(() => BottomBar());
    // } else {
    //   Get.offAll(() => SplashScreen());
    // }
    // Future.delayed(Duration(milliseconds: 500), () async {

    // });
  }

  @override
  Widget build(BuildContext context) {
    // return PinScreen();
    return Scaffold(
      backgroundColor: primaryAltBackgroundColor.value,
    );
  }
}

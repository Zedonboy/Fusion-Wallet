import 'package:flutter/material.dart';
import 'package:fusion_wallet/UI/bottomNavBar/BottomNavBar.dart';
import 'package:fusion_wallet/UI/pages/app_introduction/introduction.dart';
import 'package:fusion_wallet/UI/pages/app_introduction/introscreenonboarding.dart';
import 'package:fusion_wallet/UI/pages/home/dashboard.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<Introduction> _list = [
    const Introduction(
      title: 'Secure Wallet',
      subTitle: 'Secure Your Crypto, Anywhere Anytime',
      imageUrl: 'assets/imgs/onBoarding1.png',
    ),
    const Introduction(
      title: 'Exchange',
      subTitle: 'Swap Crypto with Confidence',
      imageUrl: 'assets/imgs/onBoarding2.png',
    ),
    const Introduction(
      title: 'All your assets in one Wallet',
      subTitle: 'Your Wallet, Your Way',
      imageUrl: 'assets/imgs/onBoarding3.png',
    ),
  ];
  @override
  void initState() {
    super.initState();
    // Add any initialization logic here
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    // logic to check if its user first time.
    Get.offAll(IntroScreenOnboarding(introductionList: _list, onTapSkipButton: () {
      
    },));
    // Get.offAll(const BottomNavigationBar1());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your logo here
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            Text('My App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

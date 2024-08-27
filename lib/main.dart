// The original content is temporarily commented out to allow generating a self-contained demo - feel free to uncomment later.

import 'package:flutter/material.dart';
import 'package:fusion_wallet/UI/pages/SplashScreen/splashScreen.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:fusion_wallet/src/rust/api/simple.dart';
import 'package:fusion_wallet/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final appController = Get.put(AppController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fusion Wallet',
     theme: ThemeData(
           primaryColor: const Color(0xff27C19F),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor:  Color(0xff27C19F),
          )
        ),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
      home: SplashScreen(),
    );
  }
}
class MyBehavior extends ScrollBehavior {
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
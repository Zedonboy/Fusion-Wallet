// The original content is temporarily commented out to allow generating a self-contained demo - feel free to uncomment later.

// /*
//  * Fusion Wallet - A non-custodial cryptocurrency wallet
//  * Copyright (C) 2025 Fusion Wallet
//  *
//  * This program is free software: you can redistribute it and/or modify
//  * it under the terms of the GNU General Public License as published by
//  * the Free Software Foundation, either version 3 of the License, or
//  * (at your option) any later version.
//  *
//  * This program is distributed in the hope that it will be useful,
//  * but WITHOUT ANY WARRANTY; without even the implied warranty of
//  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  * GNU General Public License for more details.
//  *
//  * You should have received a copy of the GNU General Public License
//  * along with this program.  If not, see <https://www.gnu.org/licenses/>.
//  */
// 
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/screens/DummyHomeScreen.dart';
import 'package:fusion_wallet/screens/splashScreen.dart';
import 'package:fusion_wallet/src/rust/frb_generated.dart';
import 'package:get/get.dart';

Future<void> main() async {
  await RustLib.init();
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppController appController = Get.put(AppController());
    return GetMaterialApp(
      title: 'Fusion Wallet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const DesktopVersionNotAvailable();
        }
        return const StartingPage();
      }),
    );
  }
}

class DesktopVersionNotAvailable extends StatelessWidget {
  const DesktopVersionNotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1930),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF252442),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.desktop_windows_outlined,
                size: 64,
                color: Color(0xFF70EDEF),
              ),
              const SizedBox(height: 24),
              const Text(
                "Desktop Version Not Available",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "dmsans",
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "The desktop version is not under development yet. Please use a mobile device to access all features.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontFamily: "dmsans",
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF70EDEF),
                  foregroundColor: const Color(0xFF1A1930),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Got it",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "dmsans",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF70EDEF),
          surface: Color(0xFF1A1930),
        ),
      ),
      home: const DummyHomeScreen(),
    );
  }
}

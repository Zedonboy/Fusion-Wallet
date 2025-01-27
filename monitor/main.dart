// The original content is temporarily commented out to allow generating a self-contained demo - feel free to uncomment later.

//
import 'package:flutter/material.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/screens/DummyHomeScreen.dart';
import 'package:fusion_wallet/screens/splashScreen.dart';
import 'package:fusion_wallet/src/rust/frb_generated.dart';
import 'package:get/get.dart';

Future<void> main() async {
  await RustLib.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DemoApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppController appController = Get.put(AppController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: DummyHomeScreen(),
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
          background: Color(0xFF09080C),
        ),
      ),
      home: const DummyHomeScreen(),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:fusion_wallet/src/rust/api/simple.dart';
// import 'package:fusion_wallet/src/rust/frb_generated.dart';

// Future<void> main() async {
//   await RustLib.init();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
//         body: Center(
//           child: Text(
//               'Action: Call Rust `greet("Tom")`\nResult: `${greet(name: "Tom")}`'),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:ffi';

// import 'package:code_scan/code_scan.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fusion_wallet/constants/colors.dart';
// import 'package:get/get.dart';
// class CodeScanner1 extends StatefulWidget {
//   const CodeScanner1({super.key});

//   @override
//   State<CodeScanner1> createState() => _CodeScanner1State();
// }

// class _CodeScanner1State extends State<CodeScanner1> {
//   TextEditingController nameAddreeC=TextEditingController();
//   TextEditingController amountC=TextEditingController();
//   var isOpen=true.obs;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//           ()=> Scaffold(
//         backgroundColor: primaryBackgroundColor.value,
//         body: SafeArea(
//           child: Container(
//             height: Get.height,
//             width: Get.width,
//             child: Stack
//               (
//               children: [
//                 CodeScanner(
//                   resolution: ResolutionPreset.medium,
//                   loading: Center(child: CircularProgressIndicator(color: primaryColor.value,)),
//                   // overlay: Center(child: Text('Scanning...')),
//                   onScan: (code, details, controller) => setState((){}),
//                   scanInterval: const Duration(seconds: 1),
//                   aspectRatio: 480 / 720,

//                   onScanAll: (codes, controller) => print('Codes: ' + codes.map((code) => code.rawValue).toString()),
//                   formats: [ BarcodeFormat.qrCode ],
//                   once: true,
//                 ),
//                 Positioned(child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       GestureDetector(
//                         onTap: (){
//                           Get.back();
//                         },
//                         child: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color:Color(0xffFFFFFF).withOpacity(0.15),
//                             border: Border.all(width: 1,color:Color(0xffFFFFFF).withOpacity(0.25),)
//                           ),
//                           child: Icon(Icons.arrow_back_ios_new_outlined,size: 19,color: Color(0xffFFFFFF),),
//                         ),
//                       ),
//                       Text(
//                         "Scan QR Code",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xffFFFFFF),
//                           fontFamily: "dmsans",

//                         ),

//                       ),
//                       Container(
//                         height: 40,
//                         width: 40,
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color:Color(0xffFFFFFF).withOpacity(0.15),
//                             border: Border.all(width: 1,color:Color(0xffFFFFFF).withOpacity(0.25),)

//                         ),
//                         child:SvgPicture.asset("assets/svgs/lets-icons_img-box-light.svg")
//                       )
//                     ],
//                   ),
//                 ))
//               ],
//             ),
//           )
//         ),
//       ),
//     );
//   }
// }

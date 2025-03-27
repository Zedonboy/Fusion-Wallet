/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */


import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
class QRcodeScreen extends StatefulWidget {
  const QRcodeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRcodeScreenState();
}

class _QRcodeScreenState extends State<QRcodeScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Expanded(child: _buildQrView(constraints));
    });
    // return Scaffold(
    //   body: Column(
    //     children: <Widget>[
    //       Expanded( child: _buildQrView(context)),
    //       // Expanded(
    //       //   flex: 1,
    //       //   child: FittedBox(
    //       //     fit: BoxFit.contain,
    //       //     child: Column(
    //       //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       //       children: <Widget>[
    //       //         if (result != null)
    //       //           Text(
    //       //               'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
    //       //         else
    //       //           const Text('Scan a code'),
    //       //         Row(
    //       //           mainAxisAlignment: MainAxisAlignment.center,
    //       //           crossAxisAlignment: CrossAxisAlignment.center,
    //       //           children: <Widget>[
    //       //             Container(
    //       //               margin: const EdgeInsets.all(8),
    //       //               child: ElevatedButton(
    //       //                   onPressed: () async {
    //       //                     await controller?.toggleFlash();
    //       //                     setState(() {});
    //       //                   },
    //       //                   child: FutureBuilder(
    //       //                     future: controller?.getFlashStatus(),
    //       //                     builder: (context, snapshot) {
    //       //                       return Text('Flash: ${snapshot.data}');
    //       //                     },
    //       //                   )),
    //       //             ),
    //       //             Container(
    //       //               margin: const EdgeInsets.all(8),
    //       //               child: ElevatedButton(
    //       //                   onPressed: () async {
    //       //                     await controller?.flipCamera();
    //       //                     setState(() {});
    //       //                   },
    //       //                   child: FutureBuilder(
    //       //                     future: controller?.getCameraInfo(),
    //       //                     builder: (context, snapshot) {
    //       //                       if (snapshot.data != null) {
    //       //                         return Text(
    //       //                             'Camera facing ${describeEnum(snapshot.data!)}');
    //       //                       } else {
    //       //                         return const Text('loading');
    //       //                       }
    //       //                     },
    //       //                   )),
    //       //             )
    //       //           ],
    //       //         ),
    //       //         Row(
    //       //           mainAxisAlignment: MainAxisAlignment.center,
    //       //           crossAxisAlignment: CrossAxisAlignment.center,
    //       //           children: <Widget>[
    //       //             Container(
    //       //               margin: const EdgeInsets.all(8),
    //       //               child: ElevatedButton(
    //       //                 onPressed: () async {
    //       //                   await controller?.pauseCamera();
    //       //                 },
    //       //                 child: const Text('pause',
    //       //                     style: TextStyle(fontSize: 20)),
    //       //               ),
    //       //             ),
    //       //             Container(
    //       //               margin: const EdgeInsets.all(8),
    //       //               child: ElevatedButton(
    //       //                 onPressed: () async {
    //       //                   await controller?.resumeCamera();
    //       //                 },
    //       //                 child: const Text('resume',
    //       //                     style: TextStyle(fontSize: 20)),
    //       //               ),
    //       //             )
    //       //           ],
    //       //         ),
    //       //       ],
    //       //     ),
    //       //   ),
    //       // )
    //     ],
    //   ),
    // );
  }

  Widget _buildQrView(BoxConstraints constraints) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = constraints.maxWidth < 600 ? 250.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (result == null) {
        setState(() {
          result = scanData;
          Get.back(result: result!.code);
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/tokenScreenOption/TopUpScreen.dart';
import 'package:fusion_wallet/src/rust/api/canister.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CanisterMetricScreen extends StatefulWidget {
  final CanisterMetric canisterMetric;

  const CanisterMetricScreen({super.key, required this.canisterMetric});

  @override
  State<CanisterMetricScreen> createState() => _CanisterMetricScreenState();
}

class _CanisterMetricScreenState extends State<CanisterMetricScreen> {
  AppController appController = Get.find<AppController>();
  var is_loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: darkBlueColor.value,
                            size: 16,
                          )),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Canister Details",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: darkBlueColor.value,
                          fontFamily: "dmsans",
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: darkBlueColor.value,
                    ),
                    color: primaryAltBackgroundColor.value,
                    surfaceTintColor: Colors.transparent,
                    shadowColor: Colors.black.withOpacity(0.1),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'remove',
                        child: Text(
                          'Remove',
                          style: TextStyle(color: darkBlueColor.value),
                        ),
                        onTap: () {
                          appController
                              .removeCanister(widget.canisterMetric.canisterId);
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        widget.canisterMetric.status.toLowerCase() == "running"
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.canisterMetric.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: widget.canisterMetric.status.toLowerCase() ==
                              "running"
                          ? Colors.green
                          : Colors.red,
                      fontFamily: "dmsans",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              // Canister ID Display
              Column(
                children: [
                  Text(
                    "Canister ID",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: lightAltTextColor.value,
                      fontFamily: "dmsans",
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          copyToClipboard(widget.canisterMetric.canisterId);
                        },
                        child: Container(
                          // width: 190,
                          height: 33,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: ShapeDecoration(
                            color: Color(0x191C1924),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 0.50, color: cardcolor.value),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.canisterMetric.canisterId,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 4),
                              Container(
                                width: 20,
                                height: 20,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(),
                                child: SvgPicture.asset("assets/svg/Icons.svg"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 4),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                          clipBehavior: Clip.antiAlias,
                          isScrollControlled: true,
                          backgroundColor: primaryBackgroundColor.value,
                          shape: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  topLeft: Radius.circular(32))),
                          TopUpScreen(
                              canisterId: widget.canisterMetric.canisterId));
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Color(0xFF1A2B56),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: SvgPicture.asset("assets/svgs/pump.svg",
                                  height: 28,
                                  width: 28,
                                  color: Color(0xFFA2BBFF))),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          getTranslated(context, "Top-up") ?? "Mint",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffFDFCFD),
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),

              // Canister Metrics Details
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: appController.isDark.value
                      ? Colors.black.withOpacity(0.3)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Canister Metrics",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: appController.isDark.value == true
                            ? const Color(0xffFDFCFD)
                            : primaryAltColor.value,
                        fontFamily: "dmsans",
                      ),
                    ),
                    SizedBox(height: 16),

                    // Cycle Balance
                    _buildMetricRow(
                      "Cycle Balance",
                      "${normalizeBalance(widget.canisterMetric.cyclesBalance, 12, maxDecimalPlaces: 2)}T",
                      Icons.account_balance_wallet,
                    ),

                    Divider(height: 24),

                    // Memory Size
                    _buildMetricRow(
                      "Memory Size",
                      formatBytes(widget.canisterMetric.memorySize),
                      Icons.memory,
                    ),

                    Divider(height: 24),

                    // Total Calls
                    _buildMetricRow(
                      "Total Calls",
                      NumberFormat('#,###')
                          .format(widget.canisterMetric.totalCalls.toInt()),
                      Icons.call_made,
                    ),

                    Divider(height: 24),

                    // Inbound Data
                    _buildMetricRow(
                      "Total Inbound Data",
                      formatBytes(widget.canisterMetric.totalInboundBytes),
                      Icons.download,
                    ),

                    Divider(height: 24),

                    // Outbound Data
                    _buildMetricRow(
                      "Total Outbound Data",
                      formatBytes(widget.canisterMetric.totalOutboundBytes),
                      Icons.upload,
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

  Widget _buildMetricRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: primaryAltColor.value.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: primaryAltColor.value,
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: lightAltTextColor.value,
                  fontFamily: "dmsans",
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: appController.isDark.value == true
                      ? const Color(0xffFDFCFD)
                      : primaryAltColor.value,
                  fontFamily: "dmsans",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

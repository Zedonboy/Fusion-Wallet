/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:fusion_wallet/controllers/deferred_prompt.dart';

import '../../constants/colors.dart';

class BackupReminderWidget extends StatefulWidget {
  final VoidCallback? onClose;
  
  const BackupReminderWidget({super.key, this.onClose});
  
  @override
  _BackupReminderWidgetState createState() => _BackupReminderWidgetState();
}


class _BackupReminderWidgetState extends State<BackupReminderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (kIsWeb) {
              promptInstall();
            }
          },
          child: Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Color(0xFF16141C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffD1FF84),
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/notification-bing.svg',
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add to Home Screen',
                          style: TextStyle(
                            color: lightTextColor.value,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Install Wallet on your Home Screen',
                          style: TextStyle(
                            color: labelColorPrimaryShade.value,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    widget.onClose?.call();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Icon(
                      Icons.close,
                      color: lightTextColor.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

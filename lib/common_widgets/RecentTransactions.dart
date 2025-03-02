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
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/src/rust/api/ic_wallet_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecentTransfers extends StatelessWidget {
  final bool isLoading;
  final List<SimpleTransaction> transfers;

  const RecentTransfers({
    super.key,
    this.isLoading = false,
    this.transfers = const [],
  });

  int nanosToMillis(BigInt nanos) {
    return (nanos ~/ BigInt.from(1000000)).toInt();
  }

  Widget transactionSkeletonWidget() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: cardcolor.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Skeletonizer(
        effect: ShimmerEffect(
          baseColor: Colors.grey.withOpacity(0.8),
          highlightColor: Colors.grey.withOpacity(0.5),
        ),
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 60,
                  height: 16,
                  color: Colors.white,
                ),
                Container(
                  width: 120,
                  height: 16,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 6),
            Divider(
              color: Color(0xFF242438),
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 12,
                      color: Colors.white,
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: 80,
                      height: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: 12,
                      color: Colors.white,
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: 100,
                      height: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTransactionItem(SimpleTransaction transaction,
      [bool isSkeleton = false]) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: cardcolor.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  isSkeleton ? "Loading..." : transaction.kind,
                  style: TextStyle(
                    color:
                        transaction.kind == "send" ? Colors.red : Colors.green,
                    fontSize: 14,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text(
                  //   transaction.kind == 'send' ? 'To:' : 'From:',
                  //   style: TextStyle(
                  //     color: subtextColor.value,
                  //     fontSize: 12,
                  //     fontFamily: 'DM Sans',
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                  SizedBox(width: 2),
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      splashColor: Colors.grey.withOpacity(0.1),
                      highlightColor: Colors.grey.withOpacity(0.05),
                      onTap: () {
                        copyToClipboard(transaction.to);
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              address_shortener(transaction.to),
                              style: TextStyle(
                                color: subtextColor.value,
                                fontSize: 12,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.copy,
                                size: 12, color: subtextColor.value),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6),
          Container(
            width: Get.width,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFF242438),
                ),
              ),
            ),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(
                      color: subtextColor.value,
                      fontSize: 12,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        transaction.amount,
                        style: TextStyle(
                          color: lightTextColor.value,
                          fontSize: 14,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        transaction.symbol,
                        style: TextStyle(
                          color: lightTextColor.value,
                          fontSize: 14,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(
                      color: subtextColor.value,
                      fontSize: 12,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    DateFormat('d MMM, y hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            transaction.timestamp.toInt())),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemBuilder: (context, index) => transactionSkeletonWidget(),
      );
    }

    if (transfers.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/svg/noTransactions.svg'),
          SizedBox(height: 16),
          SizedBox(
            width: Get.width,
            child: Text(
              'No Transaction History',
              style: TextStyle(
                color: primaryColor.value,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transfers.length,
      separatorBuilder: (context, index) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        return buildTransactionItem(transfers[index]);
      },
    );
  }
}

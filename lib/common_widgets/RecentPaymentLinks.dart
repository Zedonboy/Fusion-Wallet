/**
 * Copyright (C) 2025 Fusion Wallet
 * 
 * This file is part of Fusion Wallet.
 * 
 * Fusion Wallet is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Fusion Wallet is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Fusion Wallet.  If not, see <https://www.gnu.org/licenses/>.
 */


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/src/rust/api/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/services.dart';

class RecentPaymentLinks extends StatelessWidget {
  final bool isLoading;
  final List<PaymentLink> paymentLinks;

  const RecentPaymentLinks({
    super.key,
    this.isLoading = false,
    this.paymentLinks = const [],
  });

  int nanosToMillis(BigInt nanos) {
    // Check if the value is already in milliseconds or nanoseconds
    // Nanosecond timestamps are typically much larger than millisecond ones
    // A timestamp from 2023 in milliseconds would be around 1.7 trillion
    // If the value is less than 2 trillion, assume it's already in milliseconds
    if (nanos < BigInt.from(2000000000000)) {
      return nanos.toInt();
    }
    // Otherwise, convert from nanoseconds to milliseconds
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

  Widget buildPaymentLinkItem(PaymentLink paymentLink, [bool isSkeleton = false]) {
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
                  isSkeleton ? "Loading..." : "Payment Link",
                  style: TextStyle(
                    color: Colors.blue,
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
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      splashColor: Colors.grey.withOpacity(0.1),
                      highlightColor: Colors.grey.withOpacity(0.05),
                      onTap: () {
                        final url = "https://wxakm-ayaaa-aaaam-aejqa-cai.icp0.io/payment/${paymentLink.id}";
                        copyToClipboard(url).then((value) {
                         showToast("Copied to clipboard");
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Copy Link",
                              style: TextStyle(
                                color: subtextColor.value,
                                fontSize: 12,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.copy, size: 12, color: subtextColor.value),
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
          Divider(color: Color(0xFF242438)),
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
                        paymentLink.amount.toString(),
                        style: TextStyle(
                          color: lightTextColor.value,
                          fontSize: 14,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        paymentLink.tokenSymbol,
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
                    'Created',
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
                        nanosToMillis(paymentLink.createdAt),
                      ),
                    ),
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
          if (paymentLink.memo.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              'Memo: ${paymentLink.memo}',
              style: TextStyle(
                color: subtextColor.value,
                fontSize: 12,
                fontFamily: 'DM Sans',
              ),
            ),
          ],
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

    if (paymentLinks.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/svg/noTransactions.svg'),
          SizedBox(height: 16),
          Text(
            'No Payment Links',
            style: TextStyle(
              color: primaryColor.value,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      itemCount: paymentLinks.length,
      separatorBuilder: (context, index) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        return buildPaymentLinkItem(paymentLinks[index]);
      },
    );
  }
}

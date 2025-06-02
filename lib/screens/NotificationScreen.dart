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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var isNotifications = true.obs;
  AppController appController = Get.find<AppController>();
  final box = Hive.box<AppNotification>("notifications");



  @override
  void initState() {
   
    // Add Hive listener
    box.listenable().addListener(triggerDraw);
    // Wait for 5 seconds before marking notifications as seen
    Future.delayed(const Duration(seconds: 5), () {
      // Set new_notification flag to false in AppController
      print("Marking notifications as seen");
      appController.new_notification.value = false;
    });

     super.initState();
  }

  void triggerDraw() {
    if (!mounted) return;
    setState(() {
      
    });
  }

  @override
  void dispose() {
    
    // Remove Hive listener when widget is disposed
    box.listenable().removeListener(triggerDraw);
    super.dispose();
    print("Disposing");
   
  }

  void _markNotificationAsRead(AppNotification notification) {
    if (!notification.isRead) {
      
      Future.delayed(const Duration(seconds: 5), () async {
        notification.isRead = true;
        await notification.save();
       
      });
    }
  }

  void _clearReadNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryBackgroundColor.value,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            getTranslated(context, "Clear Read Notifications") ?? "Clear Read Notifications",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "dmsans",
              fontWeight: FontWeight.w600,
              color: headingColor.value,
            ),
          ),
          content: Text(
            getTranslated(context, "Are you sure you want to clear all read notifications?") ?? 
            "Are you sure you want to clear all read notifications?",
            style: TextStyle(
              fontSize: 14,
              fontFamily: "dmsans",
              color: lightTextColor.value,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                getTranslated(context, "Cancel") ?? "Cancel",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "dmsans",
                  color: lightTextColor.value,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final notifications = box.values.toList();
                for (var notification in notifications) {
                  if (notification.isRead) {
                    notification.delete();
                  }
                }
              },
              child: Text(
                getTranslated(context, "Clear") ?? "Clear",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "dmsans",
                  color: blueCard1.value,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

 

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryAltBackgroundColor.value,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 16,
                                color: darkBlueColor.value,
                              ),
                            ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${getTranslated(context, "Notifications") ?? "Notifications"}    ",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "dmsans",
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _clearReadNotifications,
                    child: Text(
                      getTranslated(context, "Clear Read") ?? "Clear Read",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "dmsans",
                        color: blueCard1.value,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child:  box.isEmpty ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none_outlined,
                            size: 64,
                            color: lightTextColor.value,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            getTranslated(context, "No notifications yet") ?? "No notifications yet",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: headingColor.value,
                              fontFamily: "dmsans",
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            getTranslated(context, "You'll see your notifications here when you receive them") ?? 
                            "You'll see your notifications here when you receive them",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: lightTextColor.value,
                              fontFamily: "dmsans",
                            ),
                          ),
                        ],
                      ),
                    ) : ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    itemCount: box.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final notification = box.values.elementAtOrNull(box.length - 1 - index);
                      if (notification == null) {
                        return const SizedBox.shrink();
                      }
                      return _buildNotificationItem(notification);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildNotificationItem(AppNotification notification) {
    final type = notification.data?['type'] ?? 'general';
    return VisibilityDetector(
      key: Key(notification.id),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) { // Notification is more than 50% visible
          _markNotificationAsRead(notification);  
        } 
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: notification.isRead
                ? primaryBackgroundColor.value
                : inputFieldBackgroundColor.value,
          ),
          color: notification.isRead
              ? primaryBackgroundColor.value
              : inputFieldBackgroundColor2.value,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _getTypeColor(type.toLowerCase()),
              ),
              child: notification.imageUrl != null 
                ? CachedNetworkImage(imageUrl: notification.imageUrl!) 
                : Center(child: _getTypeIcon(type.toLowerCase())),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification.appName ?? notification.canisterId ?? notification.title,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontFamily: "dmsans",
                          fontWeight: FontWeight.w600,
                          color: blueCard1.value,
                        ),
                      ),
                      Text(
                        _formatDate(notification.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "dmsans",
                          fontWeight: FontWeight.w400,
                          color: appController.isDark.value == true
                              ? const Color(0xff6C7CA7)
                              : lightTextColor.value,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "dmsans",
                      fontWeight: FontWeight.w400,
                      color: appController.isDark.value == true
                          ? const Color(0xffA2BBFF)
                          : lightTextColor.value,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case "send":
        return const Color(0xffFF5C5C);
      case "deposit":
        return const Color(0xff13E69F);
      case "swap":
        return const Color(0xff1A2B56);
      default:
        return Color(0xff13E69F);
    }
  }

  Widget _getTypeIcon(String type) {
    switch (type) {
      case "send":
        return SvgPicture.asset("assets/svgs/Arrow Top Right 1.svg");
      case "deposit":
        return SvgPicture.asset("assets/svgs/Arrow Down 1.svg");
      case "swap":
        return SvgPicture.asset("assets/svgs/a swap.svg");
      default:
        return const Icon(Icons.notifications, color: Colors.white, );
    }
  }

  String _formatDate(DateTime date) {
    DateFormat dateFormat = DateFormat("dd MMM yyyy hh:mm a");
    return dateFormat.format(date);
  }
}
/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */


import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/extensions.dart';
// import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:intl/intl.dart';
import 'package:hive_ce/hive.dart';

Future<void> copyToClipboard(String copiedText) async {
  await Clipboard.setData(ClipboardData(text: copiedText));
  HapticFeedback.vibrate();
}

showToast(message, {Color color = Colors.red}) {
  if (kIsWeb) {
    Fluttertoast.showToast(msg: message, webBgColor: primaryAltBgColor2.toHex(), textColor: headingColor.value, fontSize: 12.0);
  } else {
    Fluttertoast.showToast(msg: message);
  }
  
  // Fluttertoast.showToast(
  //     msg: "$message",
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.CENTER,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: color,
  //     textColor: Colors.white,
  //     fontSize: 16.0);
}

// Token data class to hold all values
class TokenData {
  final BigInt balance;
  final double? price;
  // final double usdWorth;

  TokenData({
    required this.balance,
    this.price,
    // required this.usdWorth,
  });

  // Create a default instance with zero values
  factory TokenData.zero() {
    return TokenData(balance: BigInt.zero, price: 0.00);
  }

  // Create an error instance
  factory TokenData.error() {
    return TokenData(balance: BigInt.from(-1), price: -1);
  }

  factory TokenData.nullData() {
    return TokenData(balance: BigInt.zero, price: null);
  }
}

String address_shortener(String addr,
    {int start_count = 5, int end_count = 4}) {
  return "${addr.substring(0, start_count)}...${addr.substring(addr.length - end_count)}";
}

String calculateUsdWorth(BigInt amount, int decimals, double? usdPrice) {

  if (usdPrice == null) {
    return "---";
  }

  if (amount == BigInt.zero || usdPrice <= 0) {
    return formatUsdPrice(0);
  }

  // Convert to decimal value
  double decimalAmount = amount.toDouble() / pow(10, decimals);

  // Calculate USD worth
  double usdWorth = decimalAmount * usdPrice;

  return formatUsdPrice(usdWorth);
}

// Formats a number as USD currency, removing unnecessary trailing zeros
/// [amount] - The amount to format
String formatUsdPrice(double amount) {
  // Handle zero and negative cases
  if (amount <= 0) return '\$0';

  // Create currency formatter
  final formatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 6,
  );

  // Format the number
  String formatted = formatter.format(amount);

  // Remove trailing zeros after decimal
  if (formatted.contains('.')) {
    // Split into dollars and cents
    var parts = formatted.split('.');

    // Remove trailing zeros from cents
    var cents = parts[1].replaceAll(RegExp(r'0+$'), '');

    // If cents is empty, return just the dollars
    if (cents.isEmpty) {
      return parts[0];
    }

    // Otherwise combine dollars with cleaned cents
    return '${parts[0]}.$cents';
  }

  return formatted;
}


String normalizeBalance(BigInt value, int decimals, {int? maxDecimalPlaces}) {
  if (value < BigInt.zero) return "0";

  print(value);

  // Convert to decimal string
  String valueStr = value.toString();
  if (valueStr.length <= decimals) {
    valueStr = "0.${"0" * (decimals - valueStr.length)}$valueStr";
  } else {
    valueStr =
        "${valueStr.substring(0, valueStr.length - decimals)}.${valueStr.substring(valueStr.length - decimals)}";
  }

  // If maxDecimalPlaces is specified, limit the decimal places
  if (maxDecimalPlaces != null && valueStr.contains('.')) {
    final parts = valueStr.split('.');
    if (parts[1].length > maxDecimalPlaces) {
      valueStr = "${parts[0]}.${parts[1].substring(0, maxDecimalPlaces)}";
    }
  }

  // Remove trailing zeros after decimal
  valueStr = valueStr.replaceAll(RegExp(r'\.?0+$'), '');

  print(valueStr);

  return valueStr;
}

BigInt decimalToBlockchainUnits(double amount, int decimals) {
  // Handle edge cases
  if (amount < 0) {
    throw ArgumentError('Amount cannot be negative');
  }
  
  if (decimals < 0) {
    throw ArgumentError('Decimals cannot be negative');
  }
  
  // Calculate the multiplier (10^decimals)
  BigInt multiplier = BigInt.from(10).pow(decimals);
  
  // Convert the decimal amount to blockchain units
  // First multiply by 10^decimals to handle the decimal places
  BigInt result = BigInt.from(amount * pow(10, decimals));
  
  return result;
}

String formatBytes(BigInt bytes, {int decimals = 2}) {
  if (bytes <= BigInt.zero) return "0 B";
  
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  final i = (log(bytes.toDouble()) / log(1024)).floor();
  
  // Handle case where bytes is so large it exceeds our suffix list
  if (i >= suffixes.length) {
    return "Too large";
  }
  
  // Calculate the value in the appropriate unit
  final value = bytes / BigInt.from(pow(1024, i));
  
  // Format with the specified number of decimal places
  return "${value.toStringAsFixed(decimals)} ${suffixes[i]}";
}

String getPathAndQuery(Uri uri) {

  if (uri.query.isEmpty) {
    return uri.path;
  }

  return "${uri.path}?${uri.query}";
}

class AppNotification extends HiveObject {
  String id;
  String title;
  String body;
  String? imageUrl;
  DateTime timestamp;
  Map<String, dynamic>? data;
  bool isRead = false;
  String? appName;
  String? canisterId;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.timestamp,
    this.data,
    this.isRead = false,
    this.appName,
    this.canisterId
  });

  // Create a Notification from a Firebase RemoteMessage
  factory AppNotification.fromRemoteMessage(RemoteMessage message) {
    return AppNotification(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'Notification',
      body: message.notification?.body ?? '',
      imageUrl: message.notification?.android?.imageUrl ?? message.notification?.apple?.imageUrl,
      timestamp: message.sentTime ?? DateTime.now(),
      data: message.data,
      appName: message.data['appName'],
      canisterId: message.data["canisterId"]
    );
  }

  // Convert to a Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'data': data,
      'isRead': isRead,
      'appName': appName,
      'canisterId': canisterId
    };
  }

  // Create a Notification from a Map (from Hive)
  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      imageUrl: map['imageUrl'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      data: map['data'],
      isRead: map['isRead'] ?? false,
      appName: map['appName'],
      canisterId: map['canisterId']
    );
  }

  // Create a copy of the notification with updated fields
  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? imageUrl,
    DateTime? timestamp,
    Map<String, dynamic>? data,
    bool? isRead,
    String? appName,
    String? canisterId
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      appName: appName ?? this.appName,
      canisterId: canisterId ?? this.canisterId
    );
  }
}

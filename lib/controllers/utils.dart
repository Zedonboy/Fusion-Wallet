
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

Future<void> copyToClipboard(String copiedText) async {
  await Clipboard.setData(ClipboardData(text: copiedText));
  HapticFeedback.vibrate();
}

showToast(message, {Color color = Colors.red}) {
  Fluttertoast.showToast(msg: message);
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
  final double price;
  // final double usdWorth;

  TokenData({
    required this.balance,
    required this.price,
    // required this.usdWorth,
  });

  // Create a default instance with zero values
  factory TokenData.zero() {
    return  TokenData(balance: BigInt.zero, price: 0.00);
  }

  // Create an error instance
  factory TokenData.error() {
    return TokenData(balance: BigInt.from(-1), price: -1);
  }
}




String address_shortener(String addr, {int start_count = 5, int end_count = 4}) {
  return "${addr.substring(0, start_count)}...${addr.substring(addr.length - end_count)}";
}

String calculateUsdWorth(BigInt amount, int decimals, double usdPrice) {
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

String normalizeBalance(BigInt value, int decimals) {

  if (value < BigInt.zero) return "0";

  print(value);

  // Convert to decimal string
  String valueStr = value.toString();
  if (valueStr.length <= decimals) {
    valueStr = "0.${"0" * (decimals - valueStr.length)}$valueStr";
  } else {
    valueStr = "${valueStr.substring(0, valueStr.length - decimals)}.${valueStr.substring(valueStr.length - decimals)}";
  }

  // Remove trailing zeros after decimal
  valueStr = valueStr.replaceAll(RegExp(r'\.?0+$'), '');

  print(valueStr);

  return valueStr;
}

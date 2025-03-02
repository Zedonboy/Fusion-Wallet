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
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:intl/intl.dart';

extension NumberStringCleaning on String {
  String removeTrailingZeroes() {
    // Check if the string contains a decimal point
    if (contains('.')) {
      // Remove trailing zeroes after decimal
      return replaceFirst(RegExp(r'\.?0+$'), '');
    }
    return this;
  }
}

extension UsdCurrencyFormatter on String {
  String toUsdCurrency() {
    try {
      // Parse the string to a double
      double value = double.parse(this);

      // Create a NumberFormat for USD currency
      final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

      // Format and return the result
      return formatter.format(value);
    } catch (e) {
      // Handle invalid input
      return 'Invalid amount';
    }
  }
}

extension TokenDataPriceFormat on TokenData {
  String get formattedPrice {
    // Return placeholder if price is negative or zero
    if (price < 0) return "---";

    // Create a NumberFormat for USD currency
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    // Format the price
    String formatted = formatter.format(price);

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
}

extension ColorExtension on Color {
  /// Convert color to hex string
  /// Returns hex string in format: #RRGGBB
  String toHex() =>
      '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  /// Convert color to hex string including alpha
  /// Returns hex string in format: #AARRGGBB
  String toHexWithAlpha() =>
      '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

String removeTrailingZeros(String number) {
  if (!number.contains('.')) return number;
  return number.replaceAll(RegExp(r'\.?0*$'), '');
}

/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */


import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fusion_wallet/common_widgets/futureImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/src/rust/api/ic_wallet_service.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';

import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends GetxController {
  var isDark = true.obs;
  RxInt selectedBOttomTabIndex = RxInt(0);
  Rx<Wallet?> active_wallet = Rx(null);
  var enabledBiometric = false.obs;
  RxMap<String, WalletToken> tokens_map = RxMap();
  // RxList<WalletToken> tokens = WalletContext.getInitialSupportedTokens().obs;
  IcWalletService? ic_service;
  var token_image_map = RxMap<String, Widget>();
  Timer? _balanceTimer;

  /// Single map to hold all token data
  var token_data_map = RxMap<String, TokenData>();
  final storage = const FlutterSecureStorage();

  Map<String, Widget> createTokenImageMap(
    List<WalletToken> tokens, {
    double? width = 40,
    double? height = 40,
    BoxFit fit = BoxFit.contain,
  }) {
    return Map.fromEntries(
      tokens.map((token) => MapEntry(
            token.tokenAddress,
            FutureAdaptiveImage(
              imageUrl: token.imageUrl ?? 'assets/images/usd.png',
              width: width,
              height: height,
              fit: fit,
            ),
          )),
    );
  }

  void listen_wallet() {
    ever(active_wallet, (data) {
      // Cancel existing timer when wallet changes
      stop_balance_monitor();
      ic_service = data?.createIcService();
      start_balance_monitor();
    });
  }

// base16 key
  Future<String?> decryptMnemonic(String encryptionKey) async {
    try {
      // Get encrypted data from secure storage
      final encryptedData = await storage.read(key: 'encrypted_mnemonic');
      final base64Iv = await storage.read(key: "key_iv");
      if (encryptedData == null || base64Iv == null) {
        return null;
      }

      // Convert encryption key to required format
      final key = encrypt.Key.fromBase16(encryptionKey);
      final iv = encrypt.IV.fromBase64(base64Iv);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      // Decrypt the data
      final decrypted = encrypter.decrypt(
        encrypt.Encrypted.fromBase64(encryptedData),
        iv: iv,
      );

      return decrypted;
    } catch (e) {
      print("Error decrypting mnemonic: $e");
      return null;
    }
  }

  Future<bool> encryptAndStoreMnemonic(String mnemonic, String pin) async {
    try {
      final encryptionKey = WalletContext.hashData(data: pin);
      // Convert encryption key to required format
      final key = encrypt.Key.fromBase16(encryptionKey);
      // Generate a random IV
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      // Encrypt the mnemonic
      final encrypted = encrypter.encrypt(mnemonic, iv: iv);

      // Store both the encrypted data and IV in secure storage
      await storage.write(key: 'encrypted_mnemonic', value: encrypted.base64);
      await storage.write(key: 'key_iv', value: iv.base64);

      return true;
    } catch (e) {
      print("Error encrypting mnemonic: $e");
      return false;
    }
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    // Load biometric preference
    enabledBiometric.value = prefs.getBool('FingerPrintEnable') ?? false;
  }

  void load() async {
    await loadPreferences();
    loadSavedTokens().then((_) {
      token_image_map.value = createTokenImageMap(tokens_map.values.toList());
      listen_wallet();
    });
  }

  void check_token_on_ic() {
    var icService = ic_service!;
    var httpService = WalletContext.createHttpService();
    var address = active_wallet.value!.toIcpPrincipal();

    Future.wait(tokens_map.values.map((token) async {
      bool wasUpdated = false;

      try {
        // Get price from coinbase
        final coinbasePrice = await httpService.getPrice(token: token);
        if (coinbasePrice > 0) {
          // Only update if we got a valid price
          final currentData = token_data_map[token.tokenAddress];
          final newBalance = currentData?.balance ?? BigInt.from(-1);
          token_data_map[token.tokenAddress] =
              TokenData(balance: newBalance, price: coinbasePrice);
          wasUpdated = true;
        }
      } catch (err) {
        print("Error fetching price for ${token.symbol}: $err");
      }

      try {
        // Get balance from IC
        final icBalance =
            await icService.getBalance(token: token, account: address);
        final currentData = token_data_map[token.tokenAddress];
        token_data_map[token.tokenAddress] =
            TokenData(balance: icBalance, price: currentData?.price ?? -1.0);
        wasUpdated = true;
      } catch (e) {
        print("Error fetching balance for ${token.symbol}: $e");
      }

      return wasUpdated;
    })).then((results) {
      // Only refresh if at least one token was updated successfully
      if (results.any((wasUpdated) => wasUpdated)) {
        token_data_map.refresh();
      }
    });
  }

  void stop_balance_monitor() {
    _balanceTimer?.cancel();
    _balanceTimer = null;
  }

  void start_balance_monitor() {
    // Cancel any existing timer
    _balanceTimer?.cancel();

    check_token_on_ic();
    _balanceTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      print("Timer: Checking balance");
      check_token_on_ic();
    });
  }

  void addToken(WalletToken token) {
    if (tokens_map.containsKey(token.tokenAddress)) return;

    Future.microtask(() {
      final imageData = FutureAdaptiveImage(
        imageUrl: token.imageUrl ?? 'assets/images/usd.png',
        width: 40,
        height: 40,
        fit: BoxFit.contain,
      );
      token_image_map[token.tokenAddress] = imageData;
      token_image_map.refresh();
    });

    // ignore: invalid_use_of_protected_member
    tokens_map.value[token.tokenAddress] = token;
    tokens_map.refresh();
    saveTokens();
  }

  // Add to AppController class:
  Future<void> saveTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenList = tokens_map.values.map((t) => t.toString()).toList();
    await prefs.setString('saved_tokens', jsonEncode(tokenList));
  }

  Future<void> loadSavedTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTokens = prefs.getString('saved_tokens');
    if (savedTokens != null) {
      final List<dynamic> tokenList = jsonDecode(savedTokens);
      for (var tokenJson in tokenList) {
        final token = WalletToken.fromString(data: tokenJson);
        tokens_map[token.tokenAddress] = token;
      }
      tokens_map.refresh();
    } else {
      final tokenList = WalletContext.getInitialSupportedTokens();
      for (var token in tokenList) {
        tokens_map[token.tokenAddress] = token;
      }
    }

    tokens_map.refresh();
  }
}

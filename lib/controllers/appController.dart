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
import 'package:fusion_wallet/src/rust/api/canister.dart';
import 'package:fusion_wallet/src/rust/api/ic_wallet_service.dart';
import 'package:fusion_wallet/src/rust/api/nft_service.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';

import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends GetxController {
  var isDark = true.obs;
  var new_notification = false.obs;
  RxInt selectedBOttomTabIndex = RxInt(0);
  Rx<IWallet?> active_wallet = Rx(null);
  var enabledBiometric = false.obs;
  RxMap<String, WalletToken> tokens_map = RxMap();
  RxMap<String, CanisterMetric> canister_map = RxMap();
  var notificationsEnabled = false.obs;
  // RxList<WalletToken> tokens = WalletContext.getInitialSupportedTokens().obs;
  IcWalletService? ic_service;
  var token_image_map = RxMap<String, Widget?>();
  Timer? _balanceTimer;
  Timer? _canisterTimer;
  RxMap<String, WalletCollection> collection = RxMap();

  CanisterMetric? onchain_wallet_canister_metric;

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
      stop_canister_monitor();
      ic_service = data?.createIcService();
      start_balance_monitor();
      start_canister_monitor();
    });

    ever(notificationsEnabled, (data) async {
     final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', data);
    });

    ever(new_notification, (data) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('new_notification', data);
    });

    ever(enabledBiometric, (data) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("FingerPrintEnable", data);
    });
  }

  Future<void> check_token_balances() async {
    if (ic_service == null || active_wallet.value == null) {
      return;
    }

    try {
      final allTokens = WalletContext.getAllSupportedTokens();
      
      for (var token in allTokens) {
        final balance = await ic_service!.getBalance(token: token, account: active_wallet.value!.toIcpPrincipal());
        
        // Check if balance is greater than 0 and token fee
        if (balance > token.transferFee) {
          addToken(token);
        }
      }
    } catch (e) {
      print("Error checking token balances: $e");
    }
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
    new_notification.value = prefs.getBool('new_notification') ?? false;
    notificationsEnabled.value = prefs.getBool('notifications_enabled') ?? false;
  }

  void load() async {
    await loadPreferences();
    loadSavedTokens().then((_) {
      token_image_map.value = createTokenImageMap(tokens_map.values.toList());
      listen_wallet();
    });
    await loadCanisters();
  }

  void check_token_on_ic() {
    var icService = ic_service!;
    var httpService = WalletContext.createHttpService();
    var address = active_wallet.value!.toIcpPrincipal();
    var wasUpdated = false;
    Future.wait(tokens_map.values.map((token) async {

      try {
        final coinbasePrice = await httpService.getPrice(token: token);
        // Get balance from IC
        final icBalance =
            await icService.getBalance(token: token, account: address);
        final currentData = token_data_map[token.tokenAddress];
        if (currentData != null) {
          // Check if both balance and price are the same
          if (currentData.balance == icBalance && 
              currentData.price == coinbasePrice) {
            return; // Skip update if values haven't changed
          }
        }

        token_data_map[token.tokenAddress] =
            TokenData(balance: icBalance, price: coinbasePrice);
        wasUpdated = true;
      } catch (e) {
        token_data_map[token.tokenAddress] = TokenData.nullData();
        print("Error fetching balance for ${token.symbol}: $e");
      }
    })).then((results) {
      // Only refresh if at least one token was updated successfully
      if (wasUpdated) {
        token_data_map.refresh();
      }
    });
  }

  void stop_balance_monitor() {
    _balanceTimer?.cancel();
    _balanceTimer = null;
  }

  start_balance_monitor() async {
    // Cancel any existing timer
    _balanceTimer?.cancel();

    check_token_on_ic();
    _balanceTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      print("Timer: Checking balance");
      check_token_on_ic();
    });
  }

  void stop_canister_monitor() {
    _canisterTimer?.cancel();
    _canisterTimer = null;
  }

  start_canister_monitor() async {
    stop_canister_monitor();
    await check_canister_on_ic();
    _canisterTimer = Timer.periodic(Duration(minutes: 10), (timer) {
      print("Timer: Checking canister");
      check_canister_on_ic();
    });
  }

  Future<void> check_canister_on_ic() async {
    var icService = ic_service!;

    final canisterInfo = icService.createCanisterInfoService();
    try {
      for (var canister in canister_map.values) {
        final canisterMetrics = await canisterInfo.getCanisterStatus(canisterId: canister.canisterId);
        canister_map[canister.canisterId] = canisterMetrics;
      }
      canister_map.refresh();
    } catch (e) {
      print("Error checking canister: $e");
    }
  }
  void addToken(WalletToken token) {

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

  // Add to AppController class:
  Future<void> saveCollectionTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenList = collection.values.map((t) => t.toString()).toList();
    await prefs.setString('saved_collections', jsonEncode(tokenList));
  }

  Future<void> loadSavedCollection() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTokens = prefs.getString('saved_collections');
    if (savedTokens != null) {
      final List<dynamic> tokenList = jsonDecode(savedTokens);
      for (var tokenJson in tokenList) {
        final token = WalletCollection.fromString(data: tokenJson);
        collection[token.tokenAddress] = token;
      }
      collection.refresh();
    }
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

  // Canister Stuffs
  void addCanister(CanisterMetric canister) {
    canister_map[canister.canisterId] = canister;
    canister_map.refresh();
    saveCanisters();
  }

  Future<void> saveCanisters() async {
    final prefs = await SharedPreferences.getInstance();
    final canisterList = canister_map.values.map((t) => t.toJson()).toList();
    await prefs.setString('saved_canisters', jsonEncode(canisterList));
  }

  Future<void> loadCanisters() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCanisters = prefs.getString('saved_canisters');
    if (savedCanisters != null) {
      final List<dynamic> canisterList = jsonDecode(savedCanisters);
      for (var canisterJson in canisterList) {
        final canister = CanisterMetric.fromJson(canisterJson); 
        canister_map[canister.canisterId] = canister;
      }
      canister_map.refresh();
    } 
  }

  void removeCanister(String canisterId) {
    canister_map.remove(canisterId);
    canister_map.refresh();
    saveCanisters();
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fusion_wallet/common_widgets/futureImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:fusion_wallet/src/rust/api/wallet_service.dart';
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

  void load() {
    loadSavedTokens().then((_) {
      token_image_map.value = createTokenImageMap(tokens_map.values.toList());
      listen_wallet();
    });
  }
  void check_token_on_ic() {
     var icService = ic_service!;
    var address = active_wallet.value!.toIcpPrincipal();
     Future.wait(tokens_map.values.map((token) async {
        BigInt balance;
        double price;

        try {
          // here i get a int number(which is a floating point(actual price) * 100)
          final coinbasePrice = await icService.getPrice(token: token);

          price = coinbasePrice;

          // ignore: empty_catches
        } catch (err) {
          price = -1.0;
        }

        try {
          final icBalance =
              await icService.getBalance(token: token, account: address);
          balance = icBalance;

          // ignore: empty_catches
        } catch (e) {
          
          balance = BigInt.from(-1);
        }

        token_data_map[token.tokenAddress] =
            TokenData(balance: balance, price: price);
      })).then((_) {
        token_data_map.refresh();
      });
  }

  void start_balance_monitor() {
    check_token_on_ic();
    Timer.periodic(Duration(seconds: 15), (timer) {
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
    final tokenList = tokens_map.values
        .map((t) => t.toString())
        .toList();
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

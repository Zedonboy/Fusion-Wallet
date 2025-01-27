import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fusion_wallet/common_widgets/futureImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:fusion_wallet/src/rust/api/wallet_service.dart';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as encrypt;


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
      final base_64_iv = await storage.read(key: "key_iv");
      if (encryptedData == null || base_64_iv == null) {
        return null;
      }

      // Convert encryption key to required format
      final key = encrypt.Key.fromBase16(encryptionKey);
      final iv = encrypt.IV.fromBase64(base_64_iv);
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
    WalletContext.getInitialSupportedTokens().forEach((wallet) {
      tokens_map[wallet.tokenAddress] = wallet;
    });
    tokens_map.refresh();
    token_image_map.value = createTokenImageMap(tokens_map.values.toList());
    listen_wallet();
  }

  void start_balance_monitor() {
    var ic_service = this.ic_service!;
    var address = active_wallet.value!.toIcpPrincipal();

    Timer.periodic(Duration(seconds: 15), (timer) {
      print("Timer: Checking balance");
      Future.wait(tokens_map.values.map((token) async {
        var balance;
        var price;

        try {
          // here i get a int number(which is a floating point(actual price) * 100)
          final coinbase_price = await ic_service.getPrice(token: token);

          price = coinbase_price;

          // ignore: empty_catches
        } catch (err) {
          price = -1.0;
        }

        try {
          final ic_balance =
              await ic_service.getBalance(token: token, account: address);
              balance = ic_balance;

          // ignore: empty_catches
        } catch (e) {
          balance = BigInt.from(-1);
        }

        token_data_map[token.tokenAddress] = TokenData(
            balance:balance,
            price: price);
      })).then((_) {
        token_data_map.refresh();
      });
    });
  }

  void addToken(WalletToken token) {
    if (tokens_map.containsKey(token.tokenAddress)) return;

    final image_data = FutureAdaptiveImage(
      imageUrl: token.imageUrl ?? 'assets/images/usd.png',
      width: 40,
      height: 40,
      fit: BoxFit.contain,
    );
    token_image_map[token.tokenAddress] = image_data;

    // ignore: invalid_use_of_protected_member
    tokens_map.value[token.tokenAddress] = token;
    token_image_map.refresh();
  }
}

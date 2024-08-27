import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fusion_wallet/services/hardwareId.dart';
import 'package:fusion_wallet/services/sharedPrefs.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get_rx/get_rx.dart';
import '../constants/colors.dart';
import 'package:encrypt/encrypt.dart' as EncrptPackage;
import 'dart:async';

class AppController extends GetxController {
  var isDark = false.obs;
  var enabledBiometric = false.obs;
  var selectedTabIndex = 1.obs;
  var selectedTabIndex1 = 0.obs;
  var theme = false.obs;
  RxList<WalletToken> visible_tokens = RxList([]);
  Wallet? master_wallet;
  WalletContext? wallet_context;

  changeTheme() {
    if (isDark.value) {
      primaryBackgroundColor.value = Color(0xff101614);
      cardColor.value = Color(0xff131C1A);
      inputFieldBackgroundColor.value = Color(0xff131C1A);
      inputFieldTextColor.value = Color(0xffcccccc);
      headingColor.value = Color(0xffffffff);
      labelColor.value = Color(0xffcccccc);
      appShadow.value = [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0).withOpacity(0.35),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ];
      Get.changeThemeMode(ThemeMode.dark);
      Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
    } else {
      headingColor.value = Color(0xFF030319);
      primaryBackgroundColor.value = Color(0xFFFFFFFF);
      inputFieldBackgroundColor.value = Color(0xFFFAFAFA);
      inputFieldTextColor.value = Color(0xFF1B2023);
      cardColor.value = Color(0xFFFCFCFC);
      labelColor.value = Color(0xFF6A6A6A);
      appShadow.value = [
        BoxShadow(
          color: Color.fromRGBO(155, 155, 155, 15).withOpacity(0.15),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ];
    }
    Get.changeThemeMode(ThemeMode.light);
    Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
    print(primaryColor.value);
  }

  set_wallet_contexts(String sd) {
    var wc = WalletContext.fromSeedPhrase(phrase: sd);
    master_wallet = wc.createMasterWallet();
    wallet_context = wc;
  }

  reset_tokens_with_seed_phrase() async {
    if (wallet_context == null) return;
    visible_tokens.value = wallet_context!.getInitialSupportedTokens();
  }

  save_and_secure_biometric_login(String pass) async {
    final hardware_id_gen = HardwareIdGenerator();
    var id = await hardware_id_gen.generateHardwareId();
    var pref = SharedPref();
    if (id == null) {
      pref.saveBool("biometric", false);
      return;
    }
    var secure_storage = FlutterSecureStorage();
    final encrypted_data = encrypt_data(id, pass);
    secure_storage.write(
        key: "biometric_password", value: encrypted_data.base64);
  }

  start_token_update_timer() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      var future_list = visible_tokens.map((wallet_token) {
        return wallet_token.updateBalanceAndWorth();
      });

      Future.wait(future_list).then((bal_list) {
        visible_tokens.refresh();
      });
    });
  }

  save_and_secure_pass(String pass, String seed_phrase) async {
    final encrypted_sd = encrypt_data(pass, seed_phrase);
    var secure_storage = FlutterSecureStorage();
    final pass_hash = hashPassword(pass);
    await secure_storage.write(key: "seed_phrase", value: encrypted_sd.base64);
    await secure_storage.write(key: "hash_password", value: pass_hash);
  }

  static EncrptPackage.Encrypted encrypt_data(String key_data, String data) {
    final key = EncrptPackage.Key.fromUtf8(key_data);
    final iv = EncrptPackage.IV.fromLength(16);

    final encrypter = EncrptPackage.Encrypter(EncrptPackage.AES(key));

    final encrypted_sd = encrypter.encrypt(data, iv: iv);

    return encrypted_sd;
  }
}

String hashPassword(String password) {
  final bytes = utf8.encode(password); // Convert the string to bytes
  final digest = sha256.convert(bytes); // Create the hash
  return digest.toString();
}

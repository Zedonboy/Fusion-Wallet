import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/screens/sendScreens/sendScreen.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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

handle_uri_path (Uri uri) async {
  print("URI: $uri");
  switch (uri.path) {
    case "/send-screen":
      final token = uri.queryParameters["token"];
      final amount = uri.queryParameters["amount"];
      final recipient = uri.queryParameters["recipient"];
      if (token == null) {
        showToast("Invalid QR");
        return;
      }

      WalletToken? wallet_token;
      wallet_token = WalletContext.getAllSupportedTokens().firstWhereOrNull((element) => element.tokenAddress == token);
      wallet_token = await WalletContext.getToken(tokenAddr: token!);

      Get.to(() => SendScreen(token: wallet_token!,  amount: amount, recipient: recipient,));
      break;
    default:
      showToast("Invalid URI");
      break;
  }
}
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

String? wallet_id = null;

Object? get deferredPrompt => null;

void promptInstall() {}

void identity_sign_in() {}

void set dart_sign_in_success(void Function(String?)? callback) {}

void set dart_sign_in_error(void Function(String?)? callback) {}

Future<String?> fetch_wallet_info() async {
  return null;
}

Future<String?> provision_wallet() async {
  return null;
} 

Future<List<int>?> sign_delegation(List<int>? data) async {
  return null;
}

Future<List<int>?> get_wallet_root_public_key() async {
  return null;
}

Future<String?> get_deposit_address() async {
  return null;
}

class OnchainSignInScreen extends StatefulWidget {
  const OnchainSignInScreen({super.key});

  @override
  State<OnchainSignInScreen> createState() => _OnchainSignInScreenState();
}

class _OnchainSignInScreenState extends State<OnchainSignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

onchain_logout() async {
  return null;
}


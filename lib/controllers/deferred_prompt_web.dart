/*
 * Fusion Wallet - A non-custodial cryptocurrency wallet
 * Copyright (C) 2025 Fusion Wallet
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

// Only import and define deferredPrompt for web environment
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:fusion_wallet/common_widgets/bottomNavBar.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/screens/ProvisionScreen.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';


@JS()
external JSString? get wallet_id;

@JS()
external JSPromise logout();

@JS()
external set dart_sign_out_success(JSFunction? callback);


@JS()
external JSObject? get deferredPrompt;

@JS("promptInstall")
external void promptInstall();

@JS()
external JSPromise<JSAny?> identity_sign_in();

@JS()
external set dart_sign_in_success(JSFunction? callback);

@JS()
external set dart_sign_in_error(JSFunction? callback);

@JS()
external JSPromise<JSString?> fetch_wallet_info();

@JS()
external JSPromise<JSString?> provision_wallet();

@JS()
external JSPromise<JSUint8Array?> sign_delegation(JSUint8Array? data);

@JS()
external JSPromise<JSUint8Array?> get_wallet_root_public_key();

@JS()
external JSPromise<JSString?> get_deposit_address();

void onchain_logout() async {
  await logout().toDart;
}

final appController = Get.find<AppController>();

onchain_wallet_setup(JSString wallet_id) async {
  final session_key = OnChainWallet.generateSessionKey();
  final expiration =
      DateTime.now().add(Duration(hours: 3)).microsecondsSinceEpoch *
          1000; // to nanoseconds
  var delegation_params = OnChainWallet.getDelegationParams(
      sessionKey: session_key, expiration: BigInt.from(expiration));

  final signed_delegation =
      await sign_delegation(delegation_params.signable.toJS).toDart;

  if (signed_delegation == null) {
    Get.back();
    CommonWidgets().showErrorSnackbar('Error!', 'Error Signing Delegation');
    return;
  }

  delegation_params.signature = signed_delegation.toDart;

  final pub_key = await get_wallet_root_public_key().toDart;

  if (pub_key == null) {
    Get.back();
    CommonWidgets()
        .showErrorSnackbar('Error!', 'Error Getting Wallet Root Public Key');
    return;
  }

  final onchain_wallet = OnChainWallet.fromDelegation(
      delegationParams: delegation_params,
      sessionKey: session_key,
      fromKey: pub_key.toDart);

  final info_service =
      onchain_wallet.createIcService().createCanisterInfoService();
  final metric =
      await info_service.getCanisterStatus(canisterId: wallet_id.toDart);
  appController.onchain_wallet_canister_metric = metric;
  appController.addCanister(metric);

  appController.active_wallet.value = onchain_wallet;

  Get.offAll(() => BottomBar());
}

class OnchainSignInScreen extends StatefulWidget {
  const OnchainSignInScreen({super.key});

  @override
  State<OnchainSignInScreen> createState() => _OnchainSignInScreenState();
}

class _OnchainSignInScreenState extends State<OnchainSignInScreen> {
  var loading = false.obs;
  void onSignInSuccess() async {
    // TODO: implement onSignInSuccess
    print("Sign in success");
    // Get.to(() => ProvisionScreen());
    // return;
    try {
      loading.value = true;
      final wallet_id = await fetch_wallet_info().toDart;
      if (wallet_id == null) {
        Get.to(() => ProvisionScreen());
        return;
      }

      await onchain_wallet_setup(wallet_id);
    } catch (e) {
      CommonWidgets().showErrorSnackbar('Error!', e.toString());
      print(e);
    } finally {
      loading.value = false;
    }
  }

  void onSignOutSuccess() async {
    await Get.offAll(() => OnchainSignInScreen());
  }

  void onSignInError() {
    // TODO: implement onSignInError
    print("Sign in error");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final js_func = onSignInSuccess.toJS;
    final js_func_error = onSignInError.toJS;
    dart_sign_in_success = js_func;
    dart_sign_in_error = js_func_error;

    final js_func_logout = onSignOutSuccess.toJS;
    dart_sign_out_success = js_func_logout;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: primaryAltBackgroundColor.value,
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 100,
              ),
              Image.asset("assets/images/onchain_banner.png"),
              // SvgPicture.asset("assets/svg/banner.svg"),
              Column(
                children: [
                  BottomRectangularBtn(onTapFunc: () async {
                     try {
                          await identity_sign_in().toDart;
                        } catch (e) {
                          print(e);
                        }
                  }, btnTitle: 'Sign in with Internet Identity', isLoading: loading.value, isDisabled: loading.value,),
                  
                  SizedBox(height: 36),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

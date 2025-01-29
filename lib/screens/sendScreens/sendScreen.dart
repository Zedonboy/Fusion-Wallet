import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/common_widgets/RecentTransactions.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/extensions.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/screens/TokenCalculator.dart';
import 'package:fusion_wallet/screens/sendScreens/conformationScreen.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:fusion_wallet/src/rust/api/wallet_service.dart';
import 'package:get/get.dart';

// import '../codeScanner.dart';
class SendScreen extends StatefulWidget {
  WalletToken token;
  SendScreen({super.key, required this.token});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController amountC = TextEditingController();
  AppController appController = Get.find<AppController>();
  var isOpen = false.obs;
  var isLoading = true.obs;
  var addressError = ''.obs;
  var amountError = ''.obs;
  RxList<SimpleTransaction> txs = RxList.empty();

  void fetch_transactions() async {
    final icService = appController.ic_service;
    final addr = appController.active_wallet.value!.toIcpPrincipal();
    try {
      final nTxes = await icService?.getLatestTransactions(
          token: widget.token, accountAddr: addr);
      isLoading.value = false;
      txs.value = nTxes ?? [];
    } catch (err) {
      isLoading.value = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetch_transactions();
  }

  void showTokenCalculator() {
    Get.bottomSheet(
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      backgroundColor: primaryBackgroundColor.value,
      shape: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(32), topLeft: Radius.circular(32))),
      TokenCalculator(
        token: widget.token,
        tokenPrice:
            appController.token_data_map[widget.token.tokenAddress]?.price ??
                0.0,
      ),
    );
  }

  void verifyInputs() {
    // // Clear previous errors
    // Clear previous errors
    addressError.value = '';
    amountError.value = '';

    // Validate address
    String address = addressController.text.trim();
    if (address.isEmpty) {
      addressError.value = 'Address is required';
      showToast("Please enter a recipient address");
      return;
    }

    // Ensure address has correct format based on network
    if (widget.token.network == WalletTokenNetWork.internetComputer) {
      // ICP principal format check
      if (!WalletContext.verifyPrincipal(text: addressController.text.trim())) {
        addressError.value = 'Invalid ICP principal format';
        showToast("Invalid ICP principal format");
        return;
      }
    }

    // Validate amount
    if (amountC.text.isEmpty) {
      amountError.value = 'Amount is required';
      showToast("Please enter an amount");
      return;
    }

    try {
      double amount = double.parse(amountC.text);
      if (amount <= 0) {
        amountError.value = 'Amount must be greater than 0';
        showToast("Amount must be greater than 0");
        return;
      }

      // Get current balance and token decimals
      final tokenData = appController.token_data_map[widget.token.tokenAddress];
      if (tokenData == null) {
        showToast("Unable to load token data");
        return;
      }

      final balance = tokenData.balance;
      final decimals = widget.token.tokenDecimal ?? 8;

      // Convert input amount to smallest units for comparison
      final inputAmountBig = BigInt.from(amount * pow(10, decimals));

      // Check if amount + fee exceeds balance
      if (inputAmountBig + widget.token.transferFee > balance) {
        amountError.value = 'Insufficient balance (including transfer fee)';
        showToast("Insufficient balance including transfer fee");
        return;
      }

      // If all validations pass, proceed to confirmation
      Get.to(() => ConformationScreen(
            token: widget.token,
            to_addr: address,
            amount: amount,
          ));
    } catch (e) {
      amountError.value = 'Invalid amount format';
      showToast("Please enter a valid number");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: darkBlueColor.value,
                            size: 16,
                          )),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${getTranslated(context, "Send") ?? "Send"}  ${widget.token.symbol.toUpperCase()}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: darkBlueColor.value,
                          fontFamily: "dmsans",
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         Get.back();
                  //       },
                  //       child: Container(
                  //           height: 32,
                  //           width: 32,
                  //           padding: EdgeInsets.all(6),
                  //           decoration: BoxDecoration(
                  //               color: inputFieldBackgroundColor.value,
                  //               borderRadius: BorderRadius.circular(8)),
                  //           child: SvgPicture.asset(
                  //             "assets/svgs/mdi_contact-outline.svg",
                  //             color: headingColor.value,
                  //           )),
                  //     )
                  //   ],
                  // )
                ],
              ),
              SizedBox(
                height: 20,
              ),
// Token Logo
              Center(
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: inputFieldBackgroundColor.value,
                  ),
                  child:
                      appController.token_image_map[widget.token.tokenAddress],
                ),
              ),
              // SizedBox(height: 8),
// Balance Display
              Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: () {
                            final tokenData = appController
                                .token_data_map[widget.token.tokenAddress];
                            if (tokenData == null) return "---";
                            return normalizeBalance(tokenData.balance,
                                widget.token.tokenDecimal ?? 8);
                          }(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: appController.isDark.value == true
                                ? const Color(0xffFDFCFD)
                                : primaryAltColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                        TextSpan(
                          text: " ${widget.token.symbol}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: appController.isDark.value == true
                                ? const Color(0xffFDFCFD)
                                : primaryAltColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 8),
                  Text(
                    () {
                      final wToken = widget.token;

                      final tokenData =
                          appController.token_data_map[wToken.tokenAddress];
                      if (tokenData == null) return "---";
                      return calculateUsdWorth(tokenData.balance,
                          wToken.tokenDecimal ?? 8, tokenData.price);
                    }(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: lightAltTextColor.value,
                      fontFamily: "dmsans",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              InputFields2(
                textController: addressController,
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 21,
                      width: 46,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              tileMode: TileMode.clamp,
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                lightTextColor.value,
                                lightTextColor.value,
                              ]),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: InkWell(
                        onTap: () {
                          Clipboard.getData("text/plain").then((data) {
                            if (data == null) return;
                            addressController.text = data.text!;
                          });
                        },
                        child: Text(
                          getTranslated(context, "Paste") ?? "Paste",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: primaryBackgroundColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                      )),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                        onTap: () async {
                          try {
                            final scanner =
                                await FlutterBarcodeScanner.scanBarcode(
                                    lightColor.toHex(),
                                    "Cancel",
                                    false,
                                    ScanMode.QR);
                            addressController.text = scanner;
                          } catch (e) {
                            showToast("Error trying to scan");
                          }
                          // Get.to(CodeScanner1());
                        },
                        child: SvgPicture.asset("assets/svgs/qr.svg")),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                hasHeader: true,
                headerText: "Address",
                hintText: "Enter Address or Principal",
                onChange: (val) {
                  setState(() {});
                },
              ),
              if (addressError.isNotEmpty)
                CommonWidgets.showErrorMessage(addressError.value),
              SizedBox(
                height: 16,
              ),
              InputFields2(
                textController: amountC,
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: 21,
                        width: 46,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                tileMode: TileMode.clamp,
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: amountC.text == ""
                                    ? [
                                        lightTextColor.value,
                                        lightTextColor.value,
                                      ]
                                    : [
                                        Color(0xff76CF56),
                                        Color(0xff55DDAF),
                                      ]),
                            borderRadius: BorderRadius.circular(5)),
                        child: InkWell(
                          onTap: () {
                            final bigBal = appController
                                    .token_data_map[widget.token.tokenAddress]
                                    ?.balance ??
                                BigInt.zero;

                            amountC.text = normalizeBalance(
                                bigBal, widget.token.tokenDecimal ?? 8);
                          },
                          child: Center(
                            child: Text(
                              getTranslated(context, "MAX") ?? "MAX",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: primaryBackgroundColor.value,
                                fontFamily: "dmsans",
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                        onTap: () {
                          showTokenCalculator();
                          // Get.to(CodeScanner1());
                        },
                        child: SvgPicture.asset("assets/svgs/calculator.svg")),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                inputType: TextInputType.number,
                hasHeader: true,
                headerText: "Amount",
                hintText: "Enter Amount",
                onChange: (v) {
                  setState(() {});
                },
              ),
              if (amountError.isNotEmpty)
                CommonWidgets.showErrorMessage(amountError.value),
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, "Recent transfers") ?? "Recent transfers",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: headingColor.value,
                      fontFamily: "dmsans",
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        isOpen.value = !isOpen.value;
                      },
                      child: Icon(
                        isOpen.value == true
                            ? Icons.keyboard_arrow_up_sharp
                            : Icons.keyboard_arrow_down_sharp,
                        size: 27,
                        color: headingColor.value,
                      ))
                ],
              ),
              SizedBox(
                height: 12,
              ),
              isOpen == false
                  ? SizedBox()
                  : RecentTransfers(
                      isLoading: isLoading.value,
                      transfers: txs,
                    ),
              SizedBox(
                height: 24,
              ),
              BottomRectangularBtn(
                  onTapFunc: () {
                    verifyInputs();
                  },
                  btnTitle: "Next"),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

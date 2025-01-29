import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/controllers/extensions.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:fusion_wallet/src/rust/api/wallet.dart';
import 'package:get/get.dart';

class TokenCalculator extends StatefulWidget {
  var tokenPrice = 12.5;
  final WalletToken token;
  TokenCalculator({super.key, required this.token, this.tokenPrice = 0.0});

  @override
  State<TokenCalculator> createState() => _TokenCalculatorState();
}

class _TokenCalculatorState extends State<TokenCalculator> {
  TextEditingController topAmountController = TextEditingController();
  TextEditingController bottomAmountController = TextEditingController();
  AppController appController = Get.find<AppController>();
  var isUsdTop = false.obs;
  // final tokenPrice = 12.50; // Example price - replace with actual token price

  @override
  void initState() {
    super.initState();
    // Add listeners to controllers to handle real-time conversion
    topAmountController.addListener(() {
      if (topAmountController.text.isNotEmpty) {
        calculateConversion(true);
      } else {
        bottomAmountController.text = '';
      }
    });

    // bottomAmountController.addListener(() {
    //   if (!bottomAmountController.text.isEmpty) {
    //     calculateConversion(false);
    //   } else {
    //     topAmountController.text = '';
    //   }
    // });
  }

  void calculateConversion(bool isTop) {
    try {
      if (isTop) {
        double amount = double.parse(topAmountController.text);
        if (isUsdTop.value) {
          final result = (amount / widget.tokenPrice).toStringAsFixed(4);
          // Convert USD to Token
          bottomAmountController.text = removeTrailingZeros(result);
        } else {
          final result = (amount * widget.tokenPrice).toStringAsFixed(2);
          // Convert Token to USD
          bottomAmountController.text = removeTrailingZeros(result);
        }
        // } else {
        //   double amount = double.parse(bottomAmountController.text);
        //   if (isUsdTop.value) {
        //     // Convert Token to USD
        //     topAmountController.text = (amount * tokenPrice).toStringAsFixed(2);
        //   } else {
        //     // Convert USD to Token
        //     topAmountController.text = (amount / tokenPrice).toStringAsFixed(4);
        //   }
      }
    } catch (e) {
      print('Error in conversion: $e');
    }
  }

  Widget buildInputSection(bool isTop) {
    bool isUsd = isTop ? isUsdTop.value : !isUsdTop.value;
    var controller = isTop ? topAmountController : bottomAmountController;

    return Container(
      // height: 148,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: inputFieldBackgroundColor2.value,
          border: Border.all(width: 1, color: inputFieldBackgroundColor.value)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryBackgroundColor.value),
                    child: isUsd
                        ? Image.asset("assets/images/usd.png")
                        : appController
                            .token_image_map[widget.token.tokenAddress],
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isUsd ? "USD" : widget.token.symbol,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: headingColor.value,
                          fontFamily: "dmsans",
                        ),
                      ),
                      if (!isUsd)
                        Text(
                          "${getTranslated(context, "Available") ?? "Available"}: ${appController.token_data_map[widget.token.symbol]?.balance ?? "0"}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: lightTextColor.value,
                            fontFamily: "dmsans",
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          Divider(
              color: inputFieldBackgroundColor.value, height: 1, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: headingColor.value,
                    fontFamily: "dmsans",
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "0",
                    hintStyle: TextStyle(
                      color: headingColor.value.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              if (!isUsd)
                Container(
                  height: 24,
                  width: 50,
                  decoration: BoxDecoration(
                      color: lightTextColor.value,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text(
                      "Max",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffFFFFFF),
                        fontFamily: "dmsans",
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
              if (!isUsd)
                InkWell(
                  onTap: () {
                    final amt = topAmountController.text;
                    copyToClipboard(amt).then((value) =>
                        {showToast("Copied amount")});
                  },
                  child: Container(
                    height: 30,
                    width: 32,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: appController.isDark.value == true
                            ? Color(0xff1A2B56)
                            : inputFieldBackgroundColor.value,
                        borderRadius: BorderRadius.circular(8)),
                    child: SvgPicture.asset("assets/svgs/u_copy-landscape.svg",
                        color: appController.isDark.value == true
                            ? Color(0xffA2BBFF)
                            : headingColor.value),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      child: Column(
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Token Calculator",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: headingColor.value,
                  fontFamily: "dmsans",
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.clear, color: headingColor.value))
            ],
          ),
          SizedBox(height: 32),
          // Calculator content
          Obx(
            () => Stack(
              children: [
                SizedBox(
                  height: 320,
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildInputSection(true),
                      buildInputSection(false),
                    ],
                  ),
                ),
                Positioned.fill(
                    child: Center(
                  child: GestureDetector(
                    onTap: () {
                      isUsdTop.value = !isUsdTop.value;
                      // Swap the values
                      String temp = topAmountController.text;
                      topAmountController.text = bottomAmountController.text;
                      bottomAmountController.text = temp;
                    },
                    child: Container(
                      height: 42,
                      width: 42,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            Color(0xff55DDAF),
                            Color(0xff76CF56),
                          ])),
                      child: SvgPicture.asset("assets/svgs/convert.svg"),
                    ),
                  ),
                ))
              ],
            ),
          ),
          SizedBox(height: 32),
          // Price info
          Container(
            width: Get.width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: inputFieldBackgroundColor2.value,
                border: Border.all(
                    width: 1, color: inputFieldBackgroundColor.value)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "1 ${widget.token.symbol} = \$${widget.tokenPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: lightTextColor.value,
                    fontFamily: "dmsans",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    topAmountController.dispose();
    bottomAmountController.dispose();
    super.dispose();
  }
}

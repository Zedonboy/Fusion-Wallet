// import 'package:crypto_wallet/localization/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';

class BottomRectangularBtn extends StatelessWidget {
  BottomRectangularBtn(
      {super.key,
      required this.onTapFunc,
      required this.btnTitle,
      this.isDisabled = false,
      this.isFilled = false,
      this.isLoading = false,
      this.loadingText = '',
      this.onlyBorder = false,
      this.color,
      this.buttonTextColor,
      this.hasIcon,
      this.svgName,
      this.svgColor,
      this.hasDoubleBorder});
  final Function onTapFunc;
  final String btnTitle;
  final bool isDisabled;
  final bool isFilled;
  final bool isLoading;
  final String loadingText;
  final Color? color;
  final Color? buttonTextColor;
  final bool? onlyBorder;
  final bool? hasIcon;
  final bool? hasDoubleBorder;
  final String? svgName;
  final Color? svgColor;
  final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    print(color);
    return InkWell(
      onTap: () {
        if (isDisabled != true) {
          if (!isLoading == true) {
            onTapFunc.call();
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: onlyBorder == true
            ? BoxDecoration(
                border: Border.all(color: primaryAltColor.value),
                borderRadius: BorderRadius.circular(66))
            : BoxDecoration(
                color: color ??
                    (isDisabled
                        ? btnDisabledBg
                        : primaryAltColor.value),
                borderRadius: const BorderRadius.all(Radius.circular(66)),
              ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  height: 28.0,
                  width: 28.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    color:
                        onlyBorder == true ? primaryAltColor.value : Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              if (isLoading) const SizedBox(width: 14),
              Row(
                children: [
                  Text(
                    isLoading
                        ? loadingText
                        : getTranslated(context, btnTitle) ?? btnTitle,
                    style: TextStyle(
                      color: isDisabled
                          ? isLoading
                              ? textDarkColor.value
                              : textDarkColor.value
                          : buttonTextColor ??
                              (onlyBorder == true
                                  ? primaryAltColor.value
                                  : btnTitle == 'Send' ||
                                          btnTitle == 'Withdraw' ||
                                          btnTitle == 'Refund me'
                                      ? appController.isDark.value
                                          ? btnTxtColor
                                          : color == primaryAltColor.value ||
                                                  color == null
                                              ? btnTxtColor
                                              : primaryAltColor.value
                                      : btnTxtColor),
                      fontSize: 16,
                      fontFamily: 'dmsans',
                    ),
                  ),
                  if (hasIcon == true)
                    SizedBox(
                      width: 10,
                    ),
                  if (hasIcon == true)
                    SvgPicture.asset(
                      'assets/svgs/$svgName.svg',
                      color: svgColor,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

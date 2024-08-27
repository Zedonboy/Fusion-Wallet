import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';

class BottomRectangularBtn extends StatelessWidget {
  BottomRectangularBtn(
      {Key? key,
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
      this.hasDoubleBorder})
      : super(key: key);
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
        if (!isLoading == true) {
          onTapFunc.call();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: onlyBorder == true
            ? BoxDecoration(
                border: Border.all(color: primaryColor.value),
                borderRadius: BorderRadius.circular(10))
            : BoxDecoration(
                color: color != null
                    ? color
                    : isDisabled
                        ? color != null
                            ? color
                            : primaryColor.value
                        : primaryColor.value,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                        onlyBorder == true ? primaryColor.value : Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              if (isLoading) const SizedBox(width: 14),
              Row(
                children: [
                  if (hasIcon == true)
                    SvgPicture.asset(
                      'assets/svgs/$svgName.svg',
                      color: svgColor,
                    ),
                  if (hasIcon == true)
                    SizedBox(
                      width: 8,
                    ),
                  Text(
                    isLoading ? loadingText : "$btnTitle",
                    style: TextStyle(
                      color: isDisabled
                          ? Color(0xff9E9B9B)
                          : buttonTextColor != null
                              ? buttonTextColor
                              : onlyBorder == true
                                  ? primaryColor.value
                                  : btnTitle == 'Send' ||
                                          btnTitle == 'Withdraw' ||
                                          btnTitle == 'Refund me'
                                      ? appController.isDark.value
                                          ? btnTxtColor
                                          : color == primaryColor.value ||
                                                  color == null
                                              ? btnTxtColor
                                              : primaryColor.value
                                      : btnTxtColor,
                      fontSize: 16,
                      fontFamily: 'sfpro',
                    ),
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

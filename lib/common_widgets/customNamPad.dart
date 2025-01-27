import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:get/get.dart';

class CustomNumPad extends StatelessWidget {
  final double buttonSize;
  final TextEditingController controller;
  final Function() delete;
  final Function() onSubmit;
  final Function()? onBiometric;
  final int maxLength;

  const CustomNumPad({
    super.key,
    this.buttonSize = 60,
    required this.delete,
    required this.onSubmit,
    required this.controller,
    this.maxLength = 4,
    this.onBiometric
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [1, 2, 3]
                .map((number) => NumberButton(
                      number: number,
                      size: buttonSize,
                      color: primaryAltColor.value,
                      controller: controller,
                      maxLength: maxLength,
                      onMaxLength: onSubmit,
                    ))
                .toList(),
          ),
          SizedBox(height: Get.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [4, 5, 6]
                .map((number) => NumberButton(
                      number: number,
                      size: buttonSize,
                      color: primaryAltColor.value,
                      controller: controller,
                      maxLength: maxLength,
                      onMaxLength: onSubmit,
                    ))
                .toList(),
          ),
          SizedBox(height: Get.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [7, 8, 9]
                .map((number) => NumberButton(
                      number: number,
                      size: buttonSize,
                      color: primaryAltColor.value,
                      controller: controller,
                      maxLength: maxLength,
                      onMaxLength: onSubmit,
                    ))
                .toList(),
          ),
          SizedBox(height: Get.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Empty button
              SizedBox(
                height: Get.width * 0.1,
                width: Get.width * 0.1,
                child: InkWell(onTap: (){
                  onBiometric?.call();
                }, child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    "assets/images/Frame333.png",
                    color: primaryAltColor.value,
                    height: 20,
                    width: 20,
                  ),
                ))
              ),
              // Number 0
              NumberButton(
                number: 0,
                size: buttonSize,
                color: primaryAltColor.value,
                controller: controller,
                maxLength: maxLength,
                onMaxLength: onSubmit,
              ),
              // Delete button
              SizedBox(
                height: Get.width * 0.1,
                width: Get.width * 0.1,
                child: InkWell(
                  onTap: delete,
                  splashColor: Colors.transparent,
                  child: SizedBox(
                    height: Get.width * 0.1,
                    width: Get.width * 0.1,
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/svgs/jvcc.svg",
                        color: primaryAltColor.value,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final int number;
  final double size;
  final Color color;
  final TextEditingController controller;
  final int maxLength;
  final Function() onMaxLength;

  const NumberButton({
    super.key,
    required this.number,
    required this.size,
    required this.color,
    required this.controller,
    required this.maxLength,
    required this.onMaxLength,
  });

  void _handleNumberInput() {
    HapticFeedback.lightImpact();
    if (controller.text.length < maxLength) {
      controller.text += number.toString();
      if (controller.text.length == maxLength) {
        onMaxLength();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
        onPressed: _handleNumberInput,
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: primaryAltBgColor2,
            ),
          ),
        ),
      ),
    );
  }
}

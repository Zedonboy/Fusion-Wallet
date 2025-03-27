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
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:get/get.dart';

class InputFields2 extends StatefulWidget {
  String? hintText;
  String? headerText;

  bool? hasHeader;
  TextEditingController? textController;
  bool? isEditable = true;
  Widget? suffixIcon;
  Function? onChange;
  TextInputType? inputType;
  Image? icon;
  FocusNode? focusNode;
  bool? isFocused;
  int? maxLines;

  InputFields2(
      {super.key,
      this.headerText,
      this.maxLines,
      this.hintText,
      this.isFocused,
      this.focusNode,
      this.hasHeader,
      this.textController,
      this.isEditable,
      this.suffixIcon,
      this.inputType,
      this.icon,
      this.onChange});

  @override
  State<InputFields2> createState() => _InputFields2State();
}

class _InputFields2State extends State<InputFields2> {
  final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    var selected = false;

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.hasHeader == true)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Text(
                  getTranslated(context, widget.headerText ?? "") ??
                      widget.headerText ??
                      "",
                  style: TextStyle(
                    color: headingColor.value,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'dmsans',
                  ),
                ),
              ),
            // SizedBox(height: 12,),
            TextFormField(
              focusNode: widget.focusNode,
              cursorColor: primaryAltColor.value,
              cursorHeight: 20,
              controller: widget.textController,
              enabled: widget.isEditable,
              keyboardType: widget.inputType ?? TextInputType.text,
              maxLines: widget.maxLines ?? 1,
              // inputFormatters: [
              //   inputType == null
              //       ? LengthLimitingTextInputFormatter(
              //           headerText!.contains('Name') ? 18 : 50)
              //       : FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,10}'))
              // ],
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'dmsans',
                color: headingColor.value,
              ),
              decoration: InputDecoration(
                  prefixIcon: widget.icon == null
                      ? null
                      : SizedBox(
                          width: 30,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 17.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 18,
                                  child: widget.icon,
                                ),
                              ),
                            ],
                          ),
                        ),
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'dmsans',
                      color: lightAltTextColor.value
                      // color: appController.isDark.value ? labelColor.value : placeholderColor
                      ),
                  filled: true,
                  fillColor: inputFieldBackgroundColor2.value,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  hintText: getTranslated(context, widget.hintText ?? "") ??
                      widget.hintText ??
                      "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: inputFieldBackgroundColor.value, width: 1),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: inputFieldBackgroundColor.value, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: inputFieldBackgroundColor.value, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: darkBlueColor.value, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: widget.suffixIcon ?? SizedBox()),
              onChanged: (value) {
                widget.onChange!.call(value);
              },
            ),
          ],
        ));
  }
}

class InputFields extends StatefulWidget {
  String? hintText;
  String? headerText;

  bool? hasHeader;
  TextEditingController? textController;
  bool? isEditable = true;
  Widget? suffixIcon;
  Function? onChange;
  TextInputType? inputType;
  Widget? icon;
  FocusNode? focusNode;
  bool? isFocused;

  InputFields(
      {super.key,
      this.headerText,
      this.hintText,
      this.isFocused,
      this.focusNode,
      this.hasHeader,
      this.textController,
      this.isEditable,
      this.suffixIcon,
      this.inputType,
      this.icon,
      this.onChange});

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    var selected = false;

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.hasHeader == true)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Text(
                  getTranslated(context, "${widget.headerText}") ??
                      "${widget.headerText}",
                  style: TextStyle(
                    color: headingColor.value,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'dmsans',
                  ),
                ),
              ),
            // SizedBox(height: 12,),
            TextFormField(
              focusNode: widget.focusNode,
              cursorColor: primaryAltColor.value,
              cursorHeight: 20,
              controller: widget.textController,
              enabled: widget.isEditable,
              keyboardType: widget.inputType ?? TextInputType.text,
              // inputFormatters: [
              //   inputType == null
              //       ? LengthLimitingTextInputFormatter(
              //           headerText!.contains('Name') ? 18 : 50)
              //       : FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,10}'))
              // ],
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'dmsans',
                color: inputFieldBackgroundColor.value,
              ),
              decoration: InputDecoration(
                  prefixIcon: widget.icon == null
                      ? null
                      : SizedBox(
                          width: 30,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 17.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 18,
                                  child: widget.icon,
                                ),
                              ),
                            ],
                          ),
                        ),
                  hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'dmsans',
                      color: lightAltTextColor.value
                      // color: appController.isDark.value ? labelColor.value : placeholderColor
                      ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  hintText: getTranslated(context, "${widget.hintText}") ??
                      "${widget.hintText}",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: inputFieldBackgroundColor.value, width: 0.5),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: inputFieldBackgroundColor.value, width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: inputFieldBackgroundColor.value, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: darkBlueColor.value, width: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: widget.suffixIcon ?? SizedBox()),
              onChanged: (value) {
                widget.onChange?.call(value);
              },
            ),
          ],
        ));
  }
}

class InputFieldPassword extends StatefulWidget {
  String? headerText;
  String hintText;
  TextEditingController? textController;
  bool? isEditable = true;
  Function onChange;
  String? svg;
  Image? preffixImage;
  SvgPicture? suffiexImage;
  FocusNode? focusNode;

  InputFieldPassword({
    super.key,
    this.headerText,
    this.focusNode,
    required this.hintText,
    required this.textController,
    required this.onChange,
    this.isEditable,
    this.preffixImage,
    this.suffiexImage,
    this.svg,
  });

  @override
  State<InputFieldPassword> createState() => _InputFieldPasswordState();
}

class _InputFieldPasswordState extends State<InputFieldPassword> {
  bool _visible = true;
  final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Text(
            widget.headerText ?? "",
            style: TextStyle(
              color: headingColor.value,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'dmsans',
            ),
          ),
        ),
        Container(
          // height: 48,
          child: TextFormField(
            focusNode: widget.focusNode,
            cursorColor: primaryAltColor.value,
            cursorHeight: 20,
            controller: widget.textController,
            enabled: widget.isEditable,
            // keyboardType: widget.inputType ?? TextInputType.text,
            // inputFormatters: [
            //   inputType == null
            //       ? LengthLimitingTextInputFormatter(
            //           headerText!.contains('Name') ? 18 : 50)
            //       : FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,10}'))
            // ],
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'dmsans',
              color: headingColor.value,
            ),
            // controller: widget.textController,
            obscureText: _visible,
            decoration: InputDecoration(
              // prefixIcon: Container(
              //   width: 30,
              //   child: Row(
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.only(left: 11.0),
              //         child: Container(
              //           width: 20,
              //           height: 18,
              //           child: widget.icon,
              //         ),
              //       ),
              //       SizedBox(
              //         width: 8,
              //       ),
              //       Container(
              //         color: lightTextColor.value,
              //         width: 1,
              //         height: 24,
              //       )
              //     ],
              //   ),
              // ),
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'dmsans',
                  color: lightAltTextColor.value
                  // color: appController.isDark.value ? labelColor.value : placeholderColor
                  ),
              filled: true,
              fillColor: inputFieldBackgroundColor2.value,

              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: inputFieldBackgroundColor.value, width: 1),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: inputFieldBackgroundColor.value, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: inputFieldBackgroundColor.value, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: darkBlueColor.value, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _visible = !_visible;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 20,
                    height: 20,
                    child: _visible == true
                        ? SvgPicture.asset("assets/svgs/iconoir_eye.svg")
                        : SvgPicture.asset("assets/svgs/iconoir_eye.svg"),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// TextStyle defaultBtnStyle = new TextStyle(
//     color: btnTxtColor, fontSize: 18, fontFamily: 'dmsans');

class InputFieldsWithSeparateIcon extends StatefulWidget {
  String headerText;
  String hintText;
  bool hasHeader;
  TextEditingController? textController;
  bool? isEditable = true;
  Widget? suffixIcon;
  Function? onChange;
  String? svg;
  TextInputType? inputType;
  FocusNode? focusNode;

  InputFieldsWithSeparateIcon(
      {super.key,
      required this.headerText,
      required this.hintText,
      required this.hasHeader,
      this.textController,
      this.focusNode,
      this.isEditable,
      this.suffixIcon,
      this.svg,
      this.inputType,
      required this.onChange});

  @override
  State<InputFieldsWithSeparateIcon> createState() =>
      _InputFieldsWithSeparateIconState();
}

class _InputFieldsWithSeparateIconState
    extends State<InputFieldsWithSeparateIcon> {
  final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.hasHeader == true)
          Container(
            margin: const EdgeInsets.only(
              bottom: 12,
            ),
            child: Text(
              widget.headerText,
              style: TextStyle(
                color: headingColor.value,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'dmsans',
              ),
            ),
          ),
        SizedBox(
          width: Get.width * 0.95,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 56,
                decoration: BoxDecoration(
                  color: appController.isDark.value == true
                      ? inputFieldBackgroundColor2.value
                      : inputFieldBackgroundColor2.value,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16)),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svgs/${widget.svg}.svg',
                    color: headingColor.value,
                  ),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: TextFormField(
                  focusNode: widget.focusNode,
                  cursorColor: primaryAltColor.value,
                  cursorHeight: 20,
                  controller: widget.textController,
                  enabled: widget.isEditable,
                  keyboardType: widget.inputType ?? TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        widget.headerText.contains('Name') ? 12 : 40),
                  ],
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'dmsans',
                      color: headingColor.value),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'dmsans',
                          color: lightAltTextColor.value

                          // color: appController.isDark.value ? labelColor.value : placeholderColor
                          ),
                      filled: true,
                      fillColor: inputFieldBackgroundColor2.value,
                      hintText: widget.hintText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16)),
                        borderSide: BorderSide(
                            color: inputFieldBackgroundColor2.value,
                            width: 0.1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide: BorderSide(
                            color: inputFieldBackgroundColor.value, width: 0.1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide: BorderSide(
                            color: inputFieldBackgroundColor.value, width: 0.1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: inputFieldBackgroundColor.value, width: 0.1),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                      ),
                      suffixIcon: widget.suffixIcon ?? SizedBox()),
                  onChanged: (value) {
                    widget.onChange!.call();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

RegExp lowerCase = RegExp(r"(?=.*[a-z])\w+");
RegExp upperCase = RegExp(r"(?=.*[A-Z])\w+");
RegExp containsNumber = RegExp(r"(?=.*?[0-9])");
RegExp hasSpecialCharacters =
    RegExp(r"[ !@#$%^&*()_+\-=\[\]{};':" "\\|,.<>/?]");

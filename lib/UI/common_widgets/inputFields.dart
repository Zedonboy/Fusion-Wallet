import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controllers/appController.dart';
import '../../constants/colors.dart';

class InputFields extends StatelessWidget {
  final appController = Get.find<AppController>();
  final String headerText;
  final String hintText;
  final bool hasHeader;
  final TextEditingController? textController;
  final bool? isEditable;
  final Widget? suffixIcon;
  final Function? onChange;
  final TextInputType? inputType;

  InputFields(
      {Key? key,
      required this.headerText,
      required this.hintText,
      required this.hasHeader,
      this.textController,
      this.isEditable,
      this.suffixIcon,
      this.inputType,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(),
          child: Text(
            headerText,
            style: TextStyle(
              color: placeholderColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'sfpro',
            ),
          ),
        ),
        TextField(
          cursorColor: primaryColor.value,
          cursorHeight: 20,
          controller: textController,
          enabled: isEditable,
          keyboardType: inputType ?? TextInputType.text,
          inputFormatters: [
            inputType == null
                ? LengthLimitingTextInputFormatter(
                    headerText.contains('Name') ? 18 : 50)
                : FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,10}'))
          ],
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'sfpro',
              color: inputFieldTextColor.value),
          decoration: InputDecoration(
              hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: 'sfpro',
                  color: appController.isDark.value
                      ? labelColor.value
                      : placeholderColor),
              filled: true,
              fillColor: inputFieldBackgroundColor.value,
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: cardColor.value, width: 0.1),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: cardColor.value, width: 0.1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: cardColor.value, width: 0.1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: cardColor.value, width: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: suffixIcon != null ? suffixIcon : SizedBox()),
          onChanged: (value) {
            onChange!.call(value);
          },
        ),
      ],
    );
  }
}

class InputFieldPassword extends StatefulWidget {
  final String headerText;
  final String hintText;
  final TextEditingController? textController;
  final bool? isEditable;
  final Function onChange;
  final String? svg;

  InputFieldPassword({
    Key? key,
    required this.headerText,
    required this.hintText,
    required this.textController,
    required this.onChange,
    this.isEditable,
    this.svg,
  }) : super(key: key);

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
          margin: const EdgeInsets.only(
            bottom: 10,
          ),
          child: Text(
            widget.headerText,
            style: TextStyle(
              color: headingColor.value,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'sfpro',
            ),
          ),
        ),
        Container(
          width: Get.width * 0.95,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 58,
                decoration: BoxDecoration(
                  color: inputFieldBackgroundColor.value,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
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
                child: TextField(
                  cursorColor: primaryColor.value,
                  cursorHeight: 20,
                  enabled: widget.isEditable,
                  onChanged: (val) {
                    widget.onChange.call();
                  },
                  style: TextStyle(color: inputFieldTextColor.value),
                  controller: widget.textController,
                  obscureText: _visible,
                  decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'sfpro',
                          color: placeholderColor),
                      filled: true,
                      //<-- SEE HERE
                      fillColor: inputFieldBackgroundColor.value,
                      //focusColor: activeInputColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide:
                            BorderSide(color: cardColor.value, width: 0.1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide:
                            BorderSide(color: cardColor.value, width: 0.1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide:
                            BorderSide(color: cardColor.value, width: 0.1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: cardColor.value, width: 0.1),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                              _visible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: primaryColor.value),
                          onPressed: () {
                            setState(() {
                              _visible = !_visible;
                            });
                          })),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

TextStyle defaultBtnStyle =
    new TextStyle(color: btnTxtColor, fontSize: 18, fontFamily: 'sfpro');

class InputFieldsWithSeparateIcon extends StatelessWidget {
  final appController = Get.find<AppController>();
  final String headerText;
  final String hintText;
  final bool hasHeader;
  final TextEditingController? textController;
  final bool? isEditable;
  final Widget? suffixIcon;
  final Function? onChange;
  final String? svg;
  final TextInputType? inputType;

  InputFieldsWithSeparateIcon(
      {Key? key,
      required this.headerText,
      required this.hintText,
      required this.hasHeader,
      this.textController,
      this.isEditable,
      this.suffixIcon,
      this.svg,
      this.inputType,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            bottom: 10,
          ),
          child: Text(
            headerText,
            style: TextStyle(
              color: headingColor.value,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'sfpro',
            ),
          ),
        ),
        Container(
          width: Get.width * 0.95,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 58,
                decoration: BoxDecoration(
                  color: inputFieldBackgroundColor.value,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svgs/$svg.svg',
                    color: headingColor.value,
                  ),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: TextField(
                  cursorColor: primaryColor.value,
                  cursorHeight: 20,
                  controller: textController,
                  enabled: isEditable,
                  keyboardType: inputType ?? TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        headerText.contains('Name') ? 12 : 40),
                  ],
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'sfpro',
                      color: inputFieldTextColor.value),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'sfpro',
                          color: appController.isDark.value
                              ? labelColor.value
                              : placeholderColor),
                      filled: true,
                      fillColor: inputFieldBackgroundColor.value,
                      hintText: hintText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide:
                            BorderSide(color: cardColor.value, width: 0.1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide:
                            BorderSide(color: cardColor.value, width: 0.1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        borderSide:
                            BorderSide(color: cardColor.value, width: 0.1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: cardColor.value, width: 0.1),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                      ),
                      suffixIcon: suffixIcon != null ? suffixIcon : SizedBox()),
                  onChanged: (value) {
                    onChange!.call();
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

RegExp lowerCase = new RegExp(r"(?=.*[a-z])\w+");
RegExp upperCase = new RegExp(r"(?=.*[A-Z])\w+");
RegExp containsNumber = new RegExp(r"(?=.*?[0-9])");
RegExp hasSpecialCharacters =
    new RegExp(r"[ !@#$%^&*()_+\-=\[\]{};':" "\\|,.<>\/?]");

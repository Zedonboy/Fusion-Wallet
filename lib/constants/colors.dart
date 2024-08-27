import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

var primaryColor = Color(0xff27C19F).obs;
var primaryBackgroundColor = Color(0xFFFFFFFF).obs;
var primaryColorDull = Color(0xFF0C9D7D).obs;
var dividerColor = Color(0xFFF2F2F2).obs;
Color nonActiveInputColor = const Color(0xFFEDEDED);
Color activeInputColor = const Color(0xFFFCFCFC);
Color activeInputBorderColor = const Color(0xFF03314B);
Color nonActiveInputBorderColor = Colors.transparent;
Color filledInputColor = const Color(0xFFEDEDED);
var headingColor = const Color(0xFF030319).obs;
var labelColor = Color(0xFF8F92A1).obs;
var dashLabelColor = Color(0xFFB4B6DB).obs;
var dashBtnColor = Color(0xFF292E9A).obs;
Color placeholderColor = Color(0xff8F92A1);
var inputFieldTextColor = Color(0xFF0F001C).obs;
var inputFieldBackgroundColor = Color(0xFFFAFAFA).obs;
var listCardColor = Color(0xFFFAFAFA).obs;

var appBarColor = Color(0xff462D81).obs;

Color btnTxtColor = const Color(0xFFFCFCFC);
Color errorTxtColor = const Color(0xFFFF0E41);
Color lightColor = const Color(0xFFFCFCFC);
var cardColor = Color(0xFFFFFFFF).obs;
var greenCardColor = Color(0xFF39B171).obs;
var redCardColor = Color(0xFFF16464).obs;
var chipChoiceColor = Color(0xFF27C19F).withOpacity(0.1);
var bSheetbtnColor = Color(0x0D27C19F).withOpacity(0.10);

///////////history screen colors//////////////
var bgCintainerColor = Color(0xff27C19F);
var bg2CintainerColor = Color(0xffFED5D5);
var iconUpColor = Color(0xffE34446);

var iconDownColor = Color(0xff0C9D7D);

//////////////history/////////

var appShadow = [
  BoxShadow(
    color: Color.fromRGBO(155, 155, 155, 15).withOpacity(0.15),
    spreadRadius: 5,
    blurRadius: 7,
    offset: Offset(0, 3), // changes position of shadow
  ),
].obs;

var homeCardBgShadow = [
  BoxShadow(
    color: Color(0x00000000),
    offset: Offset(0.0, 4.0),
    blurRadius: 20.0,
  ),
].obs;

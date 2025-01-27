import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

var primaryColor2 = Color(0xff1A2B56).obs; //changes
var primaryColor = Color(0xff5C87FF).obs; //changes
var primaryBackgroundColor = Color(0xff09080C).obs; //changed
var primaryAltBgColor2 = Color(0xff242438);
var primaryAltBackgroundColor =  Color(0xff242438).obs;
var inputFieldBackgroundColor = Color(0xff6C7CA7).obs; //changes
var inputFieldBackgroundColor2 = Color(0xff1A1930).obs;
var blueCard1 = Color(0xffFDFCFD).obs; //changed
var btnDisabledBg = Colors.grey[800];

var lightTextColor = Color(0xff6C7CA7).obs; //changed
var headingColor = Color(0xFFFDFCFD).obs; //changed
var greenColor = Color(0xff76CF56).obs;
var darkBlueColor = Color(0xffFDFCFD).obs;
var redColor = Color(0xffFF5C5C).obs;

var lightColor = const Color(0xFFFCFCFC);
var btnTxtColor = const Color(0xFF101212);
var greenCardColor = Color(0xFF39B171).obs;
var redCardColor = Color(0xFFF16464).obs;

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

var primaryAltColor = Color(0xff6366FF).obs;
var primaryColorIcon = Color(0xff57C69C).obs;
var cardcolor = Color(0xff1C1924).obs;

var hintColor = Color(0xffE1E1E1).obs;
// var primaryAltBackgroundColor = Color(0xff09080C).obs;
var textFieldTextColor = Color(0xff4B4B4B).obs;
var borderColor = Color(0xffE1E1E1).obs;
var lightAltTextColor = Color(0xFFFDFCFD).obs;
var labelColor = Color(0xff4B4B4B).obs;
var labelColorPrimaryShade = Color(0xFF6C7CA7).obs;
var subtextColor = Color(0xFF6C7CA6).obs;
var shapeDecorationColor = Color(0xFF2F2A3C).obs;
var shapeDecorationDarkColor = Color(0xFF131118).obs;
var textDarkColor = Color(0xFF101212).obs;
// var greenColor = Color(0xFF56CDAD).obs;
// var redColor = Color(0xFFFF5C5C).obs;

// primaryColor2.value = Color(0xff1A2B56); //changes
//       primaryAltColor.value = Color(0xff5C87FF); //changes
//       primaryAltBackgroundColor.value = Color(0xFF100F1C); //changed
//       inputFieldBackgroundColor.value = Color(0xff242438); //changes
//       inputFieldBackgroundColor2.value = Color(0xff1A1930);
//       blueCard1.value = Color(0xffFDFCFD); //changed

//       lightAltTextColor.value = Color(0xff6C7CA7); //changed
//       headingColor.value = Color(0xFFFDFCFD); //changed
//       greenColor.value = Color(0xff76CF56);
//       darkBlueColor.value = Color(0xffFDFCFD);
//       redColor.value = Color(0xffFF5C5C);

//       lightColor = const Color(0xFFFCFCFC);
//       btnTxtColor = const Color(0xFFFCFCFC);
//       greenCardColor.value = Color(0xFF39B171);
//       redCardColor.value = Color(0xFFF16464);

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/constants/colors.dart';
import 'package:fusion_wallet/controllers/appController.dart';
import 'package:fusion_wallet/localization/language_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  List coins=[
    {
      "image":"assets/images/usd.png",
      "symbol":"USD",
      "price1":"\$1,571.45",
      "price2":"\$1,571.45",
      "percentage":"8.75%",
      "chain":""
    },
    {
      "image":"assets/images/eur.png",
      "symbol":"EUR",
      "price1":"\$1,571.45",
      "price2":"\$1,571.45",
      "percentage":"8.75%",
      "chain":""
    },
    {
      "image":"assets/images/ngn.png",
      "symbol":"NGN",
      "price1":"\$1,571.45",
      "price2":"\$1,571.45",
      "percentage":"8.75%",
      "chain":""
    },
    {
      "image":"assets/images/usd.png",
      "symbol":"USD",
      "price1":"\$1,571.45",
      "price2":"\$1,571.45",
      "percentage":"8.75%",
      "chain":""
    },
    {
      "image":"assets/images/eth.png",
      "symbol":"ETH",
      "price1":"\$1,571.45",
      "price2":"\$1,571.45",
      "percentage":"8.75%",
      "chain":""
    },
    {
      "image":"assets/images/bttc.png",
      "symbol":"BTC",
      "price1":"\$1,571.45",
      "price2":"\$1,571.45",
      "percentage":"8.75%",
      "chain":""
    },
    {
      "image":"assets/images/usdt.png",
      "symbol":"USD",
      "price1":"\$1,571.45",
      "price2":"\$1,571.45",
      "percentage":"8.75%",
      "chain":"bnb"
    },
    {
      "image":"assets/images/usd.png",
      "symbol":"USD",
      "price1":"\$1,571.45",
      "price2":"\$1,571.45",
      "percentage":"8.75%",
      "chain":""
    },
    {
      "image":"assets/images/usd.png",
      "symbol":"USD",
      "price1":"\$1,571.45",
      "price2":"\$1,571.45",
      "percentage":"8.75%",
      "chain":""
    },

  ];
  List fiat=[
    {
      "image":"assets/images/Ellipse 26.png",
      "symbol":"USD",

    },
    {
      "image":"assets/images/Ellipse 26 (1).png",
      "symbol":"GBP",

    },
    {
      "image":"assets/images/Ellipse 28.png",
      "symbol":"AUD",

    },


  ];
  AppController appController = Get.find<AppController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22,vertical: 20),
          child: Column(
            children: [
              Row(
                children: [

                  Text(
                    "${getTranslated(context,"Swap Tokens" )??"Swap Tokens"}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: darkBlueColor.value,
                      fontFamily: "dmsans",

                    ),

                  ),
                ],
              ),
              SizedBox(height: 16,),
            Expanded(
              child: ListView(children: [


              
              
              
              
              
              
                Stack(
                  children: [
                    Container(
                      height: 320,
                      width: Get.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 148,
                            width: Get.width,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: inputFieldBackgroundColor2.value,
                                border: Border.all(width: 1,color: inputFieldBackgroundColor.value)
                            ),
                            child:Column(
                              children: [
                                InkWell(
                                  onTap:(){
                                    Get.bottomSheet(
                                        clipBehavior: Clip.antiAlias,
                                        isScrollControlled: true,
                                        backgroundColor: primaryBackgroundColor.value,
                                        shape: OutlineInputBorder(
                                            borderSide: BorderSide.none, borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                                        selectToken());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primaryBackgroundColor.value
                                            ),
                                            child: Image.asset("assets/images/eth.png"),
                                          ),
                                          SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "ETH",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: headingColor.value,
                                                  fontFamily: "dmsans",

                                                ),

                                              ),
                                              Text(
                                                "${getTranslated(context,"Available" )??"Available"}: 12",
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

                                      Icon(Icons.keyboard_arrow_down_outlined,color: headingColor.value,size: 25,)
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Divider(color: inputFieldBackgroundColor.value,height: 1,thickness: 1,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "0",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700,
                                        color: headingColor.value,
                                        fontFamily: "dmsans",
              
                                      ),
              
                                    ),
                                    Container(
                                      height: 24,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: lightTextColor.value,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child:  Center(
                                        child: Text(
                                          "MAX",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xffFFFFFF),
                                            fontFamily: "dmsans",
              
                                          ),
              
                                        ),
                                      ),
                                    )
              
                                  ],
                                ),
              
              
                              ],
                            ),
                          ),
                          Container(
                            height: 148,
                            width: Get.width,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: inputFieldBackgroundColor2.value,
                                border: Border.all(width: 1,color: inputFieldBackgroundColor.value)
                            ),
                            child:Column(
                              children: [
                                InkWell(
                                  onTap:(){
                                    Get.bottomSheet(
                                        clipBehavior: Clip.antiAlias,
                                        isScrollControlled: true,
                                        backgroundColor: primaryBackgroundColor.value,
                                        shape: OutlineInputBorder(
                                            borderSide: BorderSide.none, borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                                        selectToken());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primaryBackgroundColor.value
                                            ),
                                            child: Image.asset("assets/images/bttc.png"),
                                          ),
                                          SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "BTC",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: headingColor.value,
                                                  fontFamily: "dmsans",

                                                ),

                                              ),
                                              Text(
                                                "${getTranslated(context,"Available" )??"Available"}: 12",
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

                                      Icon(Icons.keyboard_arrow_down_outlined,color: headingColor.value,size: 25,)
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Divider(color: inputFieldBackgroundColor.value,height: 1,thickness: 1,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "0",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700,
                                        color: headingColor.value,
                                        fontFamily: "dmsans",
              
                                      ),
              
                                    ),
                                    Text(
                                      "\$0.00",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: lightTextColor.value,
                                        fontFamily: "dmsans",
              
                                      ),
              
                                    )
              
                                  ],
                                ),
              
              
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(child: Center(
                      child: Container(
                        height: 42,
                        width: 42,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xff55DDAF),
                                  Color(0xff76CF56),
              
              
                                ]
                            )
              
                        ),
                        child: SvgPicture.asset("assets/svgs/convert.svg"),
                      ),
                    ))
                  ],
                ),
                SizedBox(height: 32,),
              
              
                Container(
                  // height: 148,
                  width: Get.width,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: inputFieldBackgroundColor2.value,
                      border: Border.all(width: 1,color: inputFieldBackgroundColor.value)
                  ),
                  child:Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
              
              
                              Text(
                                "${getTranslated(context,"Swap Details" )??"Swap Details"}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: headingColor.value,
                                  fontFamily: "dmsans",
              
                                ),
              
                              )
                            ],
                          ),
              
                          Icon(Icons.keyboard_arrow_up_outlined,color: headingColor.value,size: 25,)
                        ],
                      ),
                      SizedBox(height: 15,),
                      Divider(color: inputFieldBackgroundColor.value,height: 1,thickness: 1,),
                      SizedBox(height: 15,),
              
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${getTranslated(context,"Routing Fee" )??"Routing Fee"} ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: headingColor.value,
                                  fontFamily: "dmsans",
              
                                ),
              
                              ),
                              SvgPicture.asset("assets/svgs/Question.svg")
                            ],
                          ),
                          Text(
                            "0",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: headingColor.value,
                              fontFamily: "dmsans",
              
                            ),
              
                          )
              
                        ],
                      ),
                      SizedBox(height: 15,),
              
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${getTranslated(context,"Slippage Tolerance" )??"Slippage Tolerance"}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: headingColor.value,
                              fontFamily: "dmsans",
              
                            ),
              
                          ),
                          Row(
                            children: [
                              Text(
                                "0.1%",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: headingColor.value,
                                  fontFamily: "dmsans",
              
                                ),
              
                              ),
                              SizedBox(width:7,),
                              SvgPicture.asset("assets/svgs/mingcute_settings-6-line.svg")
                            ],
                          )
              
                        ],
                      ),
              
              
                    ],
                  ),
                ),
              ],),
            ),
              Column(
                children: [
                  SizedBox(height: 24,),
                  BottomRectangularBtn(onTapFunc: (){
                    Get.bottomSheet(
                        clipBehavior: Clip.antiAlias,
                        isScrollControlled: true,
                        backgroundColor: primaryBackgroundColor.value,
                        shape: OutlineInputBorder(
                            borderSide: BorderSide.none, borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                        confirmSwap());
                  }, btnTitle: "Swap"),
                ],
              )










            ],
          ),
        ),
      ),
    );
  }
  Widget selectToken(){
    return Container(
       height: Get.height*0.9,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 22,vertical: 22),
      color:appController.isDark.value==true ?Color(0xff1A1930):inputFieldBackgroundColor.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose Token",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: headingColor.value,
                  fontFamily: "dmsans",

                ),
              ),
              GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(Icons.clear,color: headingColor.value,))



            ],
          ),
          SizedBox(height: 16,),
Expanded(
  child: ListView(
    children: [
  
      InputFields(
        icon:Image.asset("assets/images/Search.png"),
  
  
      ),
      SizedBox(height: 16,),
  
  
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 23,
            width: 113,
            decoration: BoxDecoration(
                color:appController.isDark.value==true ?Color(0xff1A2B56): inputFieldBackgroundColor2.value,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(width: 1,color: inputFieldBackgroundColor.value)
  
            ),
            child:   Center(
              child: Text(
                "Fiat Currencies",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: headingColor.value,
                  fontFamily: "dmsans",
  
                ),
  
              ),
            ),
          ),
          Divider(color: inputFieldBackgroundColor.value,height: 1,thickness: 2,),
  
        ],
      ),
      SizedBox(height: 16,),
      ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
  
        itemCount:fiat.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 12,);
        },
        itemBuilder: (BuildContext context, int index) {
          return  GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Container(
              height:60,
              width: Get.width,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: inputFieldBackgroundColor2.value,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1,color: inputFieldBackgroundColor.value)
              ),
              child: Row(
                children: [
                  Container(
                      height:32,
                      width: 32,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle
                      ),
                      child: Image.asset("${fiat[index]['image']}",height: 40,width: 40,)),
  
                  SizedBox(width: 12,),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
  
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
  
                                    Text(
                                      "${fiat[index]['symbol']}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color:appController.isDark.value==true?Color(0xffFDFCFD):  primaryColor.value,
                                        fontFamily: "dmsans",
  
                                      ),
  
                                    ),
  

  
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
  
                                    Text(
                                      "Bank Transfer",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: lightTextColor.value,
                                        fontFamily: "dmsans",
  
                                      ),
  
                                    ),
  

  
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,color: headingColor.value,size: 17,)
  
                      ],
                    ),
                  )
  
                ],
              ),
            ),
          );
        },
      ),
      SizedBox(height: 16,),
  
  
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 23,
            width: 113,
            decoration: BoxDecoration(
                color:appController.isDark.value==true ?Color(0xff1A2B56):  inputFieldBackgroundColor2.value,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(width: 1,color: inputFieldBackgroundColor.value)
  
            ),
            child:   Center(
              child: Text(
                "Crypto Currencies",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: headingColor.value,
                  fontFamily: "dmsans",
  
                ),
  
              ),
            ),
          ),
          Divider(color: inputFieldBackgroundColor.value,height: 1,thickness: 2,),
  
        ],
      ),
      SizedBox(height: 24,),
      ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
  
        itemCount: coins.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 12,);
        },
        itemBuilder: (BuildContext context, int index) {
          return  GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Container(
               height:60,
              width: Get.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: inputFieldBackgroundColor2.value,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1,color: inputFieldBackgroundColor.value)
              ),
              child: Row(
                children: [
                  Container(
                      height:32,
                      width: 32,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle
                      ),
                      child: Image.asset("${coins[index]['image']}",height: 40,width: 40,)),
  
                  SizedBox(width: 12,),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
  
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
  
                                    Text(
                                      "${coins[index]['symbol']}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color:appController.isDark.value==true?Color(0xffFDFCFD):  primaryColor.value,
                                        fontFamily: "dmsans",
  
                                      ),
  
                                    ),
  
                                    Text(
                                      "21",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color:appController.isDark.value==true?Color(0xffFDFCFD):  primaryColor.value,
                                        fontFamily: "dmsans",
  
                                      ),
  
                                    ),
  
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
  
                                    Text(
                                      "Bitcoin",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: lightTextColor.value,
                                        fontFamily: "dmsans",
  
                                      ),
  
                                    ),
  
                                    Text(
                                      "\$46448.00",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: lightTextColor.value,
                                        fontFamily: "dmsans",
  
                                      ),
  
                                    ),
  
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
  
                      ],
                    ),
                  )
  
                ],
              ),
            ),
          );
        },
      ),
    ],
  ),
),
          // SizedBox(height: 16,),







        ],
      ),
    );
  }
  Widget confirmSwap(){
    return Container(
      // height: 520,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 22,vertical: 22),
      color: inputFieldBackgroundColor.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(

            height: 162,
            width: Get.width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: inputFieldBackgroundColor2.value,
              borderRadius: BorderRadius.circular(16)
            ),
            child: Column(

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${getTranslated(context,"You Pay" )??"You Pay"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",

                      ),
                    ),
                    Text(
                      "${getTranslated(context,"You Get" )??"You Get"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",

                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      children: [
                        Text(
                          "0.68612",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",

                          ),
                        ),
                        SizedBox(width: 7,),

                        Text(
                          "SOL",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: lightTextColor.value,
                            fontFamily: "dmsans",

                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "0.68612",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",

                          ),
                        ),
                        SizedBox(width: 7,),
                        Text(
                          "ETH",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: lightTextColor.value,
                            fontFamily: "dmsans",

                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "(≈\$0.07)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",

                      ),
                    ),
                    Text(
                      "(≈\$0.07)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",

                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10,),

                Divider(color: inputFieldBackgroundColor.value,height: 1,thickness: 2,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${getTranslated(context,"From" )??"From"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",

                      ),
                    ),
                    Text(
                      "${getTranslated(context,"To" )??"To"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",

                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: inputFieldBackgroundColor.value,
                            shape: BoxShape.circle
                          ),
                          child: Image.asset("assets/images/eth.png"),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          "Ethereum",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",

                          ),
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                              color: inputFieldBackgroundColor.value,
                              shape: BoxShape.circle
                          ),
                          child: Image.asset("assets/images/matic.png"),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          "Matic",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",

                          ),
                        ),

                      ],
                    ),
                  ],
                )


              ],
            ),
          ),
          SizedBox(height: 16,),
          Container(

            // height:70,
            width: Get.width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: inputFieldBackgroundColor2.value,
                borderRadius: BorderRadius.circular(16)
            ),
            child: Column(

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${getTranslated(context,"Routing Fee" )??"Routing Fee"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",

                      ),
                    ),
                    Text(
                      "${getTranslated(context,"Slippage Tolerance" )??"Slippage Tolerance"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",

                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      children: [
                        Text(
                          "0.68612",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",

                          ),
                        ),
                        SizedBox(width: 7,),

                        Text(
                          "SOL",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: lightTextColor.value,
                            fontFamily: "dmsans",

                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "0.1%",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: headingColor.value,
                            fontFamily: "dmsans",

                          ),
                        ),

                      ],
                    ),
                  ],
                ),





              ],
            ),
          ),

          SizedBox(height: 16,),
          Container(

            // height:70,
            width: Get.width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: inputFieldBackgroundColor2.value,
                borderRadius: BorderRadius.circular(16)
            ),
            child: Column(

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${getTranslated(context,"Quote" )??"Quote"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: lightTextColor.value,
                        fontFamily: "dmsans",

                      ),
                    ),

                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      children: [
                        Text(
                          "1 ETH ≈",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: headingColor.value,
                            fontFamily: "dmsans",

                          ),
                        ),
                        SizedBox(width: 7,),

                        Text(
                          "  1.089323 SOL",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: lightTextColor.value,
                            fontFamily: "dmsans",

                          ),
                        ),
                      ],
                    ),

                  ],
                ),






              ],
            ),
          ),
          SizedBox(height: 40,),

          BottomRectangularBtn(onTapFunc: (){
            Get.back();
            Get.bottomSheet(
                clipBehavior: Clip.antiAlias,
                isScrollControlled: true,
                backgroundColor: primaryBackgroundColor.value,
                shape: OutlineInputBorder(
                    borderSide: BorderSide.none, borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                slippageSettings());
          } ,btnTitle: "Confirm Swap"),
          SizedBox(height: 10,),










        ],
      ),
    );
  }
  Widget swapCompleted(){
    return Container(
      // height: 430,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 22,vertical: 22),
      color: inputFieldBackgroundColor.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
      Container(
        height: 120,
        width: 120,
        padding: EdgeInsets.all(17),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: inputFieldBackgroundColor2.value
        ),
        child:appController.isDark.value==true?
            SvgPicture.asset("assets/svgs/arrow-circle (2).svg"):
        SvgPicture.asset("assets/svgs/arrow-circle.svg"),
      ),
          SizedBox(height: 32,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${getTranslated(context,"Swap has been completed" )??"Swap has been completed"}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: headingColor.value,
                  fontFamily: "dmsans",

                ),
              ),
            ],
          ),


          SizedBox(height: 3,),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '${getTranslated(context,"You just swapped" )??"You just swapped"}',
              style: TextStyle(fontSize: 14, color: lightTextColor.value, fontFamily: 'Spectral', fontWeight: FontWeight.w400),
              children: <TextSpan>[
                TextSpan(
                  text: ' 0.5 SOL ',
                  style: TextStyle(fontSize: 13, color: headingColor.value, fontFamily: 'dmsans', fontWeight: FontWeight.w600),
                ),
                TextSpan(text: '${getTranslated(context,"to get" )??"to get"}'),
                TextSpan(
                  text: ' 8.3 ETH ',
                  style: TextStyle(fontSize: 13, color: headingColor.value, fontFamily: 'dmsans', fontWeight: FontWeight.w600),
                ),

                TextSpan(text: '${getTranslated(context,"successfully." )??"successfully."}'),
              ],
            ),
          ),
          SizedBox(height: 32,),



          BottomRectangularBtn(onTapFunc: (){

            // Get.to(TransactionScreen());
          } ,btnTitle: "View History"),
          SizedBox(height: 12,),

          BottomRectangularBtn(
              onlyBorder: true,
              color: Colors.transparent,
              onTapFunc: (){
                Get.back();
                Get.back();


              }, btnTitle: "Cancel"),
          // SizedBox(height: 24,),










        ],
      ),
    );
  }
  Widget slippageSettings(){
    return Container(

      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 22,vertical: 22),
      color: inputFieldBackgroundColor.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${getTranslated(context,"Slippage Settings" )??"Slippage Settings"}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: headingColor.value,
                  fontFamily: "dmsans",

                ),
              ),
              GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(Icons.clear,color: headingColor.value,))



            ],
          ),
          SizedBox(height: 32,),

          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: '${getTranslated(context,"Your transaction will fail if the price changes more than the slippage. The recommended default is" )??"Your transaction will fail if the price changes more than the slippage. The recommended default is"}',
              style: TextStyle(fontSize: 14, color: lightTextColor.value, fontFamily: 'Spectral', fontWeight: FontWeight.w400),
              children: <TextSpan>[
                TextSpan(
                  text: ' 0.1%  ',
                  style: TextStyle(fontSize: 14, color: headingColor.value, fontFamily: 'dmsans', fontWeight: FontWeight.w700),
                ),

                TextSpan(
                  text: '- ${getTranslated(context,"too high of a value will result in an unfavorable trade." )??"too high of a value will result in an unfavorable trade."}',
                  // style: TextStyle(fontSize: 13, color: headingColor.value, fontFamily: 'dmsans', fontWeight: FontWeight.w600),
                ),


              ],
            ),
          ),



          SizedBox(height: 32,),
          Container(
            width: 197,
            height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: ShapeDecoration(
                    color: primaryColor.value,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                      child: Container(
                        height: 2,
                        width: 10,
                        color: primaryBackgroundColor.value,
                      )),
                ),
                SizedBox(width: 32),
                Text(
                  '0.1%',
                  style: TextStyle(
                    color:Color(0xff76CF56),
                    fontSize: 24,
                    fontFamily: 'dmsans',
                    fontWeight: FontWeight.w700,
                    height: 0.06,
                  ),
                ),
                SizedBox(width: 32),
                Container(
                  padding: EdgeInsets.all(7.50),
                  decoration: ShapeDecoration(
                    color: primaryColor.value,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Icon(Icons.add,color:Colors.white,),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          CustomSlidingSegmentedControl<int>(
            fromMax: true,
            customSegmentSettings: CustomSegmentSettings(
              radius: 100,

              hoverColor:inputFieldBackgroundColor2.value,
              borderRadius: BorderRadius.circular(100),
              highlightColor: inputFieldBackgroundColor2.value,
              splashColor:inputFieldBackgroundColor2.value,
            ),
            isShowDivider: false,
            isStretch: true,
            initialValue: 1,
            children: {
              1: Text(
                '0.1%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: headingColor.value,
                  fontSize: 14,
                  fontFamily: 'dmsans',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              2: Text(
                '0.3%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:headingColor.value,
                  fontSize: 14,
                  fontFamily: 'dmsans',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              3: Text(
                '0.5%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:headingColor.value,
                  fontSize: 14,
                  fontFamily: 'dmsans',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              4: Text(
                '1%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:headingColor.value,
                  fontSize: 14,
                  fontFamily: 'dmsans',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              )
            },
            decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(100), border: Border.all(width: 1, color: inputFieldBackgroundColor2.value)),
            thumbDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff76CF56),Color(0xff55DDAF),]
              ),
              color: primaryColor.value,
              borderRadius: BorderRadius.circular(100),
            ),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInToLinear,
            onValueChanged: (v) {
              print(v);
            },
          ),
          SizedBox(
            height: 32,
          ),

          BottomRectangularBtn(onTapFunc: (){
            Get.bottomSheet(
                clipBehavior: Clip.antiAlias,
                isScrollControlled: true,
                backgroundColor: primaryBackgroundColor.value,
                shape: OutlineInputBorder(
                    borderSide: BorderSide.none, borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                swapCompleted());

            // Get.to(TransactionScreen());
          } ,btnTitle: "Confirm"),
          // SizedBox(height: 8,),
          //
          // BottomRectangularBtn(
          //     onlyBorder: true,
          //     color: Colors.transparent,
          //     onTapFunc: (){
          //       Get.back();
          //       Get.back();
          //
          //
          //     }, btnTitle: "Cancel"),
          SizedBox(height: 24,),










        ],
      ),
    );
  }

}

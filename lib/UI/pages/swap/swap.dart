import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/UI/common_widgets/commonWidgets.dart';
import '/UI/pages/SwapTransactionHistory/swapTransactionHistory.dart';
import '/controllers/appController.dart';

import '../../../constants/colors.dart';

class Swap extends StatefulWidget {
  const Swap({Key? key}) : super(key: key);

  @override
  State<Swap> createState() => _SwapState();
}

class _SwapState extends State<Swap> {
  final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: primaryColor.value,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 110,
                  padding: EdgeInsets.only(top: 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CommonWidgets().appBar(hasBack: false, title: 'Swap'),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  decoration: BoxDecoration(
                    color: primaryBackgroundColor.value,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  constraints: BoxConstraints(
                      minHeight: Get.height - 110, minWidth: Get.width),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Swap",
                            style: TextStyle(
                                fontFamily: 'sfpro',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                letterSpacing: 0.44,
                                color: headingColor.value),
                          ),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.timer,
                                size: 18,
                                color: primaryColor.value,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(SwapTransactionHistory());
                                },
                                child: Text(
                                  "History",
                                  style: TextStyle(
                                      fontFamily: 'sfpro',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      letterSpacing: 0.44,
                                      color: primaryColor.value),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 230,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 81,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: inputFieldBackgroundColor.value,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "0",
                                        style: TextStyle(
                                            fontFamily: 'sfpro',
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                            letterSpacing: 0.37,
                                            color: labelColor.value),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _selectTokenBottomSheet(context);
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      // color: primaryColor.value,
                                                      image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: AssetImage(
                                                              "assets/imgs/swap2.png"))),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "MATIC",
                                                  style: TextStyle(
                                                      fontFamily: 'sfpro',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.37,
                                                      color: labelColor.value),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: labelColor.value,
                                                )
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "Balance: 0",
                                            style: TextStyle(
                                                fontFamily: 'sfpro',
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16.0,
                                                letterSpacing: 0.37,
                                                color: labelColor.value),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 110,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color:
                                              inputFieldBackgroundColor.value,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "0",
                                                style: TextStyle(
                                                    fontFamily: 'sfpro',
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.37,
                                                    color: labelColor.value),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _selectTokenBottomSheet(
                                                      context);
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Select Token",
                                                      style: TextStyle(
                                                          fontFamily: 'sfpro',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.37,
                                                          color:
                                                              labelColor.value),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: labelColor.value,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 0,
                                          ),
                                          Divider(
                                            height: 0,
                                            color: dividerColor.value,
                                            thickness: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // SizedBox(
                                              //     height: 15,
                                              //     width: 15,
                                              //     child: CircularProgressIndicator(
                                              //       strokeWidth: 2,
                                              //       value: 0.8,
                                              //       color: labelColor.value,
                                              //     )),
                                              // SizedBox(
                                              //   width: 10,
                                              // ),
                                              Text(
                                                "Balance: 0",
                                                style: TextStyle(
                                                    fontFamily: 'sfpro',
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.37,
                                                    color: labelColor.value),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Positioned(
                                child: Center(
                                    child: Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: primaryColor.value,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 3, color: cardColor.value),
                                ),
                                child: ImageIcon(
                                  AssetImage("assets/imgs/swap.png"),
                                  color: Colors.white,
                                ),
                              ),
                            )))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Bridge Fee",
                                style: TextStyle(
                                    fontFamily: 'sfpro',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    letterSpacing: 0.44,
                                    color: placeholderColor),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                CupertinoIcons.question_circle,
                                size: 18,
                                color: placeholderColor,
                              ),
                            ],
                          ),
                          Text(
                            "\$ 1 = 0.0061 MATIC",
                            style: TextStyle(
                                fontFamily: 'sfpro',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                letterSpacing: 0.44,
                                color: headingColor.value),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 13.5,
                      ),
                      Row(
                        children: [
                          Text(
                            "Slippage tolerance",
                            style: TextStyle(
                                fontFamily: 'sfpro',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                letterSpacing: 0.44,
                                color: placeholderColor),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            CupertinoIcons.question_circle,
                            size: 18,
                            color: placeholderColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: bSheetbtnColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Auto",
                                style: TextStyle(
                                    fontFamily: 'sfpro',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    letterSpacing: 0.44,
                                    color: placeholderColor),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "1.00%",
                                style: TextStyle(
                                    fontFamily: 'sfpro',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    letterSpacing: 0.44,
                                    color: headingColor.value),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 85,
                      ),
                      Container(
                        height: 56,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryColor.value),
                        child: Center(
                          child: Text(
                            "Approve",
                            style: TextStyle(
                                fontFamily: 'sfpro',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                                letterSpacing: 0.37,
                                color: primaryBackgroundColor.value),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future _selectTokenBottomSheet(BuildContext context) {
    return Get.bottomSheet(
        isScrollControlled: true,
        backgroundColor: primaryBackgroundColor.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        Container(
            padding: EdgeInsets.all(20),
            height: Get.height * 0.7,
            decoration: BoxDecoration(
                color: primaryBackgroundColor.value,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select token",
                      style: TextStyle(
                          fontFamily: 'sfpro',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 26.0,
                          letterSpacing: 0.44,
                          color: headingColor.value),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.clear,
                          color: headingColor.value,
                        ))
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: _tokenItems(
                    amountInUSD: "0",
                    coinName: "BTC",
                    amountInEth: "0",
                    imgName: "assets/imgs/coinImage.png",
                    percentage: "",
                    priceInUSD: "23,224.00",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: _tokenItems(
                    amountInUSD: "0",
                    coinName: "BNB",
                    amountInEth: "0",
                    imgName: "assets/imgs/coinImage.png",
                    percentage: "",
                    priceInUSD: "23,224.00",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: _tokenItems(
                    amountInUSD: "0",
                    coinName: "USDT",
                    amountInEth: "0",
                    imgName: "assets/imgs/coinImage.png",
                    percentage: "",
                    priceInUSD: "23,224.00",
                  ),
                ),
              ],
            )));
  }

  Widget _tokenItems(
      {String? coinName,
      String? amountInEth,
      String? amountInUSD,
      String? percentage,
      String? priceInUSD,
      String? imgName}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: Get.width,
        height: 72,
        decoration: BoxDecoration(
          color: cardColor.value,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/imgs/coinImage.png',
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            '$coinName',
                            style: TextStyle(
                              fontFamily: 'sfpro',
                              color: headingColor.value,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              letterSpacing: 0.37,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '\$$priceInUSD',
                        style: TextStyle(
                          fontFamily: 'sfpro',
                          color: placeholderColor,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          letterSpacing: 0.44,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        '$amountInEth',
                        style: TextStyle(
                          fontFamily: 'sfpro',
                          color: headingColor.value,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          letterSpacing: 0.37,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '\$$amountInUSD',
                    style: TextStyle(
                      fontFamily: 'sfpro',
                      color: placeholderColor,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      letterSpacing: 0.44,
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

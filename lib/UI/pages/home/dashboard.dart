import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '/UI/pages/chooseToken/chooseToken.dart';
import '/UI/pages/history/history.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../constants/colors.dart';
import '../../common_widgets/commonWidgets.dart';
import '../coinHistory/coinHistory.dart';
import '../importToken/importToken.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List coinList = [
    {
      "coinName": "AVG",
      "priceInUSD": "23,224.00",
      "imgName": "avx",
      "percentage": "0.37",
      "amountInEth": "10",
      "amountInUSD": "23000"
    },
    {
      "coinName": "USDT",
      "priceInUSD": "28,294.00",
      "imgName": "usdt",
      "percentage": "0.35",
      "amountInEth": "10",
      "amountInUSD": "23000"
    },
    {
      "coinName": "USDC",
      "priceInUSD": "25,214.00",
      "imgName": "usdc",
      "percentage": "0.15",
      "amountInEth": "10",
      "amountInUSD": "23000"
    },
    {
      "coinName": "MATIC",
      "priceInUSD": "75,214.00",
      "imgName": "matic",
      "percentage": "0.05",
      "amountInEth": "10",
      "amountInUSD": "23000"
    },
    {
      "coinName": "BNB",
      "priceInUSD": "21,224.00",
      "imgName": "bsc",
      "percentage": "0.33",
      "amountInEth": "10",
      "amountInUSD": "13"
    },
    {
      "coinName": "BTC",
      "priceInUSD": "68,224.00",
      "imgName": "btc",
      "percentage": "0.04",
      "amountInEth": "10",
      "amountInUSD": "14"
    },
    {
      "coinName": "ETH",
      "priceInUSD": "243,224.00",
      "imgName": "eth",
      "percentage": "0.46",
      "amountInEth": "11",
      "amountInUSD": "11"
    },
    {
      "coinName": "FTM",
      "priceInUSD": "43,224.00",
      "imgName": "ftm",
      "percentage": "0.33",
      "amountInEth": "10",
      "amountInUSD": "10"
    },
    {
      "coinName": "OP",
      "priceInUSD": "29,224.00",
      "imgName": "op",
      "percentage": "0.49",
      "amountInEth": "10",
      "amountInUSD": "8"
    },
    {
      "coinName": "TRON",
      "priceInUSD": "73,224.00",
      "imgName": "tron",
      "percentage": "0.34",
      "amountInEth": "10",
      "amountInUSD": "5"
    },
  ];
  //  List coinsList=List.generate(5, (index) => index+1);
  ScrollController _scrollController = ScrollController();
  int currentMax = 1;
  _getMoreList() {
    for (int i = currentMax; i < currentMax + 2; i++) {
      coinList.add(i + 1);
    }
    currentMax = currentMax + 5;
    setState(() {});
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _getMoreList();
      // Load more items here
      // e.g., fetch additional data from an API
      // and add it to your existing list
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.value,
      body: Obx(
        () => Container(
          height: Get.height,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 240,
                    padding: EdgeInsets.only(top: 50, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            CommonWidgets().selectWalletBottomSheet(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Text(
                                  'Eric Declan',
                                  style: TextStyle(
                                    fontFamily: 'sfpro',
                                    color: lightColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                    letterSpacing: 0.37,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: lightColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: Get.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Available Balance',
                                style: TextStyle(
                                  fontFamily: 'sfpro',
                                  color: lightColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  letterSpacing: 0.37,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '\$13,970.85',
                                style: TextStyle(
                                  fontFamily: 'sfpro',
                                  color: lightColor,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 40.0,
                                  letterSpacing: 0.36,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: primaryBackgroundColor.value,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      //constraints: BoxConstraints(minHeight: Get.height - 240, minWidth: Get.width),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Coin List',
                                style: TextStyle(
                                  color: headingColor.value,
                                  fontFamily: 'sfpro',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 26.0,
                                  letterSpacing: 0.36,
                                ),
                              ),

                              ///

                              /// //
                              GestureDetector(
                                onTap: () {
                                  Get.to(ImportToken());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  color: primaryBackgroundColor.value,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: primaryColor.value,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        'Import token',
                                        style: TextStyle(
                                            fontFamily: 'sfpro',
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.0,
                                            color: primaryColor.value),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: coinList.length,
                              padding: EdgeInsets.only(top: 10, bottom: 40),
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    coinList[i] == 1
                                        ? _coinRow(
                                            coinName:
                                                '${coinList[i]['coinName']}',
                                            priceInUSD:
                                                '${coinList[i]['priceInUSD']}',
                                            imgName:
                                                '${coinList[i]['imgName']}',
                                            percentage:
                                                '${coinList[i]['percentage']}',
                                            amountInEth:
                                                '${coinList[i]['amountInEth']}',
                                            amountInUSD:
                                                '${coinList[i]['amountInUSD']}',
                                            increment: true)
                                        : _coinRow(
                                            coinName:
                                                '${coinList[i]['coinName']}',
                                            priceInUSD:
                                                '${coinList[i]['priceInUSD']}',
                                            imgName:
                                                '${coinList[i]['imgName']}',
                                            percentage:
                                                '${coinList[i]['percentage']}',
                                            amountInEth:
                                                '${coinList[i]['amountInEth']}',
                                            amountInUSD:
                                                '${coinList[i]['amountInUSD']}',
                                            increment: false),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 200,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: Get.width - 32,
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: cardColor.value,
                        boxShadow: appShadow),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        _dashBTns(
                            svg: 'send',
                            btnText: 'Send',
                            onTap: () {
                              Get.to(ChooseToken());
                            }),
                        _dashBTns(
                            svg: 'recieve',
                            btnText: 'Receive',
                            onTap: () {
                              _qrBottomSheeet(context);
                            }),
                        _dashBTns(
                            svg: 'History',
                            btnText: 'History',
                            onTap: () {
                              Get.to(History());
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coinRow(
      {String? coinName,
      String? amountInEth,
      String? amountInUSD,
      String? percentage,
      String? priceInUSD,
      String? imgName,
      required bool increment}) {
    return GestureDetector(
      onTap: () {
        Get.to(CoinHistory());
      },
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Colors.transparent,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   // height: 40,
                  //   // width: 40,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     shape: BoxShape.circle
                  //   ),
                  //   child:
                  Image.asset(
                    fit: BoxFit.fill,
                    height: 50,
                    width: 50,
                    'assets/imgs/chains/$imgName.png',
                  ),
                  // ),
                  SizedBox(
                    width: 14,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(
                            width: 8,
                          ),
                          increment == true
                              ? Text(
                                  '+ $percentage%',
                                  style: TextStyle(
                                      fontFamily: 'sfpro',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      letterSpacing: 0.44,
                                      color: primaryColor.value),
                                )
                              : Text(
                                  '- $percentage%',
                                  style: TextStyle(
                                      fontFamily: 'sfpro',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      letterSpacing: 0.44,
                                      color: redCardColor.value),
                                ),
                        ],
                      ),
                      SizedBox(height: 5),
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
                  SizedBox(height: 5),
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

  Widget _dashBTns({String? svg, String? btnText, Function? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/svgs/$svg.svg',
                color: inputFieldTextColor.value,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '$btnText',
                style: TextStyle(
                  fontFamily: 'sfpro',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  letterSpacing: 0.37,
                  color: inputFieldTextColor.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _qrBottomSheeet(BuildContext context) {
    return Get.bottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        Container(
            padding: EdgeInsets.all(20),
            height: Get.height * 0.63,
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
                      "Receive",
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
                  height: 40,
                ),
                QrImageView(
                  data: "323456",
                  version: QrVersions.auto,
                  size: 200.0,
                  // backgroundColor: headingColor.value,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Send only Polygon (MATIC) to this address.\nSending any other coins may result in permanent loss.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'sfpro',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.0,
                      letterSpacing: 0.44,
                      color: placeholderColor),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(ImportToken());
                  },
                  child: Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: bSheetbtnColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage("assets/imgs/Icons1.png"),
                          color: primaryColor.value,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "0x000000...00000000",
                          style: TextStyle(
                              fontFamily: 'sfpro',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              letterSpacing: 0.44,
                              color: primaryColor.value),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            )));
  }
}

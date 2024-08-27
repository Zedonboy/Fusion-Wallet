import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../common_widgets/commonWidgets.dart';
import '../send/send.dart';

class ChooseToken extends StatefulWidget {
  ChooseToken({Key? key}) : super(key: key);

  @override
  State<ChooseToken> createState() => _ChooseTokenState();
}

class _ChooseTokenState extends State<ChooseToken> {
  final List coinToken = [
    {
      "coinName": "AVX",
      "priceInUSD": "29,224.00",
      "imgName": "avx",
      "percentage": "0.45",
      "amountInEth": "10",
      "amountInUSD": "23000"
    },
    {
      "coinName": "BSC",
      "priceInUSD": "25,224.00",
      "imgName": "bsc",
      "percentage": "0.33",
      "amountInEth": "10",
      "amountInUSD": "13"
    },
    {
      "coinName": "USDT",
      "priceInUSD": "28,294.00",
      "imgName": "usdt",
      "percentage": "0.35",
      "amountInEth": "6",
      "amountInUSD": "23000"
    },
    {
      "coinName": "USDC",
      "priceInUSD": "25,214.00",
      "imgName": "usdc",
      "percentage": "0.15",
      "amountInEth": "12",
      "amountInUSD": "23000"
    },
    {
      "coinName": "MATIC",
      "priceInUSD": "75,214.00",
      "imgName": "matic",
      "percentage": "0.05",
      "amountInEth": "14",
      "amountInUSD": "23000"
    },
    {
      "coinName": "BTC",
      "priceInUSD": "29,112.00",
      "imgName": "btc",
      "percentage": "0.50",
      "amountInEth": "10",
      "amountInUSD": "14"
    },
    {
      "coinName": "ETH",
      "priceInUSD": "26,224.00",
      "imgName": "eth",
      "percentage": "0.46",
      "amountInEth": "11",
      "amountInUSD": "11"
    },
    {
      "coinName": "FTM",
      "priceInUSD": "39,224.00",
      "imgName": "ftm",
      "percentage": "0.43",
      "amountInEth": "10",
      "amountInUSD": "10"
    },
    {
      "coinName": "OP",
      "priceInUSD": "49,224.00",
      "imgName": "op",
      "percentage": "0.49",
      "amountInEth": "10",
      "amountInUSD": "8"
    },
    {
      "coinName": "TRON",
      "priceInUSD": "59,224.00",
      "imgName": "tron",
      "percentage": "0.34",
      "amountInEth": "10",
      "amountInUSD": "5"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.value,
      body: Obx(
        () => Container(
          height: Get.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 110,
                padding: EdgeInsets.only(top: 70),
                child: CommonWidgets().appBar(hasBack: true, title: 'Send'),
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
                        children: [
                          Text(
                            'Choose Token',
                            style: TextStyle(
                              color: headingColor.value,
                              fontFamily: 'sfpro',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              fontSize: 26.0,
                              letterSpacing: 0.36,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: coinToken.length,
                          padding: EdgeInsets.only(top: 10, bottom: 40),
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                _coinRow(
                                    coinName: '${coinToken[i]['coinName']}',
                                    priceInUSD: '${coinToken[i]['priceInUSD']}',
                                    imgName: '${coinToken[i]['imgName']}',
                                    percentage: '${coinToken[i]['percentage']}',
                                    amountInEth:
                                        '${coinToken[i]['amountInEth']}',
                                    amountInUSD:
                                        '${coinToken[i]['amountInUSD']}'),

                                // _coinRow(coinName: 'BTC', priceInUSD: '24000', imgName: 'btc', percentage: '0.45', amountInEth: '10', amountInUSD: '240000'),
                                SizedBox(
                                  height: 10,
                                )
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
      String? imgName}) {
    return GestureDetector(
      onTap: () {
        Get.to(Send());
      },
      child: Container(
        width: Get.width,
        height: 72,
        decoration: BoxDecoration(
          color: primaryBackgroundColor.value,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.only(top: 12, bottom: 5, right: 12),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/imgs/chains/$imgName.png',
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
                          SizedBox(
                            width: 8,
                          ),
                          Text(
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
                      SizedBox(
                        height: 3,
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                    height: 3,
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

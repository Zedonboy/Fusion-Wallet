import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../manage/manage.dart';

class Wallets extends StatelessWidget {
  Wallets({Key? key}) : super(key: key);
  final List coinList = [
    {
      "imgName": "avx",
      "coinName": "USDT",
      "address": "\$0x000...0",
    },
    {
      "imgName": "bsc",
      "coinName": "BSC",
      "address": "\$0x000...0",
    },
    {
      "imgName": "btc",
      "coinName": "BTC",
      "address": "\$0x000...0",
    },
    {
      "imgName": "eth",
      "coinName": "ETH",
      "address": "\$0x000...0",
    },
    {
      "imgName": "ftm",
      "coinName": "FTM",
      "address": "\$0x000...0",
    },
    {
      "imgName": "op",
      "coinName": "OP",
      "address": "\$0x000...0",
    },
    {
      "imgName": "tron",
      "coinName": "TRON",
      "address": "\$0x000...0",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(CupertinoIcons.back)),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 12.0, bottom: 0),
                          child: Text(
                            "Wallets",
                            style: TextStyle(
                                fontFamily: 'sfpro',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                fontSize: 26.0,
                                letterSpacing: 0.37,
                                color: headingColor.value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 37,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Multi-Coin Wallets",
                      style: TextStyle(
                          fontFamily: 'sfpro',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          letterSpacing: 0.44,
                          color: headingColor.value),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 7,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: _walletContainer(
                    context: context,
                    amountInUSD: "0",
                    coinName: "My Multi Coin Wallet",
                    amountInEth: "0",
                    imgName: "btc",
                    percentage: "",
                    priceInUSD: "0x000...000",
                    isSelected: true),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Wallets",
                      style: TextStyle(
                          fontFamily: 'sfpro',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          letterSpacing: 0.44,
                          color: headingColor.value),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                child: Container(
                  height: 400,
                  child: ListView.builder(
                    itemCount: coinList.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: _walletContainer(
                          isSelected: false,
                          amountInUSD: "0",
                          coinName: "${coinList[index]['coinName']}",
                          amountInEth: "0",
                          imgName: "${coinList[index]['imgName']}",
                          percentage: "",
                          priceInUSD: "0x000...000",
                          context: context,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _walletContainer(
      {required BuildContext context,
      String? coinName,
      String? amountInEth,
      String? amountInUSD,
      String? percentage,
      String? priceInUSD,
      String? imgName,
      required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        Get.to(Manage());
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 58,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected == true ? bSheetbtnColor : cardColor.value,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        'assets/imgs/chains/$imgName.png',
                      ),
                    )),
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
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
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
                          fontSize: 12.0,
                          letterSpacing: 0.44,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isSelected == true
                  ? Icon(
                      Icons.check,
                      color: primaryColor.value,
                    )
                  : Icon(
                      CupertinoIcons.chevron_forward,
                      size: 25,
                      color: labelColor.value,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/UI/common_widgets/commonWidgets.dart';

import '../../../constants/colors.dart';

class SwapTransactionHistory extends StatefulWidget {
  const SwapTransactionHistory({Key? key}) : super(key: key);

  @override
  State<SwapTransactionHistory> createState() => _SwapTransactionHistoryState();
}

class _SwapTransactionHistoryState extends State<SwapTransactionHistory> {
  // final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: primaryColor.value,
          body: ListView(
            padding: EdgeInsets.zero,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 110,
                padding: EdgeInsets.only(top: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CommonWidgets().appBar(hasBack: true, title: 'History'),
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
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            //Get.to(CoinHistory());
                          },
                          child: Text(
                            "Transactions",
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
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 90),
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return _historyContainer(context: context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _historyContainer({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: 152,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: inputFieldBackgroundColor.value,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(
                          fontFamily: 'sfpro',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          letterSpacing: 0.44,
                          color: headingColor.value),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      CupertinoIcons.info,
                      size: 18,
                      color: placeholderColor,
                    ),
                  ],
                ),
                Text(
                  "Completed",
                  style: TextStyle(
                      fontFamily: 'sfpro',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      letterSpacing: 0.44,
                      color: primaryColor.value),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: dividerColor.value,
              thickness: 1,
            ),
            SizedBox(
              height: 5,
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
                          color: headingColor.value),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      CupertinoIcons.info,
                      size: 18,
                      color: placeholderColor,
                    ),
                  ],
                ),
                Text(
                  "0.0061 MATIC",
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
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/imgs/swap2.png"),
                    Text(
                      "MATIC",
                      style: TextStyle(
                          fontFamily: 'sfpro',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          letterSpacing: 0.44,
                          color: headingColor.value),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset("assets/imgs/usdc.png"),
                    Text(
                      "USDC",
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
              ],
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "+ 12023.00",
                      style: TextStyle(
                          fontFamily: 'sfpro',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          letterSpacing: 0.44,
                          color: iconDownColor),
                    ),
                  ],
                ),
                Text(
                  "-12023.00",
                  style: TextStyle(
                      fontFamily: 'sfpro',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      letterSpacing: 0.44,
                      color: iconUpColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '/UI/common_widgets/commonWidgets.dart';
import '/controllers/appController.dart';

import '../../../constants/colors.dart';

class CoinHistory extends StatefulWidget {
  const CoinHistory({Key? key}) : super(key: key);

  @override
  State<CoinHistory> createState() => _CoinHistoryState();
}

class _CoinHistoryState extends State<CoinHistory> {
  final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: primaryColor.value,
        body: Container(
          height: Get.height,
          child: ListView(
            padding: EdgeInsets.zero,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 110,
                padding: EdgeInsets.only(top: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CommonWidgets()
                        .appBar(hasBack: true, title: 'Coin History'),
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
                      height: 40,
                    ),
                    Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/imgs/coinImage.png"))),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "\$23,224.00",
                          style: TextStyle(
                              fontFamily: 'sfpro',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              letterSpacing: 0.44,
                              color: labelColor.value),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Text(
                          "-0.02%",
                          style: TextStyle(
                              fontFamily: 'sfpro',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              letterSpacing: 0.44,
                              color: iconUpColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "0 BTC",
                      style: TextStyle(
                          fontFamily: 'sfpro',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 26.0,
                          letterSpacing: 0.37,
                          color: headingColor.value),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 38.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              // ImageIcon(AssetImage("assets/imgs/coin1.png")),
                              SvgPicture.asset(
                                'assets/svgs/sendHistory.svg',
                                color: inputFieldTextColor.value,
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Text(
                                "Send",
                                style: TextStyle(
                                    fontFamily: 'sfpro',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    letterSpacing: 0.37,
                                    color: headingColor.value),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.redAccent, //color of divider
                            height: 5, //height spacing of divider
                            thickness: 3, //thickness of divier line
                            indent: 25, //spacing at the start of divider
                            endIndent: 25, //spacing at the end of divider
                          ),
                          Column(
                            children: [
                              SvgPicture.asset(
                                'assets/svgs/receiveHistory.svg',
                                color: inputFieldTextColor.value,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Receive",
                                style: TextStyle(
                                    fontFamily: 'sfpro',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    letterSpacing: 0.37,
                                    color: headingColor.value),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.redAccent, //color of divider
                            height: 5, //height spacing of divider
                            thickness: 3, //thickness of divier line
                            indent: 25, //spacing at the start of divider
                            endIndent: 25, //spacing at the end of divider
                          ),
                          Column(
                            children: [
                              SvgPicture.asset(
                                'assets/svgs/swapHistory.svg',
                                color: inputFieldTextColor.value,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Swap",
                                style: TextStyle(
                                    fontFamily: 'sfpro',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    letterSpacing: 0.37,
                                    color: headingColor.value),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return _historyContainer(
                            context: context, outGoing: 1, cIndex: index);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _historyContainer(
      {required BuildContext context, int? outGoing, cIndex}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: 67,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: inputFieldBackgroundColor.value,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    height: 24,
                    width: 24,
                    decoration: cIndex != outGoing
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            color: bgCintainerColor.withOpacity(0.15),
                          )
                        : BoxDecoration(
                            shape: BoxShape.circle,
                            color: bg2CintainerColor.withOpacity(0.15),
                          ),
                    child: Icon(
                      cIndex == outGoing
                          ? CupertinoIcons.arrow_up_right
                          : CupertinoIcons.arrow_down_left,
                      size: 15,
                      color: cIndex == outGoing ? iconUpColor : iconDownColor,
                    )),
                SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transfer",
                      style: TextStyle(
                          fontFamily: 'sfpro',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          letterSpacing: 0.37,
                          color: headingColor.value),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "0x000...000",
                      style: TextStyle(
                          fontFamily: 'sfpro',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          letterSpacing: 0.37,
                          color: headingColor.value),
                    ),
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("-12023.00 MATIC",
                    style: TextStyle(
                        fontFamily: 'sfpro',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                        letterSpacing: 0.44,
                        color:
                            cIndex == outGoing ? iconUpColor : iconDownColor)),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "08 Feb 2023",
                  style: TextStyle(
                      fontFamily: 'sfpro',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      letterSpacing: 0.44,
                      color: headingColor.value),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

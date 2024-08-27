import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/UI/common_widgets/commonWidgets.dart';
import '/UI/pages/coinHistory/coinHistory.dart';
import '/constants/constants.dart';
import '/controllers/appController.dart';

import '../../../constants/colors.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final appController = Get.find<AppController>();
  var _visible = 0;

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
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Text(
                            "Transactions",
                            style: TextStyle(
                                fontFamily: 'sfpro',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                fontSize: 26.0,
                                letterSpacing: 0.37,
                                color: headingColor.value),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: historyFilters.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: index == 0
                                ? EdgeInsets.only(left: 0.0, right: 15)
                                : EdgeInsets.symmetric(horizontal: 15.0),
                            child: InkWell(
                              onTap: () {
                                appController.selectedTabIndex1.value = index;
                                setState(() {
                                  _visible =
                                      appController.selectedTabIndex1.value;
                                });
                              },
                              child: Container(
                                height: 20,
                                decoration: appController
                                            .selectedTabIndex1.value ==
                                        index
                                    ? BoxDecoration(
                                        color: bSheetbtnColor,
                                        borderRadius: BorderRadius.circular(5))
                                    : BoxDecoration(
                                        color: cardColor.value,
                                        borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8.0),
                                    child: Text(
                                      "${historyFilters[index]}",
                                      style: TextStyle(
                                          fontFamily: 'sfpro',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.0,
                                          letterSpacing: 0.44,
                                          color: appController.selectedTabIndex1
                                                      .value ==
                                                  index
                                              ? primaryColor.value
                                              : placeholderColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: _visible == 0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 35, top: 0),
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return historyContainer(
                              context: context,
                              outGoing: 1,
                              cIndex: index,
                              onTap: () {
                                Get.to(CoinHistory());
                              });
                        },
                      ),
                    ),
                    Visibility(
                      visible: _visible == 1,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 35, top: 0),
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return historyContainer(
                              context: context,
                              outGoing: 1,
                              cIndex: index,
                              onTap: () {
                                Get.to(CoinHistory());
                              });
                        },
                      ),
                    ),
                    Visibility(
                      visible: _visible == 2,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return historyContainer(
                              context: context,
                              outGoing: 1,
                              cIndex: index,
                              onTap: () {
                                Get.to(CoinHistory());
                              });
                        },
                      ),
                    ),
                    Visibility(
                      visible: _visible == 3,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        padding: EdgeInsets.only(bottom: 35, top: 0),
                        itemBuilder: (BuildContext context, int index) {
                          return historyContainer(
                              context: context,
                              outGoing: 1,
                              cIndex: index,
                              onTap: () {
                                Get.to(CoinHistory());
                              });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget historyContainer(
      {required BuildContext context,
      int? outGoing,
      cIndex,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 67,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: cardColor.value,
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
                          color: cIndex == outGoing
                              ? iconUpColor
                              : iconDownColor)),
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
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../common_widgets/bottomRectangularbtn.dart';

class Manage extends StatelessWidget {
  const Manage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
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
                              const EdgeInsets.only(right: 12.0, bottom: 10),
                          child: Text(
                            "Manage",
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Wallet Name",
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
              Row(
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.88,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Center(
                              child: ImageIcon(
                            AssetImage("assets/imgs/wallet.png"),
                            color: headingColor.value,
                          )),
                        ),
                        Container(
                          height: 60,
                          width: 1,
                          color: dividerColor.value,
                        ),
                        Expanded(
                          child: Container(
                            height: 60,
                            padding: EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Text(
                                  "Eric Jaye",
                                  style: TextStyle(
                                      fontFamily: 'sfpro',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      letterSpacing: 0.44,
                                      color: headingColor.value),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16)),
                child: Center(
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Center(
                            child: Image.asset("assets/imgs/wallet1.png")),
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: dividerColor.value,
                      ),
                      Expanded(
                        child: Container(
                          height: 60,
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "BTC Private Key",
                                style: TextStyle(
                                    fontFamily: 'sfpro',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    letterSpacing: 0.44,
                                    color: headingColor.value),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: dividerColor.value,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageIcon(
                                AssetImage("assets/imgs/Icons1.png"),
                                color: placeholderColor,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Copy",
                                style: TextStyle(
                                    fontFamily: 'sfpro',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    letterSpacing: 0.44,
                                    color: placeholderColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 0),
                child: Text(
                  "If you lost access to this device, your funds will be lost, unless you back up!",
                  style: TextStyle(
                      fontFamily: 'sfpro',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      letterSpacing: 0.44,
                      color: placeholderColor),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.88,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16)),
                child: Center(
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Center(
                            child: Image.asset("assets/imgs/coinImage.png")),
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: dividerColor.value,
                      ),
                      Expanded(
                        child: Container(
                          height: 60,
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "BTC Private Key",
                                style: TextStyle(
                                    fontFamily: 'sfpro',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    letterSpacing: 0.44,
                                    color: headingColor.value),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: dividerColor.value,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageIcon(
                                AssetImage("assets/imgs/Icons1.png"),
                                color: placeholderColor,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Copy",
                                style: TextStyle(
                                    fontFamily: 'sfpro',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    letterSpacing: 0.44,
                                    color: placeholderColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 25),
                child: Text(
                  "If you lost access to this device, your funds will be lost, unless you back up!",
                  style: TextStyle(
                      fontFamily: 'sfpro',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      letterSpacing: 0.44,
                      color: placeholderColor),
                ),
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.88,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16)),
                child: Center(
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Center(
                            child: Image.asset("assets/imgs/wallet1.png")),
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: dividerColor.value,
                      ),
                      Expanded(
                          child: Container(
                        height: 60,
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "BTC Private Key",
                              style: TextStyle(
                                  fontFamily: 'sfpro',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  letterSpacing: 0.44,
                                  color: headingColor.value),
                            ),
                          ],
                        ),
                      )),
                      Container(
                        height: 60,
                        width: 1,
                        color: dividerColor.value,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageIcon(
                                AssetImage("assets/imgs/Icons1.png"),
                                color: placeholderColor,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Copy",
                                style: TextStyle(
                                    fontFamily: 'sfpro',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    letterSpacing: 0.44,
                                    color: placeholderColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 0),
                child: Text(
                  "If you lost access to this device, your funds will be lost, unless you back up!",
                  style: TextStyle(
                      fontFamily: 'sfpro',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      letterSpacing: 0.44,
                      color: placeholderColor),
                ),
              ),
              SizedBox(
                height: 90,
              ),
              BottomRectangularBtn(
                onTapFunc: () {
                  Navigator.pop(context);
                },
                btnTitle: "Update Changes",
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/UI/pages/biomatric/passwordLockScreen.dart';
import '/constants/colors.dart';

class BioMatricLockScreen extends StatelessWidget {
  const BioMatricLockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color(0x0D27C19F)),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Welcome Back!',
                style: TextStyle(
                    fontFamily: 'sfpro',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 26.0,
                    letterSpacing: 0.37,
                    color: headingColor.value),
              ),

              // SizedBox(height: 100),

              Column(
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      child: SvgPicture.asset(
                        "assets/svgs/biometric.svg",
                        color: primaryColor.value,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Touch ID to Open MATREX',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'sfpro',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        letterSpacing: 0.37,
                        color: primaryColor.value),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Get.to(PasswordLockScreen());
                },
                child: Text(
                  'Use Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'sfpro',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      letterSpacing: 0.37,
                      color: primaryColor.value),
                ),
              ),
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

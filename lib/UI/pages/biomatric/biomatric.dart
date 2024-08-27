import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/UI/pages/biomatric/bioMatricLockScreen.dart';
import '/constants/colors.dart';

import '../../common_widgets/bottomRectangularbtn.dart';

class BioMatric extends StatelessWidget {
  const BioMatric({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor.value,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Biometric',
                style: TextStyle(
                    fontFamily: 'sfpro',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 26.0,
                    letterSpacing: 0.37,
                    color: headingColor.value),
              ),
              Text(
                'Place your finger on the fingerprint\n scanner to get started.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'sfpro',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    letterSpacing: 0.37,
                    color: labelColor.value),
              ),
              // SizedBox(height: 100),

              SvgPicture.asset(
                "assets/svgs/biometric.svg",
                color: primaryColor.value,
              ),
              BottomRectangularBtn(
                  onTapFunc: () {
                    Get.to(BioMatricLockScreen());
                  },
                  btnTitle: 'Continue'),
            ],
          ),
        ),
      ),
    );
  }
}

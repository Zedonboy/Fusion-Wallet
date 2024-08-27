import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/UI/common_widgets/inputFields.dart';

import '../../../constants/colors.dart';
import '../../../controllers/appController.dart';
import '../../common_widgets/bottomRectangularbtn.dart';
import '../../common_widgets/commonWidgets.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({Key? key}) : super(key: key);

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final appController = Get.find<AppController>();
  TextEditingController newPassController = TextEditingController();
  final passError = ''.obs;
  final isChecked = false.obs;
  TextEditingController confirmPassController = TextEditingController();
  final confirmPassError = ''.obs;
  final checkBoxErr = ''.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.value,
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 160,
                padding: EdgeInsets.only(top: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CommonWidgets().appBar(hasBack: true, title: 'Password'),
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
                    minHeight: Get.height - 160, minWidth: Get.width),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Set new Password',
                          style: TextStyle(
                            color: headingColor.value,
                            fontFamily: 'sfpro',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 26.0,
                            letterSpacing: 0.36,
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Text(
                        //   'Protection for All Your Wallets & Assets.',
                        //   style: TextStyle(fontFamily: 'sfpro', fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 16.0, letterSpacing: 0.37, color: labelColor.value),
                        // ),
                        SizedBox(
                          height: 24,
                        ),
                        InputFieldPassword(
                          headerText: 'New Password',
                          svg: 'Lock',
                          hintText: '• • • • • • • •',
                          textController: newPassController,
                          onChange: () {
                            passError.value = '';
                          },
                        ),
                        CommonWidgets.showErrorMessage(passError.value),
                        SizedBox(
                          height: 10,
                        ),
                        InputFieldPassword(
                          headerText: 'Confirm Password',
                          svg: 'Lock',
                          hintText: '• • • • • • • •',
                          textController: confirmPassController,
                          onChange: () {
                            confirmPassError.value = '';
                          },
                        ),
                        CommonWidgets.showErrorMessage(passError.value),
                      ],
                    ),
                    Column(
                      children: [
                        BottomRectangularBtn(
                            onTapFunc: () {
                              Get.back();
                              Get.back();
                            },
                            btnTitle: 'Update Password'),
                        SizedBox(
                          height: 45,
                        )
                      ],
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
}

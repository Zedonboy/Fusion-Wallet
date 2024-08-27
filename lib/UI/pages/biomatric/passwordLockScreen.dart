import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '/constants/colors.dart';
import '/UI/common_widgets/inputFields.dart';
import '/controllers/appController.dart';

class PasswordLockScreen extends StatefulWidget {
  const PasswordLockScreen({Key? key}) : super(key: key);

  @override
  State<PasswordLockScreen> createState() => _PasswordLockScreenState();
}

class _PasswordLockScreenState extends State<PasswordLockScreen> {
  final appController = Get.find<AppController>();
  TextEditingController changepPassController = TextEditingController();
  final passError = ''.obs;
  final isChecked = false.obs;
  final checkBoxErr = ''.obs;
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
                      height: 60,
                      width: 100,
                      child: SvgPicture.asset(
                        "assets/svgs/keyImage.svg",
                        color: primaryColor.value,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InputFieldPassword(
                      headerText: '',
                      svg: 'Lock',
                      hintText: '• • • • • • • •',
                      textController: changepPassController,
                      onChange: () {
                        passError.value = '';
                      },
                    ),
                  ),
                ],
              ),
              Text(
                'Use Touch ID',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'sfpro',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    letterSpacing: 0.37,
                    color: primaryColor.value),
              ),
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

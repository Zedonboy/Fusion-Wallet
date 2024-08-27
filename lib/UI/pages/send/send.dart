import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '/UI/pages/contacts/contact.dart';

import '../../../constants/colors.dart';
import '../../common_widgets/inputFields.dart';
import '../../../controllers/appController.dart';
import '../../common_widgets/bottomRectangularbtn.dart';
import '../../common_widgets/commonWidgets.dart';

class Send extends StatefulWidget {
  const Send({Key? key}) : super(key: key);

  @override
  State<Send> createState() => _SendState();
}

class _SendState extends State<Send> {
  final appController = Get.find<AppController>();

  var isChecked = false.obs;
  var checkBoxErr = ''.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  var nameError = ''.obs;
  var amountErr = ''.obs;

  int selectedPercentage = 0;

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
                height: 110,
                padding: EdgeInsets.only(top: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CommonWidgets().appBar(hasBack: true, title: 'Send'),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: Get.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Available Balance',
                                style: TextStyle(
                                    fontFamily: 'sfpro',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0,
                                    letterSpacing: 0.37,
                                    color: labelColor.value),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '13,970.85',
                                style: TextStyle(
                                  color: headingColor.value,
                                  fontFamily: 'sfpro',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 40.0,
                                  letterSpacing: 0.36,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        InputFieldsWithSeparateIcon(
                          textController: nameController,
                          headerText: 'Amount',
                          hintText: 'Amount',
                          inputType: TextInputType.number,
                          hasHeader: true,
                          onChange: (value) {
                            nameError.value = '';
                          },
                          svg: 'walletArrow',
                          suffixIcon: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Text(
                              'MATIC',
                              style: TextStyle(
                                  fontFamily: 'sfpro',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  letterSpacing: 0.37,
                                  color: labelColor.value),
                            ),
                          ),
                        ),
                        CommonWidgets.showErrorMessage(amountErr.value),
                        Container(
                          width: Get.width,
                          height: Get.height * 0.042,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPercentage = 10;
                                  });
                                },
                                child: SizedBox(
                                  height: Get.height * 0.045,
                                  width: Get.width * 0.16,
                                  child: Card(
                                    elevation: 0,
                                    color: selectedPercentage == 10
                                        ? chipChoiceColor
                                        : appController.isDark.value
                                            ? lightColor.withOpacity(0.2)
                                            : lightColor,
                                    child: Center(
                                      child: Text(
                                        '10%',
                                        style: TextStyle(
                                          color: selectedPercentage == 10
                                              ? primaryColor.value
                                              : appController.isDark.value
                                                  ? inputFieldTextColor.value
                                                  : Colors.black87,
                                          fontFamily: 'Karla',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPercentage = 25;
                                  });
                                },
                                child: SizedBox(
                                  height: Get.height * 0.045,
                                  width: Get.width * 0.16,
                                  child: Card(
                                    elevation: 0,
                                    color: selectedPercentage == 25
                                        ? chipChoiceColor
                                        : appController.isDark.value
                                            ? lightColor.withOpacity(0.2)
                                            : lightColor,
                                    child: Center(
                                      child: Text(
                                        '25%',
                                        style: TextStyle(
                                          color: selectedPercentage == 25
                                              ? primaryColor.value
                                              : appController.isDark.value
                                                  ? inputFieldTextColor.value
                                                  : Colors.black87,
                                          fontFamily: 'Karla',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPercentage = 50;
                                  });
                                },
                                child: SizedBox(
                                  height: Get.height * 0.045,
                                  width: Get.width * 0.16,
                                  child: Card(
                                    elevation: 0,
                                    color: selectedPercentage == 50
                                        ? chipChoiceColor
                                        : appController.isDark.value
                                            ? lightColor.withOpacity(0.2)
                                            : lightColor,
                                    child: Center(
                                      child: Text(
                                        '50%',
                                        style: TextStyle(
                                          color: selectedPercentage == 50
                                              ? primaryColor.value
                                              : appController.isDark.value
                                                  ? inputFieldTextColor.value
                                                  : Colors.black87,
                                          fontFamily: 'Karla',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPercentage = 75;
                                  });
                                },
                                child: SizedBox(
                                  height: Get.height * 0.045,
                                  width: Get.width * 0.16,
                                  child: Card(
                                    elevation: 0,
                                    color: selectedPercentage == 75
                                        ? chipChoiceColor
                                        : appController.isDark.value
                                            ? lightColor.withOpacity(0.2)
                                            : lightColor,
                                    child: Center(
                                      child: Text(
                                        '75%',
                                        style: TextStyle(
                                          color: selectedPercentage == 75
                                              ? primaryColor.value
                                              : appController.isDark.value
                                                  ? inputFieldTextColor.value
                                                  : Colors.black87,
                                          fontFamily: 'Karla',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Theme(
                              data:
                                  ThemeData(unselectedWidgetColor: lightColor),
                              child: Checkbox(
                                  checkColor: lightColor,
                                  activeColor: primaryColor.value,
                                  value: isChecked.value,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked.value = !isChecked.value;
                                      if (checkBoxErr.value != '') {
                                        checkBoxErr.value = '';
                                      }
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3)),
                                  side: BorderSide(
                                      color: primaryColor.value, width: 1.0)),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                color: Colors.transparent,
                                child: Text(
                                  'Save recipient',
                                  style: TextStyle(
                                    fontFamily: 'Mont',
                                    color: placeholderColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        CommonWidgets.showErrorMessage(checkBoxErr.value),
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: Text(
                            'Recipient Address',
                            style: TextStyle(
                              color: headingColor.value,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'sfpro',
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                cursorColor: primaryColor.value,
                                cursorHeight: 20,
                                controller: addressController,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'sfpro',
                                    color: inputFieldTextColor.value),
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'sfpro',
                                      color: appController.isDark.value
                                          ? labelColor.value
                                          : placeholderColor),
                                  filled: true,
                                  fillColor: inputFieldBackgroundColor.value,
                                  hintText: '0x000...000',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: cardColor.value, width: 0.1),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: cardColor.value, width: 0.1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: cardColor.value, width: 0.1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: cardColor.value, width: 0.1),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8)),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () async {
                                      Get.to(Contacts());
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          color: Colors.transparent,
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.only(top: 2),
                                          child: SizedBox(
                                            child: SvgPicture.asset(
                                              'assets/svgs/User.svg',
                                              color: placeholderColor,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onChanged: (value) {},
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            GestureDetector(
                              onTap: () async {
                                ClipboardData? cdata = await Clipboard.getData(
                                    Clipboard.kTextPlain);
                                addressController.text = cdata?.text ?? '';
                                setState(() {});
                              },
                              child: Container(
                                width: 60,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: inputFieldBackgroundColor.value,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8)),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/svgs/qr-scanner-m.svg',
                                    color: placeholderColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        InputFields(
                          textController: nameController,
                          headerText: '',
                          hintText: 'Recipient Name',
                          hasHeader: true,
                          onChange: (value) {
                            nameError.value = '';
                          },
                        ),
                        CommonWidgets.showErrorMessage(nameError.value),
                      ],
                    ),
                    Column(
                      children: [
                        BottomRectangularBtn(
                            onTapFunc: () {
                              _showDialogBox(context);
                            },
                            btnTitle: 'Send'),
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

  _showDialogBox(BuildContext context) {
    return Get.defaultDialog(
        backgroundColor: cardColor.value,
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        title: "",
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 445,
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 41),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'MATIC',
                          style: TextStyle(
                            color: headingColor.value,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'sfpro',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '12023.00',
                          style: TextStyle(
                            color: headingColor.value,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'sfpro',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$21,196.34',
                          style: TextStyle(
                            color: headingColor.value,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'sfpro',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    DottedLine(
                      direction: Axis.horizontal,
                      lineLength: double.infinity,
                      lineThickness: 1.0,
                      dashLength: 4.0,
                      dashColor: labelColor.value,
                      dashRadius: 0.0,
                      dashGapLength: 4.0,
                      dashGapColor: dividerColor.value,
                      dashGapGradient: [
                        primaryBackgroundColor.value,
                        primaryBackgroundColor.value
                      ],
                      dashGapRadius: 0.0,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(
                            color: labelColor.value,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'sfpro',
                          ),
                        ),
                        Text(
                          'Recipient Address',
                          style: TextStyle(
                            color: headingColor.value,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'sfpro',
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            color: labelColor.value,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'sfpro',
                          ),
                        ),
                        Text(
                          'Pending',
                          style: TextStyle(
                            color: headingColor.value,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'sfpro',
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recipient Address',
                          style: TextStyle(
                            color: labelColor.value,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'sfpro',
                          ),
                        ),
                        Text(
                          '0x000...000',
                          style: TextStyle(
                            color: headingColor.value,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'sfpro',
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 25),
                    DottedLine(
                      direction: Axis.horizontal,
                      lineLength: double.infinity,
                      lineThickness: 1.0,
                      dashLength: 4.0,
                      dashColor: labelColor.value,
                      dashRadius: 0.0,
                      dashGapLength: 4.0,
                      dashGapColor: dividerColor.value,
                      dashGapGradient: [
                        primaryBackgroundColor.value,
                        primaryBackgroundColor.value
                      ],
                      dashGapRadius: 0.0,
                    ),
                    SizedBox(height: 25),
                    Container(
                      height: 44,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: dividerColor.value,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'View on Blockchain',
                          style: TextStyle(
                            color: Color(0xff030319),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'sfpro',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Positioned.fill(
                  top: -475,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                            color: iconDownColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 5, color: primaryBackgroundColor.value)),
                        child: Icon(
                          Icons.check,
                          color: primaryBackgroundColor.value,
                          size: 30,
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}

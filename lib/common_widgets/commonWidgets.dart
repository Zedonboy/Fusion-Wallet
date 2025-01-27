import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart';
import '../../controllers/appController.dart';

class CommonWidgets {
  final appController = Get.find<AppController>();
  final dateFormatting = DateFormat('MMM dd, yyyy hh:mm a');

  TextEditingController amountController = TextEditingController();
  var amountErrBox = ''.obs;
  var bankNameErrBox = ''.obs;
  var accountNumErrBox = ''.obs;
  var amountFiatErrBox = ''.obs;
  var accountNameErrBox = ''.obs;

  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController accountNumController = TextEditingController();
  TextEditingController amountFiatController = TextEditingController();

  static Widget showErrorMessage(String errorMessage) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 4.0, bottom: 2),
      child: Text(
        errorMessage,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          fontFamily: 'sfpro',
        ),
      ),
    );
  }

  // static Widget confirmationDialogUI(context, a1, a2,
  //     {String? title, String? description, Function? onConfirm}) {
  //   return Theme(
  //     data: Theme.of(context).copyWith(dialogBackgroundColor: cardColor.value),
  //     child: Transform.scale(
  //       scale: a1.value,
  //       child: Opacity(
  //         opacity: a1.value,
  //         child: AlertDialog(
  //           elevation: 10,
  //           backgroundColor: cardColor.value,
  //           shape: OutlineInputBorder(
  //               borderSide: BorderSide.none,
  //               borderRadius: BorderRadius.circular(12.0)),
  //           actionsPadding:
  //               EdgeInsets.only(left: 18, right: 18, bottom: 18, top: 0),
  //           title: Center(
  //             child: Text(
  //               title!,
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w800,
  //                 color: inputFieldTextColor.value,
  //                 fontFamily: 'sfpro',
  //               ),
  //             ),
  //           ),
  //           content: Text(
  //             description!,
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontSize: 16,
  //               height: 1.4,
  //               color: inputFieldTextColor.value,
  //               fontFamily: 'sfpro',
  //             ),
  //           ),
  //           actionsAlignment: MainAxisAlignment.center,
  //           actions: <Widget>[
  //             Container(
  //               height: 38,
  //               padding: EdgeInsets.symmetric(horizontal: 12),
  //               decoration: BoxDecoration(
  //                 border: Border.all(width: 1, color: primaryColor.value),
  //                 borderRadius: BorderRadius.all(Radius.circular(8)),
  //               ),
  //               child: TextButton(
  //                 child: Text(
  //                   description.contains('delete') ? 'Cancel' : 'Skip',
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: inputFieldTextColor.value,
  //                     fontFamily: 'sfpro',
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ),
  //             SizedBox(width: 4),
  //             Container(
  //               height: 38,
  //               padding: EdgeInsets.symmetric(horizontal: 12),
  //               decoration: BoxDecoration(
  //                 color: primaryColor.value,
  //                 border: Border.all(width: 1, color: primaryColor.value),
  //                 borderRadius: BorderRadius.all(Radius.circular(8)),
  //               ),
  //               child: TextButton(
  //                 child: Text(
  //                   description.contains('delete') ? 'Delete' : "Enable",
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.white,
  //                     fontFamily: 'sfpro',
  //                   ),
  //                 ),
  //                 onPressed: () async {},
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static Widget loadingShimmer() {
  //   return Shimmer.fromColors(
  //     baseColor: Colors.black,
  //     highlightColor: Colors.white.withOpacity(0.75),
  //     child: Container(
  //       alignment: Alignment.centerLeft,
  //       width: 66,
  //       child: Text(
  //         'Loading...',
  //         style: TextStyle(
  //             fontSize: 14,
  //             fontFamily: 'sfpro',
  //             color: inputFieldTextColor.value),
  //         maxLines: 1,
  //       ),
  //     ),
  //   );
  // }

  // Widget appBar({
  //   bool? hasBack,
  //   String? title,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 30.0),
  //     child: Row(
  //       children: [
  //         if (hasBack != false)
  //           GestureDetector(
  //             onTap: () {
  //               Get.back();
  //             },
  //             child: Container(
  //               color: Colors.transparent,
  //               child: Icon(
  //                 Icons.arrow_back_ios,
  //                 color: lightColor,
  //               ),
  //             ),
  //           ),
  //         Container(
  //           padding: EdgeInsets.symmetric(vertical: 0),
  //           width: Get.width - (hasBack != false ? 105 : 65),
  //           child: Text(
  //             '$title',
  //             style: TextStyle(
  //                 fontFamily: 'sfpro',
  //                 fontStyle: FontStyle.normal,
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 26.0,
  //                 letterSpacing: 0.36,
  //                 color: lightColor),
  //             textAlign: TextAlign.center,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}

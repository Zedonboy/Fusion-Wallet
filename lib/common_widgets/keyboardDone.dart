import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../controllers/appController.dart';

class InputDoneView extends StatelessWidget {
  InputDoneView({Key? key}) : super(key: key);

  final appController = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Container(
          width: double.infinity,
          color: primaryBackgroundColor.value,
          child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: CupertinoButton(
                  padding: const EdgeInsets.only(
                      right: 24.0, top: 8.0, bottom: 8.0),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Text("Done",
                      style: TextStyle(color:labelColorPrimaryShade.value)
                  ),
                ),
              )
          )
      ),
    );
  }
}

class KeyboardOverlay {
  static OverlayEntry? _overlayEntry;

  static showOverlay(BuildContext context) {
    if(_overlayEntry != null) {
      return;
    }

    OverlayState? overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState!.insert(_overlayEntry!);
  }

  static removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}
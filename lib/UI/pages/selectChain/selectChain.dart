import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../common_widgets/commonWidgets.dart';

class SelectChain extends StatefulWidget {
  const SelectChain({Key? key, required this.onChainSelection})
      : super(key: key);
  final Function onChainSelection;

  @override
  State<SelectChain> createState() => _SelectChainState();
}

class _SelectChainState extends State<SelectChain> {
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
                    CommonWidgets()
                        .appBar(hasBack: true, title: 'Import Wallet'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Chain Selection',
                      style: TextStyle(
                        color: headingColor.value,
                        fontFamily: 'sfpro',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 26.0,
                        letterSpacing: 0.36,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Select your chain from the list below',
                      style: TextStyle(
                          fontFamily: 'sfpro',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          letterSpacing: 0.37,
                          color: labelColor.value),
                    ),
                    SizedBox(
                      height: 21,
                    ),
                    _chainSelectionRow(
                        network: 'Bitcoin', coin: 'BTC', imgName: 'btc'),
                    SizedBox(
                      height: 10,
                    ),
                    _chainSelectionRow(
                        network: 'Ethereum', coin: 'ETH', imgName: 'eth'),
                    SizedBox(
                      height: 10,
                    ),
                    _chainSelectionRow(
                        network: 'Binance Smart Chain',
                        coin: 'BSC',
                        imgName: 'bsc'),
                    SizedBox(
                      height: 10,
                    ),
                    _chainSelectionRow(
                        network: 'Tron', coin: 'TRX', imgName: 'tron'),
                    SizedBox(
                      height: 10,
                    ),
                    _chainSelectionRow(
                        network: 'Avalanche', coin: 'AVAX', imgName: 'avx'),
                    SizedBox(
                      height: 10,
                    ),
                    _chainSelectionRow(
                        network: 'Fantom', coin: 'FTM', imgName: 'ftm'),
                    SizedBox(
                      height: 10,
                    ),
                    _chainSelectionRow(
                        network: 'Optimism', coin: 'OP', imgName: 'op'),
                    SizedBox(
                      height: 10,
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

  Widget _chainSelectionRow({String? network, String? coin, String? imgName}) {
    return GestureDetector(
      onTap: () {
        widget.onChainSelection.call(network);
        Get.back();
      },
      child: Container(
        width: Get.width,
        height: 72,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: inputFieldBackgroundColor.value),
        padding: EdgeInsets.all(12),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/imgs/chains/$imgName.png',
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$network',
                        style: TextStyle(
                          fontFamily: 'sfpro',
                          color: headingColor.value,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          letterSpacing: 0.37,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '$coin',
                        style: TextStyle(
                          fontFamily: 'sfpro',
                          color: placeholderColor,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          letterSpacing: 0.44,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: placeholderColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

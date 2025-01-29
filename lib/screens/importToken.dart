import 'package:flutter/material.dart';
import 'package:fusion_wallet/common_widgets/bottomRectangularbtn.dart';
import 'package:fusion_wallet/common_widgets/commonWidgets.dart';
import 'package:fusion_wallet/common_widgets/inputField.dart';
import 'package:fusion_wallet/controllers/utils.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';

class ImportToken extends StatefulWidget {
  const ImportToken({super.key});

  @override
  State<ImportToken> createState() => _ImportTokenState();
}

class _ImportTokenState extends State<ImportToken> {
  final appController = Get.find<AppController>();
  TextEditingController addressController = TextEditingController();
  TextEditingController indexController = TextEditingController();

  var addressErr = ''.obs;
  var importLoader = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: primaryBackgroundColor.value,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width,
                      // height: 44,
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 32,
                              width: 32,
                              padding: EdgeInsets.all(6),
                              decoration: ShapeDecoration(
                                color: cardcolor.value,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          Text(
                            'Import ICRC Token',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 0.09,
                            ),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    InputFields(
                        headerText: "ICRC Canister Id",
                        hintText: "",
                        hasHeader: true,
                        textController: addressController,
                        onChange: (v) {
                          addressErr.value = '';
                        }),
                    CommonWidgets.showErrorMessage(addressErr.value),
                    SizedBox(
                      height: 12,
                    ),
                    InputFields(
                        headerText: "Index Canister Id (Optional)",
                        hintText: "",
                        hasHeader: true,
                        textController: indexController,
                        onChange: (v) {
                          addressErr.value = '';
                        }),
                    SizedBox(
                      height: 32,
                    )
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 48,
                      child: BottomRectangularBtn(
                          color: primaryColor.value,
                          buttonTextColor: textDarkColor.value,
                          onTapFunc: () {
                            verify();
                          },
                          isLoading: importLoader.value,
                          isDisabled: importLoader.value,
                          loadingText: 'Processing...',
                          btnTitle: 'Import'),
                    ),
                    SizedBox(
                      height: 32,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  verify() async {
    if (addressController.text.trim() == '') {
      addressErr.value = 'Please add token address';
    } else {
      importLoader.value = true;
      final icService = appController.ic_service!;
      final indexId = indexController.text.trim() == "" ? null : indexController.text;
      final ledgerId = addressController.text;
      try {
        final walletToken = await icService.getToken(canisterId: ledgerId, indexCanister: indexId);
        appController.addToken(walletToken);
        showToast("Imported successfully");
        
      } catch (e) {
        print(e.toString());
        // printError(info: e.toString(), logFunction: print);
        // showToast("Error trying to fetch token");

      }

      importLoader.value = false;
      
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // Map<String, Object> data = {
      //   "decimals": num.parse(decimalController.text),
      //   "balance": 0.0,
      //   "name": "${nameController.text}",
      //   "uri": "${imageController.text}",
      //   "symbol": "${symbolController.text}",
      //   "tokenAddress": "${addressController.text}"
      // };
      // appController.savedTokens.add(data);
      // final userEncode = jsonEncode(appController.savedTokens);
      // await prefs.setString('savedSplTokens', userEncode);
      Get.back(result: 'added');
    }
  }
}

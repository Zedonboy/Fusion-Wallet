import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:fusion_wallet/UI/pages/cryptoidentities/cryptoAccounts.dart';
import 'package:fusion_wallet/UI/pages/dappList/dappList.dart';
import 'package:get/get.dart';

import '/UI/pages/home/dashboard.dart';
import '/UI/pages/settings/settings.dart';
import '/UI/pages/swap/swap.dart';
import '/constants/colors.dart';
import '/constants/customIcons.dart';

import '../../controllers/appController.dart';

class BottomNavigationBar1 extends StatefulWidget {
  const BottomNavigationBar1({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBar1> createState() => _BottomNavigationBar1State();
}

class _BottomNavigationBar1State extends State<BottomNavigationBar1> {
  final appController = Get.find<AppController>();
  List<TabItem> items = [
    const TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    const TabItem(
      icon: Icons.api,
      title: 'Dapps',
    ),
    const TabItem(
      icon: CustomIcons.swap,
      title: 'Swap',
    ),
    const TabItem(
      icon: Icons.key,
      title: 'Identity',
    ),
    const TabItem(
      icon: Icons.settings,
      title: 'Settings',
    ),
  ];
  int visit = 0;
  double height = 30;
  Color colorSelect = const Color(0XFF462D81);
  Color color = const Color(0XFF462D81);
  Color color2 = const Color(0XFF462D81);
  Color bgColor = lightColor;
  List pages = [
    const Dashboard(),
    DappListScreen(),
    const Swap(),
    CryptoAccountsScreen(),
    const Settings()
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: BottomBarDefault(
          items: items,
          backgroundColor: cardColor.value,
          color: labelColor.value,
          colorSelected: primaryColor.value,
          indexSelected: visit,
          onTap: (int index) => setState(() {
            visit = index;
          }),
          animated: false,
        ),
        body: pages.elementAt(visit),
      ),
    );
  }
}

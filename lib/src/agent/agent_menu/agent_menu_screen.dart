import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/shared_Preference/preferences_helper.dart';
import 'package:gleeky_flutter/src/Auth/view/login.dart';
import 'package:gleeky_flutter/src/agent/bottom/agent.dart';
import 'package:gleeky_flutter/src/host/Main/main_screen.dart';
import 'package:gleeky_flutter/src/host/menu/view/become_an_agent/become_an_agent_screen.dart';
import 'package:gleeky_flutter/src/host/menu/view/kyc/kyc_screen.dart';
import 'package:gleeky_flutter/src/host/menu/view/profile/profile.dart';
import 'package:gleeky_flutter/src/host/setting/login_and_security_screen.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

import 'agent_transaction_screen.dart';

class AgentMenuScreen extends StatelessWidget {
  AgentMenuScreen({Key? key}) : super(key: key);

  List menuItems = [
    // {
    //   'img': AppImages.proMemberIcon,
    //   'name': 'Become A Pro Member',
    //   'screen': const WishListScreen()
    // },
    // {
    //   'img': AppImages.hostIcon,
    //   'name': 'Become A Host',
    //   'screen': const BecomeAnAgentScreen()
    // },
    {
      'img': AppImages.agentIcon,
      'name': 'Host Dashboard',
      'screen': const BecomeAnAgentScreen(),
    },

    {
      'img': AppImages.agent_dashboard_Icon,
      'name': 'My Dashboard',
    },

    {
      'img': AppImages.agent_properties_Icon,
      'name': 'Properties',
    },

    {
      'img': AppImages.transactionHistoryIcon,
      'name': 'Transaction History',
    },
    {'img': AppImages.hostIcon, 'name': 'KYC'},

    {
      'img': AppImages.profileIcon,
      'name': 'Profile',
      'screen': ProfileScreen(),
    },
    {
      'img': AppImages.loginSecurityIcon,
      'name': 'Login & Security',
      'screen': const LoginAndSecurityScreen()
    },
    /*  {'img': AppImages.hostIcon, 'name': 'KYC', 'screen': const KycScreen()},*/

    // {
    //   'img': AppImages.settingIcon,
    //   'name': 'setting',
    //   'screen': Setting_Screen(),
    // },

    {
      'img': AppImages.logoutIcon,
      'name': 'Logout',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        agentSelectedBottom.value = 0;
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 27, top: 17, left: 27),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        agentSelectedBottom.value = 0;
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Menu',
                          style: color00000s18w600,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0,
                      child: IgnorePointer(
                        ignoring: true,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        menuItems.length,
                        (index) => InkWell(
                          onTap: () {
                            index == 0
                                ? {
                                    selectedBottom.value = 0,
                                    Get.offAll(() => MainScreen()),
                                  }
                                : index == 1
                                    ? agentSelectedBottom.value = 0
                                    : index == 2
                                        ? agentSelectedBottom.value = 1
                                        : index == 3
                                            ? Get.to(() =>
                                                const AgentTransactionScreen())
                                            : index == 4
                                                ? Get.to(KycScreen())
                                                : index == 7
                                                    ? {
                                                        PrefController.to
                                                            .clear(),
                                                        PreferencesHelper()
                                                            .clearPreferenceData(),
                                                        Get.offAll(
                                                            () => const Login())
                                                      }
                                                    : Get.to(menuItems[index]
                                                        ['screen'] as Widget);
                          },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      menuItems[index]['img'],
                                      height: 28,
                                      width: 28,
                                      color: AppColors.color000000
                                          .withOpacity(0.5),
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.04,
                                    ),
                                    Expanded(
                                      child: Text(
                                        menuItems[index]['name'],
                                        style: color00000s13w600.copyWith(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: AppColors.color000000
                                          .withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                endIndent: 10,
                                indent: 10,
                                color: AppColors.color000000.withOpacity(0.1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

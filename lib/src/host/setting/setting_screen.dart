import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/src/host/setting/notification_setting.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

import 'login_and_security_screen.dart';
import 'payment_And_payouts_Screen.dart';

class Setting_Screen extends StatelessWidget {
  Setting_Screen({Key? key}) : super(key: key);

  List profileItem = [
    {
      'img': AppImages.loginSecurityIcon,
      'name': 'Login & Security',
      'screen': const LoginAndSecurityScreen()
    },
    {
      'img': AppImages.payoutIcon,
      'name': 'Payment & Payouts',
      'screen': PaymentAndPayoutScreen()
    },
    {
      'img': AppImages.notificationIcon,
      'name': 'Notification Setting',
      'screen': NotificationSettingScreen()
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 17),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Setting',
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
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      profileItem.length,
                      (index) => InkWell(
                        onTap: () {
                          Get.to(profileItem[index]['screen'] as Widget);
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    profileItem[index]['img'],
                                    height: 25,
                                    color: AppColors.color000000,
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.04,
                                  ),
                                  Expanded(
                                    child: Text(
                                      profileItem[index]['name'],
                                      style: color00000s13w600,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.02,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

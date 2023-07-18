import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/shared_Preference/preferences_helper.dart';
import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
import 'package:gleeky_flutter/src/Auth/view/login.dart';
import 'package:gleeky_flutter/src/agent/bottom/agent.dart';
import 'package:gleeky_flutter/src/host/Main/main_screen.dart';
import 'package:gleeky_flutter/src/host/add_property/view/hostScreen.dart';
import 'package:gleeky_flutter/src/host/menu/view/become_an_agent/become_an_agent_screen.dart';
import 'package:gleeky_flutter/src/host/menu/view/get_help/get_help_screen.dart';
import 'package:gleeky_flutter/src/host/setting/transaction_history.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import '../../setting/login_and_security_screen.dart';
import 'all_listing/all_listing_screen.dart';
import 'become_an_agent/become_host_screen.dart';
import 'hosting/hosting_screen.dart';
import 'kyc/kyc_screen.dart';
import 'notification/notification.dart';
import 'profile/profile.dart';
import 'reviews/reviews_about_you.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({Key? key}) : super(key: key);

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
      'name': user_model?.data?.isAgent.toString() == '1'
          ? 'Agent Dashboard'
          : 'Become An Agent',
      'screen': const BecomeAnAgentScreen(),
    },

    {
      'img': AppImages.bookingIcon,
      'name': 'My Dashboard',
    },
    {
      'img': AppImages.createListingIcon,
      'name': 'Create A New Listing',
      'screen': HostScreen()
    },
    {
      'img': AppImages.menuIcon,
      'name': 'All Listings',
      'screen': AllListingScreen(
        type: 'All',
      )
    },
    /* {
      'img': AppImages.wishlistIcon,
      'name': 'Wishlist',
      'screen': const WishListScreen()
    },*/
    {'img': AppImages.insightIcon, 'name': 'Insight'},
    {
      'img': AppImages.transactionHistoryIcon,
      'name': 'Transaction History',
      'screen': const TransactionHistoryScreen()
    },
    {
      'img': AppImages.reviews_Icon,
      'name': 'Reviews About You',
      'screen': const ReviewsAboutYou()
    },
    {'img': AppImages.hostIcon, 'name': 'KYC', 'screen': KycScreen()},
    {
      'img': AppImages.notificationIcon,
      'name': 'Notification',
      'screen': NotificationScreen()
    },
    // {
    //   'img': AppImages.settingIcon,
    //   'name': 'setting',
    //   'screen': Setting_Screen(),
    // },
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
    /*{
      'img': AppImages.paymentIcon,
      'name': 'Payment Method',
      'screen': PaymentAndPayoutScreen()
    },*/

    {
      'img': AppImages.helpIcon,
      'name': 'Support',
      'screen': GetHelpScreen(),
    },
    {
      'img': AppImages.logoutIcon,
      'name': 'Logout',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        selectedBottom.value = 0;
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
                        selectedBottom.value = 0;
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: InkWell(
                    onTap: () {
                      Get.to(
                        () => const HostingScreen(),
                      );
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.color000000.withOpacity(0.05),
                            spreadRadius: 5,
                            blurRadius: 5,
                          ),
                        ],
                        color: AppColors.colorffffff,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pending Listing',
                            style: color00000s13w600,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
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
                                    if (user_model?.data?.isAgent.toString() ==
                                        '1')
                                      {
                                        agentSelectedBottom.value = 0,
                                        user_model?.data?.isAgent.toString() ==
                                                '1'
                                            ? Get.offAll(
                                                () => AgentMainScreen())
                                            : Get.to(
                                                () => const BecomeHostScreen()),
                                      }
                                    else
                                      {
                                        Get.to(() => KycScreen(
                                              isAgent: true,
                                            ))
                                      }
                                  }
                                : index == 1
                                    ? selectedBottom.value = 0
                                    : index == 2
                                        ? {
                                            // loaderShow(context),
                                            Get.to(menuItems[index]['screen']
                                                as Widget)
                                            // MenuScreenController.to
                                            //     .getStartHostApi(
                                            //         params: {
                                            //       'user_id': PrefController
                                            //           .to.user_id.value
                                            //     },
                                            //         error: (e) {
                                            //           loaderHide();

                                            //           showSnackBar(
                                            //               title:
                                            //                   ApiConfig.error,
                                            //               message:
                                            //                   e.toString());
                                            //           log(e.toString());
                                            //         },
                                            //         success: () {
                                            //           loaderHide();
                                            //         })
                                          }
                                        : index == 4
                                            ? selectedBottom.value = 1
                                            : index == 8
                                                ? selectedBottom.value = 2
                                                : index == 12
                                                    ? {
                                                        PrefController.to
                                                            .clear(),
                                                        log(
                                                            PrefController
                                                                .to.token.value,
                                                            name:
                                                                'NOTIFICATION TAP'),
                                                        PrefController.to
                                                            .refresh(),
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
                                  vertical: 10,
                                  horizontal: 8,
                                ),
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

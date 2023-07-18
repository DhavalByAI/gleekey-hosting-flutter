import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/services/firebase_pushNotification_service.dart';
import 'package:gleeky_flutter/src/host/dash_board/view/dashBoard_screen.dart';
import 'package:gleeky_flutter/src/host/insight/view/insight_screen.dart';
import 'package:gleeky_flutter/src/host/menu/view/menu_Screen.dart';
import 'package:gleeky_flutter/src/host/menu/view/notification/notification.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

RxInt selectedBottom = 0.obs;

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  initState() {
    PushNotificationService().setUpInterractedMassage();

    super.initState();
  }

  List screens = [
    {
      'screen': const DashBoardScreen(),
      'img': AppImages.houseIcon,
      'name': 'Home',
    },
    /* {
      'screen': BookingScreen(),
      'img': AppImages.calendarIcon,
      'name': 'Booking'
    },*/
    {
      'screen': InsightScreen(),
      'img': AppImages.insightIcon,
      'name': 'Insight',
    },
    {
      'screen': NotificationScreen(),
      'img': AppImages.notificationIcon,
      'name': 'Notification'
    },
    {
      'screen': MenuScreen(),
      'img': AppImages.menuIcon,
      'name': 'Menu',
    },
  ];

  List selectedIcons = [
    AppImages.selectedHomeIcon,
    // AppImages.selectedInboxIcon,
    // AppImages.selectedBookingIcon,
    AppImages.selectedInsightIcon,
    AppImages.notificationIcon,
    AppImages.selectedMenuIcon,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CommonBottomBar(
        child: StreamBuilder(
          stream: selectedBottom.stream,
          builder: (context, snapshot) {
            return Row(
              children: List.generate(
                screens.length,
                (index) => Expanded(
                  child: InkWell(
                    onTap: () {
                      selectedBottom.value = index;
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        selectedBottom.value == index
                            ? Image.asset(
                                selectedIcons[selectedBottom.value],
                                height: 22,
                                color: selectedBottom.value == index
                                    ? AppColors.colorFE6927
                                    : AppColors.color000000.withOpacity(0.3),
                              )
                            : Image.asset(
                                screens[index]['img'],
                                height: 22,
                                color: selectedBottom.value == index
                                    ? AppColors.colorFE6927
                                    : AppColors.color000000.withOpacity(0.3),
                              ),
                        const SizedBox(height: 8),
                        Text(
                          screens[index]['name'],
                          style: selectedBottom.value == index
                              ? colorFE6927s12w600
                              : colorFE6927s12w600.copyWith(
                                  color: AppColors.color000000.withOpacity(0.3),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: StreamBuilder(
        stream: selectedBottom.stream,
        builder: (context, snapshot) {
          return screens[selectedBottom.value]['screen'];
        },
      ),
    );
  }
}

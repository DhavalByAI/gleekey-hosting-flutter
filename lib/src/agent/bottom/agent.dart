import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/src/agent/agent_dashboard/agent_dashboard.dart';
import 'package:gleeky_flutter/src/agent/agent_menu/agent_menu_screen.dart';
import 'package:gleeky_flutter/src/agent/agent_userBooking/agent_user_booking.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

import '../agent_properties/agent_properties.dart';

RxInt agentSelectedBottom = 0.obs;

class AgentMainScreen extends StatelessWidget {
  AgentMainScreen({Key? key}) : super(key: key);

  List screens = [
    {
      'screen': const AgentDashboard(),
      'img': AppImages.agent_dashboard_Icon,
      'name': 'Dashboard',
    },
    // {'screen': InboxScreen(), 'img': AppImages.inboxIcon, 'name': 'Inbox'},
    {
      'screen': const AgentProperties(),
      'img': AppImages.agent_properties_Icon,
      'name': 'Properties',
    },
    {
      'screen': const AgentUserBookingScreen(),
      'img': AppImages.agent_booking_Icon,
      'name': 'Booking'
    },

    {
      'screen': AgentMenuScreen(),
      'img': AppImages.menuIcon,
      'name': 'Menu',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CommonBottomBar(
        child: StreamBuilder(
            stream: agentSelectedBottom.stream,
            builder: (context, snapshot) {
              return Row(
                children: List.generate(
                  screens.length,
                  (index) => Expanded(
                    child: InkWell(
                      onTap: () {
                        agentSelectedBottom.value = index;
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            screens[index]['img'],
                            height: 22,
                            color: agentSelectedBottom.value == index
                                ? AppColors.colorFE6927
                                : AppColors.color000000.withOpacity(0.3),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            screens[index]['name'],
                            style: agentSelectedBottom.value == index
                                ? colorFE6927s12w600
                                : colorFE6927s12w600.copyWith(
                                    color:
                                        AppColors.color000000.withOpacity(0.3)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
      body: StreamBuilder(
          stream: agentSelectedBottom.stream,
          builder: (context, snapshot) {
            return screens[agentSelectedBottom.value]['screen'];
          }),
    );
  }
}

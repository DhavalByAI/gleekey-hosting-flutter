import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/src/host/Main/main_screen.dart';
import 'package:gleeky_flutter/src/host/menu/controller/notification_controller.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  RxBool notification = true.obs;
  final ScrollController _scrollController = ScrollController();

  List tabs = [
    /*'Reviews About You',*/ 'Glee Notification',
    'General Notifications',
  ];

  RxInt selectedTab = 0.obs;
  RxBool showCircle = false.obs;
  RxInt offset = 1.obs;

  @override
  void initState() {
    // TODO: implement initState

    NotificationController.to.notificationList.clear();
    NotificationController.to.getNotificationApi(
        params: {'page': offset.value, 'limit': 10},
        success: () {
          notification.value = false;
        },
        error: (e) {
          showSnackBar(title: ApiConfig.error, message: e.toString());
        });

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        showCircle.value = true;
        NotificationController.to.getNotificationApi(
            params: {'page': offset.value, 'limit': 10},
            success: () {
              showCircle.value = false;
              offset.value = offset.value + 1;
            },
            error: (e) {
              showSnackBar(title: ApiConfig.error, message: e.toString());
            });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        selectedBottom.value = 0;
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Obx(() {
          return showCircle.value
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      CupertinoActivityIndicator(color: AppColors.colorFE6927),
                )
              : const SizedBox();
        }),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 17, left: 27, right: 27),
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
                          'Notification',
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
                  height: 15,
                ),
                Obx(() {
                  return Row(
                    children: List.generate(
                        tabs.length,
                        (index) => Expanded(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  selectedTab.value = index;
                                  NotificationController.to.notificationList
                                      .clear();
                                  notification.value = true;
                                  offset.value = 1;
                                  if (index == 0) {
                                    NotificationController.to
                                        .getNotificationApi(
                                            params: {
                                          'page': offset.value,
                                          'limit': 10,
                                        },
                                            success: () {
                                              notification.value = false;
                                            },
                                            error: (e) {
                                              showSnackBar(
                                                  title: ApiConfig.error,
                                                  message: e.toString());
                                            });
                                  } else {
                                    NotificationController.to
                                        .getNotificationApi(
                                            params: {
                                          'page': offset.value,
                                          'limit': 10,
                                        },
                                            success: () {
                                              notification.value = false;
                                            },
                                            error: (e) {
                                              showSnackBar(
                                                  title: ApiConfig.error,
                                                  message: e.toString());
                                            });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: selectedTab.value == index
                                        ? AppColors.colorFE6927
                                        : Colors.transparent,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 18,
                                  ),
                                  child: Center(
                                    child: Text(tabs[index],
                                        style: selectedTab.value == index
                                            ? colorfffffffs13w600.copyWith(
                                                fontWeight: FontWeight.w400)
                                            : colorfffffffs13w600.copyWith(
                                                color: AppColors.color000000
                                                    .withOpacity(0.5),
                                                fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ),
                            )),
                  );
                }),
                const SizedBox(
                  height: 15,
                ),
                Obx(() {
                  return notification.value
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: Shimmer.fromColors(
                              baseColor: AppColors.colorD9D9D9.withOpacity(0.2),
                              highlightColor: AppColors.colorD9D9D9,
                              child: Column(
                                children: List.generate(
                                  5,
                                  (index) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColors.colorFE6927,
                                                  width: 2,
                                                ),
                                              ),
                                              padding: const EdgeInsets.all(5),
                                              child: Center(
                                                child: Image.asset(
                                                  AppImages.gleekeyIcon,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Title Notification',
                                                    style: color50perBlacks13w400
                                                        .copyWith(
                                                            color: AppColors
                                                                .color000000,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            height: 0),
                                                  ),
                                                  Text(
                                                    'Discription of Notification',
                                                    style: color50perBlacks13w400
                                                        .copyWith(
                                                            color: AppColors
                                                                .color000000,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Divider(
                                          color: AppColors.color000000
                                              .withOpacity(0.2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : (NotificationController.to.notificationList.length ==
                                  0 ||
                              NotificationController
                                  .to.getNotificationRes.isEmpty)
                          ? Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    color: AppColors.colorD9D9D9,
                                    borderRadius: BorderRadius.circular(15)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 40, horizontal: 50),
                                child: Text(
                                  'Notification Box is Empty!',
                                  style: color00000s14w500,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Expanded(
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  children: List.generate(
                                    NotificationController
                                        .to.notificationList.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color:
                                                        AppColors.colorFE6927,
                                                    width: 2,
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Center(
                                                  child: Image.asset(
                                                    AppImages.gleekeyIcon,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      NotificationController.to
                                                              .notificationList[
                                                          index]['title'],
                                                      style: color50perBlacks13w400
                                                          .copyWith(
                                                              color: AppColors
                                                                  .color000000,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 0),
                                                    ),
                                                    Text(
                                                      NotificationController.to
                                                              .notificationList[
                                                          index]['description'],
                                                      style: color50perBlacks13w400.copyWith(
                                                          color: ((NotificationController
                                                                              .to
                                                                              .notificationList[index]
                                                                          ?[
                                                                          'is_read'] ??
                                                                      0) ==
                                                                  1)
                                                              ? AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5)
                                                              : AppColors
                                                                  .color000000,
                                                          fontWeight: ((NotificationController
                                                                              .to
                                                                              .notificationList[index]
                                                                          ?['is_read'] ??
                                                                      0) ==
                                                                  1)
                                                              ? FontWeight.w400
                                                              : FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircleAvatar(
                                                radius: 4,
                                                backgroundColor:
                                                    ((NotificationController.to
                                                                            .notificationList[
                                                                        index]?[
                                                                    'is_read'] ??
                                                                0) ==
                                                            1)
                                                        ? Colors.transparent
                                                        : AppColors.colorFE6927,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Divider(
                                            color: AppColors.color000000
                                                .withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

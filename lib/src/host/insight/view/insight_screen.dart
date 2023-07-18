import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/src/host/Main/main_screen.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/dashboard_controller.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/view_property_controller.dart';
import 'package:gleeky_flutter/src/host/dash_board/view/acceptAndDeclineScreen.dart';
import 'package:gleeky_flutter/src/host/dash_board/view/all_reservation_screen.dart';
import 'package:gleeky_flutter/src/host/dash_board/view/property_detail_screen.dart';
import 'package:gleeky_flutter/src/host/dash_board/view/view_receipt_screen.dart';
import 'package:gleeky_flutter/src/host/setting/transaction_history.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/chart/barchart.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:shimmer/shimmer.dart';
import '../../setting/controller/transaction_history_controller.dart';
import '../controller/insight_controller.dart';

class InsightScreen extends StatefulWidget {
  InsightScreen({Key? key}) : super(key: key);

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  List tabs = [/*'Reviews About You',*/ 'Bookings', 'Earnings', 'Views'];
  List reviewsbyYouTab = [
    'Write Review',
    'Past Review',
    'Expired Review',
  ];
  RxBool isShimmer = true.obs;
  RxInt selectedTab = 0.obs;
  RxInt selectedReviewTab = 0.obs;

  TextEditingController _hostSendMessage = TextEditingController();
  TextEditingController _describeExperience = TextEditingController();
  TextEditingController _aboutStaying = TextEditingController();
  TextEditingController _howCanImprove = TextEditingController();
  TextEditingController _accuracy = TextEditingController();
  TextEditingController _cleanliness = TextEditingController();
  TextEditingController _arrival = TextEditingController();
  TextEditingController _amenities = TextEditingController();
  TextEditingController _communication = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _value = TextEditingController();
  RxInt overallExperience = 0.obs;
  RxInt accuracyRating = 0.obs;
  RxInt cleanlinessRating = 0.obs;
  RxInt arrivalRating = 0.obs;
  RxInt amenitiesRating = 0.obs;
  RxInt communicationRating = 0.obs;
  RxInt locationRating = 0.obs;
  RxInt valueRating = 0.obs;

  @override
  void initState() {
    // TODO: implement initState
    /*InsightController.to.insightApi(
        params: {'offset': 0, "limit": 10},
        query: {'type': 'reviewsAboutYou'},
        success: () {
          isShimmer.value = false;
        },
        error: (e) {
          isShimmer.value = false;
        });*/
    DashBoardController.to.reservationApi(
        params: {'offset': '0', "limit": "10"},
        success: () {
          isShimmer.value = false;
        },
        error: (e) {
          showSnackBar(title: ApiConfig.error, message: e.toString());
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 22, left: 22, top: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          'Insight',
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
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(() {
                    return Row(
                      children: List.generate(
                          tabs.length,
                          (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    selectedTab.value = index;
                                    InsightController.to.insightApiResponse
                                        .clear();
                                    isShimmer.value = true;

                                    if (selectedTab.value == 0) {
                                      DashBoardController.to.reservationApi(
                                          params: {
                                            'offset': '0',
                                            "limit": "10"
                                          },
                                          success: () {
                                            isShimmer.value = false;
                                          },
                                          error: (e) {
                                            showSnackBar(
                                                title: ApiConfig.error,
                                                message: e.toString());
                                          });
                                      /*InsightController.to.insightApi(
                                          params: {'offset': 0, "limit": 10},
                                          query: {'type': 'reviewsAboutYou'},
                                          success: () {
                                            isShimmer.value = false;
                                            loaderHide();
                                          },
                                          error: (e) {
                                            isShimmer.value = false;

                                            loaderHide();
                                          });*/
                                    } /*else if (selectedTab.value == 1) {
                                      InsightController.to.insightApi(
                                          params: {'offset': 0, "limit": 10},
                                          query: {'type': 'reviewsByYou'},
                                          success: () {
                                            isShimmer.value = false;
                                            loaderHide();
                                            InsightController.to.reviewsToWrite
                                                .value = InsightController
                                                        .to.insightApiResponse[
                                                    'data']['reviewsToWrite'] ??
                                                [];
                                            InsightController.to.reviewsByYou
                                                .value = InsightController
                                                        .to.insightApiResponse[
                                                    'data']['reviewsByYou'] ??
                                                [];
                                            InsightController.to.expiredReviews
                                                .value = InsightController
                                                        .to.insightApiResponse[
                                                    'data']['expiredReviews'] ??
                                                [];
                                          },
                                          error: (e) {
                                            isShimmer.value = false;

                                            loaderHide();
                                          });
                                    }*/
                                    else if (selectedTab.value == 1) {
                                      InsightController.to.insightApi(
                                          params: {'offset': 0, "limit": 10},
                                          query: {'type': 'earnings'},
                                          success: () {
                                            TransactionHistoryControlller
                                                .to.transactionHistoryData
                                                .clear();
                                            TransactionHistoryControlller.to
                                                .transactionHistoryApi(
                                              params: {
                                                'page': 0,
                                                "limit": 5,
                                              },
                                              success: () {
                                                isShimmer.value = false;
                                              },
                                            );
                                          },
                                          error: (e) {
                                            isShimmer.value = false;
                                          });
                                    } else if (selectedTab.value == 2) {
                                      InsightController.to.insightApi(
                                          params: {'offset': 0, "limit": 10},
                                          query: {'type': 'views'},
                                          success: () {
                                            isShimmer.value = false;
                                          },
                                          error: (e) {
                                            isShimmer.value = false;
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
                                        vertical: 10, horizontal: 18),
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
                              )),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    endIndent: 10,
                    indent: 10,
                    color: AppColors.color000000.withOpacity(0.1),
                  ),
                ),
                Obx(() {
                  return selectedTab.value == 0
                      ? bookingsView() /*reviewsAboutYouView()*/
                      : /*selectedTab.value == 1
                          ? reviewsbyYouView()
                          :*/
                      selectedTab.value == 1
                          ? earningView()
                          : viewsView();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded viewsView() {
    return Expanded(
      child: SingleChildScrollView(
        child: isShimmer.value
            ? Shimmer.fromColors(
                baseColor: AppColors.colorD9D9D9.withOpacity(0.2),
                highlightColor: AppColors.colorD9D9D9,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.color000000.withOpacity(0.2),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Column(
                            children: [
                              Text(
                                '195',
                                style: color00000s15w600,
                              ),
                              Text(
                                'View Past 30 Days',
                                style:
                                    color50perBlacks13w400.copyWith(height: 0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),

                    ///chart
                    SizedBox(
                      height: 250,
                      width: Get.width,
                      child: const LineChartDemo(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.colorFE6927,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Text(
                          'View',
                          style: color00000s14w500,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.color000000.withOpacity(0.2),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Column(
                          children: [
                            Text(
                              (InsightController.to.insightApiResponse['data']
                                          ?['total_views'] ??
                                      '0')
                                  .toString(),
                              style: color00000s15w600,
                            ),
                            Text(
                              'View Past 30 Days',
                              style: color50perBlacks13w400.copyWith(height: 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),

                  ///chart
                  SizedBox(
                    height: 250,
                    width: Get.width,
                    child: const LineChartDemo(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.colorFE6927,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Text(
                        'View',
                        style: color00000s14w500,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
      ),
    );
  }

  Expanded earningView() {
    return Expanded(
      child: SingleChildScrollView(
        child: isShimmer.value
            ? Shimmer.fromColors(
                baseColor: AppColors.colorD9D9D9.withOpacity(0.2),
                highlightColor: AppColors.colorD9D9D9,
                child: Column(
                  children: [
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(6),
                    //     border: Border.all(
                    //       color: AppColors.color000000.withOpacity(0.2),
                    //     ),
                    //   ),
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: DropdownButton<String>(
                    //     value: 'A',
                    //     underline: const SizedBox(),
                    //     borderRadius: BorderRadius.circular(6),
                    //     style: color00000s14w500,
                    //     isExpanded: true,
                    //     icon: Icon(Icons.keyboard_arrow_down_rounded,
                    //         size: 20, color: AppColors.color000000),
                    //     items: <String>['A', 'B', 'C', 'D'].map((String value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value, style: color00000s14w500),
                    //       );
                    //     }).toList(),
                    //     onChanged: (_) {},
                    //   ),
                    // ),
                    const SizedBox(
                      height: 35,
                    ),

                    ///chart
                    SizedBox(
                      height: 270,
                      width: Get.width,
                      child: const BarchartDemo(),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.colorFE6927,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Text(
                          'Earnings',
                          style: color00000s14w500,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonButton(
                      width: Get.width / 2,
                      onPressed: () {
                        Get.to(() => const TransactionHistoryScreen());
                      },
                      name: 'Show Transaction History',
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(6),
                  //     border: Border.all(
                  //       color: AppColors.color000000.withOpacity(0.2),
                  //     ),
                  //   ),
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: DropdownButton<String>(
                  //     value: 'A',
                  //     underline: const SizedBox(),
                  //     borderRadius: BorderRadius.circular(6),
                  //     style: color00000s14w500,
                  //     isExpanded: true,
                  //     icon: Icon(Icons.keyboard_arrow_down_rounded,
                  //         size: 20, color: AppColors.color000000),
                  //     items: <String>['A', 'B', 'C', 'D'].map((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         child: Text(value, style: color00000s14w500),
                  //       );
                  //     }).toList(),
                  //     onChanged: (_) {},
                  //   ),
                  // ),
                  const SizedBox(
                    height: 35,
                  ),

                  ///chart
                  SizedBox(
                    height: 270,
                    width: Get.width,
                    child: const BarchartDemo(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.colorFE6927,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Text(
                        'Earnings ${InsightController.to.insightApiResponse['data_year']}',
                        style: color00000s14w500,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Divider(
                    color: AppColors.color000000.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Transaction History',
                    style: colorfffffffs13w600.copyWith(
                        fontSize: 20, color: AppColors.color000000),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: AppColors.color000000.withOpacity(0.5),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () {
                      return TransactionHistoryControlller
                              .to.transactionHistoryResponse.isEmpty
                          ? Column(
                              children: List.generate(
                                5,
                                (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: AppColors
                                                      .colorD9D9D9
                                                      .withOpacity(0.2),
                                                  highlightColor:
                                                      AppColors.colorD9D9D9,
                                                  child: Container(
                                                    height: 20,
                                                    color:
                                                        AppColors.colorF8F8F8,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: AppColors
                                                      .colorD9D9D9
                                                      .withOpacity(0.2),
                                                  highlightColor:
                                                      AppColors.colorD9D9D9,
                                                  child: Container(
                                                    height: 20,
                                                    color:
                                                        AppColors.colorF8F8F8,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: AppColors
                                                      .colorD9D9D9
                                                      .withOpacity(0.2),
                                                  highlightColor:
                                                      AppColors.colorD9D9D9,
                                                  child: Container(
                                                      height: 20,
                                                      color: AppColors
                                                          .colorF8F8F8),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: AppColors
                                                      .colorD9D9D9
                                                      .withOpacity(0.2),
                                                  highlightColor:
                                                      AppColors.colorD9D9D9,
                                                  child: Container(
                                                      height: 20,
                                                      color: AppColors
                                                          .colorF8F8F8),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Amount',
                                                  style: color00000s15w600,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: AppColors
                                                      .colorD9D9D9
                                                      .withOpacity(0.2),
                                                  highlightColor:
                                                      AppColors.colorD9D9D9,
                                                  child: Container(
                                                      height: 20,
                                                      color: AppColors
                                                          .colorF8F8F8),
                                                ),
                                              ],
                                            ),
                                          ),
                                          /*   Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Paidout',
                                                  style: color00000s15w600,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: AppColors
                                                      .colorD9D9D9
                                                      .withOpacity(0.2),
                                                  highlightColor:
                                                      AppColors.colorD9D9D9,
                                                  child: Container(
                                                      height: 20,
                                                      color: AppColors
                                                          .colorF8F8F8),
                                                ),
                                              ],
                                            ),
                                          ),*/
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : (TransactionHistoryControlller
                                      .to.transactionHistoryData.value.length ==
                                  0)
                              ? Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Container(
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: AppColors.colorD9D9D9,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 40,
                                      horizontal: 50,
                                    ),
                                    child: Text(
                                      'No data available',
                                      style: color00000s14w500,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: List.generate(
                                    TransactionHistoryControlller
                                        .to.transactionHistoryData.value.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Date : ',
                                                          style:
                                                              color00000s15w600,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            TransactionHistoryControlller
                                                                        .to
                                                                        .transactionHistoryData
                                                                        .value[index]
                                                                    ?[
                                                                    'created_at'] ??
                                                                '-',
                                                            style:
                                                                color50perBlacks13w400
                                                                    .copyWith(
                                                                        height:
                                                                            0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Type : ',
                                                          style:
                                                              color00000s15w600,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            TransactionHistoryControlller
                                                                        .to
                                                                        .transactionHistoryData
                                                                        .value[index]
                                                                    ?[
                                                                    'booking_type'] ??
                                                                '-',
                                                            style:
                                                                color50perBlacks13w400
                                                                    .copyWith(
                                                                        height:
                                                                            0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Status : ',
                                                          style:
                                                              color00000s15w600,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (TransactionHistoryControlller
                                                                            .to
                                                                            .transactionHistoryData[index]
                                                                        ?[
                                                                        'status'] ??
                                                                    '')
                                                                .toString(),
                                                            style:
                                                                color50perBlacks13w400
                                                                    .copyWith(
                                                                        height:
                                                                            0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'ID : ',
                                                          style:
                                                              color00000s15w600,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (TransactionHistoryControlller
                                                                            .to
                                                                            .transactionHistoryData
                                                                            .value[index]
                                                                        ?[
                                                                        'id'] ??
                                                                    '-')
                                                                .toString(),
                                                            style:
                                                                color50perBlacks13w400
                                                                    .copyWith(
                                                                        height:
                                                                            0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'Amount',
                                                      style: color00000s15w600,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '₹ ${(TransactionHistoryControlller.to.transactionHistoryData.value[index]['amount'] ?? '-').toString()}',
                                                      style: color32BD01s15w700
                                                          .copyWith(
                                                              color: (TransactionHistoryControlller
                                                                              .to
                                                                              .transactionHistoryData[index]
                                                                          [
                                                                          'status'] ==
                                                                      'Pending')
                                                                  ? AppColors
                                                                      .colorffc107
                                                                  : (TransactionHistoryControlller.to.transactionHistoryData[index]
                                                                              [
                                                                              'status'] ==
                                                                          'Paid')
                                                                      ? AppColors
                                                                          .color32BD01
                                                                      : (TransactionHistoryControlller.to.transactionHistoryData[index]['status'] ==
                                                                              'Rejected')
                                                                          ? AppColors
                                                                              .color9a0400
                                                                          : AppColors
                                                                              .colorFE6927),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              /*Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'Paidout',
                                                      style: color00000s15w600,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      (TransactionHistoryControlller
                                                                          .to
                                                                          .transactionHistoryData[
                                                                      index][
                                                                  'pay_mode']) ==
                                                              'Debit'
                                                          ? '₹ ${(TransactionHistoryControlller.to.transactionHistoryData.value[index]['amount'] ?? '-')}'
                                                          : '',
                                                      style: color32BD01s15w700
                                                          .copyWith(
                                                        color: AppColors
                                                            .color9a0400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),*/
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(
                                            color: AppColors.color000000
                                                .withOpacity(0.2),
                                            indent: 10,
                                            endIndent: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  CommonButton(
                    width: Get.width / 2,
                    onPressed: () {
                      Get.to(() => const TransactionHistoryScreen());
                    },
                    name: 'Show More',
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
      ),
    );
  }

  /* Expanded reviewsAboutYouView() {
    return Expanded(
      child: SingleChildScrollView(
        child: isShimmer.value
            ? Shimmer.fromColors(
                baseColor: AppColors.colorD9D9D9.withOpacity(0.2),
                highlightColor: AppColors.colorD9D9D9,
                child: Column(
                  children: List.generate(
                    5,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 8),
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: AppColors.colorffffff,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 5,
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      AppImages.villaImg,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Gleekey Resort',
                                    style: color000000s12w400,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 20,
                                              backgroundColor:
                                                  AppColors.colorE6E6E6,
                                              backgroundImage: const AssetImage(
                                                'assets/images/profile.png',
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Text(
                                                'Lorem Ipsum',
                                                style: color000000s12w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '2 years ago',
                                        style: color000000s12w400,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Lorem Ipsum is simply dummy text of the printing and typesetting Lorem Ipsum has been the industry\'s standard dummy text ever since the ',
                                    style: color50perBlacks13w400,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      */ /* Get.to(
                                        () => const ReviewScreen(
                                          title: 'Gleekey Resort',
                                        ),
                                      );*/ /*
                                    },
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: Text(
                                      'View Details',
                                      style: colorFE6927s12w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : InsightController.to.insightApiResponse['status'] == false
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: AppColors.colorD9D9D9,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 50,
                      ),
                      child: Column(
                        children: [
                          Text(
                            InsightController.to.insightApiResponse['message']
                                .toString(),
                            style: color00000s14w500,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: List.generate(
                      InsightController.to
                          .insightApiResponse['data']['reviewsAboutYou'].length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 8),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: AppColors.colorffffff,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: InsightController
                                                        .to.insightApiResponse[
                                                    'data']['reviewsAboutYou'][
                                                index]?['cover_photo_photos'] ??
                                            '',
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(
                                          color: AppColors.colorFE6927,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error,
                                        ),
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      InsightController.to.insightApiResponse[
                                                  'data']['reviewsAboutYou']
                                              [index]?['property_name'] ??
                                          '',
                                      style: color00000s13w600,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: CachedNetworkImage(
                                                  imageUrl: InsightController.to
                                                                      .insightApiResponse[
                                                                  'data'][
                                                              'reviewsAboutYou'][index]
                                                          ?[
                                                          'user_profile_image'] ??
                                                      '',
                                                  placeholder: (context, url) =>
                                                      CupertinoActivityIndicator(
                                                    color:
                                                        AppColors.colorFE6927,
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(
                                                    Icons.error,
                                                  ),
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  InsightController.to.insightApiResponse[
                                                                  'data'][
                                                              'reviewsAboutYou']
                                                          [
                                                          index]?['user_name'] ??
                                                      '',
                                                  style: color000000s12w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          InsightController
                                                          .to.insightApiResponse[
                                                      'data']['reviewsAboutYou']
                                                  [index]?['post_date'] ??
                                              '',
                                          style: color000000s12w400,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      InsightController.to.insightApiResponse[
                                                  'data']['reviewsAboutYou']
                                              [index]?['message'] ??
                                          '',
                                      style: color50perBlacks13w400,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            log((InsightController.to
                                                                    .insightApiResponse[
                                                                'data']
                                                            ?['reviewsAboutYou']
                                                        [index] ??
                                                    {})
                                                .toString());
                                            Get.to(
                                              () => ReviewScreen(
                                                data: InsightController.to
                                                                    .insightApiResponse[
                                                                'data']
                                                            ?['reviewsAboutYou']
                                                        [index] ??
                                                    {},
                                              ),
                                            );
                                          },
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          child: Text(
                                            'View Details',
                                            style: colorFE6927s12w600,
                                          ),
                                        ),
                                        CommonButton(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                //context: _scaffoldKey.currentContext,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 12,
                                                      vertical: 12,
                                                    ),
                                                    scrollable: true,
                                                    title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Reply To ${InsightController.to.insightApiResponse['data']['reviewsAboutYou'][index]?['user_name'] ?? ''}',
                                                            style:
                                                                color00000s18w600,
                                                          ),
                                                          InkWell(
                                                              onTap: () {
                                                                Get.back();
                                                              },
                                                              child: const Icon(
                                                                Icons.close,
                                                              ))
                                                        ]),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20.0),
                                                      ),
                                                    ),
                                                    content: SizedBox(
                                                      width: Get.width,
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    'Your Message',
                                                                    style:
                                                                        color00000s15w600),
                                                                TextFormField(
                                                                  controller:
                                                                      _hostSendMessage,
                                                                  cursorColor:
                                                                      AppColors
                                                                          .colorFE6927,
                                                                  maxLines: 3,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        'Type Here...',
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .always,
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6.0),
                                                                      borderSide:
                                                                          BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: AppColors
                                                                            .color000000
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6.0),
                                                                      borderSide:
                                                                          BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: AppColors
                                                                            .color000000
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                    ),
                                                                    contentPadding:
                                                                        const EdgeInsets.all(
                                                                            13.0),
                                                                  ),
                                                                ),
                                                                Divider(
                                                                  endIndent: 10,
                                                                  indent: 10,
                                                                  color: AppColors
                                                                      .color000000
                                                                      .withOpacity(
                                                                          0.1),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          CommonButton(
                                                            onPressed: () {
                                                              if (_hostSendMessage
                                                                  .text
                                                                  .isEmpty) {
                                                                showSnackBar(
                                                                  title:
                                                                      ApiConfig
                                                                          .error,
                                                                  message:
                                                                      'Message should not be Empty!',
                                                                );
                                                              }
                                                            },
                                                            name: 'Send',
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.reply_rounded,
                                                  size: 25,
                                                  color: AppColors.colorffffff,
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  'Reply',
                                                  style: colorfffffffs13w600,
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }*/
  Widget bookingsView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Bookings',
                  style: color00000s18w600,
                ),
                (DashBoardController.to.reservationResponse['data'] != null)
                    ? (DashBoardController
                                .to
                                .reservationResponse['data']['bookings']
                                .length >
                            3)
                        ? InkWell(
                            onTap: () {
                              Get.to(() => const AllreservationScreen());
                            },
                            child: Text('View All', style: colorFE6927s12w600))
                        : const SizedBox()
                    : const SizedBox(),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            /*   isshimmer.value
                            ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Shimmer.fromColors(
                            baseColor: AppColors.colorD9D9D9.withOpacity(0.2),
                            highlightColor: AppColors.colorD9D9D9,
                            child: Row(
                              children: List.generate(
                                4,
                                    (index) => SizedBox(
                                  width: Get.width / 2.9,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: Get.width / 4,
                                        decoration: BoxDecoration(
                                          color: AppColors.colorFE6927,
                                          borderRadius:
                                          BorderRadius.circular(6),),
                                      ),
                                    ],
                                  ),
                                ),),
                            ),
                          ),
                        )
                            : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              opetions.length,
                                  (index) => InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      _selectedType.value = index;
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width / 2.9,
                                      child: Column(
                                        children: [
                                          Text(
                                              opetions[index] +
                                                  " (${DashBoardController.to.reservationResponse['data'][opetionsCategory[index]].length})",
                                              maxLines: 1,
                                              style: _selectedType.value ==
                                                  index
                                                  ? color00000s15w600
                                                  : color50perBlacks13w400),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            height: 3,
                                            width: Get.width / 4,
                                            decoration: BoxDecoration(
                                              color:
                                              _selectedType.value == index
                                                  ? AppColors.colorFE6927
                                                  : Colors.transparent,
                                              borderRadius:
                                              BorderRadius.circular(100),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),),
                          ),
                        ),*/
            isShimmer.value
                ? Column(
                    children: List.generate(
                        3,
                        (index) => Column(
                              children: [
                                Shimmer.fromColors(
                                  baseColor:
                                      AppColors.colorD9D9D9.withOpacity(0.2),
                                  highlightColor: AppColors.colorD9D9D9,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          AppImages.villaImg,
                                          height: 130,
                                          width: 130,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 20,
                                                color: AppColors.colorF8F8F8,
                                              ),
                                              const SizedBox(height: 7),
                                              Container(
                                                height: 20,
                                                color: AppColors.colorF8F8F8,
                                              ),
                                              const SizedBox(height: 7),
                                              Container(
                                                height: 20,
                                                color: AppColors.colorF8F8F8,
                                              ),
                                              const SizedBox(height: 7),
                                              Container(
                                                height: 20,
                                                color: AppColors.colorF8F8F8,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: AppColors.color000000.withOpacity(0.1),
                                )
                              ],
                            )),
                  )
                : DashBoardController.to.reservationResponse['data']['bookings']
                            .length ==
                        0
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: AppColors.colorD9D9D9,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 40, horizontal: 50),
                          child: Text(
                            'You don’t have any guests checking in today or tomorrow.',
                            style: color00000s14w500,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          /*horizontal: 27,*/
                          vertical: 12,
                        ),
                        child: Column(
                          children: List.generate(
                            (DashBoardController
                                        .to
                                        .reservationResponse['data']['bookings']
                                        .length >
                                    5)
                                ? 5
                                : DashBoardController
                                    .to
                                    .reservationResponse['data']['bookings']
                                    .length,
                            (index) => Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (DashBoardController
                                                        .to.reservationResponse[
                                                    'data']?['bookings']?[index]
                                                ['properties']?['slug'] !=
                                            null) {
                                          loaderShow(context);
                                          ViewPropertyController.to
                                              .viewPropertyController(
                                            slug: (DashBoardController
                                                            .to.reservationResponse[
                                                        'data']?['bookings']?[
                                                    index]['properties']?['slug'])
                                                .toString(),
                                            success: () {
                                              loaderHide();
                                              Get.to(
                                                () => Property_detail_screen(),
                                              );
                                            },
                                            error: (e) {
                                              loaderHide();
                                            },
                                          );
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: DashBoardController
                                                      .to.reservationResponse[
                                                  'data']['bookings'][index]
                                              ['properties']['cover_photo'],
                                          placeholder: (context, url) =>
                                              CupertinoActivityIndicator(
                                            color: AppColors.colorFE6927,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Property Name :',
                                                  style: color000000s12w400,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    DashBoardController.to.reservationResponse[
                                                                        'data']
                                                                    ?[
                                                                    'bookings']
                                                                [index]?[
                                                            'properties']?['name'] ??
                                                        'Gleekey Property',
                                                    style: color000000s12w400
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColors
                                                                .color000000
                                                                .withOpacity(
                                                                    0.5)),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 7),
                                            Row(
                                              children: [
                                                Text(
                                                  'Booking Date : ',
                                                  style: color000000s12w400,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    DashBoardController.to.reservationResponse[
                                                                        'data']
                                                                    ?[
                                                                    'bookings']
                                                                ?[index]
                                                            ?['start_date'] ??
                                                        '-',
                                                    style: color000000s12w400
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .color000000
                                                          .withOpacity(0.5),
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 7),
                                            Row(
                                              children: [
                                                Text(
                                                  'Customer Name :',
                                                  style: color000000s12w400,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    '${DashBoardController.to.reservationResponse['data']?['bookings']?[index]?['users']?['first_name'] ?? ''} ${DashBoardController.to.reservationResponse['data']?['bookings']?[index]?['users']?['last_name'] ?? ''}',
                                                    style: color000000s12w400
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .color000000
                                                          .withOpacity(0.5),
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 7),
                                            Row(
                                              children: [
                                                Text(
                                                  'Status :',
                                                  style: color000000s12w400,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    DashBoardController.to
                                                                    .reservationResponse[
                                                                'data']?['bookings']
                                                            ?[
                                                            index]?['status'] ??
                                                        '-',
                                                    style: color000000s12w400
                                                        .copyWith(
                                                            color: (DashBoardController.to.reservationResponse['data']?['bookings']?[index]?[
                                                                            'status'] ??
                                                                        '-') ==
                                                                    'Cancelled'
                                                                ? AppColors
                                                                    .color9a0400
                                                                : (DashBoardController.to.reservationResponse['data']?['bookings']?[index]?['status'] ??
                                                                            '-') ==
                                                                        'Accepted'
                                                                    ? AppColors
                                                                        .color32BD01
                                                                    : (DashBoardController.to.reservationResponse['data']?['bookings']?[index]?['status'] ?? '-') ==
                                                                            'Pending'
                                                                        ? AppColors
                                                                            .colorffc107
                                                                        : AppColors
                                                                            .colorFE6927),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 7),
                                            ((DashBoardController.to.reservationResponse['data']
                                                                    ?['bookings']?[index]
                                                                ?['status'] ??
                                                            '-') ==
                                                        'Processing') ||
                                                    ((DashBoardController.to.reservationResponse['data']
                                                                        ?['bookings']
                                                                    ?[index]
                                                                ?['status'] ??
                                                            '-') ==
                                                        'Expired') ||
                                                    ('bookings' ==
                                                        'expired_bookings') ||
                                                    ((DashBoardController.to
                                                                        .reservationResponse['data']
                                                                    ?['bookings']
                                                                ?[index]?['status'] ??
                                                            '-') ==
                                                        'Declined')
                                                ? const SizedBox()
                                                : Row(
                                                    children: [
                                                      Text(
                                                        'Receipts :',
                                                        style:
                                                            color000000s12w400,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: InkWell(
                                                          highlightColor: Colors
                                                              .transparent,
                                                          splashColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            Get.to(
                                                              () => (DashBoardController
                                                                              .to
                                                                              .reservationResponse['data']?['bookings']?[index]?['status'] ??
                                                                          '-') ==
                                                                      'Pending'
                                                                  ? AcceptAndDeclineScreen(
                                                                      data: DashBoardController
                                                                              .to
                                                                              .reservationResponse['data']?['bookings']
                                                                          ?[
                                                                          index],
                                                                    )
                                                                  : ViewReceiptsScreen(
                                                                      data: DashBoardController
                                                                              .to
                                                                              .reservationResponse['data']?['bookings']
                                                                          ?[
                                                                          index],
                                                                    ),
                                                            );
                                                          },
                                                          child: Text(
                                                            (DashBoardController.to.reservationResponse['data']?['bookings']?[index]
                                                                            ?[
                                                                            'status'] ??
                                                                        '-') ==
                                                                    'Pending'
                                                                ? 'accept / decline'
                                                                : (DashBoardController.to.reservationResponse['data']?['bookings']?[index]?['status'] ??
                                                                            '-') ==
                                                                        'Accepted'
                                                                    ? 'View Receipts'
                                                                    : 'Booking Receipt / Cancelletion Receipt',
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              color: AppColors
                                                                  .colorFE6927,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                index == 4
                                    ? SizedBox()
                                    : const SizedBox(
                                        height: 8,
                                      ),
                                index == 4
                                    ? SizedBox()
                                    : Divider(
                                        color: AppColors.color000000
                                            .withOpacity(0.1),
                                      ),
                                index == 4
                                    ? SizedBox()
                                    : const SizedBox(
                                        height: 8,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Expanded reviewsbyYouView() {
    return Expanded(
      child: SingleChildScrollView(
        child: isShimmer.value
            ? Shimmer.fromColors(
                baseColor: AppColors.colorD9D9D9.withOpacity(0.2),
                highlightColor: AppColors.colorD9D9D9,
                child: Column(
                  children: List.generate(
                    5,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 8),
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: AppColors.colorffffff,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 5,
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      AppImages.villaImg,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Gleekey Resort',
                                    style: color000000s12w400,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 20,
                                              backgroundColor:
                                                  AppColors.colorE6E6E6,
                                              backgroundImage: const AssetImage(
                                                'assets/images/profile.png',
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Text(
                                                'Lorem Ipsum',
                                                style: color000000s12w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '2 years ago',
                                        style: color000000s12w400,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Lorem Ipsum is simply dummy text of the printing and typesetting Lorem Ipsum has been the industry\'s standard dummy text ever since the ',
                                    style: color50perBlacks13w400,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      /*  Get.to(
                                        () => const ReviewScreen(
                                          title: 'Gleekey Resort',
                                        ),
                                      );*/
                                    },
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: Text(
                                      'View Details',
                                      style: colorFE6927s12w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() {
                      return Row(
                        children: List.generate(
                            reviewsbyYouTab.length,
                            (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      selectedReviewTab.value = index;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: selectedReviewTab.value == index
                                            ? AppColors.colorFE6927
                                            : Colors.transparent,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7, horizontal: 13),
                                      child: Text(reviewsbyYouTab[index],
                                          style: selectedReviewTab.value ==
                                                  index
                                              ? colorfffffffs13w600.copyWith(
                                                  fontWeight: FontWeight.w400)
                                              : colorfffffffs13w600.copyWith(
                                                  color: AppColors.color000000
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                )),
                      );
                    }),
                  ),
                  (InsightController.to.insightApiResponse['data'] == null ||
                          InsightController
                              .to.insightApiResponse['data'].isEmpty)
                      ? const Text('empty')
                      : ((selectedReviewTab.value == 0
                                  ? InsightController.to.reviewsToWrite.length
                                  : selectedReviewTab.value == 1
                                      ? InsightController.to.reviewsByYou.length
                                      : InsightController
                                          .to.expiredReviews.length) ==
                              0)
                          ? Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: AppColors.colorD9D9D9,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 40,
                                  horizontal: 50,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'No Reviews',
                                      style: color00000s14w500,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: List.generate(
                                selectedReviewTab.value == 0
                                    ? InsightController.to.reviewsToWrite.length
                                    : selectedReviewTab.value == 1
                                        ? InsightController
                                            .to.reviewsByYou.length
                                        : InsightController
                                            .to.expiredReviews.length,
                                (index) {
                                  List data = selectedReviewTab.value == 0
                                      ? InsightController.to.reviewsToWrite
                                      : selectedReviewTab.value == 1
                                          ? InsightController.to.reviewsByYou
                                          : InsightController.to.expiredReviews;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 8),
                                    child: Container(
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                        color: AppColors.colorffffff,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 5,
                                            spreadRadius: 5,
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.05),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl: data[index]
                                                                ['properties']
                                                            ?['cover_photo'] ??
                                                        '',
                                                    placeholder: (context,
                                                            url) =>
                                                        CupertinoActivityIndicator(
                                                      color:
                                                          AppColors.colorFE6927,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                      Icons.error,
                                                    ),
                                                    fit: BoxFit.cover,
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  data[index]?['properties']
                                                          ?['name'] ??
                                                      '',
                                                  style: color000000s12w400,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: data[
                                                                          index]
                                                                      [
                                                                      'user_profile_image'] ??
                                                                  '',
                                                              placeholder: (context,
                                                                      url) =>
                                                                  CupertinoActivityIndicator(
                                                                color: AppColors
                                                                    .colorFE6927,
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(
                                                                Icons.error,
                                                              ),
                                                              fit: BoxFit.cover,
                                                              height: 40,
                                                              width: 40,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              "${data[index]?['user_name'] ?? ''}",
                                                              style:
                                                                  color000000s12w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      data[index]
                                                              ['date_range'] ??
                                                          '',
                                                      style: color000000s12w400,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  data[index]?['message'] ?? '',
                                                  style: color50perBlacks13w400,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data[index]?['post_date'] ??
                                                      '',
                                                  style: color50perBlacks13w400,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    selectedReviewTab.value == 0
                                                        ? showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            //context: _scaffoldKey.currentContext,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 12,
                                                                ),
                                                                scrollable:
                                                                    true,
                                                                title: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Write a Review',
                                                                        style:
                                                                            color00000s18w600,
                                                                      ),
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Get.back();
                                                                          },
                                                                          child:
                                                                              const Icon(
                                                                            Icons.close,
                                                                          ))
                                                                    ]),
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        20.0),
                                                                  ),
                                                                ),
                                                                content:
                                                                    SizedBox(
                                                                  width:
                                                                      Get.width,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('Describe Your Experience',
                                                                                style: color00000s15w600),
                                                                            TextFormField(
                                                                              controller: _describeExperience,
                                                                              cursorColor: AppColors.colorFE6927,
                                                                              maxLines: 3,
                                                                              decoration: InputDecoration(
                                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(6.0),
                                                                                  borderSide: BorderSide(
                                                                                    width: 1,
                                                                                    color: AppColors.color000000.withOpacity(0.5),
                                                                                  ),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0), borderSide: BorderSide(width: 1, color: AppColors.color000000.withOpacity(0.5))),
                                                                                contentPadding: const EdgeInsets.all(13.0),
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
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 8.0),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Private Host Feedback',
                                                                              style: color00000s15w600,
                                                                            ),
                                                                            Text(
                                                                              'What did you love about staying at this listing?',
                                                                              style: color50perBlacks13w400,
                                                                            ),
                                                                            TextFormField(
                                                                              controller: _aboutStaying,
                                                                              cursorColor: AppColors.colorFE6927,
                                                                              maxLines: 3,
                                                                              decoration: InputDecoration(
                                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(6.0),
                                                                                  borderSide: BorderSide(
                                                                                    width: 1,
                                                                                    color: AppColors.color000000.withOpacity(0.5),
                                                                                  ),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0), borderSide: BorderSide(width: 1, color: AppColors.color000000.withOpacity(0.5))),
                                                                                contentPadding: const EdgeInsets.all(13.0),
                                                                              ),
                                                                            ),
                                                                            Divider(
                                                                              endIndent: 10,
                                                                              indent: 10,
                                                                              color: AppColors.color000000.withOpacity(0.1),
                                                                            ),
                                                                            Text(
                                                                              'How can your host improve?',
                                                                              style: color50perBlacks13w400,
                                                                            ),
                                                                            TextFormField(
                                                                              controller: _howCanImprove,
                                                                              cursorColor: AppColors.colorFE6927,
                                                                              maxLines: 3,
                                                                              decoration: InputDecoration(
                                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(6.0),
                                                                                  borderSide: BorderSide(
                                                                                    width: 1,
                                                                                    color: AppColors.color000000.withOpacity(0.5),
                                                                                  ),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0), borderSide: BorderSide(width: 1, color: AppColors.color000000.withOpacity(0.5))),
                                                                                contentPadding: const EdgeInsets.all(13.0),
                                                                              ),
                                                                            ),
                                                                            Divider(
                                                                              endIndent: 10,
                                                                              indent: 10,
                                                                              color: AppColors.color000000.withOpacity(0.1),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text('Overall Experience',
                                                                                style: color00000s15w600),
                                                                            RatingBar.builder(
                                                                              initialRating: overallExperience.value.toDouble(),
                                                                              minRating: 0,
                                                                              direction: Axis.horizontal,
                                                                              itemCount: 5,
                                                                              itemSize: 20,
                                                                              unratedColor: AppColors.colorD9D9D9,
                                                                              itemPadding: const EdgeInsets.symmetric(
                                                                                horizontal: 4.0,
                                                                              ),
                                                                              itemBuilder: (context, _) => Icon(
                                                                                Icons.star,
                                                                                color: AppColors.colorFE6927,
                                                                              ),
                                                                              onRatingUpdate: (rating) {
                                                                                overallExperience.value = rating.toInt();
                                                                                print(overallExperience.value);
                                                                              },
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text('Accuracy',
                                                                                style: color00000s15w600),
                                                                            Text(
                                                                              'How accurately did the photos & description represent the actual space?',
                                                                              style: color50perBlacks13w400,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                                                              child: RatingBar.builder(
                                                                                initialRating: accuracyRating.value.toDouble(),
                                                                                minRating: 0,
                                                                                direction: Axis.horizontal,
                                                                                itemCount: 5,
                                                                                itemSize: 20,
                                                                                unratedColor: AppColors.colorD9D9D9,
                                                                                itemPadding: const EdgeInsets.symmetric(
                                                                                  horizontal: 4.0,
                                                                                ),
                                                                                itemBuilder: (context, _) => Icon(
                                                                                  Icons.star,
                                                                                  color: AppColors.colorFE6927,
                                                                                ),
                                                                                onRatingUpdate: (rating) {
                                                                                  accuracyRating.value = rating.toInt();
                                                                                  print(accuracyRating.value);
                                                                                },
                                                                              ),
                                                                            ),
                                                                            TextFormField(
                                                                              controller: _accuracy,
                                                                              cursorColor: AppColors.colorFE6927,
                                                                              maxLines: 2,
                                                                              decoration: InputDecoration(
                                                                                hintText: 'Accuracy',
                                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(6.0),
                                                                                  borderSide: BorderSide(
                                                                                    width: 1,
                                                                                    color: AppColors.color000000.withOpacity(0.5),
                                                                                  ),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0), borderSide: BorderSide(width: 1, color: AppColors.color000000.withOpacity(0.5))),
                                                                                contentPadding: const EdgeInsets.all(13.0),
                                                                              ),
                                                                            ),
                                                                            Divider(
                                                                              endIndent: 10,
                                                                              indent: 10,
                                                                              color: AppColors.color000000.withOpacity(0.1),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text('Cleanliness',
                                                                                style: color00000s15w600),
                                                                            Text(
                                                                              'Was the space as clean as you expect a listing to be?',
                                                                              style: color50perBlacks13w400,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                                                              child: RatingBar.builder(
                                                                                initialRating: cleanlinessRating.value.toDouble(),
                                                                                minRating: 0,
                                                                                direction: Axis.horizontal,
                                                                                itemCount: 5,
                                                                                itemSize: 20,
                                                                                unratedColor: AppColors.colorD9D9D9,
                                                                                itemPadding: const EdgeInsets.symmetric(
                                                                                  horizontal: 4.0,
                                                                                ),
                                                                                itemBuilder: (context, _) => Icon(
                                                                                  Icons.star,
                                                                                  color: AppColors.colorFE6927,
                                                                                ),
                                                                                onRatingUpdate: (rating) {
                                                                                  cleanlinessRating.value = rating.toInt();
                                                                                  print(cleanlinessRating.value);
                                                                                },
                                                                              ),
                                                                            ),
                                                                            TextFormField(
                                                                              controller: _cleanliness,
                                                                              cursorColor: AppColors.colorFE6927,
                                                                              maxLines: 2,
                                                                              decoration: InputDecoration(
                                                                                hintText: 'Cleanliness',
                                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(6.0),
                                                                                  borderSide: BorderSide(
                                                                                    width: 1,
                                                                                    color: AppColors.color000000.withOpacity(0.5),
                                                                                  ),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0), borderSide: BorderSide(width: 1, color: AppColors.color000000.withOpacity(0.5))),
                                                                                contentPadding: const EdgeInsets.all(13.0),
                                                                              ),
                                                                            ),
                                                                            Divider(
                                                                              endIndent: 10,
                                                                              indent: 10,
                                                                              color: AppColors.color000000.withOpacity(0.1),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text('Arrival',
                                                                                style: color00000s15w600),
                                                                            Text(
                                                                              'Did the host do everything within their control to provide you with a smooth arrival process?',
                                                                              style: color50perBlacks13w400,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                                                              child: RatingBar.builder(
                                                                                initialRating: arrivalRating.value.toDouble(),
                                                                                minRating: 0,
                                                                                direction: Axis.horizontal,
                                                                                itemCount: 5,
                                                                                itemSize: 20,
                                                                                unratedColor: AppColors.colorD9D9D9,
                                                                                itemPadding: const EdgeInsets.symmetric(
                                                                                  horizontal: 4.0,
                                                                                ),
                                                                                itemBuilder: (context, _) => Icon(
                                                                                  Icons.star,
                                                                                  color: AppColors.colorFE6927,
                                                                                ),
                                                                                onRatingUpdate: (rating) {
                                                                                  arrivalRating.value = rating.toInt();
                                                                                  print(arrivalRating.value);
                                                                                },
                                                                              ),
                                                                            ),
                                                                            TextFormField(
                                                                              controller: _arrival,
                                                                              cursorColor: AppColors.colorFE6927,
                                                                              maxLines: 2,
                                                                              decoration: InputDecoration(
                                                                                hintText: 'Arrival',
                                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(6.0),
                                                                                  borderSide: BorderSide(
                                                                                    width: 1,
                                                                                    color: AppColors.color000000.withOpacity(0.5),
                                                                                  ),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0), borderSide: BorderSide(width: 1, color: AppColors.color000000.withOpacity(0.5))),
                                                                                contentPadding: const EdgeInsets.all(13.0),
                                                                              ),
                                                                            ),
                                                                            Divider(
                                                                              endIndent: 10,
                                                                              indent: 10,
                                                                              color: AppColors.color000000.withOpacity(0.1),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text('Amenities',
                                                                                style: color00000s15w600),
                                                                            Text(
                                                                              'Did your host provide everything they promised in their listing description?',
                                                                              style: color50perBlacks13w400,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                                                              child: RatingBar.builder(
                                                                                initialRating: amenitiesRating.value.toDouble(),
                                                                                minRating: 0,
                                                                                direction: Axis.horizontal,
                                                                                itemCount: 5,
                                                                                itemSize: 20,
                                                                                unratedColor: AppColors.colorD9D9D9,
                                                                                itemPadding: const EdgeInsets.symmetric(
                                                                                  horizontal: 4.0,
                                                                                ),
                                                                                itemBuilder: (context, _) => Icon(
                                                                                  Icons.star,
                                                                                  color: AppColors.colorFE6927,
                                                                                ),
                                                                                onRatingUpdate: (rating) {
                                                                                  amenitiesRating.value = rating.toInt();
                                                                                  print(rating);
                                                                                },
                                                                              ),
                                                                            ),
                                                                            TextFormField(
                                                                              controller: _amenities,
                                                                              cursorColor: AppColors.colorFE6927,
                                                                              maxLines: 2,
                                                                              decoration: InputDecoration(
                                                                                hintText: 'Amenities',
                                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(6.0),
                                                                                  borderSide: BorderSide(
                                                                                    width: 1,
                                                                                    color: AppColors.color000000.withOpacity(0.5),
                                                                                  ),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0), borderSide: BorderSide(width: 1, color: AppColors.color000000.withOpacity(0.5))),
                                                                                contentPadding: const EdgeInsets.all(13.0),
                                                                              ),
                                                                            ),
                                                                            Divider(
                                                                              endIndent: 10,
                                                                              indent: 10,
                                                                              color: AppColors.color000000.withOpacity(0.1),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text('Communication',
                                                                                style: color00000s15w600),
                                                                            Text(
                                                                              'How responsive and accessible was the host before and during your stay?',
                                                                              style: color50perBlacks13w400,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                                                              child: RatingBar.builder(
                                                                                initialRating: communicationRating.value.toDouble(),
                                                                                minRating: 0,
                                                                                direction: Axis.horizontal,
                                                                                itemCount: 5,
                                                                                itemSize: 20,
                                                                                unratedColor: AppColors.colorD9D9D9,
                                                                                itemPadding: const EdgeInsets.symmetric(
                                                                                  horizontal: 4.0,
                                                                                ),
                                                                                itemBuilder: (context, _) => Icon(
                                                                                  Icons.star,
                                                                                  color: AppColors.colorFE6927,
                                                                                ),
                                                                                onRatingUpdate: (rating) {
                                                                                  communicationRating.value = rating.toInt();
                                                                                  print(rating);
                                                                                },
                                                                              ),
                                                                            ),
                                                                            TextFormField(
                                                                              controller: _communication,
                                                                              cursorColor: AppColors.colorFE6927,
                                                                              maxLines: 2,
                                                                              decoration: InputDecoration(
                                                                                hintText: 'Communication',
                                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(6.0),
                                                                                  borderSide: BorderSide(
                                                                                    width: 1,
                                                                                    color: AppColors.color000000.withOpacity(0.5),
                                                                                  ),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0), borderSide: BorderSide(width: 1, color: AppColors.color000000.withOpacity(0.5))),
                                                                                contentPadding: const EdgeInsets.all(13.0),
                                                                              ),
                                                                            ),
                                                                            Divider(
                                                                              endIndent: 10,
                                                                              indent: 10,
                                                                              color: AppColors.color000000.withOpacity(0.1),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text('Location',
                                                                                style: color00000s15w600),
                                                                            Text(
                                                                              'How appealing is the neighborhood? Consider safety, convenience, and desirability.',
                                                                              style: color50perBlacks13w400,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                                                              child: RatingBar.builder(
                                                                                initialRating: locationRating.value.toDouble(),
                                                                                minRating: 0,
                                                                                direction: Axis.horizontal,
                                                                                itemCount: 5,
                                                                                itemSize: 20,
                                                                                unratedColor: AppColors.colorD9D9D9,
                                                                                itemPadding: const EdgeInsets.symmetric(
                                                                                  horizontal: 4.0,
                                                                                ),
                                                                                itemBuilder: (context, _) => Icon(
                                                                                  Icons.star,
                                                                                  color: AppColors.colorFE6927,
                                                                                ),
                                                                                onRatingUpdate: (rating) {
                                                                                  locationRating.value = rating.toInt();
                                                                                  print(locationRating.value);
                                                                                },
                                                                              ),
                                                                            ),
                                                                            TextFormField(
                                                                              controller: _location,
                                                                              cursorColor: AppColors.colorFE6927,
                                                                              maxLines: 2,
                                                                              decoration: InputDecoration(
                                                                                hintText: 'Location',
                                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(6.0),
                                                                                  borderSide: BorderSide(
                                                                                    width: 1,
                                                                                    color: AppColors.color000000.withOpacity(0.5),
                                                                                  ),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0), borderSide: BorderSide(width: 1, color: AppColors.color000000.withOpacity(0.5))),
                                                                                contentPadding: const EdgeInsets.all(13.0),
                                                                              ),
                                                                            ),
                                                                            Divider(
                                                                              endIndent: 10,
                                                                              indent: 10,
                                                                              color: AppColors.color000000.withOpacity(0.1),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text('Value',
                                                                                style: color00000s15w600),
                                                                            Text(
                                                                              'How would you rate the value of the listing?',
                                                                              style: color50perBlacks13w400,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                                                              child: RatingBar.builder(
                                                                                initialRating: valueRating.value.toDouble(),
                                                                                minRating: 0,
                                                                                direction: Axis.horizontal,
                                                                                itemCount: 5,
                                                                                itemSize: 20,
                                                                                unratedColor: AppColors.colorD9D9D9,
                                                                                itemPadding: const EdgeInsets.symmetric(
                                                                                  horizontal: 4.0,
                                                                                ),
                                                                                itemBuilder: (context, _) => Icon(
                                                                                  Icons.star,
                                                                                  color: AppColors.colorFE6927,
                                                                                ),
                                                                                onRatingUpdate: (rating) {
                                                                                  valueRating.value = rating.toInt();
                                                                                  print(valueRating.value);
                                                                                },
                                                                              ),
                                                                            ),
                                                                            TextFormField(
                                                                              controller: _value,
                                                                              cursorColor: AppColors.colorFE6927,
                                                                              maxLines: 2,
                                                                              decoration: InputDecoration(
                                                                                hintText: 'Value',
                                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(6.0),
                                                                                  borderSide: BorderSide(
                                                                                    width: 1,
                                                                                    color: AppColors.color000000.withOpacity(0.5),
                                                                                  ),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0), borderSide: BorderSide(width: 1, color: AppColors.color000000.withOpacity(0.5))),
                                                                                contentPadding: const EdgeInsets.all(13.0),
                                                                              ),
                                                                            ),
                                                                            Divider(
                                                                              endIndent: 10,
                                                                              indent: 10,
                                                                              color: AppColors.color000000.withOpacity(0.1),
                                                                            ),
                                                                            Align(
                                                                              alignment: Alignment.center,
                                                                              child: CommonButton(
                                                                                onPressed: () {
                                                                                  log(_describeExperience.text + _aboutStaying.text + _howCanImprove.text + _accuracy.text + _cleanliness.text + _arrival.text + _amenities.text + _communication.text + _location.text + _value.text);
                                                                                  log('${overallExperience.value + accuracyRating.value + cleanlinessRating.value + arrivalRating.value + amenitiesRating.value + communicationRating.value + locationRating.value + valueRating.value}');
                                                                                },
                                                                                name: 'Submit',
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : Get.defaultDialog(
                                                            title: data[index]?[
                                                                        'properties']
                                                                    ?['name'] ??
                                                                '',
                                                            barrierDismissible:
                                                                true,
                                                            content: SizedBox(
                                                              width: Get.width,
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text('Describe Your Experience',
                                                                                style: color00000s15w600),
                                                                            /*   RatingBar
                                                                        .builder(
                                                                      initialRating:
                                                                          double.parse(
                                                                              ('0').toString()),
                                                                      minRating:
                                                                          1,
                                                                      ignoreGestures:
                                                                          true,
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      allowHalfRating:
                                                                          true,
                                                                      itemCount:
                                                                          5,
                                                                      itemSize:
                                                                          20,
                                                                      unratedColor:
                                                                          AppColors
                                                                              .colorD9D9D9,
                                                                      itemPadding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            4.0,
                                                                      ),
                                                                      itemBuilder:
                                                                          (context, _) =>
                                                                              Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: AppColors
                                                                            .colorFE6927,
                                                                      ),
                                                                      onRatingUpdate:
                                                                          (rating) {
                                                                        print(
                                                                            rating);
                                                                      },
                                                                    ),*/
                                                                          ],
                                                                        ),
                                                                        Text(
                                                                          data[index]['message'] ??
                                                                              '',
                                                                          style:
                                                                              color50perBlacks13w400,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        Divider(
                                                                          endIndent:
                                                                              10,
                                                                          indent:
                                                                              10,
                                                                          color: AppColors
                                                                              .color000000
                                                                              .withOpacity(0.1),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text('Private Guest Feedback',
                                                                                style: color00000s15w600),
                                                                            /*   RatingBar
                                                                        .builder(
                                                                      initialRating:
                                                                          double.parse(
                                                                              ('0').toString()),
                                                                      minRating:
                                                                          1,
                                                                      ignoreGestures:
                                                                          true,
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      allowHalfRating:
                                                                          true,
                                                                      itemCount:
                                                                          5,
                                                                      itemSize:
                                                                          20,
                                                                      unratedColor:
                                                                          AppColors
                                                                              .colorD9D9D9,
                                                                      itemPadding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            4.0,
                                                                      ),
                                                                      itemBuilder:
                                                                          (context, _) =>
                                                                              Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: AppColors
                                                                            .colorFE6927,
                                                                      ),
                                                                      onRatingUpdate:
                                                                          (rating) {
                                                                        print(
                                                                            rating);
                                                                      },
                                                                    ),*/
                                                                          ],
                                                                        ),
                                                                        Text(
                                                                          data[index]['secret_feedback'] ??
                                                                              'No secret feedback',
                                                                          style:
                                                                              color50perBlacks13w400,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        Divider(
                                                                          endIndent:
                                                                              10,
                                                                          indent:
                                                                              10,
                                                                          color: AppColors
                                                                              .color000000
                                                                              .withOpacity(0.1),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            'Did the guest leave your space clean?',
                                                                            style:
                                                                                color00000s15w600),
                                                                        RatingBar
                                                                            .builder(
                                                                          initialRating:
                                                                              double.parse((data[index]['cleanliness'] ?? '0').toString()),
                                                                          minRating:
                                                                              1,
                                                                          ignoreGestures:
                                                                              true,
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          allowHalfRating:
                                                                              true,
                                                                          itemCount:
                                                                              5,
                                                                          itemSize:
                                                                              20,
                                                                          unratedColor:
                                                                              AppColors.colorD9D9D9,
                                                                          itemPadding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                4.0,
                                                                          ),
                                                                          itemBuilder: (context, _) =>
                                                                              Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                AppColors.colorFE6927,
                                                                          ),
                                                                          onRatingUpdate:
                                                                              (rating) {
                                                                            print(rating);
                                                                          },
                                                                        ),
                                                                        (data[index]['cleanliness_message'] == null ||
                                                                                data[index]['cleanliness_message'] == '')
                                                                            ? const SizedBox()
                                                                            : const SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                        (data[index]['cleanliness_message'] == null ||
                                                                                data[index]['cleanliness_message'] == '')
                                                                            ? const SizedBox()
                                                                            : Text(
                                                                                data[index]['cleanliness_message'] ?? '',
                                                                                style: color50perBlacks13w400,
                                                                              ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Divider(
                                                                          endIndent:
                                                                              10,
                                                                          indent:
                                                                              10,
                                                                          color: AppColors
                                                                              .color000000
                                                                              .withOpacity(0.1),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            'How clearly did the guest communicate their plans, questions, and concerns?',
                                                                            style:
                                                                                color00000s15w600),
                                                                        RatingBar
                                                                            .builder(
                                                                          initialRating:
                                                                              double.parse((data[index]['communication'] ?? '0').toString()),
                                                                          minRating:
                                                                              1,
                                                                          ignoreGestures:
                                                                              true,
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          allowHalfRating:
                                                                              true,
                                                                          itemCount:
                                                                              5,
                                                                          itemSize:
                                                                              20,
                                                                          unratedColor:
                                                                              AppColors.colorD9D9D9,
                                                                          itemPadding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                4.0,
                                                                          ),
                                                                          itemBuilder: (context, _) =>
                                                                              Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                AppColors.colorFE6927,
                                                                          ),
                                                                          onRatingUpdate:
                                                                              (rating) {
                                                                            print(rating);
                                                                          },
                                                                        ),
                                                                        (data[index]['communication_message'] == null ||
                                                                                data[index]['communication_message'] == '')
                                                                            ? const SizedBox()
                                                                            : const SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                        (data[index]['communication_message'] == null ||
                                                                                data[index]['communication_message'] == '')
                                                                            ? const SizedBox()
                                                                            : Text(
                                                                                data[index]['communication_message'] ?? '',
                                                                                style: color50perBlacks13w400,
                                                                              ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Divider(
                                                                          endIndent:
                                                                              10,
                                                                          indent:
                                                                              10,
                                                                          color: AppColors
                                                                              .color000000
                                                                              .withOpacity(0.1),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            'Did the guest observe the house rules you provided?',
                                                                            style:
                                                                                color00000s15w600),
                                                                        RatingBar
                                                                            .builder(
                                                                          initialRating:
                                                                              double.parse((data[index]['house_rules'] ?? '0').toString()),
                                                                          minRating:
                                                                              1,
                                                                          ignoreGestures:
                                                                              true,
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          allowHalfRating:
                                                                              true,
                                                                          itemCount:
                                                                              5,
                                                                          itemSize:
                                                                              20,
                                                                          unratedColor:
                                                                              AppColors.colorD9D9D9,
                                                                          itemPadding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                4.0,
                                                                          ),
                                                                          itemBuilder: (context, _) =>
                                                                              Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                AppColors.colorFE6927,
                                                                          ),
                                                                          onRatingUpdate:
                                                                              (rating) {
                                                                            print(rating);
                                                                          },
                                                                        ),
                                                                        Divider(
                                                                          endIndent:
                                                                              10,
                                                                          indent:
                                                                              10,
                                                                          color: AppColors
                                                                              .color000000
                                                                              .withOpacity(0.1),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                  },
                                                  highlightColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  child: Text(
                                                    selectedReviewTab.value == 0
                                                        ? 'Write Review'
                                                        : 'View Details',
                                                    style: colorFE6927s12w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ],
              ),
      ),
    );
  }
}

import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/dashboard_controller.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/view_property_controller.dart';
import 'package:gleeky_flutter/src/host/dash_board/view/acceptAndDeclineScreen.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:shimmer/shimmer.dart';
import 'property_detail_screen.dart';
import 'view_receipt_screen.dart';

class AllreservationScreen extends StatefulWidget {
  const AllreservationScreen({Key? key}) : super(key: key);

  @override
  State<AllreservationScreen> createState() => _AllreservationScreenState();
}

class _AllreservationScreenState extends State<AllreservationScreen> {
  RxBool loader = true.obs;
  RxBool showCircle = false.obs;
  RxBool isshimmer = true.obs;
  RxInt offset = 1.obs;
  List<List> opetionsCategory = [
    DashBoardController.to.AllReservation,
    DashBoardController.to.OngoingReservation,
    DashBoardController.to.UpcomingReservation,
    DashBoardController.to.CompletedReservation,
    DashBoardController.to.CancelledReservation,
  ];
  List<String> opetions = [
    'All',
    'Ongoing',
    'Upcoming',
    'Completed',
    'Cancelled'
  ];

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add Your Code here.

      ///clear List
      DashBoardController.to.AllReservation.clear();
      DashBoardController.to.OngoingReservation.clear();
      DashBoardController.to.UpcomingReservation.clear();
      DashBoardController.to.CompletedReservation.clear();
      DashBoardController.to.CancelledReservation.clear();

      ///reservation api
      DashBoardController.to.reservationApi(
        params: {'page': offset.value, "limit": "10"},
        success: () {
          isshimmer.value = false;
          offset.value = offset.value + 1;
        },
        error: (e) {
          showSnackBar(title: ApiConfig.error, message: e.toString());
        },
      );

      ///pagination
      _scrollController.addListener(
        () {
          if (_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels) {
            showCircle.value = true;
            DashBoardController.to.reservationApi(
              params: {'page': offset.value, "limit": "10"},
              success: () {
                offset.value = offset.value + 1;

                log(offset.value.toString(), name: 'PAGE NUMBER');
                showCircle.value = false;
              },
              error: (e) {
                showCircle.value = false;
                showSnackBar(title: ApiConfig.error, message: e.toString());
              },
            );
          }
        },
      );
    });
    super.initState();
  }

  RxString dropDownValue = 'All'.obs;
  RxInt listName = 0.obs;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 17, right: 27, left: 27),
                child: Row(
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
                          'Reservations',
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),
                child: StreamBuilder(
                    stream: dropDownValue.stream,
                    builder: (context, snapshot) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.color000000.withOpacity(0.2),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButton<String>(
                          value: dropDownValue.value,
                          underline: const SizedBox(),
                          borderRadius: BorderRadius.circular(6),
                          style: color00000s14w500,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              size: 20, color: AppColors.color000000),
                          items: opetions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: color00000s14w500,
                              ),
                            );
                          }).toList(),
                          onChanged: (_) {
                            dropDownValue.value = _.toString();
                            listName.value = opetions.indexOf(_.toString());
                            /*offset.value = 0;
                              loader.value = true;*/
                          },
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 15,
              ),
              isshimmer.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 27,
                        vertical: 17,
                      ),
                      child: Column(
                        children: List.generate(
                            3,
                            (index) => Column(
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: AppColors.colorD9D9D9
                                          .withOpacity(0.2),
                                      highlightColor: AppColors.colorD9D9D9,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                    color:
                                                        AppColors.colorF8F8F8,
                                                  ),
                                                  const SizedBox(height: 7),
                                                  Container(
                                                    height: 20,
                                                    color:
                                                        AppColors.colorF8F8F8,
                                                  ),
                                                  const SizedBox(height: 7),
                                                  Container(
                                                    height: 20,
                                                    color:
                                                        AppColors.colorF8F8F8,
                                                  ),
                                                  const SizedBox(height: 7),
                                                  Container(
                                                    height: 20,
                                                    color:
                                                        AppColors.colorF8F8F8,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: AppColors.color000000
                                          .withOpacity(0.1),
                                    )
                                  ],
                                )),
                      ),
                    )
                  : opetionsCategory[listName.value].isEmpty
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
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 27,
                              vertical: 17,
                            ),
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(
                                children: List.generate(
                                  opetionsCategory[listName.value].length,
                                  (index) => Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (opetionsCategory[
                                                          listName.value][index]
                                                      ['properties']?['slug'] !=
                                                  null) {
                                                loaderShow(context);
                                                ViewPropertyController.to
                                                    .viewPropertyController(
                                                  slug: (opetionsCategory[
                                                                      listName
                                                                          .value]
                                                                  [index]
                                                              ['properties']
                                                          ?['slug'])
                                                      .toString(),
                                                  success: () {
                                                    loaderHide();
                                                    Get.to(
                                                      () =>
                                                          Property_detail_screen(),
                                                    );
                                                  },
                                                  error: (e) {
                                                    loaderHide();
                                                  },
                                                );
                                              }
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: opetionsCategory[
                                                            listName.value]
                                                        [index]['properties']
                                                    ['cover_photo'],
                                                placeholder: (context, url) =>
                                                    CupertinoActivityIndicator(
                                                  color: AppColors.colorFE6927,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                height: 130,
                                                width: 130,
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
                                                        style:
                                                            color000000s12w400,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          opetionsCategory[listName
                                                                              .value]
                                                                          [
                                                                          index]
                                                                      ?[
                                                                      'properties']
                                                                  ?['name'] ??
                                                              'Gleekey Property',
                                                          style: color000000s12w400
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: AppColors
                                                                      .color000000
                                                                      .withOpacity(
                                                                          0.5)),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 7),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Booking Date : ',
                                                        style:
                                                            color000000s12w400,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          opetionsCategory[listName
                                                                          .value]
                                                                      [index]?[
                                                                  'start_date'] ??
                                                              '-',
                                                          style:
                                                              color000000s12w400
                                                                  .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColors
                                                                .color000000
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 7),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Customer Name :',
                                                        style:
                                                            color000000s12w400,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          '${opetionsCategory[listName.value][index]?['users']?['first_name'] ?? ''} ${opetionsCategory[listName.value][index]?['users']?['last_name'] ?? ''}',
                                                          style:
                                                              color000000s12w400
                                                                  .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColors
                                                                .color000000
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 7),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Status :',
                                                        style:
                                                            color000000s12w400,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          opetionsCategory[listName
                                                                          .value]
                                                                      [index]
                                                                  ?['status'] ??
                                                              '-',
                                                          style: color000000s12w400.copyWith(
                                                              color: (opetionsCategory[listName.value][index]?['status'] ?? '-') == 'Cancelled'
                                                                  ? AppColors.color9a0400
                                                                  : (opetionsCategory[listName.value][index]?['status'] ?? '-') == 'Accepted'
                                                                      ? AppColors.color32BD01
                                                                      : (opetionsCategory[listName.value][index]?['status'] ?? '-') == 'Pending'
                                                                          ? AppColors.colorffc107
                                                                          : (opetionsCategory[listName.value][index]?['status'] ?? '-') == 'Processing'
                                                                              ? const Color(0xffffc107)
                                                                              : AppColors.colorFE6927),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 7),
                                                  ((opetionsCategory[listName.value]
                                                                          [index]
                                                                      ?[
                                                                      'status'] ??
                                                                  '-') ==
                                                              'Processing') ||
                                                          ((opetionsCategory[listName.value]
                                                                          [index]
                                                                      ?[
                                                                      'status'] ??
                                                                  '-') ==
                                                              'Expired') ||
                                                          (listName.value ==
                                                              'expired_bookings') ||
                                                          ((opetionsCategory[listName
                                                                              .value]
                                                                          [index]
                                                                      ?[
                                                                      'status'] ??
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
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                splashColor: Colors
                                                                    .transparent,
                                                                onTap: () {
                                                                  Get.to(
                                                                    () => (opetionsCategory[listName.value][index]?['status']) ==
                                                                            'Pending'
                                                                        ? AcceptAndDeclineScreen(
                                                                            data:
                                                                                opetionsCategory[listName.value][index],
                                                                          )
                                                                        : ViewReceiptsScreen(
                                                                            data:
                                                                                opetionsCategory[listName.value][index],
                                                                          ),
                                                                  );
                                                                },
                                                                child: Text(
                                                                  (opetionsCategory[listName.value][index]?['status'] ??
                                                                              '-') ==
                                                                          'Pending'
                                                                      ? 'Accept / Decline'
                                                                      : (opetionsCategory[listName.value][index]?['status'] ?? '-') ==
                                                                              'Accepted'
                                                                          ? 'View Receipts'
                                                                          : 'Booking Receipt / Cancelletion Receipt',
                                                                  style: color000000s12w400
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
                                      Divider(
                                        color: AppColors.color000000
                                            .withOpacity(0.1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
            ],
          );
        }),
      ),
      bottomNavigationBar: Obx(
        () {
          return showCircle.value
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoActivityIndicator(
                    color: AppColors.colorFE6927,
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}

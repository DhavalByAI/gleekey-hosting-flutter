import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/src/host/add_property/view/hostScreen.dart';
import 'package:gleeky_flutter/src/host/calendar/view/calander.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/dashboard_controller.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class HostingScreen extends StatefulWidget {
  const HostingScreen({Key? key}) : super(key: key);

  @override
  State<HostingScreen> createState() => _HostingScreenState();
}

class _HostingScreenState extends State<HostingScreen> {
  final ScrollController _scrollController = ScrollController();

  RxBool loader = true.obs;
  RxBool showCircle = false.obs;

  RxInt offset = 0.obs;
  @override
  void initState() {
    // TODO: implement initState
    DashBoardController.to.allPropertyListing.clear();
    DashBoardController.to.allPropertyApi(
        params: {"status": 'Unlisted', 'page': offset, 'limit': 10},
        success: () {
          loader.value = false;
          offset.value = offset.value + 1;
        },
        error: (e) {
          Get.back();
        });
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        showCircle.value = true;
        DashBoardController.to.allPropertyApi(
            params: {"status": 'Unlisted', 'page': offset, 'limit': 10},
            success: () {
              showCircle.value = false;
              offset.value = offset.value + 1;
            },
            error: (e) {
              Get.back();
            });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 17, left: 20, right: 20),
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
                        'Pending Listing',
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
                          Icons.menu_open,
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
              Obx(
                () {
                  return loader.value
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                2,
                                (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: AppColors.colorD9D9D9
                                            .withOpacity(0.2),
                                        highlightColor: AppColors.colorD9D9D9,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            height: Get.width / 1.6,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: AppColors.colorFE6927),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Shimmer.fromColors(
                                              baseColor: AppColors.colorD9D9D9
                                                  .withOpacity(0.2),
                                              highlightColor:
                                                  AppColors.colorD9D9D9,
                                              child: Container(
                                                height: 20,
                                                color: AppColors.colorF8F8F8,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: AppColors.colorD9D9D9
                                            .withOpacity(0.2),
                                        highlightColor: AppColors.colorD9D9D9,
                                        child: Container(
                                          height: 20,
                                          width: double.maxFinite,
                                          color: AppColors.colorF8F8F8,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: AppColors.colorD9D9D9
                                            .withOpacity(0.2),
                                        highlightColor: AppColors.colorD9D9D9,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CommonButton(
                                                onPressed: () {},
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                name: 'Book Now',
                                                width: double.maxFinite,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Expanded(
                                              child: CommonButton(
                                                onPressed: () {},
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                name: 'Book Now',
                                                width: double.maxFinite,
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
                      : DashBoardController.to.allPropertyListing.isEmpty ||
                              DashBoardController.to.allPropertyResponse.isEmpty
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
                                  'You don’t have any Pending Listing',
                                  style: color00000s14w500,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Expanded(
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                scrollDirection:
                                    MediaQuery.of(context).size.width >
                                            MediaQuery.of(context).size.height
                                        ? Axis.horizontal
                                        : Axis.vertical,
                                child:
                                    MediaQuery.of(context).size.width >
                                            MediaQuery.of(context).size.height
                                        ? Row(
                                            children: List.generate(
                                              DashBoardController
                                                  .to.allPropertyListing.length,
                                              (index) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: Container(
                                                          height:
                                                              Get.height / 3,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              color: AppColors
                                                                  .colorD9D9D9),
                                                          child: Stack(
                                                            children: [
                                                              Positioned.fill(
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: DashBoardController
                                                                              .to
                                                                              .allPropertyListing[index]
                                                                          ?[
                                                                          'cover_photo'] ??
                                                                      ' ',
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
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              DashBoardController
                                                                              .to
                                                                              .allPropertyListing[
                                                                          index]
                                                                      ?[
                                                                      'property_name'] ??
                                                                  ' ',
                                                              style:
                                                                  color00000s18w600,
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Price : ',
                                                                style:
                                                                    color00000s14w500,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                '₹ ${DashBoardController.to.allPropertyListing[index]?['property_price']?['price'] ?? '-'} /night',
                                                                style:
                                                                    color00000s14w500,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Last Modified : ',
                                                                  style: color50perBlacks13w400
                                                                      .copyWith(
                                                                          height:
                                                                              0),
                                                                ),
                                                                Text(
                                                                  DashBoardController
                                                                              .to
                                                                              .allPropertyListing[index]['updated_at'] ==
                                                                          null
                                                                      ? '-'
                                                                      : '${DateFormat.yMMMEd().format(DateTime.parse(DashBoardController.to.allPropertyListing[index]['updated_at'].toString())).toString()}  ${DateFormat.jm().format(DateTime.parse(DashBoardController.to.allPropertyListing[index]['updated_at'].toString())).toString()}',
                                                                  style:
                                                                      color00000s14w500,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Status : ',
                                                                  style: color50perBlacks13w400
                                                                      .copyWith(
                                                                          height:
                                                                              0),
                                                                ),
                                                                Text(
                                                                  DashBoardController.to.allPropertyListing[index]
                                                                              [
                                                                              'is_approve'] ==
                                                                          2
                                                                      ? 'Rejected'
                                                                      : DashBoardController
                                                                              .to
                                                                              .allPropertyListing[index]['status'] ??
                                                                          '',
                                                                  style:
                                                                      color00000s14w500,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: CommonButton(
                                                              onPressed: () {
                                                                Get.to(
                                                                  () =>
                                                                      HostScreen(
                                                                    pageNum:
                                                                        0 /*int.parse((DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['steps_completed']).toString())*/,
                                                                    property_id: DashBoardController
                                                                        .to
                                                                        .allPropertyListing[
                                                                            index]
                                                                            ?[
                                                                            'id']
                                                                        .toString(),
                                                                  ),
                                                                );
                                                              },
                                                              name:
                                                                  'Manage Listing',
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          12),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: CommonButton(
                                                              onPressed: () {
                                                                log((DashBoardController
                                                                            .to
                                                                            .allPropertyListing[index]?['id'] ??
                                                                        '')
                                                                    .toString());
                                                                /*Get.to(() =>
                                                                    calander());*/
                                                              },
                                                              name:
                                                                  'Manage Calendar',
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                vertical: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Column(
                                            children: List.generate(
                                              DashBoardController
                                                  .to.allPropertyListing.length,
                                              (index) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: Container(
                                                            height:
                                                                Get.height / 5,
                                                            width:
                                                                Get.height / 5,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                color: AppColors
                                                                    .colorD9D9D9),
                                                            child: Stack(
                                                              children: [
                                                                Positioned.fill(
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: DashBoardController
                                                                            .to
                                                                            .allPropertyListing[index]?['cover_photo'] ??
                                                                        ' ',
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            CupertinoActivityIndicator(
                                                                      color: AppColors
                                                                          .colorFE6927,
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                      Icons
                                                                          .error,
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                DashBoardController
                                                                            .to
                                                                            .allPropertyListing[index]
                                                                        ?[
                                                                        'property_name'] ??
                                                                    ' ',
                                                                style:
                                                                    color00000s18w600,
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'Price : ',
                                                                    style:
                                                                        color00000s14w500,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    '₹ ${DashBoardController.to.allPropertyListing[index]?['property_price']?['price'] ?? '-'} /night',
                                                                    style:
                                                                        color00000s14w500,
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Last Modified : ',
                                                                    style: color50perBlacks13w400
                                                                        .copyWith(
                                                                            height:
                                                                                0),
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                      DashBoardController.to.allPropertyListing[index]['updated_at'] ==
                                                                              null
                                                                          ? '-'
                                                                          : '${DateFormat.yMMMEd().format(DateTime.parse(DashBoardController.to.allPropertyListing[index]['updated_at'].toString())).toString()}  ${DateFormat.jm().format(DateTime.parse(DashBoardController.to.allPropertyListing[index]['updated_at'].toString())).toString()}',
                                                                      style:
                                                                          color00000s14w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 8,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          'Status : ',
                                                                          style:
                                                                              color50perBlacks13w400.copyWith(height: 0),
                                                                        ),
                                                                        Text(
                                                                          DashBoardController.to.allPropertyListing[index]['is_approve'] == 2
                                                                              ? 'Rejected'
                                                                              : DashBoardController.to.allPropertyListing[index]['status'] ?? '',
                                                                          style:
                                                                              color00000s14w500,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: CommonButton(
                                                            onPressed: () {
                                                              Get.to(
                                                                () =>
                                                                    HostScreen(
                                                                  pageNum:
                                                                      0 /*int.parse((DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['steps_completed']).toString())*/,
                                                                  property_id: DashBoardController
                                                                      .to
                                                                      .allPropertyListing[
                                                                          index]
                                                                          ?[
                                                                          'id']
                                                                      .toString(),
                                                                ),
                                                              );
                                                            },
                                                            name:
                                                                'Manage Listing',
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        12),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: CommonButton(
                                                            onPressed: () {
                                                              log((DashBoardController
                                                                              .to
                                                                              .allPropertyListing[index]
                                                                          ?[
                                                                          'id'] ??
                                                                      '')
                                                                  .toString());
                                                              Get.to(
                                                                  () =>
                                                                      calander(
                                                                        property_Id:
                                                                            (DashBoardController.to.allPropertyListing[index]?['id'] ?? '').toString(),
                                                                        property_Price:
                                                                            (DashBoardController.to.allPropertyListing[index]?['property_price']?['price'] ?? '0').toString(),
                                                                      ));
                                                            },
                                                            name:
                                                                'Manage Calendar',
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                              ),
                            );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return showCircle.value
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoActivityIndicator(color: AppColors.colorFE6927),
              )
            : SizedBox();
      }),
    );
  }
}

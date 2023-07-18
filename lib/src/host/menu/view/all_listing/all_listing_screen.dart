import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/src/host/add_property/view/hostScreen.dart';
import 'package:gleeky_flutter/src/host/calendar/view/calander.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/dashboard_controller.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/view_property_controller.dart';
import 'package:gleeky_flutter/src/host/dash_board/view/property_detail_screen.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class AllListingScreen extends StatefulWidget {
  String type;
  AllListingScreen({Key? key, required this.type}) : super(key: key);

  @override
  State<AllListingScreen> createState() => _AllListingScreenState();
}

class _AllListingScreenState extends State<AllListingScreen> {
  RxBool loader = true.obs;
  RxBool showCircle = false.obs;
  RxString dropDownValue = 'All'.obs;
  RxInt offset = 1.obs;

  @override
  initState() {
    dropDownValue.value = widget.type;
    DashBoardController.to.allPropertyListing.clear();
    DashBoardController.to.allPropertyApi(
        params: {
          "status": dropDownValue.value,
          'page': offset.value,
          'limit': 10
        },
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
            params: {
              "status": dropDownValue.value,
              'page': offset,
              'limit': 10
            },
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

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 17, left: 27, right: 27),
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
                        'All Listing',
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
              StreamBuilder(
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
                        items: <String>[
                          'All',
                          'Listed',
                          'Unlisted',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: color00000s14w500),
                          );
                        }).toList(),
                        onChanged: (_) {
                          dropDownValue.value = _.toString();
                          offset.value = 1;
                          loader.value = true;

                          DashBoardController.to.allPropertyListing.clear();
                          DashBoardController.to.allPropertyApi(
                              params: {
                                "status": dropDownValue.value,
                                'page': offset,
                                'limit': 10
                              },
                              success: () {
                                loader.value = false;
                                offset.value = offset.value + 1;
                              },
                              error: (e) {
                                Get.back();
                              });
                        },
                      ),
                    );
                  }),
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
                                  'You don’t have any listing',
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
                                                      Bounce(
                                                        onPressed: () {
                                                          if (DashBoardController
                                                                  .to
                                                                  .allPropertyListing[
                                                                      index]
                                                                      ['status']
                                                                  .toString() ==
                                                              'Listed') {
                                                            loaderShow(context);
                                                            ViewPropertyController
                                                                .to
                                                                .viewPropertyController(
                                                              slug: (DashBoardController
                                                                              .to
                                                                              .allPropertyListing[
                                                                          index]
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
                                                          // Get.to(PropertyAllDetails(
                                                          //         slug: DashBoardController
                                                          //                     .to
                                                          //                     .allPropertyListing[
                                                          //                 index]
                                                          //             ?['slug'])
                                                          //     .toString());
                                                        },
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    150),
                                                        child: Container(
                                                          color: Colors.black,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            child: Container(
                                                              height:
                                                                  Get.height /
                                                                      3,
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
                                                              child: Positioned
                                                                  .fill(
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
                                                            ),
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
                                                                'Pricekg : ',
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
                                                                  'Property Name : ',
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
                                                                    pageNum: 0,
                                                                    /* int.parse((DashBoardController
                                                                            .to
                                                                            .unlistedPropertyRes['data']['properties'][index]?['steps_completed'])
                                                                        .toString()),*/
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
                                                    Bounce(
                                                      onPressed: () {
                                                        if (DashBoardController
                                                                .to
                                                                .allPropertyListing[
                                                                    index]
                                                                    ['status']
                                                                .toString() ==
                                                            'Listed') {
                                                          loaderShow(context);
                                                          ViewPropertyController
                                                              .to
                                                              .viewPropertyController(
                                                            slug: (DashBoardController
                                                                        .to
                                                                        .allPropertyListing[
                                                                    index]?['slug'])
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
                                                        // Get.to(() => PropertyAllDetails(
                                                        //     slug: DashBoardController
                                                        //             .to
                                                        //             .allPropertyListing[
                                                        //                 index]?[
                                                        //                 'slug']
                                                        //             .toString() ??
                                                        //         ''));
                                                      },
                                                      duration: const Duration(
                                                          milliseconds: 150),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: Container(
                                                          height:
                                                              Get.height / 3,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
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
                                                                        index]?[
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
                                                                'Property Name : ',
                                                                style: color50perBlacks13w400
                                                                    .copyWith(
                                                                        height:
                                                                            0),
                                                              ),
                                                              Text(
                                                                DashBoardController.to.allPropertyListing[index]
                                                                            [
                                                                            'name'] ==
                                                                        null
                                                                    ? '-'
                                                                    : DashBoardController
                                                                        .to
                                                                        .allPropertyListing[
                                                                            index]
                                                                            [
                                                                            'name']
                                                                        .toString(),
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
                                                                            'status'] ==
                                                                        "Listed"
                                                                    ? (DashBoardController.to.allPropertyListing[index]['is_approve'] ==
                                                                            '0')
                                                                        ? 'Approval Pending'
                                                                        : 'Listed'
                                                                    : DashBoardController.to.allPropertyListing[index]['is_approve'] ==
                                                                            '2'
                                                                        ? 'Rejected'
                                                                        : DashBoardController.to.allPropertyListing[index]['status'] ??
                                                                            '',
                                                                style: DashBoardController.to.allPropertyListing[index]
                                                                            [
                                                                            'status'] ==
                                                                        "Listed"
                                                                    ? (DashBoardController.to.allPropertyListing[index]['is_approve'] ==
                                                                            '0')
                                                                        ? colorFFAE00s14w500
                                                                        : color45C625s14w500
                                                                    : color00000s14w500,
                                                              ),

                                                              /* Text(
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
                                                              ),*/
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
                                                              log("--->  ${DashBoardController.to.allPropertyListing[index]?['steps_completed'].toString()}");
                                                              Get.to(
                                                                () =>
                                                                    HostScreen(
                                                                  pageNum:
                                                                      /*int.parse((DashBoardController
                                                                              .to
                                                                              .unlistedPropertyRes['data']['properties'][index]
                                                                          ?[
                                                                          'steps_completed'])
                                                                      .toString()),*/
                                                                      // 0,
                                                                      DashBoardController
                                                                              .to
                                                                              .allPropertyListing[index]
                                                                          ?[
                                                                          'steps_completed'],
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
              // const SizedBox(
              //   height: 15,
              // ),
            ],
          ),
        ),
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

import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
import 'package:gleeky_flutter/src/host/add_property/view/hostScreen.dart';
import 'package:gleeky_flutter/src/host/calendar/view/calander.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/getUserController.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/view_property_controller.dart';
import 'package:gleeky_flutter/src/host/menu/view/all_listing/all_listing_screen.dart';
import 'package:gleeky_flutter/src/host/menu/view/kyc/kyc_screen.dart';
import 'package:gleeky_flutter/src/host/menu/view/profile/profile.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'acceptAndDeclineScreen.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../controller/dashboard_controller.dart';
import 'all_reservation_screen.dart';
import 'property_detail_screen.dart';
import 'view_receipt_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  UserController userController = Get.put(UserController());
  List opetions = [
    'All',
    'Currently Hosting',
    'Completed',
    'Arriving Soon',
    'Expired',
    'Cancelled'
  ];

  RxBool isshimmer = true.obs;

  @override
  initState() {
    log("USER MODEL $user_model");

    GetUserController.to.getUserApi();
    DashBoardController.to.AllReservation.clear();
    DashBoardController.to.reservationApi(
      params: {'offset': '0', "limit": "10000"},
      success: () {
        isshimmer.value = false;
      },
      error: (e) {
        showSnackBar(title: ApiConfig.error, message: e.toString());
      },
    );
    DashBoardController.to.unlistedPropertyAPI(
      params: {'status': 'Listed', 'page': 0, "limit": 10},
      error: (e) {
        showSnackBar(title: ApiConfig.error, message: e.toString());
      },
    );

    super.initState();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  _onRefresh() async {
    isshimmer.value = true;

    log('REFRESH START', name: 'START');
    /*DashBoardController.to.reservationResponse.clear();*/
    DashBoardController.to.unlistedPropertyRes.clear();
    await DashBoardController.to.unlistedPropertyAPI(
      params: {'status': 'Listed', 'page': 0, "limit": 10},
      success: () {
        isshimmer.value = false;
      },
      error: (e) {
        showSnackBar(title: ApiConfig.error, message: e.toString());
      },
    );
    /*await DashBoardController.to.reservationApi(
        params: {'offset': '0', "limit": "10"},
        success: () {
          isshimmer.value = false;
        },
        error: (e) {
          showSnackBar(title: ApiConfig.error, message: e.toString());
        });*/

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          //context: _scaffoldKey.currentContext,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              scrollable: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Are you want to exit from Gleekey?',
                      style: color00000s18w600,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  child: CommonButton(
                    onPressed: () {
                      Get.back();
                    },
                    color: AppColors.colorEBEBEB,
                    style: colorfffffffs13w600.copyWith(
                        color: AppColors.color000000.withOpacity(0.7)),
                    name: 'No',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  child: CommonButton(
                    onPressed: () {
                      exit(0);
                    },
                    name: 'Yes',
                  ),
                ),
              ],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            );
          },
        );
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 80),
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/appbar_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Bounce(
                            duration: const Duration(milliseconds: 200),
                            onPressed: () {
                              Get.to(() => ProfileScreen());
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: user_model?.data?.profileSrc ?? '',
                                placeholder: (context, url) =>
                                    Image.asset(AppImages.profile_image),
                                errorWidget: (context, url, error) =>
                                    Image.asset(AppImages.profile_image),
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              'Hey , ${user_model?.data?.firstName ?? ''}',
                              style: color00000s18w600.copyWith(
                                  color: AppColors.colorffffff),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PrefController.to.user_id.value != null
                        ? CommonButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            onPressed: () {
                              // loaderShow(context);
                              Get.to(
                                () => HostScreen(
                                    // property_id: response.data['data']?['property_id'].toString(),
                                    ),
                              );
                            },
                            name: 'Host Property')
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: Obx(
              () {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EarningsView(context),
                      Divider(
                        color: AppColors.color000000.withOpacity(0.1),
                      ),
                      BookingsCalendarView(),
                      Divider(
                        color: AppColors.color000000.withOpacity(0.1),
                      ),
                      /* ReservationView(context),
                      Divider(
                        color: AppColors.color000000.withOpacity(0.1),
                      ),*/
                      PropertiesDetailView(),
                      /* Divider(
                        color: AppColors.color000000.withOpacity(0.1),
                      ),*/
                      /*  Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 27, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Your Listed Properties',
                              style: color00000s18w600,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            ((DashBoardController
                                        .to.unlistedPropertyRes.isNotEmpty &&
                                    (DashBoardController
                                                .to.unlistedPropertyRes['data']
                                            ?['properties'] !=
                                        null)))
                                ? ((DashBoardController
                                                .to
                                                .unlistedPropertyRes['data']
                                                    ?['properties']
                                                .length ??
                                            0) >
                                        3)
                                    ? InkWell(
                                        onTap: () {
                                          Get.to(() => const AllListingScreen());
                                        },
                                        child: Text('View All',
                                            style: colorFE6927s12w600))
                                    : const SizedBox()
                                : const SizedBox(),
                          ],
                        ),
                      ),*/
                      isshimmer.value
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 27, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor:
                                        AppColors.colorD9D9D9.withOpacity(0.2),
                                    highlightColor: AppColors.colorD9D9D9,
                                    child: Image.asset(
                                      AppImages.villaImg,
                                      height: 210,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Shimmer.fromColors(
                                          baseColor: AppColors.colorD9D9D9
                                              .withOpacity(0.2),
                                          highlightColor: AppColors.colorD9D9D9,
                                          child: Container(
                                            height: 20,
                                            color: AppColors.colorF8F8F8,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: AppColors.colorD9D9D9
                                            .withOpacity(0.2),
                                        highlightColor: AppColors.colorD9D9D9,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              AppImages.starIcon,
                                              height: 19,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '5.0',
                                              style: color00000s14w500,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Shimmer.fromColors(
                                    baseColor:
                                        AppColors.colorD9D9D9.withOpacity(0.2),
                                    highlightColor: AppColors.colorD9D9D9,
                                    child: Container(
                                      height: 20,
                                      width: double.maxFinite,
                                      color: AppColors.colorF8F8F8,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Shimmer.fromColors(
                                    baseColor:
                                        AppColors.colorD9D9D9.withOpacity(0.2),
                                    highlightColor: AppColors.colorD9D9D9,
                                    child: Container(
                                      height: 20,
                                      width: double.maxFinite,
                                      color: AppColors.colorF8F8F8,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Shimmer.fromColors(
                                    baseColor:
                                        AppColors.colorD9D9D9.withOpacity(0.2),
                                    highlightColor: AppColors.colorD9D9D9,
                                    child: Container(
                                      height: 20,
                                      width: double.maxFinite,
                                      color: AppColors.colorF8F8F8,
                                    ),
                                  ),
                                  Shimmer.fromColors(
                                    baseColor:
                                        AppColors.colorD9D9D9.withOpacity(0.2),
                                    highlightColor: AppColors.colorD9D9D9,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CommonButton(
                                              onPressed: () {},
                                              name: 'Manage Listing',
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: CommonButton(
                                              onPressed: () {},
                                              name: 'Manage Calendar',
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : StreamBuilder(
                              stream: DashBoardController
                                  .to.unlistedPropertyRes.stream,
                              builder: (context, snapshot) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ((DashBoardController
                                                  .to
                                                  .unlistedPropertyRes
                                                  .isEmpty) ||
                                              (DashBoardController
                                                  .to
                                                  .unlistedPropertyRes['data']
                                                  .isEmpty) ||
                                              (DashBoardController.to
                                                          .unlistedPropertyRes[
                                                      'data']?['properties'] ==
                                                  null))
                                          ? const SizedBox()
                                          : (MediaQuery.of(context).size.width <
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height)
                                              ? Column(
                                                  children: List.generate(
                                                    ((DashBoardController
                                                                    .to
                                                                    .unlistedPropertyRes[
                                                                        'data']
                                                                        ?[
                                                                        'properties']
                                                                    .length ??
                                                                0) >
                                                            3)
                                                        ? 3
                                                        : (DashBoardController
                                                                .to
                                                                .unlistedPropertyRes[
                                                                    'data']?[
                                                                    'properties']
                                                                .length ??
                                                            0),
                                                    (index) => Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 7),
                                                      child: SizedBox(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width <
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height)
                                                            ? (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                54)
                                                            : (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.3),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                                height:
                                                                    Get.height *
                                                                        0.01),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              (DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['name'] ?? 'Gleekey Resort'),
                                                                              style: color00000s18w600,
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Image.asset(AppImages.starIcon, height: 19),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Text(
                                                                                (DashBoardController.to.unlistedPropertyRes['data']?['properties']?[index]?['avg_rating'] ?? '0').toString(),
                                                                                style: color00000s14w500,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              15),
                                                                      Text(
                                                                        'Start From ',
                                                                        style:
                                                                            color828282s12w400,
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                      Text(
                                                                        '₹ ${DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['property_price']?['price'] ?? '0'}/night',
                                                                        style:
                                                                            color645555s15w700,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 15,
                                                                ),
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child:
                                                                      Container(
                                                                    height: (MediaQuery.of(context).size.width <
                                                                            MediaQuery.of(context)
                                                                                .size
                                                                                .height)
                                                                        ? (Get.height /
                                                                            6.5)
                                                                        : (Get.height /
                                                                            6),
                                                                    width: (MediaQuery.of(context)
                                                                                .size
                                                                                .width <
                                                                            MediaQuery.of(context)
                                                                                .size
                                                                                .height)
                                                                        ? (MediaQuery.of(context).size.width /
                                                                            3.5)
                                                                        : (MediaQuery.of(context).size.width /
                                                                            6),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                12),
                                                                        color: AppColors
                                                                            .colorD9D9D9),
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Positioned
                                                                            .fill(
                                                                          child:
                                                                              Bounce(
                                                                            duration:
                                                                                const Duration(milliseconds: 150),
                                                                            onPressed:
                                                                                () {
                                                                              loaderShow(context);
                                                                              ViewPropertyController.to.viewPropertyController(
                                                                                slug: (DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['slug']).toString(),
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
                                                                            },
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              imageUrl: DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['cover_photo'] ?? ' ',
                                                                              placeholder: (context, url) => CupertinoActivityIndicator(
                                                                                color: AppColors.colorFE6927,
                                                                              ),
                                                                              errorWidget: (context, url, error) => const Icon(
                                                                                Icons.error,
                                                                              ),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            (DashBoardController.to.unlistedPropertyRes['data']['properties'][index]
                                                                            ?[
                                                                            'steps_completed'] ??
                                                                        '') ==
                                                                    0
                                                                ? const SizedBox()
                                                                : SizedBox(
                                                                    height: Get
                                                                            .height *
                                                                        0.015),
                                                            (DashBoardController
                                                                            .to
                                                                            .unlistedPropertyRes['data']['properties'][index]?['steps_completed'] ??
                                                                        '') ==
                                                                    0
                                                                ? const SizedBox()
                                                                : Row(
                                                                    children: [
                                                                      Text(
                                                                        'Complete Important Details : ',
                                                                        style:
                                                                            color000000s12w400,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          'Required To Publish',
                                                                          style:
                                                                              colorFE6927s12w600,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            SizedBox(
                                                                height:
                                                                    Get.height *
                                                                        0.01),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Status : ',
                                                                  style:
                                                                      color000000s12w400,
                                                                ),
                                                                SizedBox(
                                                                    height: Get
                                                                            .height *
                                                                        0.005),
                                                                Flexible(
                                                                  child: Text(
                                                                    (DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['steps_completed'] ??
                                                                                '') ==
                                                                            0
                                                                        ? 'Published'
                                                                        : 'Pending (${DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['steps_completed'] ?? '0'} Steps To Be Listed)',
                                                                    style: colorFE6927s12w600.copyWith(
                                                                        color: (DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['steps_completed'] ?? '') ==
                                                                                0
                                                                            ? AppColors.color32BD01
                                                                            : AppColors.colorFE6927),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                vertical:
                                                                    Get.height *
                                                                        0.015,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        CommonButton(
                                                                      onPressed:
                                                                          () {
                                                                        Get.to(
                                                                          () =>
                                                                              HostScreen(
                                                                            pageNum:
                                                                                0 /*int.parse((DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['steps_completed']).toString())*/,
                                                                            property_id:
                                                                                DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['id'].toString(),
                                                                          ),
                                                                        );
                                                                      },
                                                                      name:
                                                                          'Manage Listing',
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        vertical:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          20),
                                                                  Expanded(
                                                                    child:
                                                                        CommonButton(
                                                                      onPressed:
                                                                          () {
                                                                        Get.to(() =>
                                                                            calander(
                                                                              property_Id: (DashBoardController.to.unlistedPropertyRes['data']?['properties']?[index]?['id'] ?? '').toString(),
                                                                              property_Price: (DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['property_price']?['price'] ?? '0').toString(),
                                                                            ));
                                                                      },
                                                                      name:
                                                                          'Manage Calendar',
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        vertical:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.1),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: List.generate(
                                                      ((DashBoardController
                                                                      .to
                                                                      .unlistedPropertyRes[
                                                                          'data']
                                                                          ?[
                                                                          'properties']
                                                                      .length ??
                                                                  0) >
                                                              3)
                                                          ? 3
                                                          : (DashBoardController
                                                                  .to
                                                                  .unlistedPropertyRes[
                                                                      'data']?[
                                                                      'properties']
                                                                  .length ??
                                                              0),
                                                      (index) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 7),
                                                        child: SizedBox(
                                                          width: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width <
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height)
                                                              ? (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  54)
                                                              : (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2.3),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height:
                                                                      Get.height *
                                                                          0.01),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    child:
                                                                        Container(
                                                                      height: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height)
                                                                          ? (Get.height /
                                                                              6.5)
                                                                          : (Get.height /
                                                                              6),
                                                                      width: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height)
                                                                          ? (MediaQuery.of(context).size.width /
                                                                              3.5)
                                                                          : (MediaQuery.of(context).size.width /
                                                                              6),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              12),
                                                                          color:
                                                                              AppColors.colorD9D9D9),
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Bounce(
                                                                            duration:
                                                                                const Duration(milliseconds: 150),
                                                                            onPressed:
                                                                                () {},
                                                                            child:
                                                                                Positioned.fill(
                                                                              child: CachedNetworkImage(
                                                                                imageUrl: DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['cover_photo'] ?? ' ',
                                                                                placeholder: (context, url) => CupertinoActivityIndicator(
                                                                                  color: AppColors.colorFE6927,
                                                                                ),
                                                                                errorWidget: (context, url, error) => const Icon(
                                                                                  Icons.error,
                                                                                ),
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['name'] ?? 'Gleekey Resort',
                                                                                style: color00000s18w600,
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Image.asset(AppImages.starIcon, height: 19),
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                Text(
                                                                                  (DashBoardController.to.unlistedPropertyRes['data']?['properties']?[index]?['avg_rating'] ?? '0').toString(),
                                                                                  style: color00000s14w500,
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                Get.height * 0.005),
                                                                        Text(
                                                                          'Start From ',
                                                                          style:
                                                                              color828282s12w400,
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                Get.height * 0.005),
                                                                        Text(
                                                                          '₹ ${DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['property_price']?['price'] ?? '0'}/night',
                                                                          style:
                                                                              color645555s15w700,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      Get.height *
                                                                          0.005),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'Complete Important Details : ',
                                                                    style:
                                                                        color000000s12w400,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                      'Required To Publish',
                                                                      style:
                                                                          colorFE6927s12w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      Get.height *
                                                                          0.005),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'Status : ',
                                                                    style:
                                                                        color000000s12w400,
                                                                  ),
                                                                  SizedBox(
                                                                      height: Get
                                                                              .height *
                                                                          0.005),
                                                                  Flexible(
                                                                    child: Text(
                                                                      'Pending (${DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['steps_completed'] ?? '0'} Steps To Be Listed)',
                                                                      style:
                                                                          colorFE6927s12w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  vertical:
                                                                      Get.height *
                                                                          0.02,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          CommonButton(
                                                                        onPressed:
                                                                            () {
                                                                          Get.to(
                                                                            () =>
                                                                                HostScreen(
                                                                              pageNum: 0 /*int.parse((DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['steps_completed']).toString())*/,
                                                                              property_id: DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['id'].toString(),
                                                                            ),
                                                                          );
                                                                        },
                                                                        name:
                                                                            'Manage Listing',
                                                                        padding:
                                                                            const EdgeInsets.symmetric(
                                                                          vertical:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width: Get.height *
                                                                            0.01),
                                                                    Expanded(
                                                                      child:
                                                                          CommonButton(
                                                                        onPressed:
                                                                            () {
                                                                          Get.to(() =>
                                                                              calander(
                                                                                property_Id: (DashBoardController.to.unlistedPropertyRes['data']?['properties']?[index]?['id'] ?? '').toString(),
                                                                                property_Price: (DashBoardController.to.unlistedPropertyRes['data']['properties'][index]?['property_price']?['price'] ?? '0').toString(),
                                                                              ));
                                                                        },
                                                                        name:
                                                                            'Manage Calendar',
                                                                        padding:
                                                                            const EdgeInsets.symmetric(
                                                                          vertical:
                                                                              15,
                                                                        ),
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
                                                ),
                                    ],
                                  ),
                                );
                              },
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      DesignedBySoftView(),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Container DesignedBySoftView() {
    return Container(
      decoration: BoxDecoration(color: AppColors.colorFE6927.withOpacity(0.2)),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
          child: RichText(
        text: TextSpan(
          text: 'Design by',
          style: colorFE6927s12w600.copyWith(
              color: AppColors.color000000.withOpacity(0.5),
              fontWeight: FontWeight.w400),
          children: <TextSpan>[
            TextSpan(
              text: ' Softieons Technology ',
              style: colorFE6927s12w600.copyWith(
                  color: AppColors.color000000, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      )),
    );
  }

  Column PropertiesDetailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'My Booking Listing',
                style: color00000s18w600,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27.0),
          child: Row(
            children: [
              Expanded(
                child: Bounce(
                  duration: const Duration(milliseconds: 150),
                  onPressed: () {
                    Get.to(() => AllListingScreen(
                          type: 'Listed',
                        ));
                  },
                  child: Container(
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
                      vertical: 25,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.listedPropertiesIcon,
                                height: 25,
                                width: 25,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Listed',
                                style: color00000s14w500.copyWith(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${user_model?.data?.totalListed ?? 0}',
                            style: color00000s14w500.copyWith(
                                color: AppColors.color32BD01,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Bounce(
                  duration: const Duration(milliseconds: 150),
                  onPressed: () {
                    Get.to(() => AllListingScreen(
                          type: 'Unlisted',
                        ));
                  },
                  child: Container(
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
                      vertical: 25,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.pending_icon,
                                height: 25,
                                width: 25,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Unlisted',
                                style: color00000s14w500.copyWith(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${user_model?.data?.totalPending ?? 0}',
                            style: color00000s14w500.copyWith(
                                color: Colors.redAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Bounce(
          duration: const Duration(milliseconds: 150),
          onPressed: () {
            Get.to(() => AllListingScreen(
                  type: 'All',
                ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27.0),
            child: Container(
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
                vertical: 25,
              ),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.property_icon,
                          height: 25,
                          width: 25,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Total Properties',
                          style: color00000s14w500.copyWith(
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${user_model?.data?.totalProperty ?? 0}',
                      style: color00000s14w500.copyWith(
                          color: AppColors.colorFE6927,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Your Listed Properties',
                style: color00000s18w600,
              ),
              const SizedBox(
                height: 8,
              ),
              ((DashBoardController.to.unlistedPropertyRes.isNotEmpty &&
                      (DashBoardController.to.unlistedPropertyRes['data']
                              ?['properties'] !=
                          null)))
                  ? ((DashBoardController
                                  .to
                                  .unlistedPropertyRes['data']?['properties']
                                  .length ??
                              0) >
                          3)
                      ? Bounce(
                          onPressed: () {
                            Get.to(() => AllListingScreen(type: 'All'));
                          },
                          duration: const Duration(milliseconds: 100),
                          child: Text('View All',
                              style: colorFE6927s12w600.copyWith(fontSize: 16)),
                        )
                      : const SizedBox()
                  : const SizedBox(),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Column ReservationView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 27,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Reservation',
                style: color00000s18w600,
              ),
              (DashBoardController.to.reservationResponse['data'] != null)
                  ? (DashBoardController.to
                              .reservationResponse['data']['bookings'].length >
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
        ),
        const SizedBox(
          height: 8,
        ),
        isshimmer.value
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 27,
                  vertical: 17,
                ),
                child: Column(
                  children: List.generate(
                      1,
                      (index) => Column(
                            children: [
                              Shimmer.fromColors(
                                baseColor:
                                    AppColors.colorD9D9D9.withOpacity(0.2),
                                highlightColor: AppColors.colorD9D9D9,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
              )
            : DashBoardController
                        .to.reservationResponse['data']['bookings'].length ==
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
                : Scrollbar(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          (DashBoardController
                                      .to
                                      .reservationResponse['data']['bookings']
                                      .length >
                                  3)
                              ? 3
                              : DashBoardController
                                  .to
                                  .reservationResponse['data']['bookings']
                                  .length,
                          (index) => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 27,
                                  vertical: 12,
                                ),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 54,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              slug: (DashBoardController.to
                                                                  .reservationResponse[
                                                              'data']
                                                          ?['bookings']?[index]
                                                      ['properties']?['slug'])
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
                                            imageUrl: DashBoardController
                                                        .to.reservationResponse[
                                                    'data']['bookings'][index]
                                                ['properties']['cover_photo'],
                                            placeholder: (context, url) =>
                                                CupertinoActivityIndicator(
                                              color: AppColors.colorFE6927,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
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
                                                                  FontWeight
                                                                      .w400,
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
                                                                      'data']
                                                                  ?['bookings']
                                                              ?[
                                                              index]?['status'] ??
                                                          '-',
                                                      style: color000000s12w400
                                                          .copyWith(
                                                              color: (DashBoardController.to.reservationResponse['data']?['bookings']?[index]
                                                                              ?[
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
                                                                          : AppColors.colorFE6927),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 7),
                                              ((DashBoardController.to.reservationResponse['data']
                                                                          ?['bookings']
                                                                      ?[index]
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
                                                                      ?['bookings']?[index]
                                                                  ?['status'] ??
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
                                                                () => (DashBoardController.to.reservationResponse['data']?['bookings']?[index]?['status'] ??
                                                                            '-') ==
                                                                        'Pending'
                                                                    ? AcceptAndDeclineScreen(
                                                                        data: DashBoardController
                                                                            .to
                                                                            .reservationResponse['data']?['bookings']?[index],
                                                                      )
                                                                    : ViewReceiptsScreen(
                                                                        data: DashBoardController
                                                                            .to
                                                                            .reservationResponse['data']?['bookings']?[index],
                                                                      ),
                                                              );
                                                            },
                                                            child: Text(
                                                              (DashBoardController.to.reservationResponse['data']?['bookings']?[index]
                                                                              ?[
                                                                              'status'] ??
                                                                          '-') ==
                                                                      'Pending'
                                                                  ? 'Accept / Decline'
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Column BookingsCalendarView() {
    return Column(
      children: [
        /*const SizedBox(
          height: 10,
        ),*/
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Center(
              child: Text(
                'My Booking',
                style: colorfffffffs13w600.copyWith(
                    fontSize: 22, color: AppColors.color000000),
              ),
            ),
          ),
        ),
        /*Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            height: 550,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              */ /* border: Border.all(
                color: AppColors.colorFE6927,
              ),*/ /*
              color: AppColors.colorffffff,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 5,
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                ),
              ],
            ),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.colorFE6927,
                unselectedWidgetColor: AppColors.colorFE6927,
                primarySwatch: Colors.deepOrange,
                secondaryHeaderColor: Colors.red,
              ),
              child: SfCalendar(
                view: CalendarView.month,
                headerStyle: CalendarHeaderStyle(
                  textAlign: TextAlign.center,
                  textStyle: color00000s13w600,
                ),
                backgroundColor: AppColors.colorffffff,
                cellEndPadding: 10,
                initialSelectedDate: DateTime.now(),
                minDate: DateTime.now(),
                maxDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day + 45),
                cellBorderColor: AppColors.colorFE6927.withOpacity(
                  0.2,
                ),
                monthCellBuilder:
                    (BuildContext buildContext, MonthCellDetails details) {
                  final Color backgroundColor = Colors.white;
                  final Color defaultColor =
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.black54
                          : Colors.white;
                  return Container(
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(color: defaultColor, width: 0.5)),
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        details.date.day.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                },
                monthViewSettings: MonthViewSettings(
                    showAgenda: true,
                    showTrailingAndLeadingDates: false,
                    dayFormat: 'EEE',
                    monthCellStyle: MonthCellStyle(
                      leadingDatesBackgroundColor: AppColors.color000000,
                      trailingDatesBackgroundColor: AppColors.color000000,
                    )),
                dataSource: _getCalendarDataSource(),
              ),
            ),
          ),
        ),*/
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            height: 550,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              /* border: Border.all(
                color: AppColors.colorFE6927,
              ),*/
              color: AppColors.colorffffff,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 5,
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Theme(
                data: ThemeData(
                  // primaryColor: AppColors.colorFE6927,
                  // unselectedWidgetColor: AppColors.colorFE6927,
                  primarySwatch: Colors.deepOrange,
                ),
                child: SfCalendar(
                  view: CalendarView.month,
                  headerHeight: 60,
                  headerStyle: CalendarHeaderStyle(
                    textAlign: TextAlign.center,
                    textStyle: color00000s15w600,
                  ),
                  viewHeaderStyle: ViewHeaderStyle(
                    backgroundColor: AppColors.colorFE6927.withOpacity(0.2),
                    dayTextStyle: color00000s12w600,
                  ),
                  backgroundColor: AppColors.colorffffff,
                  cellEndPadding: 10,
                  /* initialSelectedDate: DateTime.now(),*/
                  minDate: DateTime.now(),
                  maxDate: DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day + 45),
                  cellBorderColor: AppColors.colorFE6927.withOpacity(
                    0.2,
                  ),
                  selectionDecoration: const BoxDecoration(),
                  monthCellBuilder:
                      (BuildContext buildContext, MonthCellDetails details) {
                    const Color backgroundColor = Colors.white;
                    final Color defaultColor =
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black54
                            : Colors.white;
                    return
                        // details.date.isAfter(DateTime(
                        //           DateTime.now().year,
                        //           DateTime.now().month,
                        //           DateTime.now().day - 1)) &&
                        //       details.date.isBefore(DateTime(DateTime.now().year,
                        //           DateTime.now().month, DateTime.now().day + 45))
                        //   ?
                        Container(
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: defaultColor, width: 0.5)),
                      padding: const EdgeInsets.all(8),
                      child: CircleAvatar(
                        backgroundColor: mybookingList.isEmpty
                            ? Colors.white
                            : getColour(details.date),
                        child: Center(
                          child: Text(
                            details.date.day.toString(),
                            style: const TextStyle(
                                color:
                                    /*  details.date.isBefore(DateTime.now()) ||
                                            details.date.isAfter(DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day + 45))
                                        ? Colors.
                                        :*/
                                    Colors.black),
                          ),
                        ),
                      ),
                    );
                    // : SizedBox();
                  },
                  monthViewSettings: MonthViewSettings(
                      showAgenda: true,
                      showTrailingAndLeadingDates: false,
                      dayFormat: 'EEE',
                      monthCellStyle: MonthCellStyle(
                        leadingDatesBackgroundColor: AppColors.color000000,
                        trailingDatesBackgroundColor: AppColors.color000000,
                      ),
                      agendaItemHeight: 30,
                      agendaViewHeight: 100,
                      appointmentDisplayCount: 0),
                  dataSource: _getCalendarDataSource(),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            statusView(
              color: AppColors.colorffc107,
              status: 'Upcoming Bookings',
            ),
            statusView(
              color: AppColors.colorFE6927,
              status: 'Ongoing Bookings',
            ),
            statusView(
              color: AppColors.color32BD01,
              status: 'Completed Bookings',
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27),
          child: CommonButton(
            onPressed: () {
              Get.to(() => const AllreservationScreen());
            },
            width: MediaQuery.of(context).size.width,
            name: 'All Reservations',
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Column EarningsView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        ((user_model?.data?.kycStatus ?? '') == 'Processing')
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 27.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.colord1ecf1,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: AppColors.color000000, size: 25),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          'Your request for KYC has been successfully submitted and sent for further processing !',
                          style: color00000s14w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ((user_model?.data?.kycStatus ?? '') == 'Pending') ||
                    ((user_model?.data?.kycStatus ?? '') == 'Re-Submited')
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 27.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.colorFE6927.withOpacity(0.2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: AppColors.color000000, size: 25),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        'Your Glee Partner KYC is pending. Please ',
                                    style: color00000s14w500),
                                TextSpan(
                                  text: 'Complete Glee Partner KYC.',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap =
                                        () => Get.to(() => KycScreen()),
                                  style: color00000s14w500.copyWith(
                                      color: AppColors.colorFE6927,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  )
                : ((user_model?.data?.kycStatus ?? '') == 'Reject')
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 27.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.colorf8d7da.withOpacity(0.2),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  color: AppColors.color000000, size: 25),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              'Your request for KYC has been rejected! Please ',
                                          style: color00000s14w500),
                                      TextSpan(
                                        text: 'Verify ',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () =>
                                              Get.to(() => KycScreen()),
                                        style: color00000s14w500.copyWith(
                                            color: AppColors.colorFE6927,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      TextSpan(
                                          text: 'your details.',
                                          style: color00000s14w500),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Center(
              child: Text(
                'Your Earnings',
                style: colorfffffffs13w600.copyWith(
                    fontSize: 22, color: AppColors.color000000),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
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
                    vertical: 25,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.received_Icon,
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Received',
                              style: color00000s14w500.copyWith(
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          '₹ ${user_model?.data?.totalRecivedAmount ?? 0}',
                          style: color00000s14w500.copyWith(
                              color: AppColors.color32BD01,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
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
                    vertical: 25,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.pending_icon,
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Pending',
                              style: color00000s14w500.copyWith(
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          '₹ ${user_model?.data?.totalPendingAmount ?? 0}',
                          style: color00000s14w500.copyWith(
                              color: AppColors.colorE31717,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27.0),
          child: Row(
            children: [
              Expanded(
                child: Bounce(
                  duration: const Duration(milliseconds: 200),
                  onPressed: () {
                    Get.to(() => AllListingScreen(
                          type: 'All',
                        ));
                  },
                  child: Container(
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
                      vertical: 25,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.property_icon,
                                height: 25,
                                width: 25,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Total Properties',
                                style: color00000s14w500.copyWith(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${user_model?.data?.totalProperty ?? 0}',
                            style: color00000s14w500.copyWith(
                                color: AppColors.colorFE6927,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Bounce(
                  duration: const Duration(milliseconds: 200),
                  onPressed: () {
                    Get.to(() => const AllreservationScreen());
                  },
                  child: Container(
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
                      vertical: 25,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.reservation_Icon,
                                height: 25,
                                width: 25,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Reservation',
                                style: color00000s14w500.copyWith(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${user_model?.data?.totalReservation ?? 0}',
                            style: color00000s14w500.copyWith(
                                color: AppColors.colorFE6927,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Padding statusView({required Color color, required String status}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            status,
            style: color000000s12w400.copyWith(fontSize: 13),
          )
        ],
      ),
    );
  }

  Color getColour(DateTime date) {
    Color barColor = Colors.white;
    for (var element in mybookingList) {
      if (element.subject == 'Upcoming' &&
          (((element.startTime == date) || (element.endTime == date)) ||
              (element.startTime.isBefore(date) &&
                  element.endTime.isAfter(date)))) {
        barColor = const Color(0xffffc107);
      } else if (element.subject == 'Completed' &&
          (((element.startTime == date) || (element.endTime == date)) ||
              (element.startTime.isBefore(date) &&
                  element.endTime.isAfter(date)))) {
        barColor = const Color(0xff32BD01);
      } else if (element.subject == 'Ongoing' &&
          (((element.startTime == date) || (element.endTime == date)) ||
              (element.startTime.isBefore(date) &&
                  element.endTime.isAfter(date)))) {
        barColor = const Color(0xffFE6927);
      } else {}
    }
    return barColor;
  }
}

_AppointmentDataSource _getCalendarDataSource() {
  List<Appointment> appointments = <Appointment>[];
  appointments.clear();
  for (var element in DashBoardController.to.OngoingReservation) {
    /*if (element['status'] == 'Pending') {*/
    appointments.add(Appointment(
      startTime: DateTime.parse((element['start_date']).toString()),
      endTime: DateTime.parse((element['end_date']).toString()),
      id: element['id'],
      subject:
          /*'${element['properties']['name']} Booked by : ${element['booking_first_name']} ${element['booking_last_name']}'*/ 'Ongoing',
      color: AppColors.colorFE6927,
    ));
    /*  }*/
  }

  for (var element in DashBoardController.to.UpcomingReservation) {
    appointments.add(Appointment(
      startTime: DateTime.parse((element['start_date']).toString()),
      endTime: DateTime.parse((element['end_date']).toString()),
      id: element['id'],
      subject:
          /* '${element['properties']['name']} Booked by : ${element['booking_first_name']} ${element['booking_last_name']}'*/ 'Upcoming',
      color: AppColors.colorffc107,
    ));
  }
  for (var element in DashBoardController.to.CompletedReservation) {
    appointments.add(Appointment(
      startTime: DateTime.parse((element['start_date']).toString()),
      endTime: DateTime.parse((element['end_date']).toString()),
      id: element['id'],
      subject:
          /*'${element['properties']['name']} Booked by : ${element['booking_first_name']} ${element['booking_last_name']}'*/ 'Completed',
      color: AppColors.color32BD01,
    ));
  }

  return _AppointmentDataSource(appointments);
}

List<Appointment> mybookingList = <Appointment>[];

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    /* source.forEach((element) {
      if (source.contains(element)) {
        log(element.subject, name: 'CONTAINS');
        source.remove(element);
      }
    });*/

    appointments = source.toSet().toList();
    mybookingList = source.toSet().toList();
    log(mybookingList.toString(), name: 'mybookingList');
  }
}

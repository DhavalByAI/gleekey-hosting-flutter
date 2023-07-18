import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
import 'package:gleeky_flutter/src/agent/bottom/agent.dart';
import 'package:gleeky_flutter/src/agent/controllers/agent_booking_controller.dart';
import 'package:gleeky_flutter/src/host/menu/view/kyc/kyc_screen.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class AgentUserBookingScreen extends StatefulWidget {
  const AgentUserBookingScreen({Key? key}) : super(key: key);

  @override
  State<AgentUserBookingScreen> createState() => _AgentUserBookingScreenState();
}

class _AgentUserBookingScreenState extends State<AgentUserBookingScreen> {
  final ScrollController _scrollController = ScrollController();
  RxBool showCircle = false.obs;

  RxInt offset = 1.obs;
  @override
  initState() {
    AgentBookingController.to.bookingList.clear();
    AgentBookingController.to.agentBookingApi(
        params: {'page': offset.value, 'limit': 5},
        error: (e) {
          showSnackBar(title: ApiConfig.error, message: e.toString());
        },
        success: () {
          isShimmer.value = false;
          offset.value = offset.value + 1;
        });

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        showCircle.value = true;
        AgentBookingController.to.agentBookingApi(
            params: {'page': offset.value, 'limit': 5},
            success: () {
              showCircle.value = false;
              offset.value = offset.value + 1;
            },
            error: () {});
      }
    });
    super.initState();
  }

  RxString dropDownValue = 'All'.obs;
  RxBool isShimmer = true.obs;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        agentSelectedBottom.value = 0;
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
            padding: const EdgeInsets.only(top: 20, left: 27, right: 27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'User Bookings',
                          style: color00000s18w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'All Bookings',
                        style: color00000s14w500,
                      ),
                    ),
                    /*Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Text(
                            'Sort By:',
                            style: color00000s14w500,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: StreamBuilder(
                              stream: dropDownValue.stream,
                              builder: (context, snapshot) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color:
                                          AppColors.color000000.withOpacity(0.2),
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 16),
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
                                        child:
                                            Text(value, style: color00000s14w500),
                                      );
                                    }).toList(),
                                    onChanged: (_) {
                                      dropDownValue.value = _.toString();
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),*/
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Obx(() {
                    return isShimmer.value
                        ? SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                3,
                                (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: AppColors.colorD9D9D9
                                            .withOpacity(0.2),
                                        highlightColor: AppColors.colorD9D9D9,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://www.myglobalviewpoint.com/wp-content/uploads/2020/01/Most-beautiful-places-in-Switzerland-585x390.jpg',
                                            placeholder: (context, url) =>
                                                CupertinoActivityIndicator(
                                                    color:
                                                        AppColors.colorFE6927),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.asset(
                                                    AppImages.profile_image),
                                            height: 130,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: AppColors.colorD9D9D9
                                            .withOpacity(0.2),
                                        highlightColor: AppColors.colorD9D9D9,
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Sr. :',
                                                        style:
                                                            color000000s12w400,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          'Dummy Text',
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
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
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
                                                          'Dummy Text',
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
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Accommodates :',
                                                        style:
                                                            color000000s12w400,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          'Dummy Text',
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
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Kitchen :',
                                                        style:
                                                            color000000s12w400,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          'Dummy Text',
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
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Location :',
                                                        style:
                                                            color000000s12w400,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          'Dummy Text',
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
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
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
                                                          'Dummy Text',
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
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Price :',
                                                        style:
                                                            color000000s12w400,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          'Dummy Text',
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
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Bedrooms :',
                                                        style:
                                                            color000000s12w400,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          'Dummy Text',
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
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Bedrooms :',
                                                        style:
                                                            color000000s12w400,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          'Dummy Text',
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
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Last Modified : ',
                                                        style:
                                                            color000000s12w400,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          'Dummy Text',
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
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Divider(
                                        color: AppColors.color000000
                                            .withOpacity(0.2),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : AgentBookingController.to.bookingList.isEmpty
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Container(
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          color: AppColors.colorD9D9D9,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 40, horizontal: 50),
                                      child: Text(
                                        'You don\'t have any Bookings yet!!',
                                        style: color00000s14w500,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  children: List.generate(
                                    AgentBookingController
                                        .to.bookingList.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl: AgentBookingController
                                                          .to.bookingList[index]
                                                      ['photo'] ??
                                                  '',
                                              placeholder: (context, url) =>
                                                  CupertinoActivityIndicator(
                                                      color: AppColors
                                                          .colorFE6927),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  const Icon(Icons
                                                      .error_outline_outlined),
                                              height: 130,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Sr. :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (index + 1)
                                                                .toString(),
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                          'Booking Id :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            AgentBookingController
                                                                            .to
                                                                            .bookingList[
                                                                        index]
                                                                    ['code'] ??
                                                                '',
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                          'Customer Name :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (AgentBookingController
                                                                            .to
                                                                            .bookingList[index]
                                                                        [
                                                                        'first_name'] ??
                                                                    '') +
                                                                ' ' +
                                                                (AgentBookingController
                                                                            .to
                                                                            .bookingList[index]
                                                                        [
                                                                        'last_name'] ??
                                                                    ''),
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                          'Booked On : ',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (AgentBookingController
                                                                            .to
                                                                            .bookingList[index]
                                                                        [
                                                                        'created_at']) ==
                                                                    null
                                                                ? ""
                                                                : DateFormat(
                                                                        'dd-MM-yyyy')
                                                                    .format(DateTime.parse(
                                                                        (AgentBookingController.to.bookingList[index]['created_at'] ??
                                                                                '')
                                                                            .toString()))
                                                                    .toString(),
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (AgentBookingController
                                                                            .to
                                                                            .bookingList[
                                                                        index][
                                                                    'status'] ??
                                                                ''),
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
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
                                                            (AgentBookingController
                                                                            .to
                                                                            .bookingList[
                                                                        index][
                                                                    'property_name'] ??
                                                                ''),
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                          'Price :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            "₹" +
                                                                ' ' +
                                                                (AgentBookingController
                                                                            .to
                                                                            .bookingList[index]['total'] ??
                                                                        '0')
                                                                    .toString(),
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                          'Check-In :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (AgentBookingController
                                                                            .to
                                                                            .bookingList[
                                                                        index][
                                                                    'start_date'] ??
                                                                ''),
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                          'Check-Out :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (AgentBookingController
                                                                            .to
                                                                            .bookingList[
                                                                        index][
                                                                    'end_date'] ??
                                                                ''),
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Divider(
                                            color: AppColors.color000000
                                                .withOpacity(0.2),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

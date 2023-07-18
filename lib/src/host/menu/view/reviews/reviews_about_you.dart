import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/src/host/insight/controller/insight_controller.dart';
import 'package:gleeky_flutter/src/host/insight/view/review_screen.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:shimmer/shimmer.dart';

class ReviewsAboutYou extends StatefulWidget {
  const ReviewsAboutYou({Key? key}) : super(key: key);

  @override
  State<ReviewsAboutYou> createState() => _ReviewsAboutYouState();
}

class _ReviewsAboutYouState extends State<ReviewsAboutYou> {
  List tabs = [
    'Reviews About You',
  ];

  RxBool isShimmer = true.obs;
  RxInt page = 0.obs;
  RxBool showCircle = false.obs;

  final TextEditingController _hostSendMessage = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    InsightController.to.insightApi(
        params: {'page': page.value, "limit": 5},
        query: {'type': 'reviewsAboutYou'},
        success: () {
          isShimmer.value = false;
          page.value = page.value + 1;
        },
        error: (e) {
          isShimmer.value = false;
        });

    ///pagination
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          showCircle.value = true;
          InsightController.to.insightApi(
            params: {'page': page.value, "limit": 5},
            query: {'type': 'reviewsAboutYou'},
            success: () {
              page.value = page.value + 1;
              showCircle.value = false;
            },
            error: (e) {},
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Reviews',
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
                child: Row(
                  children: List.generate(
                    tabs.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.colorFE6927,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 18),
                          child: Text(tabs[index],
                              style: colorfffffffs13w600.copyWith(
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(
                  endIndent: 10,
                  indent: 10,
                  color: AppColors.color000000.withOpacity(0.1),
                ),
              ),
              Obx(
                () {
                  return reviewsAboutYouView();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded reviewsAboutYouView() {
    return Expanded(
      child: isShimmer.value
          ? Shimmer.fromColors(
              baseColor: AppColors.colorD9D9D9.withOpacity(0.2),
              highlightColor: AppColors.colorD9D9D9,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    6,
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
              ),
            )
          : InsightController.to.insightApiResponse['status'] == false
              ? Column(
                  children: [
                    Padding(
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
                    ),
                  ],
                )
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: List.generate(
                      InsightController
                          .to
                          .insightApiResponse['data']?['reviewsAboutYou']
                          .length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
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
                                width: 15,
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
  }
}

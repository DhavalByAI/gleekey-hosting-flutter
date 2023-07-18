import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:shimmer/shimmer.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../../../../utills/style/constants.dart';

import 'package:share_plus/share_plus.dart';
import '../../../../../../utills/style/palette.dart';
import 'commonText.dart';
import 'propertyAllDetails_controller.dart';
import 'viewAllPhotos.dart';

final Completer<GoogleMapController> _controller =
    Completer<GoogleMapController>();

class PropertyAllDetails extends StatefulWidget {
  String slug;
  PropertyAllDetails({Key? key, required this.slug}) : super(key: key);

  @override
  State<PropertyAllDetails> createState() => _PropertyAllDetailsState();
}

class _PropertyAllDetailsState extends State<PropertyAllDetails> {
  PropertyAllDetailsController getController =
      Get.put(PropertyAllDetailsController());
  // SearchPlacesController _ = Get.find();
  @override
  initState() {
    getController.getApi(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PropertyAllDetailsController>(
        initState: (_) {},
        builder: (_) {
          return _.isDataLoaded
              ? Stack(
                  children: [topContainer(), detailBottomSheet(), reserve()],
                )
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ShimmerBox(250, dwidth),
                      const SizedBox(
                        height: 12,
                      ),
                      ShimmerBox(16, 200),
                      const SizedBox(
                        height: 12,
                      ),
                      Expanded(child: ShimmerBox(30, dwidth)),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget ShimmerBox(int dheight, int dwidth) {
    return Shimmer(
      duration: const Duration(seconds: 1),
      colorOpacity: 0.4,
      child: Container(
        height: dheight.toDouble(),
        width: dwidth.toDouble(),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  CachedNetworkImage cNetworkImage(String? link,
      {double? height, double? width, BoxFit? fit, Alignment? alignment}) {
    return CachedNetworkImage(
      height: height,
      width: width,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      imageUrl: link ?? "",
      placeholder: (context, url) => const CupertinoActivityIndicator(
        color: kOrange,
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget topContainer() {
    PropertyAllDetailsController getController = Get.find();
    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: kBlack.withOpacity(0.2),
        // image: DecorationImage(
        //     image:
        //         NetworkImage(getController.PropertyData!.result!.coverPhoto!),
        //     fit: BoxFit.cover)
      ),
      child: GetBuilder<PropertyAllDetailsController>(
        initState: (_) {},
        builder: (_) {
          return Stack(
            children: [
              CarouselSlider(
                items: List.generate(_.PropertyData!.propertyPhotos!.length,
                    ((index) {
                  return cNetworkImage(
                    _.PropertyData!.propertyPhotos![index].image,
                    fit: BoxFit.cover,
                  );
                })),
                carouselController: _.carouselController,
                options: CarouselOptions(
                  height: 380,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  // aspectRatio: 2.0,
                ),
              ),
              _.PropertyData!.propertyPhotos!.length >= 3
                  ? Positioned(
                      bottom: 70,
                      left: (dwidth - (150 + 24)) / 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Bounce(
                            onPressed: (() {
                              _.carouselController.animateToPage(0);
                            }),
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: kWhite, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                  color: kBlack.withOpacity(0.2),
                                  image: DecorationImage(
                                      image: NetworkImage(_.PropertyData!
                                          .propertyPhotos![0].image),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Bounce(
                            onPressed: (() {
                              _.carouselController.animateToPage(1);
                            }),
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: kWhite, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                  color: kBlack.withOpacity(0.2),
                                  image: DecorationImage(
                                      image: NetworkImage(_.PropertyData!
                                          .propertyPhotos![1].image),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Bounce(
                            onPressed: (() {
                              Get.to(() => const ViewAllPhotos());
                            }),
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: kWhite, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: NetworkImage(_.PropertyData!
                                          .propertyPhotos![2].image),
                                      fit: BoxFit.cover)),
                              child: Stack(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black.withOpacity(0.6),
                                  )),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: AutoSizeText(
                                        "+ ${_.PropertyData!.propertyPhotos!.length - 2}",
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                            color: kWhite),
                                        maxLines: 1,
                                      ),
                                    ),
                                    // child: commonText(
                                    //     maxlines: 1,
                                    //     textAlign: TextAlign.center,
                                    //     text:

                                    //         "+ ${_.PropertyData!.propertyPhotos!.length - 2}",
                                    //     color: kWhite,
                                    //     fontWeight: FontWeight.w800,
                                    //     fontSize: 24),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              SafeArea(
                  child: Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 10, 0),
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: kWhite,
                      ),
                    ),
                    Row(
                      children: [
                        Bounce(
                          duration: const Duration(milliseconds: 150),
                          onPressed: (() {
                            Share.share(
                                'Check this out on GleeKey \n${getController.PropertyData!.shareLink!}');
                          }),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: kBlack.withOpacity(0.3),
                            child: Image.asset(
                              "assets/images/share.png",
                              color: kWhite,
                              width: 15,
                              height: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // addWishlistWidget(
                        //     PropertyID: getController.PropertyData!.result!.id),

                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  ],
                ),
              )),
            ],
          );
        },
      ),
    );
  }

  Widget detailBottomSheet() {
    PropertyAllDetailsController getController = Get.find();
    CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(
          double.parse(
              getController.PropertyData!.result!.propertyAddress!.latitude!),
          double.parse(
              getController.PropertyData!.result!.propertyAddress!.longitude!)),
      zoom: 14.4746,
    );

    Set<Circle> circles = {
      Circle(
          fillColor: Colors.blueAccent.withOpacity(0.2),
          circleId: const CircleId("circleId"),
          center: LatLng(
              double.parse(getController
                  .PropertyData!.result!.propertyAddress!.latitude!),
              double.parse(getController
                  .PropertyData!.result!.propertyAddress!.longitude!)),
          radius: 200,
          strokeWidth: 2,
          strokeColor: Colors.blueAccent)
    };

    List housePrefix = [
      "Check-In Time",
      "Check-Out Time",
      "Pet Friendly",
      "Pool Timings",
      "Loud Music Timings",
      "Food Allowed",
      "Alcohol Allowed",
    ];
    List houseSuffix = [
      "${getController.PropertyData!.houseRules?[0].checkInTime}"
          .substring(0, 5),
      "${getController.PropertyData!.houseRules?[0].checkOutTime}"
          .substring(0, 5),
      "${getController.PropertyData!.houseRules?[0].petFriendly}",
      "${getController.PropertyData!.houseRules?[0].poolTime}",
      "${getController.PropertyData!.houseRules?[0].loudMusicTime}",
      "${getController.PropertyData!.houseRules?[0].foodAllowed}",
      "${getController.PropertyData!.houseRules?[0].alcoholAllowedSide}",
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.6,
      builder: (BuildContext context, ScrollController scrollController) {
        return SafeArea(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    color: kWhite,
                    boxShadow: [
                      BoxShadow(
                          color: kDarkGrey.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0.0, 5.0))
                    ]),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 30, 28, 100),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getController.PropertyData!.result!.name!,
                            style: Palette.detailText1,
                          ),
                          Text(
                            '( ${getController.PropertyData!.result!.propertyAddress!.city}, ${getController.PropertyData!.result!.propertyAddress!.state}, ${getController.PropertyData!.result!.propertyAddress!.country} )',
                            style: Palette.detailText2,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            getController.PropertyData!.result!
                                .propertyDescription!.summary,
                            style: Palette.bestText2,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            color: kDarkGrey,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${getController.PropertyData!.result!.name!} Hosted By ${getController.PropertyData!.result!.users!.firstName} ${getController.PropertyData!.result!.users!.lastName}",
                                    style: Palette.detailText3,
                                  ),
                                  // const SizedBox(
                                  //   height: 3,
                                  // ),
                                  // Text(
                                  //   'simply dummy text',
                                  //   style: Palette.bestText2,
                                  // ),
                                ],
                              )),
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(getController
                                    .PropertyData!.result!.users!.profileSrc),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          const Divider(
                            color: kDarkGrey,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Amenities included',
                            style: Palette.headerText,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          aminities(),
                          const SizedBox(
                            height: 3,
                          ),
                          const Divider(
                            color: kDarkGrey,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // Bounce(
                          //   onPressed: () {
                          //     Get.to(() => RoomScreen());
                          //   },
                          //   duration: const Duration(milliseconds: 150),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //           child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //             'Check Availability',
                          //             style: Palette.headerText,
                          //           ),
                          //           // const SizedBox(
                          //           //   height: 5,
                          //           // ),
                          //           // Text(
                          //           //   '(_startDate to _endDate)',
                          //           //   style: Palette.detailText4,
                          //           // ),
                          //         ],
                          //       )),
                          //       const Icon(
                          //         Icons.arrow_forward_ios,
                          //         color: kBlack,
                          //       )
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          // const calander(),

                          const SizedBox(
                            height: 10,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8),
                          //   child: Container(
                          //     color: kWhite,
                          //     width: MediaQuery.of(context).size.width - 90,
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         commonText(
                          //           text: "Who's Coming?",
                          //           color: kBlack,
                          //           fontSize: 20,
                          //           fontWeight: FontWeight.w700,
                          //         ),
                          //         const SizedBox(
                          //           height: 15,
                          //         ),
                          //         commonText(
                          //           text: " Adults",
                          //           color: kBlack.withAlpha(125),
                          //           fontSize: 12,
                          //           fontWeight: FontWeight.w600,
                          //         ),
                          //         const SizedBox(
                          //           height: 10,
                          //         ),
                          //         addRemoveButtons(
                          //           variable: "A",
                          //         ),
                          //         const SizedBox(
                          //           height: 12,
                          //         ),
                          //         commonText(
                          //           text: " Children",
                          //           color: kBlack.withAlpha(125),
                          //           fontSize: 12,
                          //           fontWeight: FontWeight.w600,
                          //         ),
                          //         const SizedBox(
                          //           height: 10,
                          //         ),
                          //         addRemoveButtons(
                          //           variable: "C",
                          //         ),
                          //         const SizedBox(
                          //           height: 12,
                          //         ),
                          //         commonText(
                          //           text: " Infants",
                          //           color: kBlack.withAlpha(125),
                          //           fontSize: 12,
                          //           fontWeight: FontWeight.w600,
                          //         ),
                          //         const SizedBox(
                          //           height: 10,
                          //         ),
                          //         addRemoveButtons(
                          //           variable: "I",
                          //         ),
                          //         const SizedBox(
                          //           height: 12,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),

                          const Divider(
                            color: kDarkGrey,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Location',
                            style: Palette.headerText,
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            height: 200,
                            child: Card(
                              color: kBtnGrey,
                              child: GoogleMap(
                                mapType: MapType.normal,
                                circles: circles,
                                initialCameraPosition: kGooglePlex,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Divider(
                            color: kDarkGrey,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'House Rules',
                            style: Palette.headerText,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Column(
                            children: List<Widget>.generate(
                              7,
                              ((index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/orangeDot.png",
                                        height: 8,
                                        width: 8,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${housePrefix[index]} : ",
                                        style: Palette.bestText2
                                            .copyWith(color: Colors.black),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${houseSuffix[index]}",
                                          style: Palette.bestText2,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                          const Divider(
                            color: kDarkGrey,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Review',
                            style: Palette.headerText,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/star_icon.png",
                                height: 20,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              commonText(
                                  text: getController
                                      .PropertyData!.result!.avgRating
                                      .toString(),
                                  color: Colors.black,
                                  fontSize: 14),
                              commonText(
                                  text:
                                      " ( ${getController.PropertyData!.result!.reviewsCount} )",
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 12),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Column(
                                  children: [
                                    progressBar(
                                        title: "Accuracy",
                                        rating: "4.3",
                                        value: 0.7),
                                    progressBar(
                                        title: "Communication",
                                        rating: "4.3",
                                        value: 0.4),
                                    progressBar(
                                        title: "Cleanliness",
                                        rating: "4.3",
                                        value: 0.5),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  width: 1,
                                  height: 130,
                                  color: klightgrey,
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    progressBar(
                                        title: "Location",
                                        rating: "4.3",
                                        value: 0.1),
                                    progressBar(
                                        title: "Checkin",
                                        rating: "4.3",
                                        value: 0.8),
                                    progressBar(
                                        title: "Value for money",
                                        rating: "4.3",
                                        value: 0.9),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            color: kDarkGrey,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Safety & Property',
                            style: Palette.headerText,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Column(
                            children: List<Widget>.generate(
                              2,
                              ((index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/orangeDot.png",
                                        height: 8,
                                        width: 8,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Check-In After 2:00 PM",
                                          style: Palette.bestText2,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                          const Divider(
                            color: kDarkGrey,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Cancellation Policy',
                            style: Palette.headerText,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "**Please note: Cancellation fee is primarily applicable to cover platform charges, convenience fee and processing charges. Taxes as applicable.",
                            style: Palette.bestText2,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Column(
                            children: List<Widget>.generate(
                              4,
                              ((index) {
                                List CancellationPollicy = [
                                  "If you wish to cancel 30 days before the arrival date, you will be charged 5% cancellation charges** of the booking value in the original payment mode.",
                                  "Cancellations that are made between 16 to 30 days prior to the arrival date, 15% cancellation charges** of the total booking value.",
                                  "Cancellations that are made between 8 to 15 days prior to the arrival date, 25% cancellation charges** of the total booking value.",
                                  "For any cancellations requested within 7 days of the check-in date, the booking will be non-refundable."
                                ];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/orangeDot.png",
                                        height: 8,
                                        width: 8,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          CancellationPollicy[index],
                                          style: Palette.bestText2,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                          // const Divider(
                          //   color: kDarkGrey,
                          // ),
                          const SizedBox(
                            height: 24,
                          ),
                          // Row(
                          //   children: [
                          //     const CircleAvatar(
                          //       radius: 25,
                          //       backgroundImage: NetworkImage(
                          //           "https://gleekey.in/public/demo/public/images/default-profile.png"),
                          //     ),
                          //     const SizedBox(
                          //       width: 10,
                          //     ),
                          //     Flexible(
                          //       child: AutoSizeText(
                          //         "Hosted By ${getController.PropertyData!.result!.hostName} ",
                          //         maxLines: 2,
                          //         minFontSize: 14,
                          //         style: Palette.headerText,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 2, vertical: 16),
                          //   child: Row(
                          //     children: [
                          //       Image.asset(
                          //         "assets/images/star_icon.png",
                          //         height: 15,
                          //         width: 15,
                          //       ),
                          //       const SizedBox(
                          //         width: 4,
                          //       ),
                          //       commonText(
                          //         text:
                          //             "${getController.PropertyData!.result!.reviewsCount} Reviews",
                          //         color: kBlack,
                          //         fontSize: 12,
                          //       ),
                          //       const SizedBox(
                          //         width: 12,
                          //       ),
                          //       Image.asset(
                          //         "assets/images/verified.png",
                          //         height: 18,
                          //         width: 18,
                          //       ),
                          //       const SizedBox(
                          //         width: 4,
                          //       ),
                          //       commonText(
                          //         text: "Verified",
                          //         color: kBlack,
                          //         fontSize: 12,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Flexible(
                          //     child: Text(
                          //   "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                          //   style: Palette.bestText2,
                          // )),
                          // const SizedBox(
                          //   height: 16,
                          // ),
                          // SizedBox(
                          //   height: 45,
                          //   width: 100,
                          //   child: MaterialButton(
                          //       color: kOrange,
                          //       shape: Palette.subCardShape,
                          //       padding:
                          //           const EdgeInsets.fromLTRB(10, 7, 10, 7),
                          //       child: Text(
                          //         'Contact Host',
                          //         style: Palette.bestText4,
                          //       ),
                          //       onPressed: () {}),
                          // ),
                          // const SizedBox(
                          //   height: 30,
                          // ),
                        ],
                      ),
                    ))),
          ),
        );
      },
    );
  }

  Widget progressBar(
      {required String title, required String rating, double? value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              commonText(
                text: title,
                color: Colors.black,
                fontSize: 12,
              ),
              commonText(
                text: rating,
                color: Colors.black,
                fontSize: 12,
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Flexible(
            child: ProgressBar(
              value: value,
              backgroundColor: kOrange.withOpacity(0.3),
              color: kOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget aminities() {
    PropertyAllDetailsController getController = Get.find();
    if (getController.PropertyData!.amenities == null) {
      return const SizedBox();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 2,
            children: List.generate(
              getController.PropertyData!.amenities!.length > 5
                  ? 5
                  : getController.PropertyData!.amenities!.length,
              (i) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  // color: kBlack.withOpacity(0.05),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getController.PropertyData!.amenities![i]
                                  ['amenitie_icon'] !=
                              null
                          ? cNetworkImage(
                              getController.PropertyData!.amenities![i]
                                  ['amenitie_icon']!,
                              // scale: 6,
                              // color: kOrange,
                              width: 24,
                              height: 24,
                            )
                          : Image.asset(
                              "assets/images/defaultAmenities.png",
                              // scale: 6,
                              // color: kOrange,
                              width: 24,
                              height: 24,
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: AutoSizeText(
                          getController.PropertyData!.amenities![i]['title'],
                          style: Palette.bestText2,
                          minFontSize: 10,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: MaterialButton(
                color: kOrange,
                shape: Palette.subCardShape,
                padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                child: Text(
                  'See all',
                  style: Palette.bestText4,
                ),
                onPressed: () {
                  Get.dialog(Scaffold(body: Allaminities()));
                }),
          )
        ],
      );
    }
  }

  Widget reserve() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: dwidth.toDouble(),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: kBlack.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1)
            ],
            color: kWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<PropertyAllDetailsController>(
                initState: (_) {},
                builder: (_) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₹ ${_.PropertyData!.result!.propertyPrice!.price ?? ""} Night',
                        style: Palette.headerText,
                      ),
                      // const SizedBox(
                      //   height: 6,
                      // ),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.info_outline_rounded,
                      //       size: 11,
                      //       color: kBlack.withOpacity(0.5),
                      //     ),
                      //     commonText(
                      //       color: kBlack.withAlpha(125),
                      //       text:
                      //           ' GST ₹${((_.PropertyData!.result!.propertyPrice!.price * (C.totalNight ?? 1)) * 18) / 100} Excluded',
                      //       fontSize: 10,
                      //     ),
                      //   ],
                      // ),
                    ],
                  );
                },
              ),
              // SizedBox(
              //   height: 45,
              //   width: 100,
              //   child: MaterialButton(
              //       color: kOrange,
              //       shape: Palette.subCardShape,
              //       padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
              //       child: Text(
              //         'Reserve',
              //         style: Palette.bestText4,
              //       ),
              //       onPressed: () {
              //         SearchPlacesController C = Get.find();
              //         C.endDate == null
              //             ? showSnackBar(
              //                 title: "Last Date Is not Selected",
              //                 message:
              //                     "Please select last date of your stay with property")
              //             : Get.to(() => ConfirmNpay(
              //                   coverImg: getController
              //                       .PropertyData!.result!.coverPhoto,
              //                   price: getController
              //                       .PropertyData!.result!.propertyPrice!.price,
              //                   totalNight: C.totalNight ?? 1,
              //                 ));
              //       }),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Allaminities() {
    PropertyAllDetailsController getController = Get.find();
    ScrollController c = ScrollController();
    if (getController.PropertyData!.amenities == null) {
      return const SizedBox();
    } else {
      return Scaffold(
        backgroundColor: kWhite,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: kBlack,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "All Amenities",
                    style: Palette.headerText,
                  ),
                  const Spacer()
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: c,
                      itemCount: getController.PropertyData!.amenities!.length,
                      itemBuilder: ((context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              getController.PropertyData!.amenities![i]
                                          ['amenitie_icon'] !=
                                      null
                                  ? cNetworkImage(
                                      getController.PropertyData!.amenities![i]
                                          ['amenitie_icon']!,
                                      // scale: 6,
                                      // color: kOrange,
                                      width: 24,
                                      height: 24,
                                    )
                                  : Image.asset(
                                      "assets/images/defaultAmenities.png",
                                      // scale: 6,
                                      // color: kOrange,
                                      width: 24,
                                      height: 24,
                                    ),
                              const SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                child: AutoSizeText(
                                  getController.PropertyData!.amenities![i]
                                      ['title'],
                                  style: Palette.bestText2,
                                  minFontSize: 10,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      })),
                ),
              ),
              // Wrap(
              //   spacing: 2,
              //   children: List.generate(
              //     getController.PropertyData!.amenities!.length,
              //     (i) {
              //       return Container(
              //         padding: const EdgeInsets.all(10),
              //         margin: const EdgeInsets.all(5),
              //         // color: kBlack.withOpacity(0.05),
              //         child: InkWell(
              //             onTap: () {},
              //             child: Row(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 getController.PropertyData!.amenities![i]
              //                             .amenitieIcon !=
              //                         null
              //                     ? cNetworkImage(
              //                         BaseConstant.BASE_IMG_URL +
              //                             EndPoint.amenities +
              //                             getController.PropertyData!
              //                                 .amenities![i].amenitieIcon!,
              //                         // scale: 6,
              //                         // color: kOrange,
              //                         width: 24,
              //                         height: 24,
              //                       )
              //                     : Image.asset(
              //                         "assets/images/defaultAmenities.png",
              //                         // scale: 6,
              //                         // color: kOrange,
              //                         width: 24,
              //                         height: 24,
              //                       ),
              //                 const SizedBox(
              //                   width: 10,
              //                 ),
              //                 Flexible(
              //                   child: AutoSizeText(
              //                     getController
              //                         .PropertyData!.amenities![i].title,
              //                     style: Palette.bestText2,
              //                     minFontSize: 10,
              //                     maxLines: 3,
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                 )
              //               ],
              //             )),
              //       );
              //     },
              //   ),
              // ),
              // Container(
              //   margin: const EdgeInsets.only(left: 10),
              //   child: MaterialButton(
              //       color: kOrange,
              //       shape: Palette.subCardShape,
              //       padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
              //       child: Text(
              //         'See all',
              //         style: Palette.bestText4,
              //       ),
              //       onPressed: () {
              //         Get.dialog(Scaffold(body: aminities()));
              //       }),
              // )
            ],
          ),
        ),
      );
    }
  }
}

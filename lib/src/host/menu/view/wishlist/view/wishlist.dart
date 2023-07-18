import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/wishList_controller.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  initState() {
    WishListController.to.wishListDataApi(
        params: {'offset': "0", "limit": "10"},
        success: () {},
        error: (e) {
          Get.back();
          showSnackBar(title: ApiConfig.error, message: e.toString());
        });

    super.initState();
  }

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
                        'Wishlist',
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
                height: 20,
              ),
              Obx(
                () {
                  return WishListController.to.wishListResponse.isEmpty
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
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Shimmer.fromColors(
                                            baseColor: AppColors.colorD9D9D9
                                                .withOpacity(0.2),
                                            highlightColor:
                                                AppColors.colorD9D9D9,
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
                                          )
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
                                              width: 8,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                // if (await MapLauncher
                                                //     .isMapAvailable(
                                                //         MapType.google)) {
                                                await MapLauncher.launchMap(
                                                  mapType: Platform.isAndroid
                                                      ? MapType.google
                                                      : MapType.apple,
                                                  coords: Coords(
                                                    double.parse((WishListController
                                                                            .to
                                                                            .wishListResponse[
                                                                        'data'][index]
                                                                    ?[
                                                                    'properties']
                                                                ?[
                                                                'property_address']?['latitude'] ??
                                                            '21.1702')
                                                        .toString()),
                                                    double.parse((WishListController
                                                                            .to
                                                                            .wishListResponse['data'][index]
                                                                        ['properties']
                                                                    ?[
                                                                    'property_address']
                                                                ?[
                                                                'longitude'] ??
                                                            '72.8311')
                                                        .toString()),
                                                  ),
                                                  title: "",
                                                  description: "",
                                                );
                                                // }
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: AppColors
                                                    .colorFE6927
                                                    .withOpacity(0.3),
                                                child: Icon(
                                                  Icons.near_me,
                                                  color: AppColors.colorFE6927,
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
                        )
                      : WishListController.to.wishListResponse['data'].length ==
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
                                  vertical: 40,
                                  horizontal: 50,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'You don\'t have any Favourite Listing yet—But when You do, you’ll find them here.',
                                      style: color00000s14w500,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                    WishListController
                                        .to.wishListResponse['data'].length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Container(
                                              height: Get.width / 1.6,
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: AppColors.colorD9D9D9),
                                              child: Stack(
                                                children: [
                                                  Positioned.fill(
                                                    child: CachedNetworkImage(
                                                      imageUrl: WishListController
                                                                          .to
                                                                          .wishListResponse[
                                                                      'data'][index]
                                                                  ?[
                                                                  'properties']
                                                              ?[
                                                              'cover_photo'] ??
                                                          '',
                                                      placeholder: (context,
                                                              url) =>
                                                          CupertinoActivityIndicator(
                                                        color: AppColors
                                                            .colorFE6927,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 15,
                                                    right: 15,
                                                    child: InkWell(
                                                      onTap: () {
                                                        loaderShow(context);
                                                        WishListController.to
                                                            .addAndRemoveFromWishListApi(
                                                          params: {
                                                            "property_id":
                                                                WishListController
                                                                            .to
                                                                            .wishListResponse[
                                                                        'data'][index]
                                                                    [
                                                                    'property_id']
                                                          },
                                                          error: (e) {
                                                            loaderHide();
                                                          },
                                                          success: () {
                                                            WishListController
                                                                .to
                                                                .wishListDataApi(
                                                              params: {
                                                                'offset': "0",
                                                                "limit": "10"
                                                              },
                                                              success: () {
                                                                loaderHide();
                                                              },
                                                              error: (e) {
                                                                loaderHide();
                                                                Get.back();
                                                                showSnackBar(
                                                                  title:
                                                                      ApiConfig
                                                                          .error,
                                                                  message: e
                                                                      .toString(),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );
                                                      },
                                                      highlightColor:
                                                          Colors.transparent,
                                                      splashColor:
                                                          Colors.transparent,
                                                      child: CircleAvatar(
                                                        maxRadius: 20,
                                                        backgroundColor:
                                                            AppColors
                                                                .color000000
                                                                .withOpacity(
                                                                    0.5),
                                                        child: const Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                          size: 25,
                                                        ),
                                                      ),
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
                                                  WishListController.to
                                                                  .wishListResponse[
                                                              'data'][index]?[
                                                          'properties']?['name'] ??
                                                      '',
                                                  style: color00000s18w600,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    AppImages.starIcon,
                                                    height: 19,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    (WishListController.to.wishListResponse[
                                                                            'data']
                                                                        [index]
                                                                    ?[
                                                                    'properties']
                                                                ?[
                                                                'avg_rating'] ??
                                                            '0')
                                                        .toString(),
                                                    style: color00000s14w500,
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
                                                    Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color:
                                                          AppColors.colorEBEBEB,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${WishListController.to.wishListResponse['data'][index]?['properties']?['property_address']?['city'] ?? ''}, ${WishListController.to.wishListResponse['data'][index]?['properties']?['property_address']?['state'] ?? ''}, ${WishListController.to.wishListResponse['data'][index]?['properties']?['property_address']?['country'] ?? ''}',
                                                      style: color00000s14w500,
                                                    ),
                                                  ],
                                                ),
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
                                                      'Start From ',
                                                      style:
                                                          color50perBlacks13w400
                                                              .copyWith(
                                                                  height: 0),
                                                    ),
                                                    Text(
                                                      '${WishListController.to.wishListResponse['data'][index]?['properties']?['property_price']?['default_symbol'] ?? ''} ${WishListController.to.wishListResponse['data'][index]?['properties']?['property_price']?['original_price'] ?? ''}/night',
                                                      style: color00000s14w500,
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
                                                  onPressed: () {},
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  name: 'Book Now',
                                                  width: double.maxFinite,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              InkWell(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () async {
                                                  // if (await MapLauncher
                                                  //     .isMapAvailable(
                                                  //         MapType.google)) {
                                                  await MapLauncher.launchMap(
                                                    mapType: Platform.isAndroid
                                                        ? MapType.google
                                                        : MapType.apple,
                                                    coords: Coords(
                                                      double.parse(
                                                        (WishListController.to.wishListResponse['data'][index]
                                                                            ?[
                                                                            'properties']
                                                                        ?[
                                                                        'property_address']
                                                                    ?[
                                                                    'latitude'] ??
                                                                '21.1702')
                                                            .toString(),
                                                      ),
                                                      double.parse(
                                                        (WishListController.to.wishListResponse['data'][index]
                                                                            [
                                                                            'properties']
                                                                        ?[
                                                                        'property_address']
                                                                    ?[
                                                                    'longitude'] ??
                                                                '72.8311')
                                                            .toString(),
                                                      ),
                                                    ),
                                                    title: "",
                                                    description: "",
                                                  );
                                                  // }
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor: AppColors
                                                      .colorFE6927
                                                      .withOpacity(0.3),
                                                  child: Icon(
                                                    Icons.near_me,
                                                    color:
                                                        AppColors.colorFE6927,
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
    );
  }
}

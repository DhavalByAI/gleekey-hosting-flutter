import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/src/host/Main/main_screen.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:shimmer/shimmer.dart';

class InboxScreen extends StatelessWidget {
  InboxScreen({Key? key}) : super(key: key);

  RxBool isshimmer = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 17),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Center(
                    child: Text(
                      'All Messages',
                      style: color00000s18w600,
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.search, size: 20),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.more_vert, size: 20),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: isshimmer.value
                      ? Column(
                          children: List.generate(
                            10,
                            (index) => Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        AppColors.colorD9D9D9.withOpacity(0.2),
                                    highlightColor: AppColors.colorD9D9D9,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              AppColors.colorE6E6E6,
                                          backgroundImage: const AssetImage(
                                            'assets/images/profile.png',
                                          ),
                                        ),
                                        SizedBox(
                                          width: Get.width * 0.04,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 20,
                                                  color: AppColors.colorF8F8F8),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                  height: 20,
                                                  width: 50,
                                                  color: AppColors.colorF8F8F8),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
                        )
                      : Column(
                          children: List.generate(
                            10,
                            (index) => Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: AppColors.colorE6E6E6,
                                        backgroundImage: const AssetImage(
                                          'assets/images/profile.png',
                                        ),
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.04,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Lorem Ipsum is simply dummy text of the printing $index',
                                          style: color00000s15w600.copyWith(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
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
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

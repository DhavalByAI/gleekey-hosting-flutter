import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
import 'package:gleeky_flutter/src/agent/controllers/agent_dashboard_controller.dart';
import 'package:gleeky_flutter/src/agent/controllers/agent_transaction_controller.dart';
import 'package:gleeky_flutter/src/host/menu/view/kyc/kyc_screen.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class AgentTransactionScreen extends StatefulWidget {
  const AgentTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AgentTransactionScreen> createState() => _AgentTransactionScreenState();
}

class _AgentTransactionScreenState extends State<AgentTransactionScreen> {
  final ScrollController _scrollController = ScrollController();
  RxBool showCircle = false.obs;

  RxInt offset = 1.obs;
  @override
  initState() {
    AgentTransactionController.to.transactionList.clear();
    AgentTransactionController.to.agentTransactionApi(
      params: {'page': offset.value, 'limit': 5},
      success: () {
        isShimmer.value = false;
        offset.value = offset.value + 1;
      },
      error: (e) {
        showSnackBar(title: ApiConfig.error, message: e.toString());
      },
    );

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        showCircle.value = true;
        AgentTransactionController.to.agentTransactionApi(
            params: {'page': offset.value, 'limit': 5},
            success: () {
              showCircle.value = false;
              offset.value = offset.value + 1;
            },
            error: (e) {});
      }
    });
    super.initState();
  }

  RxString dropDownValue = 'All'.obs;
  RxBool isShimmer = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() {
        return showCircle.value
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoActivityIndicator(color: AppColors.colorFE6927),
              )
            : const SizedBox();
      }),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, right: 27, left: 27, bottom: 20),
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
                        'Transactions',
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
                          Icons.menu,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                () {
                  return AgentDashboardController
                          .to.getagentDashboardRes.isEmpty
                      ? Shimmer.fromColors(
                          baseColor: AppColors.colorD9D9D9.withOpacity(0.2),
                          highlightColor: AppColors.colorD9D9D9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
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
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.05),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  AppImages.total_credit_Icon,
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  'Total Credit',
                                                  style: color00000s14w500
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              '₹ ${0}',
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
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.05),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  AppImages.total_credit_Icon,
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  'Total Debit',
                                                  style: color00000s14w500
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              '₹ ${0}',
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
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
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
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.05),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  AppImages.wallet_Icon,
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  'Wallet Balance',
                                                  style: color00000s14w500
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              '₹ ${0}',
                                              style: color00000s14w500.copyWith(
                                                  color: AppColors.colorFE6927,
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
                                    child: Opacity(
                                      opacity: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.colorffffff,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                          vertical: 25,
                                        ),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    AppImages.total_credit_Icon,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    'Total Debit',
                                                    style: color00000s14w500
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                '₹ ${0}',
                                                style:
                                                    color00000s14w500.copyWith(
                                                        color: AppColors
                                                            .color9a0400,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                AppImages.total_credit_Icon,
                                                height: 25,
                                                width: 25,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                'Total Credit',
                                                style:
                                                    color00000s14w500.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            '₹ ${AgentDashboardController.to.getagentDashboardRes['data']?['total_credit'] ?? 0}',
                                            style: color00000s14w500.copyWith(
                                              color: AppColors.color32BD01,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                AppImages.total_credit_Icon,
                                                height: 25,
                                                width: 25,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                'Total Debit',
                                                style:
                                                    color00000s14w500.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            '₹ ${AgentDashboardController.to.getagentDashboardRes['data']?['total_debit'] ?? 0}',
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                AppImages.wallet_Icon,
                                                height: 25,
                                                width: 25,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                'Wallet Balance',
                                                style:
                                                    color00000s14w500.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            '₹ ${AgentDashboardController.to.getagentDashboardRes['data']?['wallet_balance'] ?? 0}',
                                            style: color00000s14w500.copyWith(
                                                color: AppColors.colorFE6927,
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
                                  child: Opacity(
                                    opacity: 0,
                                    child: Container(
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
                                        vertical: 25,
                                      ),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  AppImages.total_credit_Icon,
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  'Total Debit',
                                                  style: color00000s14w500
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              '₹ ${user_model?.data?.totalPendingAmount ?? 0}',
                                              style: color00000s14w500.copyWith(
                                                  color: AppColors.color9a0400,
                                                  fontSize: 18,
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
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Transactions',
                      style: color00000s14w500,
                    ),
                  ),
                  /*   Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Text(
                          'Sort By:',
                          style: color00000s14w500,
                        ),
                        const SizedBox(
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
                                      color: AppColors.color000000
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: DropdownButton<String>(
                                    value: dropDownValue.value,
                                    underline: const SizedBox(),
                                    borderRadius: BorderRadius.circular(6),
                                    style: color00000s14w500,
                                    isExpanded: true,
                                    icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 20,
                                        color: AppColors.color000000),
                                    items: <String>[
                                      'All',
                                      'Listed',
                                      'Unlisted',
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style: color00000s14w500),
                                      );
                                    }).toList(),
                                    onChanged: (_) {
                                      dropDownValue.value = _.toString();
                                    },
                                  ),
                                );
                              }),
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
                child: Obx(
                  () {
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
                                                          'Dummuy Text',
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
                                                          'Dummuy Text',
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
                                                          'Dummuy Text',
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
                                                          'Dummuy Text',
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
                                                          'Dummuy Text',
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
                                                          'Dummuy Text',
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
                                                          'Dummuy Text',
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
                                                          'Dummuy Text',
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
                                                          'Dummuy Text',
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
                                                          'Dummuy Text',
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
                        : AgentTransactionController.to.transactionList.isEmpty
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Container(
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          color: AppColors.colorD9D9D9,
                                          borderRadius:
                                              BorderRadius.circular(15),),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 40,
                                        horizontal: 50,
                                      ),
                                      child: Text(
                                        'You don\'t have any Transaction yet!!',
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
                                    AgentTransactionController
                                        .to.transactionList.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  AgentTransactionController.to
                                                              .transactionList[
                                                          index]['photo'] ??
                                                      '',
                                              placeholder: (context, url) =>
                                                  CupertinoActivityIndicator(
                                                      color: AppColors
                                                          .colorFE6927),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Icon(Icons
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
                                                            '${index + 1}',
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
                                                          'Property Name :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            AgentTransactionController
                                                                .to
                                                                .transactionList[
                                                                    index][
                                                                    'property_name']
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
                                                                0.5,
                                                              ),
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
                                                          'Booked by :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (AgentTransactionController.to.transactionList[index]
                                                                            [
                                                                            'first_name'] ??
                                                                        '')
                                                                    .toString() +
                                                                ' ' +
                                                                (AgentTransactionController
                                                                            .to
                                                                            .transactionList[index]['last_name'] ??
                                                                        '')
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
                                                          'Booked on :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (AgentTransactionController
                                                                            .to
                                                                            .transactionList[index]
                                                                        [
                                                                        'start_date'] ??
                                                                    '')
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
                                                          'Mode :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (AgentTransactionController
                                                                            .to
                                                                            .transactionList[index]
                                                                        [
                                                                        'mode'] ??
                                                                    '')
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
                                                          'Base Price :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            '₹ ' +
                                                                (AgentTransactionController
                                                                            .to
                                                                            .transactionList[index]['total_amount'] ??
                                                                        0)
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
                                                          'Earned Per. :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (AgentTransactionController
                                                                            .to
                                                                            .transactionList[index]['percentage'] ??
                                                                        0)
                                                                    .toString() +
                                                                ' %',
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
                                                          'Earned Amount :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            '₹ ' +
                                                                (AgentTransactionController
                                                                            .to
                                                                            .transactionList[index]['amount'] ??
                                                                        0)
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
                                                          'Transaction Date :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (AgentTransactionController
                                                                            .to
                                                                            .transactionList[index]
                                                                        [
                                                                        'transuction_date']) ==
                                                                    null
                                                                ? ""
                                                                : DateFormat(
                                                                        'dd-MM-yyyy')
                                                                    .format(DateTime.parse((AgentTransactionController
                                                                            .to
                                                                            .transactionList[index]['transuction_date'])
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
import 'package:gleeky_flutter/src/agent/agent_properties/agent_properties.dart';
import 'package:gleeky_flutter/src/agent/controllers/agent_dashboard_controller.dart';
import 'package:gleeky_flutter/src/host/menu/view/kyc/kyc_screen.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:shimmer/shimmer.dart';

class AgentDashboard extends StatefulWidget {
  const AgentDashboard({Key? key}) : super(key: key);

  @override
  State<AgentDashboard> createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard> {
  @override
  initState() {
    AgentDashboardController.to.getagentDashboardApi();
    super.initState();
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, right: 27, left: 27, bottom: 20),
                  child: Row(
                    children: [
                      /*  IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.menu,
                          size: 25,
                        ),
                      ),*/
                      Expanded(
                        child: Center(
                          child: Text(
                            'Agent Dashboard',
                            style: color00000s18w600,
                          ),
                        ),
                      ),
                      /* Opacity(
                        opacity: 0,
                        child: IgnorePointer(
                          ignoring: true,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.menu,
                              size: 25,
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
                Obx(() {
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 27.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Bounce(
                                        duration:
                                            const Duration(milliseconds: 150),
                                        onPressed: () {
                                          Get.to(() => const AgentProperties());
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.colorffffff,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 5,
                                                spreadRadius: 3,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.05),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 25,
                                          ),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Bounce(
                                                  duration: const Duration(
                                                      milliseconds: 150),
                                                  onPressed: () {
                                                    Get.to(() =>
                                                        const AgentProperties());
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                        'Total Properties df',
                                                        style: color00000s14w500
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  '${0}',
                                                  style: color00000s14w500
                                                      .copyWith(
                                                          color: AppColors
                                                              .colorFE6927,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.colorffffff,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 5,
                                              spreadRadius: 3,
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
                                                    AppImages.reservation_Icon,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    'Total Booking',
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
                                                '${0}',
                                                style:
                                                    color00000s14w500.copyWith(
                                                        color: AppColors
                                                            .colorFE6927,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 27.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.colorffffff,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 5,
                                              spreadRadius: 3,
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
                                                            .color32BD01,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 5,
                                              spreadRadius: 3,
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
                                                            .colorE31717,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 27.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.colorffffff,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 5,
                                              spreadRadius: 3,
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
                                                            .colorFE6927,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
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
                                                spreadRadius: 3,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.05),
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
                                                      AppImages
                                                          .total_credit_Icon,
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
                                                  style: color00000s14w500
                                                      .copyWith(
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
                            ((AgentDashboardController.to.getagentDashboardRes['data']
                                            ?['result']?['kyc_status'] ??
                                        '') ==
                                    'Processing')
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 27.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.colord1ecf1,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 12),
                                      child: Row(
                                        children: [
                                          Icon(Icons.error_outline,
                                              color: AppColors.color000000,
                                              size: 25),
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
                                : ((AgentDashboardController.to.getagentDashboardRes['data']
                                                        ?['result']
                                                    ?['kyc_status'] ??
                                                '') ==
                                            'Pending') ||
                                        ((AgentDashboardController.to
                                                        .getagentDashboardRes['data']?['result']
                                                    ?['kyc_status'] ??
                                                '') ==
                                            'Re-Submited')
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 27.0,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: AppColors.colorFE6927
                                                .withOpacity(0.2),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 12),
                                          child: Row(
                                            children: [
                                              Icon(Icons.error_outline,
                                                  color: AppColors.color000000,
                                                  size: 25),
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
                                                        style:
                                                            color00000s14w500),
                                                    TextSpan(
                                                      text:
                                                          'Complete Glee Partner KYC.',
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () =>
                                                                Get.to(() =>
                                                                    KycScreen()),
                                                      style: color00000s14w500
                                                          .copyWith(
                                                              color: AppColors
                                                                  .colorFE6927,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                      )
                                    : ((AgentDashboardController.to.getagentDashboardRes['data']
                                                    ?['result']?['kyc_status'] ??
                                                '') ==
                                            'Reject')
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 27.0,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors.colorf8d7da
                                                    .withOpacity(0.2),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 12),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.error_outline,
                                                      color:
                                                          AppColors.color000000,
                                                      size: 25),
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
                                                              style:
                                                                  color00000s14w500),
                                                          TextSpan(
                                                            text: 'Verify ',
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () =>
                                                                      Get.to(() =>
                                                                          KycScreen()),
                                                            style: color00000s14w500.copyWith(
                                                                color: AppColors
                                                                    .colorFE6927,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          TextSpan(
                                                              text:
                                                                  'your details.',
                                                              style:
                                                                  color00000s14w500),
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
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 27.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Bounce(
                                      duration:
                                          const Duration(milliseconds: 150),
                                      onPressed: () {
                                        Get.to(() => const AgentProperties());
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.colorffffff,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 5,
                                              spreadRadius: 3,
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
                                                    AppImages.property_icon,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    'Total Properties',
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
                                                '${AgentDashboardController.to.getagentDashboardRes['data']?['total_property'] ?? 0}',
                                                style:
                                                    color00000s14w500.copyWith(
                                                        color: AppColors
                                                            .colorFE6927,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                            ],
                                          ),
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
                                            spreadRadius: 3,
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
                                                  AppImages.reservation_Icon,
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  'Total Booking',
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
                                              '${AgentDashboardController.to.getagentDashboardRes['data']?['total_booking'] ?? 0}',
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
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 27.0),
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
                                            spreadRadius: 3,
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
                                              '₹ ${AgentDashboardController.to.getagentDashboardRes['data']?['total_credit'] ?? 0}',
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
                                            spreadRadius: 3,
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 27.0),
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
                                            spreadRadius: 3,
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
                                      opacity:
                                          (user_model?.data?.sponserCode) ==
                                                  null
                                              ? 0
                                              : 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.colorffffff,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 5,
                                              spreadRadius: 3,
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
                                                    AppImages.hostIcon,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    'Agent Code',
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
                                                '${user_model?.data?.sponserCode}',
                                                style:
                                                    color00000s14w500.copyWith(
                                                        color: AppColors
                                                            .colorFE6927,
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

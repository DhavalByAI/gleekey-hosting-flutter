import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/text_fields_widgets/custom_textfield_common.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'controller/transaction_history_controller.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  RxBool showCircle = false.obs;

  RxInt offset = 1.obs;
  // Initial Selected Value

  TextEditingController fromDate = TextEditingController();
  DateTime? from;
  TextEditingController toDate = TextEditingController();
  DateTime? To;

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add Your Code here.
      TransactionHistoryControlller.to.transactionHistoryData.clear();
      TransactionHistoryControlller.to.transactionHistoryApi(
          params: {
            'page': offset.value,
            "limit": "10",
            'from': fromDate.text,
            'to': toDate.text
          },
          success: () {
            offset.value = offset.value + 1;
          });
      _scrollController.addListener(() {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          showCircle.value = true;
          TransactionHistoryControlller.to.transactionHistoryApi(
              params: {
                'page': offset.value,
                "limit": "10",
                'from': fromDate.text,
                'to': toDate.text
              },
              success: () {
                showCircle.value = false;
                offset.value = offset.value + 1;
              },
              error: () {});
        }
      });
    });

    super.initState();
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 17),
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
                        'Transaction History',
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
              Row(
                children: [
                  Expanded(
                    child: CustomTextfieldCommon(
                      controller: fromDate,
                      label: 'From',
                      hint: 'From date',
                      validate: (v) {},
                      onTap: () async {
                        from = await showDatePicker(
                          context: context,
                          initialDate: To != null ? To! : DateTime.now(),
                          firstDate: DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: To ?? DateTime(2025),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary:
                                      AppColors.colorFE6927, // <-- SEE HERE
                                  // onPrimary:
                                  //     AppColors.colorFE6927, // <-- SEE HERE
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    primary: AppColors
                                        .colorFE6927, // button text color
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (from != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(from!);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            fromDate.text =
                                formattedDate; //set output date to TextField value.
                          });
                        }
                      },
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomTextfieldCommon(
                      controller: toDate,
                      label: 'To',
                      hint: 'To date',
                      validate: (v) {},
                      onTap: () async {
                        To = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: from != null ? from! : DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary:
                                      AppColors.colorFE6927, // <-- SEE HERE
                                  // onPrimary:
                                  //     AppColors.colorFE6927, // <-- SEE HERE
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    primary: AppColors
                                        .colorFE6927, // button text color
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (To != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(To!);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            toDate.text =
                                formattedDate; //set output date to TextField value.
                          });
                        }
                      },
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CommonButton(
                      onPressed: () {
                        offset.value = 0;
                        loaderShow(context);
                        TransactionHistoryControlller.to.transactionHistoryData
                            .clear();
                        TransactionHistoryControlller
                            .to.transactionHistoryResponse
                            .clear();
                        TransactionHistoryControlller.to.transactionHistoryApi(
                            params: {
                              'offset': offset.value,
                              "limit": "10",
                              'from': fromDate.text,
                              'to': toDate.text
                            },
                            success: () {
                              loaderHide();
                              offset.value = offset.value + 1;
                            },
                            error: (e) {
                              loaderHide();
                            });
                      },
                      name: 'Filter',
                      padding: const EdgeInsets.symmetric(vertical: 15))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Obx(
                    () {
                      return TransactionHistoryControlller
                              .to.transactionHistoryResponse.isEmpty
                          ? Column(
                              children: List.generate(
                                5,
                                (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: AppColors
                                                      .colorD9D9D9
                                                      .withOpacity(0.2),
                                                  highlightColor:
                                                      AppColors.colorD9D9D9,
                                                  child: Container(
                                                    height: 20,
                                                    color:
                                                        AppColors.colorF8F8F8,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: AppColors
                                                      .colorD9D9D9
                                                      .withOpacity(0.2),
                                                  highlightColor:
                                                      AppColors.colorD9D9D9,
                                                  child: Container(
                                                    height: 20,
                                                    color:
                                                        AppColors.colorF8F8F8,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: AppColors
                                                      .colorD9D9D9
                                                      .withOpacity(0.2),
                                                  highlightColor:
                                                      AppColors.colorD9D9D9,
                                                  child: Container(
                                                      height: 20,
                                                      color: AppColors
                                                          .colorF8F8F8),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: AppColors
                                                      .colorD9D9D9
                                                      .withOpacity(0.2),
                                                  highlightColor:
                                                      AppColors.colorD9D9D9,
                                                  child: Container(
                                                      height: 20,
                                                      color: AppColors
                                                          .colorF8F8F8),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Amount',
                                                  style: color00000s15w600,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: AppColors
                                                      .colorD9D9D9
                                                      .withOpacity(0.2),
                                                  highlightColor:
                                                      AppColors.colorD9D9D9,
                                                  child: Container(
                                                      height: 20,
                                                      color: AppColors
                                                          .colorF8F8F8),
                                                ),
                                              ],
                                            ),
                                          ),
                                          /*   Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Paidout',
                                                  style: color00000s15w600,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: AppColors
                                                      .colorD9D9D9
                                                      .withOpacity(0.2),
                                                  highlightColor:
                                                      AppColors.colorD9D9D9,
                                                  child: Container(
                                                      height: 20,
                                                      color: AppColors
                                                          .colorF8F8F8),
                                                ),
                                              ],
                                            ),
                                          ),*/
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        color: AppColors.color000000
                                            .withOpacity(0.2),
                                        indent: 10,
                                        endIndent: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : (TransactionHistoryControlller
                                      .to.transactionHistoryData.value.length ==
                                  0)
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
                                    child: Text(
                                      'No data available',
                                      style: color00000s14w500,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: List.generate(
                                    TransactionHistoryControlller
                                        .to.transactionHistoryData.value.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Date : ',
                                                          style:
                                                              color00000s15w600,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            TransactionHistoryControlller
                                                                        .to
                                                                        .transactionHistoryData
                                                                        .value[index]
                                                                    ?[
                                                                    'created_at'] ??
                                                                '-',
                                                            style:
                                                                color50perBlacks13w400
                                                                    .copyWith(
                                                                        height:
                                                                            0),
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
                                                          'Type : ',
                                                          style:
                                                              color00000s15w600,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            TransactionHistoryControlller
                                                                        .to
                                                                        .transactionHistoryData
                                                                        .value[index]
                                                                    ?[
                                                                    'booking_type'] ??
                                                                '-',
                                                            style:
                                                                color50perBlacks13w400
                                                                    .copyWith(
                                                                        height:
                                                                            0),
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
                                                              color00000s15w600,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (TransactionHistoryControlller
                                                                            .to
                                                                            .transactionHistoryData[index]
                                                                        ?[
                                                                        'status'] ??
                                                                    '')
                                                                .toString(),
                                                            style:
                                                                color50perBlacks13w400
                                                                    .copyWith(
                                                                        height:
                                                                            0),
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
                                                          'ID : ',
                                                          style:
                                                              color00000s15w600,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            (TransactionHistoryControlller
                                                                            .to
                                                                            .transactionHistoryData
                                                                            .value[index]
                                                                        ?[
                                                                        'id'] ??
                                                                    '-')
                                                                .toString(),
                                                            style:
                                                                color50perBlacks13w400
                                                                    .copyWith(
                                                                        height:
                                                                            0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'Amount',
                                                      style: color00000s15w600,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '₹ ${(TransactionHistoryControlller.to.transactionHistoryData.value[index]['amount'] ?? '-').toString()}',
                                                      style: color32BD01s15w700
                                                          .copyWith(
                                                              color: (TransactionHistoryControlller
                                                                              .to
                                                                              .transactionHistoryData[index]
                                                                          [
                                                                          'status'] ==
                                                                      'Pending')
                                                                  ? AppColors
                                                                      .colorffc107
                                                                  : (TransactionHistoryControlller.to.transactionHistoryData[index]
                                                                              [
                                                                              'status'] ==
                                                                          'Paid')
                                                                      ? AppColors
                                                                          .color32BD01
                                                                      : (TransactionHistoryControlller.to.transactionHistoryData[index]['status'] ==
                                                                              'Rejected')
                                                                          ? AppColors
                                                                              .color9a0400
                                                                          : AppColors
                                                                              .colorFE6927),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              /*Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'Paidout',
                                                      style: color00000s15w600,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      (TransactionHistoryControlller
                                                                          .to
                                                                          .transactionHistoryData[
                                                                      index][
                                                                  'pay_mode']) ==
                                                              'Debit'
                                                          ? '₹ ${(TransactionHistoryControlller.to.transactionHistoryData.value[index]['amount'] ?? '-')}'
                                                          : '',
                                                      style: color32BD01s15w700
                                                          .copyWith(
                                                        color: AppColors
                                                            .color9a0400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),*/
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(
                                            color: AppColors.color000000
                                                .withOpacity(0.2),
                                            indent: 10,
                                            endIndent: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

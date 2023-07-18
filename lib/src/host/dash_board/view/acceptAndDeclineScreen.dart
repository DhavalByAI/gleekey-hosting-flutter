import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/src/host/Main/main_screen.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/acceptAnddecline_controller.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

import '../controller/dashboard_controller.dart';

class AcceptAndDeclineScreen extends StatefulWidget {
  final Map data;
  AcceptAndDeclineScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<AcceptAndDeclineScreen> createState() => _AcceptAndDeclineScreenState();
}

class _AcceptAndDeclineScreenState extends State<AcceptAndDeclineScreen> {
  RxBool priceBackUp = false.obs;
  RxList date_with_price = [].obs;
  RxDouble subtotal = 0.00.obs;
  TextEditingController _messageToGuest = TextEditingController();
  TextEditingController _whyDeclining = TextEditingController();
  TextEditingController _message = TextEditingController();
  RxBool isAgree = false.obs;
  RxBool blockDate = false.obs;
  @override
  initState() {
    log("DATA OF " + jsonEncode(widget.data['date_with_price']).toString());
    date_with_price.value =
        jsonDecode(widget.data['date_with_price'].toString());
    date_with_price.forEach((element) {
      subtotal.value = subtotal.value + element['price'];
    });
    super.initState();
  }

  List<Map<String, String>> reasons = [
    {' ': 'Why are you declining'},
    {'dates_not_available': 'Dates are not available'},
    {'not_comfortable': 'I do not feel comfortable with this guest'},
    {
      'not_a_good_fit':
          'My listing is not a good fit for the guest’s needs (children, pets, etc.)'
    },
    {
      'waiting_for_better_reservation':
          'I am waiting for a more attractive booking'
    },
    {
      'different_dates_than_selected':
          'The guest is asking for different dates than the ones selected in this request'
    },
    {'spam': 'This message is spam'},
    {'other': 'other'},
  ];
  RxString reasonsDropDown = 'Why are you declining'.obs;
  RxString reasonsDropDownKey = ' '.obs;

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
                      selectedBottom.value = 0;
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
                        'Requested Booking',
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
                          Icons.search,
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
              Expanded(
                child: OnGoingView(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text:
                          '${widget.data['users']['first_name']} ${widget.data['users']['last_name']}  ',
                      style: color00000s14w500),
                  TextSpan(
                    text:
                        'has requested to book your property.Please accept or Decline this request.',
                    style: color50perBlacks13w400.copyWith(height: 0),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                    onPressed: () {
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Accept this request',
                                      style: color00000s18w600,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Icon(
                                          Icons.close,
                                        ))
                                  ]),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              content: SizedBox(
                                width: Get.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Write a message to guest (Optional)',
                                      style: color00000s14w500,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: _messageToGuest,
                                      cursorColor: AppColors.colorFE6927,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: AppColors.color000000
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: AppColors.color000000
                                                    .withOpacity(0.5))),
                                        contentPadding:
                                            const EdgeInsets.all(13.0),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        CommonCheckBox(isAgree),
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'I agree to the ',
                                              style:
                                                  colorFE6927s12w600.copyWith(
                                                      color:
                                                          AppColors.color000000,
                                                      fontWeight:
                                                          FontWeight.w400),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      'Host Terms and condition ',
                                                  style: colorFE6927s12w600,
                                                ),
                                                TextSpan(
                                                  text: 'and ',
                                                  style: colorFE6927s12w600
                                                      .copyWith(
                                                          color: AppColors
                                                              .color000000,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                                TextSpan(
                                                  text: 'Cancellation Policy',
                                                  style: colorFE6927s12w600,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColors
                                                          .color000000),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Center(
                                                child: Text(
                                                  'Close',
                                                  style: colorfffffffs13w600
                                                      .copyWith(
                                                    color:
                                                        AppColors.color000000,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if (isAgree.value &&
                                                  widget.data['id'] != null) {
                                                loaderShow(context);
                                                AcceptAndDeclineController.to
                                                    .acceptApi(
                                                        params: {
                                                      "booking_id":
                                                          widget.data['id'],
                                                      "message":
                                                          _messageToGuest.text,
                                                      "tos_confirm":
                                                          isAgree.value
                                                    },
                                                        success: () {
                                                          loaderHide();
                                                          DashBoardController.to
                                                              .reservationApi(
                                                                  params: {
                                                                'offset': '0',
                                                                "limit": "10"
                                                              },
                                                                  success: () {
                                                                    Get.back();
                                                                    Get.back();
                                                                  },
                                                                  error: (e) {
                                                                    Get.back();
                                                                    Get.back();
                                                                    showSnackBar(
                                                                        title: ApiConfig
                                                                            .error,
                                                                        message:
                                                                            e.toString());
                                                                  });
                                                        },
                                                        error: (e) {
                                                          loaderHide();
                                                          Get.back();
                                                          showSnackBar(
                                                              title: ApiConfig
                                                                  .error,
                                                              message:
                                                                  e.toString());
                                                        });
                                              } else {
                                                showSnackBar(
                                                    title: ApiConfig.error,
                                                    message:
                                                        'Accept the terms and Conditions');
                                              }
                                            },
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: AppColors.colorFE6927,
                                                  border: Border.all(
                                                      color: AppColors
                                                          .colorFE6927),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Center(
                                                child: Text(
                                                  'Accept',
                                                  style: colorfffffffs13w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    name: 'Accept',
                    width: double.maxFinite,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Cancel this Booking',
                                      style: color00000s18w600,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Icon(
                                          Icons.close,
                                        ))
                                  ]),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              content: SizedBox(
                                width: Get.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Help us improve your experience.Please write down the main reason for Cancelling this Booking',
                                      style: color50perBlacks13w400,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Your response will not be shared with the host',
                                      style: color00000s14w500,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Obx(() {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: AppColors.color000000
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: DropdownButton(
                                          underline: const SizedBox(),
                                          hint: Text(reasonsDropDown.value,
                                              style: color00000s14w500),
                                          isExpanded: true,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          items: List.generate(
                                              reasons.length,
                                              (index) => DropdownMenuItem(
                                                    onTap: () {
                                                      reasonsDropDown.value =
                                                          reasons[index]
                                                              .values
                                                              .first;
                                                      reasonsDropDownKey.value =
                                                          reasons[index]
                                                              .keys
                                                              .first;
                                                    },
                                                    value:
                                                        reasons[index].values,
                                                    child: Text(
                                                      reasons[index]
                                                          .values
                                                          .first,
                                                      style: color00000s14w500,
                                                    ),
                                                  )),
                                          onChanged: (_) {},
                                        ),
                                      );
                                    }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Why are you declining?',
                                      style: color00000s14w500,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: _whyDeclining,
                                      cursorColor: AppColors.colorFE6927,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: AppColors.color000000
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: AppColors.color000000
                                                    .withOpacity(0.5))),
                                        contentPadding:
                                            const EdgeInsets.all(13.0),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        CommonCheckBox(blockDate),
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'Block my calendar from ',
                                              style:
                                                  colorFE6927s12w600.copyWith(
                                                      color:
                                                          AppColors.color000000,
                                                      fontWeight:
                                                          FontWeight.w400),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: (widget.data[
                                                              'date_range'] ??
                                                          '') +
                                                      '.',
                                                  style: color00000s14w500,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Write optional message to guest',
                                      style: color00000s14w500,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: _message,
                                      cursorColor: AppColors.colorFE6927,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: AppColors.color000000
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: AppColors.color000000
                                                    .withOpacity(0.5))),
                                        contentPadding:
                                            const EdgeInsets.all(13.0),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColors
                                                          .color000000),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Center(
                                                child: Text(
                                                  'Close',
                                                  style: colorfffffffs13w600
                                                      .copyWith(
                                                    color:
                                                        AppColors.color000000,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if (reasonsDropDownKey.value !=
                                                  ' ') {
                                                loaderShow(context);
                                                AcceptAndDeclineController.to
                                                    .declineApi(
                                                        params: {
                                                      "booking_id":
                                                          widget.data['id'],
                                                      "decline_reason":
                                                          reasonsDropDownKey
                                                              .value,
                                                      "decline_reason_other":
                                                          _whyDeclining.text,
                                                      "block_calendar":
                                                          blockDate.value,
                                                      "message": _message.text,
                                                    },
                                                        success: () {
                                                          loaderHide();
                                                          DashBoardController.to
                                                              .reservationApi(
                                                                  params: {
                                                                'offset': '0',
                                                                "limit": "10"
                                                              },
                                                                  success: () {
                                                                    Get.back();
                                                                    Get.back();
                                                                  },
                                                                  error: (e) {
                                                                    Get.back();
                                                                    Get.back();
                                                                    showSnackBar(
                                                                        title: ApiConfig
                                                                            .error,
                                                                        message:
                                                                            e.toString());
                                                                  });
                                                        },
                                                        error: (e) {
                                                          loaderHide();
                                                          Get.back();
                                                          showSnackBar(
                                                              title: ApiConfig
                                                                  .error,
                                                              message:
                                                                  e.toString());
                                                        });
                                              } else {
                                                showSnackBar(
                                                    title: ApiConfig.error,
                                                    message:
                                                        'Select reason why you want to decline booking');
                                              }
                                            },
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: AppColors.colorFE6927,
                                                  border: Border.all(
                                                      color: AppColors
                                                          .colorFE6927),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Center(
                                                child: Text(
                                                  'Decline',
                                                  style: colorfffffffs13w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.color000000.withOpacity(0.8)),
                          borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'Decline',
                          style: colorfffffffs13w600.copyWith(
                            color: AppColors.color000000,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget OnGoingView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: Get.width / 1.6,
                width: Get.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.colorFE6927),
                child: CachedNetworkImage(
                    imageUrl: widget.data['properties']['cover_photo'],
                    placeholder: (context, url) => CupertinoActivityIndicator(
                          color: AppColors.colorFE6927,
                        ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.data['properties']?['name'] ?? 'TITLE',
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
                      (widget.data['properties']?['avg_rating'] ?? 0)
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
            /* Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.color000000.withOpacity(0.2),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text(
                    'STATIC ADDRESS',
                    style: color00000s14w500,
                  ),
                ),
              ],
            ),*/
            const SizedBox(
              height: 8,
            ),
            Divider(
              color: AppColors.color000000.withOpacity(0.2),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total Guests',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  '${widget.data['guest']} Guests',
                  style: color00000s14w500,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Price',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  '₹ ${widget.data['per_night']}',
                  style: color00000s14w500,
                ),
              ],
            ),
            Text(
              '(For 1 Night)',
              style: color50perBlacks13w400,
            ),
            const SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () {
                priceBackUp.value = !priceBackUp.value;
                print(date_with_price);
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Text(
                'View Price Breakup',
                style: colorFE6927s12w600,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Obx(() {
              return priceBackUp.value
                  ? Column(
                      children: List.generate(date_with_price.length, (i) {
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                (date_with_price[i]?["date"] ?? '-').toString(),
                                style: color00000s14w500,
                              ),
                            ),
                            Text(
                              '₹ ${date_with_price[i]['price'].toString()}',
                              style: color00000s14w500,
                            ),
                          ],
                        );
                      }),
                    )
                  : const SizedBox();
            }),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Subtotal',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  '₹ ${subtotal.value.round()}',
                  style: color00000s14w500,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Gleekey Fees (15%)',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  '- ₹ ${(subtotal.value * 0.15).round()}',
                  style: colorFE6927s12w600,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Divider(
              color: AppColors.color000000.withOpacity(0.2),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Grand Total',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  '₹ ${((subtotal.value) - (subtotal.value * 0.15)).round()}',
                  style: color00000s14w500,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'GST',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  '₹ ${(((subtotal.value) - (subtotal.value * 0.15)) * 0.18).round()}',
                  style: color00000s14w500,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Divider(
              color: AppColors.color000000.withOpacity(0.2),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Amount you will get',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  '₹ ${((subtotal.value) - ((subtotal.value * 0.15)) + (((subtotal.value) - (subtotal.value * 0.15)) * 0.18)).round()}',
                  style: color00000s15w600,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

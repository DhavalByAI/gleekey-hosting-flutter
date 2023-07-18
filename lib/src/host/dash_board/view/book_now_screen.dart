import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
import 'package:gleeky_flutter/src/host/Main/main_screen.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/view_property_controller.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/pdf/pdf_controller.dart';
import 'package:gleeky_flutter/utills/style/constants.dart';
import 'package:gleeky_flutter/utills/style/palette.dart';
import 'package:gleeky_flutter/utills/text_fields_widgets/custom_textfield_common.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'All_photos_screen.dart';

class BookNowScreen extends StatefulWidget {
  final String checkIn;
  final String checkout;
  final String adults;
  final String Children;
  final String Infants;
  final String Propertytype;
  BookNowScreen(
      {Key? key,
      required this.checkIn,
      required this.checkout,
      required this.adults,
      required this.Children,
      required this.Infants,
      required this.Propertytype})
      : super(key: key);

  @override
  State<BookNowScreen> createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  TextEditingController _firstName =
      TextEditingController(text: user_model?.data?.firstName ?? '');
  TextEditingController _lastName =
      TextEditingController(text: user_model?.data?.lastName ?? '');
  TextEditingController _emailId =
      TextEditingController(text: user_model?.data?.email ?? '');
  TextEditingController _contactNumber =
      TextEditingController(text: user_model?.data?.phone ?? '');
  TextEditingController _additionalReq = TextEditingController();

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
                        'Confirm & Pay',
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
                child: receiptView(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget receiptView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: MediaQuery.of(context).size.width >
                        MediaQuery.of(context).size.height
                    ? Get.height / 3.5
                    : Get.height / 4,
                width: MediaQuery.of(context).size.width >
                        MediaQuery.of(context).size.height
                    ? MediaQuery.of(context).size.height / 3.3
                    : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.colorFE6927),
                child: CachedNetworkImage(
                    imageUrl:
                        ViewPropertyController.to.viewPropertyresponse['data']
                                ?['result']?['cover_photo'] ??
                            '',
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
                    ViewPropertyController.to.viewPropertyresponse['data']
                            ?['result']?['property_name'] ??
                        '',
                    style: color00000s18w600,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              ViewPropertyController.to.viewPropertyresponse['data']?['result']
                      ?['slug'] ??
                  '',
              style: color00000s14w500,
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
            Text(
              'Booking Summary',
              style: color00000s18w600,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Check In',
                  style: color00000s15w600,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.checkIn,
                  style:
                      color50perBlacks13w400.copyWith(height: 0, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Check Out',
                  style: color00000s15w600,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.checkout,
                  style:
                      color50perBlacks13w400.copyWith(height: 0, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(ViewPropertyController.to.viewPropertyresponse['data']?['result']?['guest'] ?? '0').toString()} Total Guests',
                  style: color00000s15w600,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '${widget.adults} Adults | ${widget.Children} Children | ${widget.Infants} Infants',
                  style:
                      color50perBlacks13w400.copyWith(height: 0, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rooms',
                  style: color00000s15w600,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.Propertytype,
                  style: color50perBlacks13w400.copyWith(
                    height: 0,
                    fontSize: 15,
                  ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enter Guest Details',
                  style: color00000s18w600,
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.color000000.withOpacity(0.2),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('First Name', style: color50perBlacks13w400),
                    TextFormField(
                      controller: _firstName,
                      cursorColor: AppColors.colorFE6927,
                      style: color00000s14w500,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.color000000.withOpacity(0.2),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last Name', style: color50perBlacks13w400),
                    TextFormField(
                      controller: _lastName,
                      cursorColor: AppColors.colorFE6927,
                      style: color00000s14w500,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.color000000.withOpacity(0.2),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email Id', style: color50perBlacks13w400),
                    TextFormField(
                      controller: _emailId,
                      cursorColor: AppColors.colorFE6927,
                      style: color00000s14w500,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.color000000.withOpacity(0.2),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact No.', style: color50perBlacks13w400),
                    TextFormField(
                      controller: _contactNumber,
                      cursorColor: AppColors.colorFE6927,
                      style: color00000s14w500,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: AppColors.color000000.withOpacity(0.2),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.color000000.withOpacity(0.2),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Request', style: color50perBlacks13w400),
                    TextFormField(
                      controller: _additionalReq,
                      cursorColor: AppColors.colorFE6927,
                      style: color00000s14w500,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Additional Requests'),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              children: List.generate(2, (i) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        'price break up',
                        style: color00000s14w500,
                      ),
                    ),
                    Text(
                      '₹ 1000',
                      style: color00000s14w500,
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Sub Total',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  '₹ ${1000.round()}',
                  style: color00000s14w500,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            /*      widget.data['couponcode_amount'] == 0 ||
                    widget.data['couponcode_amount'] == '' ||
                    widget.data['couponcode_amount'] == null
                ? const SizedBox()
                : Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Discount',
                          style: color00000s15w600,
                        ),
                      ),
                      Text(
                        '- ₹ ${widget.data['couponcode_amount']}',
                        style: color00000s14w500,
                      ),
                    ],
                  ),
            widget.data['couponcode_amount'] == 0
                ? const SizedBox()
                : const SizedBox(
                    height: 8,
                  ),*/
            Row(
              children: [
                Expanded(
                  child: Text(
                    'GST',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  '₹ ${((1000) * 0.18).round()}',
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
                    'Total Price',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  '₹ ${((1000 /*- ('couponcode_amount' ?? 0)*/) + (1000 * 0.18)).round()}',
                  style: color00000s15w600,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.center,
              child: CommonButton(
                width: Get.width,
                onPressed: () {},
                name: 'Continue',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            /* Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cancellation Policy',
                  style: color00000s15w600,
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Learn more',
                    style: colorFE6927s12w600,
                  ),
                ),
              ],
            ),*/
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget SpaceCommonRow({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          MyBullet(),
          SizedBox(
            width: 10,
          ),
          Text(
            '$title: $value',
            style: color50perBlacks13w400.copyWith(height: 0),
          )
        ],
      ),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 12.0,
      width: 12.0,
      decoration: new BoxDecoration(
        color: AppColors.colorFE6927,
        shape: BoxShape.circle,
      ),
    );
  }
}

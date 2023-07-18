import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/src/host/Main/main_screen.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/pdf/pdf_controller.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewReceiptsScreen extends StatefulWidget {
  final Map data;
  ViewReceiptsScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<ViewReceiptsScreen> createState() => _ViewReceiptsScreenState();
}

class _ViewReceiptsScreenState extends State<ViewReceiptsScreen> {
  RxBool priceBackUp = false.obs;
  RxList date_with_price = [].obs;
  RxDouble subtotal = 0.00.obs;
  @override
  initState() {
    log("DATA OF " + jsonEncode(widget.data).toString());
    date_with_price.value = jsonDecode(widget.data['date_with_price']);
    date_with_price.forEach((element) {
      subtotal.value = subtotal.value + (element['price'] ?? 0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: CommonButton(
            width: Get.width,
            padding: EdgeInsets.symmetric(vertical: 12),
            onPressed: () async {
              loaderShow(context);
              File file = await PdfController.generate(
                  widget.data, date_with_price, subtotal.value);
              loaderHide();
              PdfApi.openDocument(file: file);
            },
            name: 'Generate PDF'),
      ),
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
                        'Receipt',
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
            Row(
              children: [
                Text(
                  'Confirmation Code : ',
                  style: color00000s18w600,
                ),
                Expanded(
                  child: Text(
                    widget.data['code'] ?? '-',
                    style: color00000s18w600,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: Get.height / 3.3,
                width: MediaQuery.of(context).size.width >
                        MediaQuery.of(context).size.height
                    ? MediaQuery.of(context).size.height / 3.3
                    : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.colorFE6927),
                child: CachedNetworkImage(
                    imageUrl: widget.data['properties']?['cover_photo'] ?? '-',
                    placeholder: (context, url) => CupertinoActivityIndicator(
                          color: AppColors.colorFE6927,
                        ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
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
                    widget.data['properties']?['name'] ?? '-',
                    style: color00000s18w600,
                  ),
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
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Hosted By: ',
                  style: color00000s18w600,
                ),
                Text(
                  widget.data['properties']?['host_name'] ?? '-',
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
            Text(
              'Booking Details',
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
              children: [
                Text(
                  '${widget.data['total_night'] ?? '-'} Nights',
                  style: color00000s15w600,
                ),
                Expanded(
                  child: Text(
                    widget.data['accepted_at'] == null ||
                            widget.data['accepted_at'] == ''
                        ? 'Booked on --'
                        : 'Booked on ${DateFormat('yyyy-MM-dd').format(
                            DateTime.parse(widget.data['accepted_at']),
                          )}',
                    style: color00000s14w500,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'CHECK-IN',
                  style: color00000s15w600,
                ),
                Expanded(
                  child: Text(
                    widget.data['start_date'] == null ||
                            widget.data['start_date'] == ''
                        ? '--'
                        : DateFormat.yMMMEd()
                            .format(DateTime.parse(widget.data['start_date'])),
                    style: color00000s14w500,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'CHECK-OUT',
                  style: color00000s15w600,
                ),
                Expanded(
                  child: Text(
                    widget.data['end_date'] == null ||
                            widget.data['end_date'] == ''
                        ? '--'
                        : DateFormat.yMMMEd()
                            .format(DateTime.parse(widget.data['end_date']))
                            .toString(),
                    style: color00000s14w500,
                    textAlign: TextAlign.end,
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
              children: [
                Expanded(
                  child: Text(
                    'GUEST(s)',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  'Adult(s) | Children | Infant(s)',
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
                    'Total Guests',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  '${widget.data['guest'] ?? '-'} Guests',
                  style: color00000s14w500,
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
                  'PHONE NO',
                  style: color00000s15w600,
                ),
                Text(
                  '${widget.data['users']?['formatted_phone'] ?? '-'}',
                  style: color00000s14w500,
                  textAlign: TextAlign.end,
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
                  'PRIMARY GUEST',
                  style: color00000s15w600,
                ),
                Text(
                  '${widget.data['users']?['first_name'] ?? '-'} ${widget.data['users']?['last_name'] ?? '-'}',
                  style: color00000s14w500,
                  textAlign: TextAlign.end,
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
                  'EMAIL ID',
                  style: color00000s15w600,
                ),
                Text(
                  '${widget.data['users']?['email'] ?? '-'}',
                  style: color00000s14w500,
                  textAlign: TextAlign.end,
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
            Text(
              'Price Breakup',
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
            Column(
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
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Sub Total for ${widget.data['total_night']} Nights',
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
            widget.data['couponcode_amount'] == 0 ||
                    widget.data['couponcode_amount'] == '' ||
                    widget.data['couponcode_amount'] == null
                ? SizedBox()
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
                ? SizedBox()
                : const SizedBox(
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
                  '₹ ${(((subtotal.value - (int.parse(widget.data['couponcode_amount'] ?? 0))) * 0.18).round()).toString()}',
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
                    'Sub Total',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  '₹ ${((subtotal.value) + (subtotal.value * 0.18)).round()}',
                  style: colorFE6927s12w600.copyWith(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Divider(
              color: AppColors.color000000.withOpacity(0.2),
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
                  '₹ ${(((subtotal.value) - (int.parse(widget.data['couponcode_amount'] ?? 0))) + (subtotal.value * 0.18)).round()}',
                  style: color00000s15w600,
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
                    'AMOUNT PAID',
                    style: color00000s14w500,
                  ),
                ),
                Text(
                  '₹ ${(((subtotal.value) - (int.parse(widget.data['couponcode_amount'] ?? 0))) + (subtotal.value * 0.18)).round()}',
                  style: color00000s14w500,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.color000000.withOpacity(0.2),
                ),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Note :',
                    style: color00000s15w600,
                  ),
                  Text(
                    '\u2022 At the time of check-in, details entered below should match as per govt. issued ID proofs for all the guests. Entry might be restricted in case of non-availability or mismacth of ID Proofs.',
                    style: color50perBlacks13w400,
                  ),
                  Text(
                    '\u2022 Complete Property details will be shared to you before 5 days of check-in date.',
                    style: color50perBlacks13w400,
                  ),
                  Text(
                    '\u2022 Final Invoice will be shared on registered email id or you can check into my-trips before 5 days of check-id date on website.',
                    style: color50perBlacks13w400,
                  ),
                  Text(
                    '\u2022 On arrival please produce the booking invoice for check-in.',
                    style: color50perBlacks13w400,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.color000000.withOpacity(0.2),
                ),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GleeKey Support :',
                    style: color00000s15w600,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text:
                                'For any queries in regards to booking, kindly reach us at  ',
                            style: color50perBlacks13w400),
                        TextSpan(
                            text: 'queries@gleekey.in',
                            style: color50perBlacks13w400.copyWith(
                                color: AppColors.colorFE6927),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final Uri params = Uri(
                                  scheme: 'mailto',
                                  path: 'queries@gleekey.in',
                                );
                                String url = params.toString();
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  print('Could not launch $url');
                                }
                              }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

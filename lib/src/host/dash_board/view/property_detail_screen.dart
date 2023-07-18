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
import 'book_now_screen.dart';

class Property_detail_screen extends StatefulWidget {

  Property_detail_screen({Key? key}) : super(key: key);

  @override
  State<Property_detail_screen> createState() => _Property_detail_screenState();
}

class _Property_detail_screenState extends State<Property_detail_screen> {
  RxBool priceBackUp = false.obs;
  RxList date_with_price = [].obs;
  RxDouble subtotal = 0.00.obs;
  @override
  initState() {
    log('${_checkOut!.difference(_checkIn!).inDays}');
    log('$_checkOut');
    log('$_checkIn');


    super.initState();
  }

  final TextEditingController _checkInTime = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    ),
  );
  DateTime? _checkIn =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime? _checkOut = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    (DateTime.now().day + 1),
  );
  final TextEditingController _checkOutTime = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        (DateTime.now().day + 1),
      ),
    ),
  );

  TextEditingController adults = TextEditingController(text: '1');
  TextEditingController childrens = TextEditingController(text: '0');
  TextEditingController infants = TextEditingController(text: '0');
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
                        ViewPropertyController.to.viewPropertyresponse['data']
                                ?['result']?['property_name'] ??
                            '',
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
                    imageUrl: ViewPropertyController.to.viewPropertyresponse['data']?['result']?['cover_photo'] ?? '',
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
            GridView.builder(gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:(MediaQuery.of(context).size.width >
                MediaQuery.of(context).size.height
                )?6 :3,crossAxisSpacing: 15,mainAxisSpacing: 15), shrinkWrap: true,itemCount: 3,itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.colorFE6927),
                child: CachedNetworkImage(
                    imageUrl:
                    ViewPropertyController.to.viewPropertyresponse['data']?['property_photos']?[index]?['image']??'',
                    placeholder: (context, url) =>
                        CupertinoActivityIndicator(
                          color: AppColors.colorFE6927,
                        ),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                    fit: BoxFit.cover),
              ),
            ),),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: CommonButton(
                  width: Get.width, onPressed: () {
Get.to(()=>AllPhotosScreen());

              }, name: 'See All Photos'),
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
                        '' ,
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
          /*  const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Hosted By: ',
                  style: color00000s18w600,
                ),
                Text(
                  'STATIC',
                  style: color00000s18w600,
                ),
              ],
            ),*/
            const SizedBox(
              height: 8,
            ),
            Divider(
              color: AppColors.color000000.withOpacity(0.2),
            ),
          /*  const SizedBox(
              height: 8,
            ),
            Text(
              'Booking',
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
                Expanded(
                  child: Text(
                    'CHECK-IN',
                    style: color00000s15w600,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _checkInTime,
                    readOnly: true,
                    onTap: () async {
                      _checkIn = await showDatePicker(
                        context: context,
                        initialDate: DateTime.parse(_checkInTime.text),
                        firstDate: DateTime.now(),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day + 44),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.colorFE6927, // <-- SEE HERE
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

                      if (_checkIn != null) {
                        //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(_checkIn!);
                        _checkOut = DateTime(
                            _checkIn!.year, _checkIn!.month, _checkIn!.day + 1);
                        _checkOutTime.text =
                            DateFormat('yyyy-MM-dd').format(_checkOut!);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          _checkInTime.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_month,
                            color: AppColors.colorFE6927),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide:
                                const BorderSide(width: 1, color: kBlack)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide:
                                const BorderSide(width: 1, color: kBlack)),
                        contentPadding: const EdgeInsets.all(13.0),
                        hintText: 'Check-In',
                        hintStyle: Palette.hintStyle),
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
                  child: Text(
                    'CHECK-OUT',
                    style: color00000s15w600,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _checkOutTime,
                    readOnly: true,
                    onTap: () async {
                      _checkOut = await showDatePicker(
                        context: context,
                        initialDate: DateTime.parse(_checkOutTime.text),
                        firstDate: DateTime(
                            DateTime.parse(_checkInTime.text).year,
                            DateTime.parse(_checkInTime.text).month,
                            DateTime.parse(_checkInTime.text).day + 1),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day + 45),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.colorFE6927, // <-- SEE HERE
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

                      if (_checkOut != null) {
                        //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(_checkOut!);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          _checkOutTime.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_month,
                            color: AppColors.colorFE6927),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide:
                                const BorderSide(width: 1, color: kBlack)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide:
                                const BorderSide(width: 1, color: kBlack)),
                        contentPadding: const EdgeInsets.all(13.0),
                        hintText: 'Check-Out',
                        hintStyle: Palette.hintStyle),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Divider(
              color: AppColors.color000000.withOpacity(0.2),
            ),*/
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
                  (ViewPropertyController.to.viewPropertyresponse['data']
                              ?['result']?['guest'] ??
                          '0')
                      .toString(),
                  style: color00000s14w500,
                ),
              ],
            ),
            /*const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Adults',
                    style: color00000s15w600,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: adults,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      prefixIcon: InkWell(
                        onTap: () {
                          if ((int.parse(adults.text)) > 1) {
                            adults.text =
                                (int.parse(adults.text) - 1).toString();
                          }
                        },
                        child: Icon(
                          Icons.remove,
                          color: AppColors.colorFE6927,
                        ),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          if ((int.parse(adults.text)) <
                              int.parse((ViewPropertyController
                                              .to.viewPropertyresponse['data']
                                          ?['result']?['guest'] ??
                                      '0')
                                  .toString())) {
                            adults.text =
                                (int.parse(adults.text) + 1).toString();
                          }
                        },
                        child: Icon(
                          Icons.add,
                          color: AppColors.colorFE6927,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(width: 1, color: kBlack)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(width: 1, color: kBlack)),
                      contentPadding: const EdgeInsets.all(13.0),
                      hintText: 'Adults',
                      hintStyle: Palette.hintStyle,
                    ),
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
                  child: Text(
                    'Children',
                    style: color00000s15w600,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: childrens,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {
                            if ((int.parse(childrens.text)) > 0) {
                              childrens.text =
                                  (int.parse(childrens.text) - 1).toString();
                            }
                          },
                          child: Icon(
                            Icons.remove,
                            color: AppColors.colorFE6927,
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            if ((int.parse(childrens.text)) <
                                int.parse((ViewPropertyController
                                                .to.viewPropertyresponse['data']
                                            ?['result']?['guest'] ??
                                        '0')
                                    .toString())) {
                              childrens.text =
                                  (int.parse(childrens.text) + 1).toString();
                            }
                          },
                          child: Icon(
                            Icons.add,
                            color: AppColors.colorFE6927,
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide:
                                const BorderSide(width: 1, color: kBlack)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide:
                                const BorderSide(width: 1, color: kBlack)),
                        contentPadding: const EdgeInsets.all(13.0),
                        hintText: 'Children',
                        hintStyle: Palette.hintStyle),
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
                  child: Text(
                    'Infants',
                    style: color00000s15w600,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: infants,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {
                            if ((int.parse(infants.text)) > 0) {
                              infants.text =
                                  (int.parse(infants.text) - 1).toString();
                            }
                          },
                          child: Icon(
                            Icons.remove,
                            color: AppColors.colorFE6927,
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            if ((int.parse(infants.text)) <
                                int.parse((ViewPropertyController
                                                .to.viewPropertyresponse['data']
                                            ?['result']?['guest'] ??
                                        '0')
                                    .toString())) {
                              infants.text =
                                  (int.parse(infants.text) + 1).toString();
                            }
                          },
                          child: Icon(
                            Icons.add,
                            color: AppColors.colorFE6927,
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide:
                                const BorderSide(width: 1, color: kBlack)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide:
                                const BorderSide(width: 1, color: kBlack)),
                        contentPadding: const EdgeInsets.all(13.0),
                        hintText: 'Infants',
                        hintStyle: Palette.hintStyle),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Per Night ',
                  style: color00000s18w600,
                ),
                Text(
                 '₹ '+(ViewPropertyController.to.viewPropertyresponse['data']?['result']?['property_price']?['price']??'').toString(),
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
           /* Column(
              children: List.generate(_checkOut!.difference(_checkIn!).inDays, (i) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(DateTime(_checkIn!.year,_checkIn!.month,(_checkIn!.day)+i)),
                        style: color00000s14w500,
                      ),
                    ),
                    Text(
                      '₹ '+(ViewPropertyController.to.viewPropertyresponse['data']?['result']?['property_price']?['price']??'').toString(),
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
                  '₹ ${int.parse((ViewPropertyController.to.viewPropertyresponse['data']?['result']?['property_price']?['price']??'0').toString())*_checkOut!.difference(_checkIn!).inDays}',
                  style: color00000s14w500,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),*/
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
          /*  Row(
              children: [
                Expanded(
                  child: Text(
                    'GST',
                    style: color00000s15w600,
                  ),
                ),
                Text(
                  '₹ ${((int.parse((ViewPropertyController.to.viewPropertyresponse['data']?['result']?['property_price']?['price']??'0').toString())*_checkOut!.difference(_checkIn!).inDays) * 0.18).round()}',
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
                  '₹ ${((int.parse((ViewPropertyController.to.viewPropertyresponse['data']?['result']?['property_price']?['price']??'0').toString())*_checkOut!.difference(_checkIn!).inDays) + ((int.parse((ViewPropertyController.to.viewPropertyresponse['data']?['result']?['property_price']?['price']??'0').toString())*_checkOut!.difference(_checkIn!).inDays) * 0.18)).round()}',
                  style: color00000s15w600,
                ),
              ],
            ),*/
           /* const SizedBox(
              height: 8,
            ),*/
       /*     Align(
                alignment: Alignment.center,
                child: CommonButton(
                    width: Get.width, onPressed: () {
                      Get.to(()=>BookNowScreen(adults: adults.text,checkIn: _checkInTime.text,checkout: _checkOutTime.text,Children: childrens.text,Infants: infants.text,Propertytype: ViewPropertyController.to.viewPropertyresponse['data']
                      ?['result']?['property_type_name'] ??
                          '',));
                }, name: 'Book Now')),*/
            const SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amenities included',
                  style: color00000s15w600,
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  children: List.generate(
                    ViewPropertyController
                        .to.viewPropertyresponse['data']['amenities'].length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                              imageUrl: ViewPropertyController
                                          .to.viewPropertyresponse['data']
                                      ['amenities'][index]['amenitie_icon'] ??
                                  '-',
                              placeholder: (context, url) =>
                                  CupertinoActivityIndicator(
                                    color: AppColors.colorFE6927,
                                  ),
                              width: 30,
                              height: 30,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            ViewPropertyController
                                        .to.viewPropertyresponse['data']
                                    ['amenities'][index]['title'] ??
                                '',
                            style: color50perBlacks13w400.copyWith(height: 0),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: AppColors.color000000.withOpacity(0.2),
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The Space',
                  style: color00000s15w600,
                ),
                const SizedBox(
                  height: 10,
                ),
                SpaceCommonRow(
                    title: 'Property type',
                    value:
                        ViewPropertyController.to.viewPropertyresponse['data']
                                ?['result']?['property_type_name'] ??
                            ''),
                SpaceCommonRow(
                    title: 'Constructed Area',
                    value:
                        (ViewPropertyController.to.viewPropertyresponse['data']
                                    ?['result']?['constructed_square_feet'] ??
                                '') +
                            ' sqft'),
                SpaceCommonRow(
                    title: 'Accomodates',
                    value:
                        (ViewPropertyController.to.viewPropertyresponse['data']
                                    ?['result']?['accommodates'] ??
                                '')
                            .toString()),
                SpaceCommonRow(
                    title: 'Bedrooms',
                    value:
                        (ViewPropertyController.to.viewPropertyresponse['data']
                                    ?['result']?['bedrooms'] ??
                                '')
                            .toString()),
                SpaceCommonRow(
                    title: 'Bathrooms',
                    value:
                        (ViewPropertyController.to.viewPropertyresponse['data']
                                    ?['result']?['bathrooms'] ??
                                '')
                            .toString()),
              ],
            ),
            Divider(
              color: AppColors.color000000.withOpacity(0.2),
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review',
                  style: color00000s15w600,
                ),
                SizedBox(
                  height: 5,
                ),
                (ViewPropertyController.to.viewPropertyresponse['data']
                                ?['reviews_from_guests'] ==
                            null) ||
                        (ViewPropertyController.to.viewPropertyresponse['data']
                                ?['reviews_from_guests'] ==
                            [])
                    ? SizedBox()
                    : Column(
                        children: List.generate(
                          ViewPropertyController
                              .to
                              .viewPropertyresponse['data']
                                  ?['reviews_from_guests']
                              .length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                          imageUrl: ViewPropertyController.to
                                                          .viewPropertyresponse['data']
                                                      [
                                                      'reviews_from_guests'][index]
                                                  ['users']['profile_src'] ??
                                              '-',
                                          placeholder: (context, url) =>
                                              CupertinoActivityIndicator(
                                                color: AppColors.colorFE6927,
                                              ),
                                          width: 35,
                                          height: 35,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (ViewPropertyController.to.viewPropertyresponse[
                                                                  'data']
                                                              ['reviews_from_guests']
                                                          [index]['users']
                                                      ['first_name'] ??
                                                  '') +
                                              ' ' +
                                              (ViewPropertyController.to
                                                                  .viewPropertyresponse[
                                                              'data']
                                                          ['reviews_from_guests']
                                                      [index]['users']['last_name'] ??
                                                  ''),
                                          style: color00000s14w500,
                                        ),
                                        Text(
                                      ViewPropertyController
                                          .to.viewPropertyresponse[
                                      'data']['reviews_from_guests']
                                      [
                                      index]['updated_at']!= null||ViewPropertyController
                                          .to.viewPropertyresponse[
                                      'data']['reviews_from_guests']
                                      [
                                      index]['updated_at']!= ''?  DateFormat.yMMMEd().format(DateTime.parse(
                                        (ViewPropertyController
                                                        .to.viewPropertyresponse[
                                                    'data']['reviews_from_guests']
                                                [
                                                index]['updated_at'] ??
                                            ''))):'',
                                    style: color00000s14w500,
                                  ),
                                      ],
                                    )
                                  ],
                                ),
                                RatingBar.builder(
                                  initialRating: double.parse((ViewPropertyController.to.viewPropertyresponse[
                                  'data']?
                                  ['reviews_from_guests']?
                                  [index]?['rating']??'0').toString()),
                                  minRating: 1,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  unratedColor: AppColors.colorD9D9D9,
                                  itemPadding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: AppColors.colorFE6927,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  ViewPropertyController.to.viewPropertyresponse[
                                  'data']?
                                  ['reviews_from_guests']?
                                  [index]?['message']??'',
                                  style: color50perBlacks13w400.copyWith(
                                      height: 0),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            Divider(
              color: AppColors.color000000.withOpacity(0.2),
            ),
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

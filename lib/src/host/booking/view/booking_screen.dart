import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/src/host/Main/main_screen.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

import 'receipt_screen.dart';

class BookingScreen extends StatelessWidget {
  BookingScreen({Key? key}) : super(key: key);

  RxInt selectedBookingType = 0.obs;
  List bookingType = ['Ongoing', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        selectedBottom.value = 0;
        return false;
      },
      child: Scaffold(
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
                          'My Bookings',
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
                Obx(() {
                  return Row(
                    children: List.generate(
                      bookingType.length,
                      (index) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: InkWell(
                            onTap: () {
                              selectedBookingType.value = index;
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: selectedBookingType.value == index
                                      ? AppColors.colorFE6927
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: selectedBookingType.value == index
                                          ? Colors.transparent
                                          : AppColors.colorFE6927)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                  child: Text(bookingType[index],
                                      style: selectedBookingType.value == index
                                          ? colorfffffffs13w600
                                          : color00000s13w600)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: MediaQuery.of(context).size.width >
                            MediaQuery.of(context).size.height
                        ? Axis.horizontal
                        : Axis.vertical,
                    child: Obx(() {
                      return selectedBookingType.value == 0
                          ? OnGoingView(context)
                          : selectedBookingType.value == 1
                              ? CompletedView(context)
                              : CancelledView(context);
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget OnGoingView(BuildContext context) {
    return MediaQuery.of(context).size.width >
            MediaQuery.of(context).size.height
        ? Row(
            children: List.generate(
              10,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: Get.height / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.colorFE6927),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  AppImages.villaImg,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 15,
                                right: 15,
                                child: CircleAvatar(
                                  maxRadius: 20,
                                  backgroundColor:
                                      AppColors.color000000.withOpacity(0.5),
                                  child: Icon(
                                    Icons.favorite,
                                    color: AppColors.colorffffff,
                                    size: 25,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.colorFE6927,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 25),
                                  child: Text(
                                    'Paid',
                                    style: colorfffffffs13w600,
                                  ),
                                ),
                              )
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
                              'Gleekey Resort',
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
                                '5.0',
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
                                Text(
                                  'Start From ',
                                  style: color50perBlacks13w400.copyWith(
                                      height: 0),
                                ),
                                Text(
                                  '₹ 5500/night',
                                  style: color00000s14w500,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(AppImages.calendarIcon, height: 19),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                '3 - 10 dec',
                                style: color00000s14w500,
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Container(
                                              height: 3,
                                              width: Get.width / 4.5,
                                              decoration: BoxDecoration(
                                                color: AppColors.color000000
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Cancel Booking',
                                            style: color00000s15w600,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Divider(
                                              color: AppColors.color000000
                                                  .withOpacity(0.2),
                                              endIndent: 30,
                                              indent: 30,
                                            ),
                                          ),
                                          Text(
                                            'Are You Sure Want To Cancel Your Hotel Booking?',
                                            style: color00000s15w600,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry\'s standard dummy text ever ',
                                              style: color50perBlacks13w400,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 17,
                                                        horizontal: 10),
                                                child: CommonButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  width: Get.width / 3,
                                                  color: AppColors.colorEBEBEB,
                                                  style: colorfffffffs13w600
                                                      .copyWith(
                                                          color: AppColors
                                                              .color000000
                                                              .withOpacity(
                                                                  0.7)),
                                                  name: 'Cancel',
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 17,
                                                        horizontal: 10),
                                                child: CommonButton(
                                                  width: Get.width / 3,
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  name: 'Yes, Continue',
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.colorFE6927),
                                    borderRadius: BorderRadius.circular(6)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Text(
                                    'Cancel Booking',
                                    style: colorfffffffs13w600.copyWith(
                                      color: AppColors.color000000,
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
                                Get.to(
                                  () => ReceiptScreen(),
                                );
                              },
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.colorFE6927,
                                    border: Border.all(
                                        color: AppColors.colorFE6927),
                                    borderRadius: BorderRadius.circular(6)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Text(
                                    'View Receipt',
                                    style: colorfffffffs13w600,
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
                      Divider(
                        color: AppColors.color000000.withOpacity(0.2),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Column(
            children: List.generate(
              10,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: Get.height / 4,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.colorFE6927),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                AppImages.villaImg,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 15,
                              child: CircleAvatar(
                                maxRadius: 20,
                                backgroundColor:
                                    AppColors.color000000.withOpacity(0.5),
                                child: Icon(
                                  Icons.favorite,
                                  color: AppColors.colorffffff,
                                  size: 25,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.colorFE6927,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 25),
                                child: Text(
                                  'Paid',
                                  style: colorfffffffs13w600,
                                ),
                              ),
                            )
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
                            'Gleekey Resort',
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
                              '5.0',
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
                              Text(
                                'Start From ',
                                style:
                                    color50perBlacks13w400.copyWith(height: 0),
                              ),
                              Text(
                                '₹ 5500/night',
                                style: color00000s14w500,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset(AppImages.calendarIcon, height: 19),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              '3 - 10 dec',
                              style: color00000s14w500,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Container(
                                            height: 3,
                                            width: Get.width / 4.5,
                                            decoration: BoxDecoration(
                                              color: AppColors.color000000
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Cancel Booking',
                                          style: color00000s15w600,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Divider(
                                            color: AppColors.color000000
                                                .withOpacity(0.2),
                                            endIndent: 30,
                                            indent: 30,
                                          ),
                                        ),
                                        Text(
                                          'Are You Sure Want To Cancel Your Hotel Booking?',
                                          style: color00000s15w600,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry\'s standard dummy text ever ',
                                            style: color50perBlacks13w400,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 17,
                                                      horizontal: 10),
                                              child: CommonButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                width: Get.width / 3,
                                                color: AppColors.colorEBEBEB,
                                                style: colorfffffffs13w600
                                                    .copyWith(
                                                        color: AppColors
                                                            .color000000
                                                            .withOpacity(0.7)),
                                                name: 'Cancel',
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 17,
                                                      horizontal: 10),
                                              child: CommonButton(
                                                width: Get.width / 3,
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                name: 'Yes, Continue',
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.colorFE6927),
                                  borderRadius: BorderRadius.circular(6)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: Text(
                                  'Cancel Booking',
                                  style: colorfffffffs13w600.copyWith(
                                    color: AppColors.color000000,
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
                              Get.to(
                                () => ReceiptScreen(),
                              );
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.colorFE6927,
                                  border:
                                      Border.all(color: AppColors.colorFE6927),
                                  borderRadius: BorderRadius.circular(6)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: Text(
                                  'View Receipt',
                                  style: colorfffffffs13w600,
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
                    Divider(
                      color: AppColors.color000000.withOpacity(0.2),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget CompletedView(BuildContext context) {
    return MediaQuery.of(context).size.width >
            MediaQuery.of(context).size.height
        ? Row(
            children: List.generate(
              10,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: Get.height / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.colorFE6927),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  AppImages.villaImg,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 15,
                                right: 15,
                                child: CircleAvatar(
                                  maxRadius: 20,
                                  backgroundColor:
                                      AppColors.color000000.withOpacity(0.5),
                                  child: Icon(
                                    Icons.favorite,
                                    color: AppColors.colorffffff,
                                    size: 25,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  decoration: BoxDecoration(
                                    color: AppColors.colorFE6927,
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline_outlined,
                                        color: AppColors.colorffffff,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'You Have Completed',
                                        style: colorfffffffs13w600,
                                      ),
                                    ],
                                  ),
                                ),
                              )
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
                              'Gleekey Resort',
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
                                '5.0',
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
                                Text(
                                  'Start From ',
                                  style: color50perBlacks13w400.copyWith(
                                      height: 0),
                                ),
                                Text(
                                  '₹ 5500/night',
                                  style: color00000s14w500,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(AppImages.calendarIcon, height: 19),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                '3 - 10 dec',
                                style: color00000s14w500,
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CommonButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Container(
                                              height: 3,
                                              width: Get.width / 4.5,
                                              decoration: BoxDecoration(
                                                color: AppColors.color000000
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Leave A Review',
                                            style: color00000s15w600,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Divider(
                                              color: AppColors.color000000
                                                  .withOpacity(0.2),
                                              endIndent: 30,
                                              indent: 30,
                                            ),
                                          ),
                                          Text(
                                            'How Your Experience With Lonavala Resort?',
                                            style: color00000s15w600,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          RatingBar.builder(
                                            initialRating: 3,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 30,
                                            unratedColor: AppColors.colorD9D9D9,
                                            glowColor: AppColors.colorFE6927
                                                .withOpacity(0.5),
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: AppColors.colorFE6927,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Divider(
                                              color: AppColors.color000000
                                                  .withOpacity(0.2),
                                              endIndent: 30,
                                              indent: 30,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Write Your Review',
                                                style: color00000s14w500,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                style: color00000s14w500,
                                                maxLines: 5,
                                                cursorColor:
                                                    AppColors.colorFE6927,
                                                decoration: InputDecoration(
                                                  fillColor:
                                                      AppColors.colorD9D9D9,
                                                  filled: true,
                                                  isDense: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    borderSide: BorderSide(
                                                      color: AppColors
                                                          .color000000
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    borderSide: BorderSide(
                                                      color: AppColors
                                                          .color000000
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    borderSide: BorderSide(
                                                      color: AppColors
                                                          .color000000
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 17,
                                                        horizontal: 10),
                                                child: CommonButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  width: Get.width / 3,
                                                  color: AppColors.colorEBEBEB,
                                                  style: colorfffffffs13w600
                                                      .copyWith(
                                                          color: AppColors
                                                              .color000000
                                                              .withOpacity(
                                                                  0.7)),
                                                  name: 'Maybe Later',
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 17,
                                                        horizontal: 10),
                                                child: CommonButton(
                                                  width: Get.width / 3,
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  name: 'Submit',
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              name: 'Leave Review',
                              width: double.maxFinite,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: AppColors.color000000.withOpacity(0.2),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Column(
            children: List.generate(
              10,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: Get.height / 4,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.colorFE6927),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                AppImages.villaImg,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 15,
                              child: CircleAvatar(
                                maxRadius: 20,
                                backgroundColor:
                                    AppColors.color000000.withOpacity(0.5),
                                child: Icon(
                                  Icons.favorite,
                                  color: AppColors.colorffffff,
                                  size: 25,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 54,
                                decoration: BoxDecoration(
                                  color: AppColors.colorFE6927,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline_outlined,
                                      color: AppColors.colorffffff,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'You Have Completed',
                                      style: colorfffffffs13w600,
                                    ),
                                  ],
                                ),
                              ),
                            )
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
                            'Gleekey Resort',
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
                              '5.0',
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
                              Text(
                                'Start From ',
                                style:
                                    color50perBlacks13w400.copyWith(height: 0),
                              ),
                              Text(
                                '₹ 5500/night',
                                style: color00000s14w500,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset(AppImages.calendarIcon, height: 19),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              '3 - 10 dec',
                              style: color00000s14w500,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CommonButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Container(
                                            height: 3,
                                            width: Get.width / 4.5,
                                            decoration: BoxDecoration(
                                              color: AppColors.color000000
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Leave A Review',
                                          style: color00000s15w600,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Divider(
                                            color: AppColors.color000000
                                                .withOpacity(0.2),
                                            endIndent: 30,
                                            indent: 30,
                                          ),
                                        ),
                                        Text(
                                          'How Your Experience With Lonavala Resort?',
                                          style: color00000s15w600,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        RatingBar.builder(
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 30,
                                          unratedColor: AppColors.colorD9D9D9,
                                          glowColor: AppColors.colorFE6927
                                              .withOpacity(0.5),
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: AppColors.colorFE6927,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Divider(
                                            color: AppColors.color000000
                                                .withOpacity(0.2),
                                            endIndent: 30,
                                            indent: 30,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Write Your Review',
                                              style: color00000s14w500,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextFormField(
                                              style: color00000s14w500,
                                              maxLines: 5,
                                              cursorColor:
                                                  AppColors.colorFE6927,
                                              decoration: InputDecoration(
                                                fillColor:
                                                    AppColors.colorD9D9D9,
                                                filled: true,
                                                isDense: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    color: AppColors.color000000
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    color: AppColors.color000000
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    color: AppColors.color000000
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 17,
                                                      horizontal: 10),
                                              child: CommonButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                width: Get.width / 3,
                                                color: AppColors.colorEBEBEB,
                                                style: colorfffffffs13w600
                                                    .copyWith(
                                                        color: AppColors
                                                            .color000000
                                                            .withOpacity(0.7)),
                                                name: 'Maybe Later',
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 17,
                                                      horizontal: 10),
                                              child: CommonButton(
                                                width: Get.width / 3,
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                name: 'Submit',
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            name: 'Leave Review',
                            width: double.maxFinite,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: AppColors.color000000.withOpacity(0.2),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget CancelledView(BuildContext context) {
    return MediaQuery.of(context).size.width >
            MediaQuery.of(context).size.height
        ? Row(
            children: List.generate(
              10,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: Get.height / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.colorFE6927),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  AppImages.villaImg,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 15,
                                right: 15,
                                child: CircleAvatar(
                                  maxRadius: 20,
                                  backgroundColor:
                                      AppColors.color000000.withOpacity(0.5),
                                  child: Icon(
                                    Icons.favorite,
                                    color: AppColors.colorffffff,
                                    size: 25,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  decoration: BoxDecoration(
                                    color: AppColors.colorFE6927,
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Cancelled And Refunded',
                                        style: colorfffffffs13w600,
                                      ),
                                    ],
                                  ),
                                ),
                              )
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
                              'Gleekey Resort',
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
                                '5.0',
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
                                Text(
                                  'Start From ',
                                  style: color50perBlacks13w400.copyWith(
                                      height: 0),
                                ),
                                Text(
                                  '₹ 5500/night',
                                  style: color00000s14w500,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(AppImages.calendarIcon, height: 19),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                '3 - 10 dec',
                                style: color00000s14w500,
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: AppColors.color000000.withOpacity(0.2),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Column(
            children: List.generate(
              10,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: Get.height / 4,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.colorFE6927),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                AppImages.villaImg,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 15,
                              child: CircleAvatar(
                                maxRadius: 20,
                                backgroundColor:
                                    AppColors.color000000.withOpacity(0.5),
                                child: Icon(
                                  Icons.favorite,
                                  color: AppColors.colorffffff,
                                  size: 25,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 54,
                                decoration: BoxDecoration(
                                  color: AppColors.colorFE6927,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Cancelled And Refunded',
                                      style: colorfffffffs13w600,
                                    ),
                                  ],
                                ),
                              ),
                            )
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
                            'Gleekey Resort',
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
                              '5.0',
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
                              Text(
                                'Start From ',
                                style:
                                    color50perBlacks13w400.copyWith(height: 0),
                              ),
                              Text(
                                '₹ 5500/night',
                                style: color00000s14w500,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset(AppImages.calendarIcon, height: 19),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              '3 - 10 dec',
                              style: color00000s14w500,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: AppColors.color000000.withOpacity(0.2),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

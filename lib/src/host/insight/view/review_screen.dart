import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

class ReviewScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const ReviewScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        data['property_name'],
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  endIndent: 10,
                  indent: 10,
                  color: AppColors.color000000.withOpacity(0.1),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Overall Experience',
                                    style: color00000s15w600),
                                RatingBar.builder(
                                  initialRating: double.parse(
                                      (data['rating'] ?? '0').toString()),
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
                              ],
                            ),
                            Text(
                              data['message'] ?? '',
                              style: color50perBlacks13w400,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Check In', style: color00000s15w600),
                                RatingBar.builder(
                                  initialRating: double.parse(
                                      (data['checkin'] ?? 0).toString()),
                                  minRating: 1,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  unratedColor: AppColors.colorD9D9D9,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: AppColors.colorFE6927,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ],
                            ),
                            Text(
                              data['checkin_message'] ?? '',
                              style: color50perBlacks13w400,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Communication', style: color00000s15w600),
                                RatingBar.builder(
                                  initialRating: double.parse(
                                      (data['communication'] ?? 0).toString()),
                                  minRating: 1,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  unratedColor: AppColors.colorD9D9D9,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: AppColors.colorFE6927,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ],
                            ),
                            Text(
                              data['communication_message'] ?? '',
                              style: color50perBlacks13w400,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                      'How accurately did the photos &amp; description represent the actual space?',
                                      style: color00000s15w600),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                RatingBar.builder(
                                  initialRating: double.parse(
                                      (data['accuracy'] ?? 0).toString()),
                                  minRating: 1,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  unratedColor: AppColors.colorD9D9D9,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: AppColors.colorFE6927,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ],
                            ),
                            Text(
                              data['accuracy_message'] ?? '',
                              style: color50perBlacks13w400,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                      'Did your host provide everything they promised in their listing description?',
                                      style: color00000s15w600),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                RatingBar.builder(
                                  initialRating: double.parse(
                                      (data['value'] ?? 0).toString()),
                                  minRating: 1,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  unratedColor: AppColors.colorD9D9D9,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: AppColors.colorFE6927,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ],
                            ),
                            Text(
                              data['value_message'] ?? '',
                              style: color50perBlacks13w400,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text('Cleanliness feedback',
                                      style: color00000s15w600),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                RatingBar.builder(
                                  initialRating: double.parse(
                                      (data['cleanliness'] ?? 0).toString()),
                                  minRating: 1,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  unratedColor: AppColors.colorD9D9D9,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: AppColors.colorFE6927,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ],
                            ),
                            Text(
                              data['cleanliness_message'] ?? '',
                              style: color50perBlacks13w400,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                      'How would you rate the value of the listing?',
                                      style: color00000s15w600),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                RatingBar.builder(
                                  initialRating: double.parse(
                                      (data['value'] ?? 0).toString()),
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
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text('Private Guest Feedback',
                                      style: color00000s15w600),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            Text(
                              data['secret_feedback'] ?? '',
                              style: color50perBlacks13w400,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text('How can your host improve?',
                                      style: color00000s15w600),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            Text(
                              data['improve_message'] ?? '',
                              style: color50perBlacks13w400,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                    ],
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/src/host/calendar/controller/manage_calendar_controller.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:intl/intl.dart';

class PricingCalenderScreen extends StatelessWidget {
  final String property_id;
  final String selectedDays;
  final DateTime startDate;
  final DateTime endDate;
  PricingCalenderScreen({
    Key? key,
    required this.selectedDays,
    required this.startDate,
    required this.endDate,
    required this.property_id,
  }) : super(key: key);

  TextEditingController price = TextEditingController(text: '0');
  TextEditingController minStay = TextEditingController(text: '0');

  RxBool isAvailable = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorFE6927,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        centerTitle: true,
        title: Text('$selectedDays Dates Selected'),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.colorffffff)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 8),
              child: Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        return Text(
                          isAvailable.value ? 'Available' : 'Unavailable',
                          style: color00000s15w600,
                        );
                      }),
                    ),
                    InkWell(
                      onTap: () {
                        isAvailable.value = false;
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              !isAvailable.value ? AppColors.colorFE6927 : null,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: !isAvailable.value
                                ? AppColors.colorFE6927
                                : AppColors.color000000.withOpacity(0.5),
                          ),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          Icons.close,
                          color: !isAvailable.value
                              ? AppColors.colorffffff
                              : AppColors.color000000.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        isAvailable.value = true;
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isAvailable.value ? AppColors.colorFE6927 : null,
                          border: Border.all(
                            color: isAvailable.value
                                ? AppColors.colorFE6927
                                : AppColors.color000000.withOpacity(0.5),
                          ),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          Icons.done,
                          color: isAvailable.value
                              ? AppColors.colorffffff
                              : AppColors.color000000.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            Divider(
              color: AppColors.color000000.withOpacity(0.2),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date Range : ',
                        style: color00000s15w600,
                      ),
                      Flexible(
                        child: Text(
                          '${DateFormat('dd-MM-yyyy').format(startDate)} To ${DateFormat('dd-MM-yyyy').format(endDate)}',
                          style: color00000s15w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Pricing',
                    style: color00000s15w600,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    style: color00000s14w500,
                    cursorColor: AppColors.colorFE6927,
                    controller: price,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Enter Your Price Here..',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: AppColors.color000000.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: AppColors.color000000.withOpacity(0.5),
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: AppColors.color000000.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Minimum Stay',
                    style: color00000s15w600,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    style: color00000s14w500,
                    cursorColor: AppColors.colorFE6927,
                    controller: minStay,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Minimum Stay',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: AppColors.color000000.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: AppColors.color000000.withOpacity(0.5),
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: AppColors.color000000.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Divider(
              color: AppColors.color000000.withOpacity(0.2),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  child: CommonButton(
                    onPressed: () {
                      Get.back();
                    },
                    color: AppColors.colorEBEBEB,
                    style: colorfffffffs13w600.copyWith(
                        color: AppColors.color000000.withOpacity(0.7)),
                    name: 'Close',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  child: CommonButton(
                    onPressed: () {
                      if (price.text.isNotEmpty && int.parse(price.text) > 0) {
                        loaderShow(context);

                        ManageCalendarContoller.to.set_price_dateApi(
                            params: {
                              'property_id': property_id,
                              'start_date':
                                  DateFormat('yyyy-MM-dd').format(startDate),
                              'end_date':
                                  DateFormat('yyyy-MM-dd').format(endDate),
                              'price': price.text,
                              'min_stay': minStay.text,
                              'status': isAvailable.value
                                  ? 'Available'
                                  : 'Not Available',
                            },
                            error: (e) {
                              loaderHide();
                            },
                            success: () {
                              loaderHide();
                            });
                      } else {
                        showSnackBar(
                            title: ApiConfig.error,
                            message: 'Price Should not be 0');
                      }
                    },
                    name: 'Submit',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

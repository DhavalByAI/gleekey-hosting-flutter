import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

class AddAPayoutMethodScreen extends StatelessWidget {
  AddAPayoutMethodScreen({Key? key}) : super(key: key);

  RxString countryName = 'India'.obs;
  RxString radioGrpValue = ''.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonButton(
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: Get.width / 1.5,
                onPressed: () {},
                name: 'Setup Payouts'),
          ],
        ),
      ),
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
                        'Add A Payout Method',
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
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                    style: color00000s14w500,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Country',
                    style: color00000s15w600,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(
                    () {
                      return InkWell(
                        onTap: () {
                          showCountryPicker(
                              context: context,
                              countryListTheme: CountryListThemeData(
                                flagSize: 25,
                                backgroundColor: Colors.white,
                                textStyle: const TextStyle(
                                    fontSize: 16, color: Colors.blueGrey),
                                bottomSheetHeight: Get.height /
                                    1.5, // Optional. Country list modal height
                                //Optional. Sets the border radius for the bottomsheet.
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                //Optional. Styles the search field.

                                inputDecoration: InputDecoration(
                                    // labelText: 'Search',
                                    hintText: 'Start typing to search',
                                    prefixIcon: const Icon(Icons.search),
                                    focusColor: AppColors.colorFE6927,
                                    iconColor: AppColors.colorFE6927,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.color000000
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.color000000
                                            .withOpacity(0.5),
                                      ),
                                    )),
                              ),
                              onSelect: (Country country) =>
                                  countryName.value = country.name);
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.color000000.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Country',
                                      style: color50perBlacks13w400,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      countryName.value,
                                      style: color00000s15w600,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'How You Get Paid',
                    style: color00000s15w600,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Payout Sent Be Sent In INR',
                    style: color50perBlacks13w400,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () {
                      return Row(
                        children: [
                          Image.asset(AppImages.bankIcon,
                              height: 24, width: 24),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Text(
                              'Bank Transfer',
                              style: color00000s14w500,
                            ),
                          ),
                          Radio(
                            activeColor: AppColors.colorFE6927,
                            value: 'BANK',
                            groupValue: radioGrpValue.value,
                            onChanged: (val) {
                              radioGrpValue.value = val.toString();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

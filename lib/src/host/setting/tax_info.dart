import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

import 'add_a_payout_method.dart';

class TaxInfoScreen extends StatelessWidget {
  const TaxInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 17),
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
                        'Tax Info',
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
                height: 25,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Taxpayer Information',
                        style: color00000s18w600,
                      ),
                      Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        style: color50perBlacks13w400,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CommonButton(onPressed: () {}, name: 'Add Tax Info'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          color: AppColors.color000000.withOpacity(0.2),
                        ),
                      ),
                      Text(
                        'VAT',
                        style: color00000s18w600,
                      ),
                      Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        style: color50perBlacks13w400,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CommonButton(
                        onPressed: () {
                          Get.to(() => AddAPayoutMethodScreen());
                        },
                        name: 'Add VAT ID Number',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          color: AppColors.color000000.withOpacity(0.2),
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

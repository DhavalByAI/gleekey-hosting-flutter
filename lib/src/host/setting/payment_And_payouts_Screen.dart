import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/src/host/setting/tax_info.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'how_you_get_paid.dart';
import 'transaction_history.dart';

class PaymentAndPayoutScreen extends StatelessWidget {
  PaymentAndPayoutScreen({Key? key}) : super(key: key);

  List paymentOpetion = [
    {
      'img': AppImages.payoutMethodIcon,
      'name': 'Payout Methods',
      'screen': const HowToGetPaid()
    },
    {
      'img': AppImages.transactionHistoryIcon,
      'name': 'Transection History',
      'screen': TransactionHistoryScreen()
    },
    {
      'img': AppImages.taxInfoIcon,
      'name': 'Tax Info',
      'screen': const TaxInfoScreen()
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        'Payments & Payouts',
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: List.generate(
                          paymentOpetion.length,
                          (index) => InkWell(
                            onTap: () {
                              Get.to(paymentOpetion[index]['screen'] as Widget);
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        paymentOpetion[index]['img'],
                                        height: 25,
                                        color: AppColors.color000000,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.04,
                                      ),
                                      Expanded(
                                        child: Text(
                                          paymentOpetion[index]['name'],
                                          style: color00000s13w600,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.02,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  endIndent: 10,
                                  indent: 10,
                                  color: AppColors.color000000.withOpacity(0.1),
                                ),
                              ],
                            ),
                          ),
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

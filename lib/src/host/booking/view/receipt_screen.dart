import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

class ReceiptScreen extends StatelessWidget {
  ReceiptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: CommonButton(
            onPressed: () {},
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.file_download,
                  color: AppColors.colorffffff,
                ),
                Text(
                  'Download Receipt',
                  style: colorfffffffs13w600,
                )
              ],
            )),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 17, left: 20, right: 20),
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
                        'View Receipt',
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
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.colorffffff,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                  spreadRadius: 3,
                                  blurRadius: 3),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Column(
                            children: [
                              CommonRow(
                                title: 'Date',
                                subtext: '27/10/2022 to 2/11/2022',
                              ),
                              CommonRow(
                                title: 'Check In',
                                subtext: '27/10/2022 ',
                              ),
                              CommonRow(
                                title: 'Check Out',
                                subtext: '31/10/2022 ',
                              ),
                              CommonRow(
                                title: 'Guests',
                                subtext: '2 adults ,2 children',
                              ),
                              CommonRow(
                                title: 'Rooms',
                                subtext: '1 Room',
                                divider: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.colorffffff,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                  spreadRadius: 3,
                                  blurRadius: 3),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Column(
                            children: [
                              CommonRow(
                                title: 'Amount',
                                subtext: '₹ 25000',
                              ),
                              CommonRow(
                                title: 'Goods & Services Tax',
                                subtext: '₹ 5000',
                              ),
                              CommonRow(
                                title: 'Total',
                                subtext: '₹ 30000',
                                divider: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.colorffffff,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                  spreadRadius: 3,
                                  blurRadius: 3),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Column(
                            children: [
                              CommonRow(
                                title: 'Name',
                                subtext: 'jayesh chudasama',
                              ),
                              CommonRow(
                                title: 'Phone Number',
                                subtext: '+911234567890',
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Booking ID',
                                          style: color50perBlacks13w400
                                              .copyWith(height: 0),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '12ADC78512367',
                                                  style: color00000s13w600,
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              InkWell(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () async {
                                                  await Clipboard.setData(
                                                          ClipboardData(
                                                              text:
                                                                  "12ADC78512367"))
                                                      .then((value) => showSnackBar(
                                                          title:
                                                              ApiConfig.success,
                                                          message:
                                                              'Copied Successfully!'));
                                                },
                                                child: Icon(
                                                  Icons.copy,
                                                  size: 18,
                                                  color: AppColors.color000000,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      color: AppColors.color000000
                                          .withOpacity(0.2),
                                      endIndent: 5,
                                      indent: 5,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Transaction ID',
                                          style: color50perBlacks13w400
                                              .copyWith(height: 0),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '12ADC78512367',
                                                  style: color00000s13w600,
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              InkWell(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () async {
                                                  await Clipboard.setData(
                                                          ClipboardData(
                                                              text:
                                                                  "12ADC78512367"))
                                                      .then((value) => showSnackBar(
                                                          title:
                                                              ApiConfig.success,
                                                          message:
                                                              'Copied Successfully!'));
                                                },
                                                child: Icon(
                                                  Icons.copy,
                                                  size: 18,
                                                  color: AppColors.color000000,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      color: AppColors.color000000
                                          .withOpacity(0.2),
                                      endIndent: 5,
                                      indent: 5,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Status',
                                          style: color50perBlacks13w400
                                              .copyWith(height: 0),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Paid',
                                                  style: color00000s13w600,
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              InkWell(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () async {},
                                                child: Icon(
                                                  Icons.check_circle,
                                                  size: 18,
                                                  color: AppColors.colorFE6927,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding CommonRow(
      {required String title, required String subtext, bool divider = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: color50perBlacks13w400.copyWith(height: 0),
              ),
              Expanded(
                child: Text(
                  subtext,
                  style: color00000s13w600,
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          divider
              ? Divider(
                  color: AppColors.color000000.withOpacity(0.2),
                  endIndent: 5,
                  indent: 5,
                )
              : SizedBox()
        ],
      ),
    );
  }
}

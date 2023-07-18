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

class AllPhotosScreen extends StatefulWidget {
  AllPhotosScreen({Key? key}) : super(key: key);

  @override
  State<AllPhotosScreen> createState() => _AllPhotosScreenState();
}

class _AllPhotosScreenState extends State<AllPhotosScreen> {
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (MediaQuery.of(context).size.width >
                          MediaQuery.of(context).size.height)
                      ? 6
                      : 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15),
              itemCount: ViewPropertyController
                  .to.viewPropertyresponse['data']?['property_photos'].length,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.colorFE6927),
                  child: CachedNetworkImage(
                      imageUrl:
                          ViewPropertyController.to.viewPropertyresponse['data']
                                  ?['property_photos']?[index]?['image'] ??
                              '',
                      placeholder: (context, url) => CupertinoActivityIndicator(
                            color: AppColors.colorFE6927,
                          ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

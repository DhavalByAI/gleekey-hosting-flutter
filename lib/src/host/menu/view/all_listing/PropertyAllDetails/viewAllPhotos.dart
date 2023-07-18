import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

import 'propertyAllDetails_controller.dart';

class ViewAllPhotos extends StatelessWidget {
  const ViewAllPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    PropertyAllDetailsController _ = Get.find();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWithTitleAndBack(title: "Property Photos"),
      body: SingleChildScrollView(
        child: StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children:
                List.generate(_.PropertyData!.propertyPhotos!.length, ((index) {
              return Bounce(
                onPressed: () {
                  MultiImageProvider multiImageProvider = MultiImageProvider(
                      List.generate(_.PropertyData!.propertyPhotos!.length,
                          ((index) {
                        return Image(
                            image: CachedNetworkImageProvider(
                          _.PropertyData!.propertyPhotos![index].image,
                        )).image;
                      })),
                      initialIndex: index);
                  showImageViewerPager(context, multiImageProvider,
                      swipeDismissible: true,
                      doubleTapZoomable: true,
                      useSafeArea: true);
                },
                duration: const Duration(milliseconds: 200),
                child: cNetworkImage(
                  _.PropertyData!.propertyPhotos![index].image,
                  fit: BoxFit.cover,
                ),
              );
            }))),
      ),
    );
  }

  AppBar AppBarWithTitleAndBack(
      {required String title, bool backButton = true}) {
    return AppBar(
      elevation: 0,
      leading: backButton
          ? Bounce(
              duration: const Duration(milliseconds: 150),
              onPressed: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            )
          : null,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'HankenGrotesk',
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  CachedNetworkImage cNetworkImage(String? link,
      {double? height, double? width, BoxFit? fit, Alignment? alignment}) {
    return CachedNetworkImage(
      height: height,
      width: width,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      imageUrl: link ?? "",
      placeholder: (context, url) => const CupertinoActivityIndicator(
        color: Color(0xFFFE6927),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

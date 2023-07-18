import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

class HostingDetailScreen extends StatelessWidget {
  final String title;
  HostingDetailScreen({Key? key, required this.title}) : super(key: key);

  RxInt selectedType = 0.obs;
  List type = ['Listing', 'Booking Settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 17, left: 20, right: 20),
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
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  title,
                  style: color00000s18w600,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Obx(() {
                return Row(
                  children: List.generate(
                    type.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          selectedType.value = index;
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Column(
                          children: [
                            Text(
                              type[index],
                              style: selectedType.value == index
                                  ? color00000s13w600
                                  : color00000s13w600.copyWith(
                                      color: AppColors.color000000
                                          .withOpacity(0.4)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 2,
                              width: Get.width / 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: selectedType.value == index
                                    ? AppColors.colorFE6927
                                    : Colors.transparent,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Obx(
                      () {
                        return selectedType.value == 0
                            ? ListingView()
                            : BookingSettingView();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column ListingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Listing Details',
              style: color00000s15w600,
            ),
            CommonButton(onPressed: () {}, name: 'Preview')
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Photos ( 5 photos )',
          style: color00000s13w600,
        ),
        const SizedBox(
          height: 10,
        ),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 12 / 9,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 4,
          itemBuilder: (BuildContext context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(AppImages.villaImg, fit: BoxFit.cover),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
        ),
        CommonDetailView(title: 'Listing Title', subtext: 'Booking Settigns'),
        CommonDetailView(
            title: 'Discription',
            subtext:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
        CommonDetailView(
            title: 'Room & Spaces', subtext: '2 bedroom , 2 bed , 3 bathroom '),
        CommonDetailView(
            title: 'Property & Guests',
            subtext: 'shared room,bungalow,1 guest'),
        CommonDetailView(
            title: 'Accessibility', subtext: 'shared room,bungalow,1 guest'),
        CommonDetailView(title: 'Amenities', subtext: 'Lorem Ipsum'),
        CommonDetailView(title: 'Location', subtext: 'Lorem Ipsum'),
        Text(
          'Custom Link',
          style: color00000s15w600,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'Lorem Ipsum is simply dummy text of the printin',
          style: color50perBlacks13w400,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
        ),
        Text(
          'Info For Guests',
          style: color00000s15w600,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Wifi',
          style: color50perBlacks13w400,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
        ),
        Text(
          'Check In Instructions',
          style: color50perBlacks13w400,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
        ),
        Text(
          'House Manual',
          style: color50perBlacks13w400,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
        ),
        Text(
          'Directions',
          style: color50perBlacks13w400,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Column BookingSettingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pricing',
          style: color00000s15w600,
        ),
        Text(
          'simply dummy text',
          style: color50perBlacks13w400,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                AppImages.villaImg,
                height: 90,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹ 5500/night',
                    style: color00000s15w600,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '1 Night 1 guest',
                    style: color00000s13w600,
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
        ),
        CommonNextStepView(
          name: 'Nightly Price',
          onTap: () {
            print('tap');
          },
        ),
        CommonNextStepView(
          name: 'Additional Charges',
          onTap: () {
            print('tap');
          },
        ),
        CommonNextStepView(
          name: 'Length Of Stay Prices',
          onTap: () {
            print('tap');
          },
        ),
        CommonNextStepView(
          name: 'Currency',
          onTap: () {
            print('tap');
          },
        ),
        Text(
          'Booking',
          style: color00000s15w600,
        )
      ],
    );
  }

  Column CommonNextStepView({
    required String name,
    GestureTapCallback? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: color00000s14w500,
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Column CommonDetailView({required String title, required String subtext}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: color00000s13w600,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          subtext,
          style: color50perBlacks13w400,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}

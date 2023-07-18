import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

class HelpDetailScreen extends StatelessWidget {
  const HelpDetailScreen({Key? key}) : super(key: key);

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
                  Expanded(
                    child: Center(
                      child: Text(
                        'Help',
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
                height: 15,
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: HelpView(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column HelpView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edit Your Account Settings',
          style: color00000s18w600,
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Text(
              'How Its Works',
              style: color50perBlacks13w400.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Container(
              height: 3,
              width: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.colorFE6927),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        CommonWorksDetail(
          name:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
        ),
        CommonWorksDetail(
          name:
              'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,',
        ),
        CommonWorksDetail(
          name:
              'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.',
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Was this information helpful?',
          style: color00000s14w500.copyWith(
            height: 0,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              AppImages.like_outline_Icon,
              height: 40,
            ),
            const SizedBox(
              width: 15,
            ),
            Image.asset(
              AppImages.unlike_Icon,
              height: 30,
            )
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Image.asset(
          AppImages.like_filled_Icon,
          height: 35,
        ),
      ],
    );
  }

  Widget CommonWorksDetail({
    required String name,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: AppColors.colorFE6927,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              name,
              style: color00000s14w500.copyWith(
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

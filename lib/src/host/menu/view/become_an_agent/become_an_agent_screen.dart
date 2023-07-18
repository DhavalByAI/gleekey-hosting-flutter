import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

import 'become_host_screen.dart';

class BecomeAnAgentScreen extends StatelessWidget {
  const BecomeAnAgentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 17, left: 18, right: 18),
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
                        'Become An Agent On Gleekey',
                        style: color00000s18w600,
                        textAlign: TextAlign.center,
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
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AgentView(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column AgentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            AppImages.becomeAgentImg,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          'Lorem Ipsum',
          style: color00000s18w600,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
          style: color50perBlacks13w400,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Lorem Ipsum',
          style: color00000s18w600,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
          style: color50perBlacks13w400,
        ),
        const SizedBox(
          height: 25,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            'Benefits Of Becoming Agents On Gleekey',
            style: color00000s18w600,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Table(
          border: TableBorder.all(
              color: AppColors.color000000.withOpacity(0.2), width: 1),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Center(child: Text('', style: color00000s15w600)),
                Center(child: Text('GleeKey', style: color00000s15w600)),
                Center(child: Text('Competitors', style: color00000s15w600)),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guest identity verification',
                        style: color00000s13w600,
                      ),
                      Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        style: color50perBlacks13w400,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      AppImages.trueIcon,
                      height: 25,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      AppImages.falseIcon,
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lorem Ipsum',
                        style: color00000s13w600,
                      ),
                      Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        style: color50perBlacks13w400,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      AppImages.trueIcon,
                      height: 25,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      AppImages.falseIcon,
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lorem Ipsum',
                        style: color00000s13w600,
                      ),
                      Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        style: color50perBlacks13w400,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      AppImages.trueIcon,
                      height: 25,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      AppImages.falseIcon,
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.center,
          child: CommonButton(
            onPressed: () {
              Get.back();
              Get.to(() => const BecomeHostScreen());
            },
            name: 'Become Host',
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

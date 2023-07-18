import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

class NotificationSettingScreen extends StatelessWidget {
  NotificationSettingScreen({Key? key}) : super(key: key);

  RxInt selectedTransactionType = 0.obs;
  List trancationType = ['Offer & Updates', 'Account'];

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
                        'Notification Setting',
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
              Obx(() {
                return Row(
                  children: List.generate(
                    trancationType.length,
                    (index) => Expanded(
                      child: InkWell(
                        onTap: () {
                          selectedTransactionType.value = index;
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Column(
                          children: [
                            Text(
                              trancationType[index],
                              style: selectedTransactionType.value == index
                                  ? color00000s15w600
                                  : color00000s15w600.copyWith(
                                      color: AppColors.color000000
                                          .withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                    ),
                            ),
                            Divider(
                              color: selectedTransactionType.value == index
                                  ? AppColors.colorFE6927
                                  : AppColors.colorE6E6E6,
                              thickness: 2,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() {
                        return Text(
                          selectedTransactionType.value == 0
                              ? 'Hosting Insights And Rewards'
                              : 'Account Activity And Policies',
                          style: color00000s15w600,
                        );
                      }),
                      Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        style: color50perBlacks13w400,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Hosting Insights And Rewards',
                                style: color00000s15w600,
                              ),
                            ),
                            Text(
                              'on :SMS',
                              style: color50perBlacks13w400.copyWith(height: 0),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                RxBool email = false.obs;
                                RxBool sms = false.obs;
                                RxBool phoneCalls = false.obs;
                                RxBool browserNotification = false.obs;
                                showModalBottomSheet<void>(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Obx(() {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              height: 3,
                                              width: Get.width / 4.5,
                                              decoration: BoxDecoration(
                                                color: AppColors.color000000
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Email',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: email.value,
                                                    onChanged: (val) {
                                                      email.value =
                                                          !email.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'SMS',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: sms.value,
                                                    onChanged: (val) {
                                                      sms.value = !sms.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Phone Calls',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: phoneCalls.value,
                                                    onChanged: (val) {
                                                      phoneCalls.value =
                                                          !phoneCalls.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Browser Notifications',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: browserNotification
                                                        .value,
                                                    onChanged: (val) {
                                                      browserNotification
                                                              .value =
                                                          !browserNotification
                                                              .value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.color000000),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                child: const Text('Edit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Insights And Tips',
                                style: color00000s15w600,
                              ),
                            ),
                            Text(
                              'on :SMS',
                              style: color50perBlacks13w400.copyWith(height: 0),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                RxBool email = false.obs;
                                RxBool sms = false.obs;
                                RxBool phoneCalls = false.obs;
                                RxBool browserNotification = false.obs;
                                showModalBottomSheet<void>(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Obx(() {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              height: 3,
                                              width: Get.width / 4.5,
                                              decoration: BoxDecoration(
                                                color: AppColors.color000000
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Email',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: email.value,
                                                    onChanged: (val) {
                                                      email.value =
                                                          !email.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'SMS',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: sms.value,
                                                    onChanged: (val) {
                                                      sms.value = !sms.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Phone Calls',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: phoneCalls.value,
                                                    onChanged: (val) {
                                                      phoneCalls.value =
                                                          !phoneCalls.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Browser Notifications',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: browserNotification
                                                        .value,
                                                    onChanged: (val) {
                                                      browserNotification
                                                              .value =
                                                          !browserNotification
                                                              .value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.color000000),
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                child: const Text('Edit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Pricing Trends And Suggestions',
                                style: color00000s15w600,
                              ),
                            ),
                            Text(
                              'on :SMS',
                              style: color50perBlacks13w400.copyWith(height: 0),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                RxBool email = false.obs;
                                RxBool sms = false.obs;
                                RxBool phoneCalls = false.obs;
                                RxBool browserNotification = false.obs;
                                showModalBottomSheet<void>(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Obx(() {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              height: 3,
                                              width: Get.width / 4.5,
                                              decoration: BoxDecoration(
                                                color: AppColors.color000000
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Email',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: email.value,
                                                    onChanged: (val) {
                                                      email.value =
                                                          !email.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'SMS',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: sms.value,
                                                    onChanged: (val) {
                                                      sms.value = !sms.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Phone Calls',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: phoneCalls.value,
                                                    onChanged: (val) {
                                                      phoneCalls.value =
                                                          !phoneCalls.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Browser Notifications',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: browserNotification
                                                        .value,
                                                    onChanged: (val) {
                                                      browserNotification
                                                              .value =
                                                          !browserNotification
                                                              .value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.color000000),
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                child: const Text('Edit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Hosting Perks',
                                style: color00000s15w600,
                              ),
                            ),
                            Text(
                              'on :SMS',
                              style: color50perBlacks13w400.copyWith(height: 0),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                RxBool email = false.obs;
                                RxBool sms = false.obs;
                                RxBool phoneCalls = false.obs;
                                RxBool browserNotification = false.obs;
                                showModalBottomSheet<void>(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Obx(() {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              height: 3,
                                              width: Get.width / 4.5,
                                              decoration: BoxDecoration(
                                                color: AppColors.color000000
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Email',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: email.value,
                                                    onChanged: (val) {
                                                      email.value =
                                                          !email.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'SMS',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: sms.value,
                                                    onChanged: (val) {
                                                      sms.value = !sms.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Phone Calls',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: phoneCalls.value,
                                                    onChanged: (val) {
                                                      phoneCalls.value =
                                                          !phoneCalls.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Browser Notifications',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: browserNotification
                                                        .value,
                                                    onChanged: (val) {
                                                      browserNotification
                                                              .value =
                                                          !browserNotification
                                                              .value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.color000000),
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                child: const Text('Edit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: AppColors.color000000.withOpacity(0.2),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Hosting Updates',
                        style: color00000s15w600,
                      ),
                      Text(
                        'Loren Ipsum is simply dummy text of the printing and typesetting industry.',
                        style: color50perBlacks13w400,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'News And Updates',
                                style: color00000s15w600,
                              ),
                            ),
                            Text(
                              'on :SMS',
                              style: color50perBlacks13w400.copyWith(height: 0),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                RxBool email = false.obs;
                                RxBool sms = false.obs;
                                RxBool phoneCalls = false.obs;
                                RxBool browserNotification = false.obs;
                                showModalBottomSheet<void>(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Obx(() {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              height: 3,
                                              width: Get.width / 4.5,
                                              decoration: BoxDecoration(
                                                color: AppColors.color000000
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Email',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: email.value,
                                                    onChanged: (val) {
                                                      email.value =
                                                          !email.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'SMS',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: sms.value,
                                                    onChanged: (val) {
                                                      sms.value = !sms.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Phone Calls',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: phoneCalls.value,
                                                    onChanged: (val) {
                                                      phoneCalls.value =
                                                          !phoneCalls.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Browser Notifications',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: browserNotification
                                                        .value,
                                                    onChanged: (val) {
                                                      browserNotification
                                                              .value =
                                                          !browserNotification
                                                              .value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.color000000),
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                child: const Text('Edit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Hosting Perks',
                                style: color00000s15w600,
                              ),
                            ),
                            Text(
                              'on :SMS',
                              style: color50perBlacks13w400.copyWith(height: 0),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                RxBool email = false.obs;
                                RxBool sms = false.obs;
                                RxBool phoneCalls = false.obs;
                                RxBool browserNotification = false.obs;
                                showModalBottomSheet<void>(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Obx(() {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              height: 3,
                                              width: Get.width / 4.5,
                                              decoration: BoxDecoration(
                                                color: AppColors.color000000
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Email',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: email.value,
                                                    onChanged: (val) {
                                                      email.value =
                                                          !email.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'SMS',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: sms.value,
                                                    onChanged: (val) {
                                                      sms.value = !sms.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Phone Calls',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: phoneCalls.value,
                                                    onChanged: (val) {
                                                      phoneCalls.value =
                                                          !phoneCalls.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Browser Notifications',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: browserNotification
                                                        .value,
                                                    onChanged: (val) {
                                                      browserNotification
                                                              .value =
                                                          !browserNotification
                                                              .value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.color000000),
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                child: const Text('Edit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: AppColors.color000000.withOpacity(0.2),
                      ),
                      Text(
                        'Glekey Updates',
                        style: color00000s15w600,
                      ),
                      Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        style: color50perBlacks13w400,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'News And Programmes',
                                style: color00000s15w600,
                              ),
                            ),
                            Text(
                              'on :SMS',
                              style: color50perBlacks13w400.copyWith(height: 0),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                RxBool email = false.obs;
                                RxBool sms = false.obs;
                                RxBool phoneCalls = false.obs;
                                RxBool browserNotification = false.obs;
                                showModalBottomSheet<void>(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Obx(() {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              height: 3,
                                              width: Get.width / 4.5,
                                              decoration: BoxDecoration(
                                                color: AppColors.color000000
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Email',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: email.value,
                                                    onChanged: (val) {
                                                      email.value =
                                                          !email.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'SMS',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: sms.value,
                                                    onChanged: (val) {
                                                      sms.value = !sms.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Phone Calls',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: phoneCalls.value,
                                                    onChanged: (val) {
                                                      phoneCalls.value =
                                                          !phoneCalls.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Browser Notifications',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: browserNotification
                                                        .value,
                                                    onChanged: (val) {
                                                      browserNotification
                                                              .value =
                                                          !browserNotification
                                                              .value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.color000000),
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                child: const Text('Edit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Feedback',
                                style: color00000s15w600,
                              ),
                            ),
                            Text(
                              'on :SMS',
                              style: color50perBlacks13w400.copyWith(height: 0),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                RxBool email = false.obs;
                                RxBool sms = false.obs;
                                RxBool phoneCalls = false.obs;
                                RxBool browserNotification = false.obs;
                                showModalBottomSheet<void>(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Obx(() {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              height: 3,
                                              width: Get.width / 4.5,
                                              decoration: BoxDecoration(
                                                color: AppColors.color000000
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Email',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: email.value,
                                                    onChanged: (val) {
                                                      email.value =
                                                          !email.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'SMS',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: sms.value,
                                                    onChanged: (val) {
                                                      sms.value = !sms.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Phone Calls',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: phoneCalls.value,
                                                    onChanged: (val) {
                                                      phoneCalls.value =
                                                          !phoneCalls.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Browser Notifications',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: browserNotification
                                                        .value,
                                                    onChanged: (val) {
                                                      browserNotification
                                                              .value =
                                                          !browserNotification
                                                              .value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.color000000),
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                child: const Text('Edit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Travel Regulations',
                                style: color00000s15w600,
                              ),
                            ),
                            Text(
                              'on :SMS',
                              style: color50perBlacks13w400.copyWith(height: 0),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                RxBool email = false.obs;
                                RxBool sms = false.obs;
                                RxBool phoneCalls = false.obs;
                                RxBool browserNotification = false.obs;
                                showModalBottomSheet<void>(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Obx(() {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              height: 3,
                                              width: Get.width / 4.5,
                                              decoration: BoxDecoration(
                                                color: AppColors.color000000
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Email',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: email.value,
                                                    onChanged: (val) {
                                                      email.value =
                                                          !email.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'SMS',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: sms.value,
                                                    onChanged: (val) {
                                                      sms.value = !sms.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Phone Calls',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: phoneCalls.value,
                                                    onChanged: (val) {
                                                      phoneCalls.value =
                                                          !phoneCalls.value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Browser Notifications',
                                                      style: color00000s15w600,
                                                    ),
                                                  ),
                                                  CupertinoSwitch(
                                                    value: browserNotification
                                                        .value,
                                                    onChanged: (val) {
                                                      browserNotification
                                                              .value =
                                                          !browserNotification
                                                              .value;
                                                    },
                                                    activeColor:
                                                        AppColors.colorFE6927,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.color000000),
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                child: const Text('Edit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
}

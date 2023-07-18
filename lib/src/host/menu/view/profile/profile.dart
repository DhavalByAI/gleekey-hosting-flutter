import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
import 'package:gleeky_flutter/src/host/setting/edit_personal_info_screen.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstName = TextEditingController();

  final TextEditingController _lastName = TextEditingController();

  final TextEditingController _birthdate = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _phoneNumber = TextEditingController();

  // final TextEditingController _governmentID = TextEditingController();
  final TextEditingController _emergencyContect = TextEditingController();

  // Initial Selected Value
  RxString dropdownvalue = 'Gender'.obs;

  // List of items in our dropdown menu
  var items = [
    'Gender',
    'Male',
    'Female',
  ];

  @override
  initState() {
    log(user_model?.userDetails?.gender ?? 'Gender');
    _firstName.text = user_model?.data?.firstName ?? "";
    _lastName.text = user_model?.data?.lastName ?? "";
    _email.text = user_model?.data?.email ?? "";
    _phoneNumber.text =
        user_model?.data?.formattedPhone ?? user_model?.data?.phone ?? '';
    _birthdate.text = (user_model?.userDetails?.dateOfBirth ?? '').toString();

    dropdownvalue.value = user_model?.userDetails?.gender ?? 'Gender';
    // _governmentID.text = 'Adhar Card';

    _emergencyContect.text = user_model?.userDetails?.about ?? "";
    super.initState();
  }

  UserController userController = Get.put(UserController());

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
                        'Profile',
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Opacity(
                                opacity: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.color000000,
                                      ),
                                      borderRadius: BorderRadius.circular(6)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 20),
                                  child: Text('EDIT', style: color00000s14w500),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            user_model?.data?.profileSrc ?? '',
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(
                                              color: AppColors.colorFE6927,
                                            ),
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(
                                              backgroundColor:
                                                  AppColors.colorD9D9D9,
                                              child: Icon(
                                                Icons.person,
                                                color: AppColors.color000000,
                                              ),
                                            ),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => const EditPersonalInfoScreen());
                                },
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.color000000,
                                      ),
                                      borderRadius: BorderRadius.circular(6)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 20),
                                  child: Text('EDIT', style: color00000s14w500),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Hi, ${user_model?.data?.firstName ?? ''} ${user_model?.data?.lastName ?? ''}',
                            style: color00000s18w600,
                          ),
                          Text(
                            'Member Since, ${DateFormat('dd/MM/yyyy').format(DateTime.parse((user_model?.data?.createdAt ?? '0000-00-00').toString()))}',
                            style: color50perBlacks13w400,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      IgnorePointer(
                        ignoring: true,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color:
                                        AppColors.color000000.withOpacity(0.2),
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 13),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('First Name',
                                        style: color50perBlacks13w400),
                                    TextFormField(
                                      controller: _firstName,
                                      cursorColor: AppColors.colorFE6927,
                                      style: color00000s14w500,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color:
                                        AppColors.color000000.withOpacity(0.2),
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Last Name',
                                        style: color50perBlacks13w400),
                                    TextFormField(
                                      controller: _lastName,
                                      cursorColor: AppColors.colorFE6927,
                                      style: color00000s14w500,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: InkWell(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: AppColors
                                                .colorFE6927, // <-- SEE HERE
                                            // onPrimary:
                                            //     AppColors.colorFE6927, // <-- SEE HERE
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              primary: Colors
                                                  .red, // button text color
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    setState(() {
                                      _birthdate.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {}
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: AppColors.color000000
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Birthdate',
                                        style: color50perBlacks13w400,
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        controller: _birthdate,
                                        cursorColor: AppColors.colorFE6927,
                                        style: color00000s14w500,
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Obx(() {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color:
                                        AppColors.color000000.withOpacity(0.2),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 5,
                                ),
                                child: DropdownButton(
                                  value: dropdownvalue.value,
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  borderRadius: BorderRadius.circular(6),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: color00000s14w500,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    dropdownvalue.value = newValue!;
                                  },
                                ),
                              );
                            }),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Divider(
                                color: AppColors.color000000.withOpacity(0.2),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Email',
                                              style: color00000s14w500),
                                          TextFormField(
                                            cursorColor: AppColors.colorFE6927,
                                            style: color50perBlacks13w400,
                                            controller: _email,
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: AppColors.color000000.withOpacity(0.2),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                            Column(children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Phone Number',
                                          style: color00000s14w500,
                                        ),
                                        TextFormField(
                                          cursorColor: AppColors.colorFE6927,
                                          style: color50perBlacks13w400,
                                          controller: _phoneNumber,
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            isDense: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: AppColors.color000000.withOpacity(0.2),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ]),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Describe Yourself',
                                              style: color00000s14w500),
                                          TextFormField(
                                            cursorColor: AppColors.colorFE6927,
                                            style: color50perBlacks13w400,
                                            controller: _emergencyContect,
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: AppColors.color000000.withOpacity(0.2),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ],
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

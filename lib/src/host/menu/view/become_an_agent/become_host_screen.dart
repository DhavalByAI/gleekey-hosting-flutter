import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:image_picker/image_picker.dart';

class BecomeHostScreen extends StatefulWidget {
  const BecomeHostScreen({Key? key}) : super(key: key);

  @override
  State<BecomeHostScreen> createState() => _BecomeHostScreenState();
}

class _BecomeHostScreenState extends State<BecomeHostScreen> {
  List data = ['Basic Info', 'Verify Details'];

  RxInt selectedIndex = 0.obs;

  final TextEditingController _fName = TextEditingController();

  final TextEditingController _lName = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _contectNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();

  final TextEditingController _bankName = TextEditingController();
  final TextEditingController _branchName = TextEditingController();
  final TextEditingController _accountNumber = TextEditingController();
  final TextEditingController _IFSCCode = TextEditingController();

  RxString adharCardFront = ''.obs;
  RxString adharCardBack = ''.obs;
  RxString pancard = ''.obs;
  RxString bankPassbook = ''.obs;
  RxString cancelCheck = ''.obs;

  final RxBool _termsAndCondition = false.obs;

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
                ],
              ),
              const SizedBox(height: 15),
              Obx(
                () {
                  return Row(
                    children: List.generate(
                      data.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: selectedIndex.value == index
                                  ? AppColors.colorFE6927
                                  : Colors.transparent),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Text(
                            data[index],
                            style: selectedIndex.value == index
                                ? colorfffffffs14w500
                                : color00000s14w500.copyWith(
                                    color:
                                        AppColors.color000000.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  color: AppColors.color000000.withOpacity(0.2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Obx(
                      () {
                        return selectedIndex.value == 0
                            ? basicInfoView()
                            : VerifyDetailView();
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

  Column basicInfoView() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Basic Details',
            style: color00000s15w600,
          ),
          const SizedBox(
            height: 10,
          ),
          CommonTextFeildPart(
            controller: _fName,
            title: 'First Name',
            hintText: 'Enter Your First Name',
          ),
          CommonTextFeildPart(
            controller: _lName,
            title: 'Last Name',
            hintText: 'Enter Your Last Name',
          ),
          CommonTextFeildPart(
            controller: _email,
            title: 'Email',
            hintText: 'Enter Your Email',
          ),
          CommonTextFeildPart(
            controller: _contectNumber,
            title: 'Contact Number',
            hintText: 'Enter Your Contact Number',
            keyboardType: TextInputType.phone,
          ),
          CommonTextFeildPart(
            controller: _address,
            title: 'Address',
            maxLines: 4,
            hintText: 'Enter Your Address',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CommonButton(
                  onPressed: () {
                    selectedIndex.value = 0;
                  },
                  color: AppColors.colorEBEBEB,
                  style: colorfffffffs13w600.copyWith(
                      color: AppColors.color000000.withOpacity(0.7)),
                  name: 'Previous',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CommonButton(
                  onPressed: () {
                    if (_fName.text.isEmpty ||
                        _lName.text.isEmpty ||
                        _email.text.isEmpty ||
                        _contectNumber.text.isEmpty ||
                        _address.text.isEmpty) {
                      showSnackBar(
                          title: ApiConfig.error, message: 'Fill Your Details');
                    } else {
                      selectedIndex.value = 1;
                    }
                  },
                  name: 'Next',
                ),
              ),
            ],
          ),
        ],
      );

  Column VerifyDetailView() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verify Your Aadhaar Identity',
            style: color00000s15w600,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: CommonChooseFileView(
                  title: 'Aadhaar Card Front',
                  fileName: adharCardFront,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: VerticalDivider(
                  color: AppColors.color000000.withOpacity(0.2),
                ),
              ),
              Expanded(
                child: CommonChooseFileView(
                  title: 'Aadhaar Card Back',
                  fileName: adharCardBack,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Pancard And Bank Details',
            style: color00000s15w600,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: CommonChooseFileView(
                  fileName: pancard,
                  title: 'Pancard',
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: CommonChooseFileView(
                  fileName: bankPassbook,
                  title: 'Bank Passbook (First page)',
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: CommonChooseFileView(
                  fileName: cancelCheck,
                  title: 'Cancelled Check',
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          CommonTextFeildPart(
              controller: _bankName,
              title: 'Bank Name',
              hintText: 'Enter Your Bank Name'),
          CommonTextFeildPart(
              controller: _branchName,
              title: 'Branch Name',
              hintText: 'Enter Your Branch Name'),
          CommonTextFeildPart(
              controller: _accountNumber,
              title: 'Account Number',
              hintText: 'Enter Your Account Number'),
          CommonTextFeildPart(
              controller: _IFSCCode,
              title: 'IFSC Code',
              hintText: 'Enter Your IFSC Code'),
          Row(
            children: [
              CommonCheckBox(_termsAndCondition),
              Text(
                'I accept Terms & Condition and Privacy Policy',
                style: color00000s14w500,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CommonButton(
                  onPressed: () {
                    selectedIndex.value = 0;
                  },
                  color: AppColors.colorEBEBEB,
                  style: colorfffffffs13w600.copyWith(
                      color: AppColors.color000000.withOpacity(0.7)),
                  name: 'Previous',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CommonButton(
                  onPressed: () {
                    if (adharCardFront.value == '' ||
                        adharCardBack.value == '' ||
                        pancard.value == '' ||
                        bankPassbook.value == '' ||
                        cancelCheck.value == '') {
                      showSnackBar(
                          title: ApiConfig.error,
                          message: 'Select Document Images Please');
                    } else if (_bankName.text.isEmpty ||
                        _branchName.text.isEmpty ||
                        _accountNumber.text.isEmpty ||
                        _IFSCCode.text.isEmpty) {
                      showSnackBar(
                          title: ApiConfig.error,
                          message: 'Fill Your Bank Details');
                    } else if (!_termsAndCondition.value) {
                      showSnackBar(
                          title: ApiConfig.error,
                          message: 'Accept Terms & Condition');
                    } else {
                      Get.back();
                    }
                  },
                  name: 'Submit',
                ),
              ),
            ],
          ),
        ],
      );

  Column CommonChooseFileView({
    required String title,
    required RxString fileName,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: color00000s13w600,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
            onTap: () async {
              try {
                var image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (image == null) {
                  return;
                } else {
                  fileName.value = image.path;
                }
              } on PlatformException catch (e) {
                showSnackBar(
                    title: ApiConfig.error,
                    message: 'Failed to pick image: $e');
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.colorF8F8F8,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.color000000)),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: const Text('Choose File'),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: Get.width / 3,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: AppColors.colorD9D9D9,
            ),
            child: fileName.value != ''
                ? Image.file(
                    File(fileName.value),
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                  )
                : const SizedBox(),
          ),
        )
      ],
    );
  }

  Widget CommonTextFeildPart(
      {String? title,
      String? hintText,
      required TextEditingController controller,
      Widget? suffix,
      bool readOnly = false,
      GestureTapCallback? onTap,
      int? maxLines = 1,
      ValueChanged<String>? onChanged,
      TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? '',
            style: color00000s14w500,
          ),
          const SizedBox(
            height: 6,
          ),
          TextFormField(
            onTap: onTap,
            style: color00000s14w500,
            maxLines: maxLines,
            cursorColor: AppColors.colorFE6927,
            keyboardType: keyboardType,
            controller: controller,
            readOnly: readOnly,
            onChanged: onChanged,
            decoration: InputDecoration(
              suffixIcon: suffix,
              hintText: hintText,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: AppColors.color000000.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: AppColors.color000000.withOpacity(0.5),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: AppColors.color000000.withOpacity(0.5),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/getUserController.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'kyc_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dropdown_search/dropdown_search.dart';

class KycScreen extends StatefulWidget {
  bool? isAgent = false;
  KycScreen({Key? key, this.isAgent}) : super(key: key);

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  List data = ['Basic Info', 'Verify Details', 'Finish'];

  RxInt selectedIndex = 0.obs;
  final TextEditingController _fName = TextEditingController();
  final TextEditingController _lName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _contectNumber = TextEditingController();
  final TextEditingController _address1 = TextEditingController();
  final TextEditingController _address2 = TextEditingController();

  final RxString _country = 'Select Your Country'.obs;
  final RxString _countryID = ''.obs;
  final RxString _state = 'Select Your State'.obs;
  final RxString _stateID = ''.obs;
  final RxString _city = 'Select Your City'.obs;
  final RxString _cityID = ''.obs;

  final TextEditingController _pinCode = TextEditingController();

  final TextEditingController _GST = TextEditingController();
  final RxString _bankName = 'Select Bank'.obs;
  final RxString _bankID = ''.obs;

  final TextEditingController _branchName = TextEditingController();
  final TextEditingController _accountNumber = TextEditingController();
  final TextEditingController _confirmAccountNumber = TextEditingController();
  final TextEditingController _IFSCCode = TextEditingController();

  RxString adharCardFront = ''.obs;
  RxString adharCardFrontNetwork = ''.obs;
  RxString adharCardBack = ''.obs;
  RxString adharCardBackNetwork = ''.obs;
  RxString pancard = ''.obs;
  RxString pancardNetwork = ''.obs;
  RxString cancelCheck = ''.obs;
  RxString cancelCheckNetwork = ''.obs;

  final RxBool _termsAndCondition = false.obs;

  @override
  initState() {
    KycController.to.getCountryApi();
    _contectNumber.text =
        user_model?.data?.formattedPhone ?? user_model?.data?.phone ?? '';
    KycController.to.getKYCApi(success: () {
      _fName.text =
          KycController.to.getKYCResponse['basic_data'][0]?['first_name'] ?? '';
      _lName.text =
          KycController.to.getKYCResponse['basic_data'][0]?['last_name'] ?? '';
      _email.text =
          KycController.to.getKYCResponse['basic_data'][0]?['email'] ?? '';

      _address1.text =
          KycController.to.getKYCResponse['basic_data'][0]?['address'] ?? '';
      _address2.text =
          KycController.to.getKYCResponse['basic_data'][0]?['address_2'] ?? '';
      _pinCode.text =
          KycController.to.getKYCResponse['basic_data'][0]?['pincode'] ?? '';

      if (KycController.to.getKYCResponse['basic_data'][0]?['country_id'] !=
          null) {
        _countryID.value = KycController
                .to.getKYCResponse['basic_data'][0]?['country_id']
                .toString() ??
            '';
        KycController.to.getCountryApi(
          success: () {
            // List tmpCountry = KycController.to.getCountryRes['data'];
            // _country.value = tmpCountry[tmpCountry.indexWhere((element) =>
            //     element['id'] ==
            //     KycController.to.getKYCResponse['basic_data'][0]
            //         ?['country_id'])]['name'];
            KycController.to.getCountryRes['data'].forEach(
              (element) {
                (element['id'].toString() ==
                        KycController
                            .to.getKYCResponse['basic_data'][0]?['country_id']
                            .toString())
                    ? _country.value = element['name'].toString()
                    : _country.value = _country.value;
              },
            );
          },
        );

        print("COUNTRY NAME${_country.value}");
      }

      if (KycController.to.getKYCResponse['basic_data'][0]?['state_id'] !=
          null) {
        _stateID.value = KycController
                .to.getKYCResponse['basic_data'][0]?['state_id']
                .toString() ??
            '';
        KycController.to.getStateApi(
          params: {
            'country_id': KycController.to.getKYCResponse['basic_data'][0]
                ?['country_id']
          },
          success: () {
            KycController.to.getStateRes['data'].forEach(
              (element) {
                (element['id'] ==
                        KycController.to.getKYCResponse['basic_data'][0]
                            ?['state_id'])
                    ? _state.value = element['name']
                    : _state.value = _state.value;
              },
            );
          },
        );
      }

      if (KycController.to.getKYCResponse['basic_data'][0]?['city_id'] !=
          null) {
        _cityID.value = KycController
                .to.getKYCResponse['basic_data'][0]?['city_id']
                .toString() ??
            '';
        KycController.to.getCityApi(
          params: {
            'state_id': KycController.to.getKYCResponse['basic_data'][0]
                ?['state_id']
          },
          success: () {
            KycController.to.getCityRes['data'].forEach(
              (element) {
                (element['id'] ==
                        KycController.to.getKYCResponse['basic_data'][0]
                            ?['city_id'])
                    ? _city.value = element['name']
                    : _city.value = _city.value;
              },
            );
          },
        );
      }

      ///second step
      if (KycController.to.getKYCResponse['kyc_data'] != null &&
          KycController.to.getKYCResponse['kyc_data'] != [] &&
          KycController.to.getKYCResponse['kyc_data'].isNotEmpty) {
        _GST.text =
            KycController.to.getKYCResponse['kyc_data'][0]['gst_number'] ?? '';

        adharCardFrontNetwork.value =
            KycController.to.getKYCResponse['kyc_data'][0]['aadhar_front'] ??
                '';
        adharCardBackNetwork.value =
            KycController.to.getKYCResponse['kyc_data'][0]['aadhar_back'] ?? '';
        pancardNetwork.value =
            KycController.to.getKYCResponse['kyc_data'][0]['pancard'] ?? '';
        cancelCheckNetwork.value = KycController.to.getKYCResponse['kyc_data']
                [0]['canceled_check'] ??
            '';

        _branchName.text =
            KycController.to.getKYCResponse['kyc_data'][0]['branch_name'] ?? '';
        _accountNumber.text = KycController.to.getKYCResponse['kyc_data'][0]
                ['account_number'] ??
            '';
        _confirmAccountNumber.text = KycController.to.getKYCResponse['kyc_data']
                [0]['account_number'] ??
            '';
        _IFSCCode.text =
            KycController.to.getKYCResponse['kyc_data'][0]['ifsc_code'] ?? '';

        if (KycController.to.getKYCResponse['kyc_data'][0]?['bank_name'] !=
            null) {
          _bankID.value =
              KycController.to.getKYCResponse['kyc_data'][0]?['bank_name'];

          print("Country name${_country.value}");
        }
      } else {
        print('else 1');
      }
    }, error: (e) {
      print('KYC Controller $e');
    });

    super.initState();
  }

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
                        'KYC',
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
                            : selectedIndex.value == 1
                                ? VerifyDetailView()
                                : FinishView();
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
            autovalidateMode: AutovalidateMode.always,
            validator: (val) {
              if (_email.text.isEmpty ||
                  !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(_email.text)) {
                return "Enter Correct Email Address";
              } else {
                return null;
              }
            },
          ),
          CommonTextFeildPart(
            controller: _contectNumber,
            title: 'Contact Number',
            hintText: 'Enter Your Contact Number',
            keyboardType: TextInputType.phone,
          ),
          CommonTextFeildPart(
            controller: _address1,
            title: 'Address 1',
            maxLines: 4,
            hintText: 'Enter Your Address',
          ),
          CommonTextFeildPart(
            controller: _address2,
            title: 'Address 2 (Optional)',
            maxLines: 4,
            hintText: 'Enter Your Address',
          ),
          Text(
            'Country',
            style: color00000s14w500,
          ),
          const SizedBox(
            height: 6,
          ),
          Obx(() {
            return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.color000000.withOpacity(0.5),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownSearch<String>(
                  popupProps: const PopupProps.menu(
                    showSelectedItems: true,
                    showSearchBox: true,
                  ),
                  items: List.generate(
                      KycController.to.getCountryRes.isEmpty
                          ? 0
                          : KycController.to.getCountryRes['data'].length,
                      (j) => KycController.to.getCountryRes['data'][j]['name']
                          .toString())
                  // DropdownMenuItem(
                  //       onTap: () {
                  //         _country.value = KycController
                  //             .to.getCountryRes['data'][index]['name'];
                  //         _countryID.value = KycController
                  //             .to.getCountryRes['data'][index]['id']
                  //             .toString();
                  //         KycController.to.getStateApi(params: {
                  //           'country_id': KycController
                  //               .to.getCountryRes['data'][index]['id']
                  //         });
                  //       },
                  //       value: KycController.to.getCountryRes['data'][index]
                  //           ['name'],
                  //       child: Text(
                  //         KycController
                  //             .to.getCountryRes['data'][index]['name']
                  //             .toString(),
                  //         style: color00000s14w500,
                  //       ),
                  //     )),
                  ,
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        // labelText: "Menu mode",
                        // hintText: "country in menu mode",
                        ),
                  ),
                  onChanged: (value) {
                    List tmpList = KycController.to.getCountryRes['data'];
                    _country.value = value ?? '';
                    int tmpId = tmpList
                        .indexWhere((element) => element['name'] == value);
                    _countryID.value = tmpList[tmpId]['id'].toString();
                    KycController.to.getStateApi(
                        params: {'country_id': _countryID.value.toString()});
                    _state.value = 'Select Your State';
                    _city.value = 'Select Your City';
                  },
                  selectedItem: _country.value,
                )
                // DropdownButton(
                //   underline: const SizedBox(),
                //   hint: Text(
                //     _country.value,
                //     style: color00000s14w500,
                //   ),
                //   isExpanded: true,
                //   borderRadius: BorderRadius.circular(6),
                //   items: List.generate(
                //       KycController.to.getCountryRes.isEmpty
                //           ? 0
                //           : KycController.to.getCountryRes['data'].length,
                //       (index) => DropdownMenuItem(
                //             onTap: () {
                //               _country.value = KycController
                //                   .to.getCountryRes['data'][index]['name'];
                //               _countryID.value = KycController
                //                   .to.getCountryRes['data'][index]['id']
                //                   .toString();
                //               KycController.to.getStateApi(params: {
                //                 'country_id': KycController
                //                     .to.getCountryRes['data'][index]['id']
                //               });
                //             },
                //             value: KycController.to.getCountryRes['data'][index]
                //                 ['name'],
                //             child: Text(
                //               KycController
                //                   .to.getCountryRes['data'][index]['name']
                //                   .toString(),
                //               style: color00000s14w500,
                //             ),
                //           )),
                //   onChanged: (_) {
                //     _state.value = 'Select Your State';
                //     _city.value = 'Select Your City';
                //   },
                // ),
                );
          }),
          const SizedBox(
            height: 6,
          ),
          Text(
            'State',
            style: color00000s14w500,
          ),
          const SizedBox(
            height: 6,
          ),
          Obx(() {
            return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppColors.color000000.withOpacity(0.5))),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownSearch<String>(
                  popupProps: const PopupProps.menu(
                    showSelectedItems: true,
                    showSearchBox: true,
                  ),
                  items: List.generate(
                      KycController.to.getStateRes.isEmpty
                          ? 0
                          : KycController.to.getStateRes['data'].length,
                      (j) => KycController.to.getStateRes['data'][j]['name']
                          .toString()),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(),
                  ),
                  onChanged: (value) {
                    List tmpList = KycController.to.getStateRes['data'];
                    int tmpId = tmpList
                        .indexWhere((element) => element['name'] == value);
                    _state.value =
                        KycController.to.getStateRes['data'][tmpId]['name'];
                    _stateID.value = KycController
                        .to.getStateRes['data'][tmpId]['id']
                        .toString();
                    KycController.to.getCityApi(
                        params: {'state_id': _stateID.value.toString()});
                    _city.value = 'Select Your City';
                  },
                  selectedItem: _state.value,
                ));
          }),
          const SizedBox(
            height: 6,
          ),
          Text(
            'City',
            style: color00000s14w500,
          ),
          const SizedBox(
            height: 6,
          ),
          Obx(() {
            return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.color000000.withOpacity(0.5),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownSearch<String>(
                  popupProps: const PopupProps.menu(
                    showSelectedItems: true,
                    showSearchBox: true,
                  ),
                  items: List.generate(
                      KycController.to.getCityRes.isEmpty
                          ? 0
                          : KycController.to.getCityRes['data'].length,
                      (j) => KycController.to.getCityRes['data'][j]['name']
                          .toString()),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(),
                  ),
                  onChanged: (value) {
                    List tmpList = KycController.to.getCityRes['data'];
                    int tmpId = tmpList
                        .indexWhere((element) => element['name'] == value);
                    _city.value =
                        KycController.to.getCityRes['data'][tmpId]['name'];
                    _cityID.value = KycController
                        .to.getCityRes['data'][tmpId]['id']
                        .toString();
                  },
                  selectedItem: _city.value,
                )
                // DropdownButton(
                //   underline: const SizedBox(),
                //   hint: Text(
                //     _city.value,
                //     style: color00000s14w500,
                //   ),
                //   isExpanded: true,
                //   borderRadius: BorderRadius.circular(6),
                //   items: List.generate(
                //       KycController.to.getCityRes.isEmpty
                //           ? 0
                //           : KycController.to.getCityRes['data'].length,
                //       (index) => DropdownMenuItem(
                //             onTap: () {
                //               _city.value = KycController.to.getCityRes['data']
                //                   [index]['name'];
                //               _cityID.value = KycController
                //                   .to.getCityRes['data'][index]['id']
                //                   .toString();
                //             },
                //             value: KycController.to.getCityRes['data'][index]
                //                 ['name'],
                //             child: Text(
                //               KycController.to.getCityRes['data'][index]['name']
                //                   .toString(),
                //               style: color00000s14w500,
                //             ),
                //           )),
                //   onChanged: (_) {},
                // ),
                );
          }),
          const SizedBox(
            height: 5,
          ),
          CommonTextFeildPart(
              controller: _pinCode,
              title: 'Pincode',
              hintText: 'Enter Your Pincode',
              keyboardType: TextInputType.number),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CommonButton(
                  onPressed: () {
                    if (_fName.text.isEmpty ||
                        _lName.text.isEmpty ||
                        _email.text.isEmpty ||
                        _contectNumber.text.isEmpty ||
                        _address1.text.isEmpty ||
                        _country.value == 'Select Your Country' ||
                        _city.value == 'Select Your City' ||
                        _state.value == 'Select Your State' ||
                        _pinCode.text.isEmpty) {
                      showSnackBar(
                          title: ApiConfig.error, message: 'Fill Your Details');
                    } else {
                      loaderShow(context);
                      KycController.to.getBankListApi(error: (e) {
                        loaderHide();
                      }, success: () {
                        selectedIndex.value = 1;
                        if (KycController.to.getKYCResponse['kyc_data'] != [] &&
                            KycController
                                .to.getKYCResponse['kyc_data'].isNotEmpty &&
                            KycController.to.getKYCResponse['kyc_data'][0]
                                    ?['bank_name'] !=
                                null) {
                          _bankID.value = KycController
                              .to.getKYCResponse['kyc_data'][0]?['bank_name'];
                          KycController.to.getbankListRes['data'].forEach(
                            (element) {
                              (element['id'].toString() ==
                                      KycController
                                              .to.getKYCResponse['kyc_data'][0]
                                          ?['bank_name'])
                                  ? _bankName.value = element['name']
                                  : _bankName.value = _bankName.value;
                            },
                          );
                        } else {
                          print('else');
                        }

                        loaderHide();
                      });
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
          CommonTextFeildPart(
              controller: _GST,
              title: 'GST (Optional)',
              hintText: 'GJACPD0123456789'),
          KycController.to.getKYCResponse['kyc_data'].isEmpty
              ? const SizedBox()
              : ((KycController.to.getKYCResponse['kyc_data']?[0]?['is_gst'] ??
                          0) ==
                      2)
                  ? const SizedBox(
                      height: 10,
                    )
                  : const SizedBox(),
          KycController.to.getKYCResponse['kyc_data'].isEmpty
              ? const SizedBox()
              : ((KycController.to.getKYCResponse['kyc_data']?[0]?['is_gst'] ??
                          0) ==
                      2)
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.colorf8d7da,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber,
                              color: AppColors.color000000, size: 25),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              'Note : ' +
                                  (KycController.to.getKYCResponse['kyc_data']
                                          [0]['admin_gst_note'] ??
                                      'Rejected by Team Gleekey'),
                              style: color00000s14w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
          const SizedBox(
            height: 12,
          ),
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
                    fileNameNetwork: adharCardFrontNetwork),
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
                  fileNameNetwork: adharCardBackNetwork,
                ),
              ),
            ],
          ),
          KycController.to.getKYCResponse['kyc_data'].isEmpty
              ? const SizedBox()
              : ((KycController.to.getKYCResponse['kyc_data'][0]['is_aadhar'] ??
                          0) ==
                      2)
                  ? const SizedBox(
                      height: 10,
                    )
                  : const SizedBox(),
          KycController.to.getKYCResponse['kyc_data'].isEmpty
              ? const SizedBox()
              : ((KycController.to.getKYCResponse['kyc_data'][0]['is_aadhar'] ??
                          0) ==
                      2)
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.colorf8d7da,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber,
                              color: AppColors.color000000, size: 25),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              'Note : ' +
                                  (KycController.to.getKYCResponse['kyc_data']
                                          [0]['admin_document_note'] ??
                                      'Rejected by Team Gleekey'),
                              style: color00000s14w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
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
                    fileNameNetwork: pancardNetwork),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          KycController.to.getKYCResponse['kyc_data'].isEmpty
              ? const SizedBox()
              : ((KycController.to.getKYCResponse['kyc_data'][0]
                              ['is_pancard'] ??
                          0) ==
                      2)
                  ? const SizedBox(
                      height: 10,
                    )
                  : const SizedBox(),
          KycController.to.getKYCResponse['kyc_data'].isEmpty
              ? const SizedBox()
              : ((KycController.to.getKYCResponse['kyc_data'][0]
                              ['is_pancard'] ??
                          0) ==
                      2)
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.colorf8d7da,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber,
                              color: AppColors.color000000, size: 25),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              'Note : ' +
                                  (KycController.to.getKYCResponse['kyc_data']
                                          [0]['admin_pancard_note'] ??
                                      'Rejected by Team Gleekey'),
                              style: color00000s14w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
          const SizedBox(
            height: 10,
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
                    fileNameNetwork: cancelCheckNetwork),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          KycController.to.getKYCResponse['kyc_data'].isEmpty
              ? const SizedBox()
              : ((KycController.to.getKYCResponse['kyc_data'][0]
                              ['is_passbook'] ??
                          0) ==
                      2)
                  ? const SizedBox(
                      height: 10,
                    )
                  : const SizedBox(),
          KycController.to.getKYCResponse['kyc_data'].isEmpty
              ? const SizedBox()
              : ((KycController.to.getKYCResponse['kyc_data'][0]
                              ['is_passbook'] ??
                          0) ==
                      2)
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.colorf8d7da,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber,
                              color: AppColors.color000000, size: 25),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              'Note : ' +
                                  (KycController.to.getKYCResponse['kyc_data']
                                          [0]['admin_bank_note'] ??
                                      'Rejected by Team Gleekey'),
                              style: color00000s14w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Bank Name',
            style: color00000s14w500,
          ),
          const SizedBox(
            height: 6,
          ),
          Obx(
            () {
              return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.color000000.withOpacity(0.5),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownSearch<String>(
                    popupProps: const PopupProps.menu(
                      showSelectedItems: true,
                      showSearchBox: true,
                    ),
                    items: List.generate(
                        KycController.to.getbankListRes.isEmpty
                            ? 0
                            : KycController.to.getbankListRes['data'].length,
                        (j) => KycController
                            .to.getbankListRes['data'][j]['name']
                            .toString()),
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(),
                    ),
                    onChanged: (value) {
                      List tmpList = KycController.to.getbankListRes['data'];
                      int tmpId = tmpList
                          .indexWhere((element) => element['name'] == value);
                      _bankName.value = KycController.to.getbankListRes['data']
                          [tmpId]['name'];
                      _bankID.value = KycController
                          .to.getbankListRes['data'][tmpId]['id']
                          .toString();
                    },
                    selectedItem: _bankName.value,
                  )
                  // DropdownButton(
                  //   underline: const SizedBox(),
                  //   hint: Text(
                  //     _bankName.value,
                  //     style: color00000s14w500,
                  //   ),
                  //   isExpanded: true,
                  //   borderRadius: BorderRadius.circular(6),
                  //   items: List.generate(
                  //     KycController.to.getbankListRes.isEmpty
                  //         ? 0
                  //         : KycController.to.getbankListRes['data'].length,
                  //     (index) => DropdownMenuItem(
                  //       onTap: () {
                  //         _bankName.value = KycController
                  //             .to.getbankListRes['data'][index]['name'];
                  //         _bankID.value = KycController
                  //             .to.getbankListRes['data'][index]['id']
                  //             .toString();
                  //       },
                  //       value: KycController.to.getbankListRes['data'][index]
                  //           ['name'],
                  //       child: Text(
                  //         KycController.to.getbankListRes['data'][index]['name']
                  //             .toString(),
                  //         style: color00000s14w500,
                  //       ),
                  //     ),
                  //   ),
                  //   onChanged: (_) {},
                  // ),

                  );
            },
          ),
          CommonTextFeildPart(
            controller: _branchName,
            title: 'Branch Name',
            hintText: 'Enter Your Branch Name',
          ),
          CommonTextFeildPart(
            controller: _accountNumber,
            title: 'Account Number',
            keyboardType: TextInputType.number,
            hintText: 'Enter Your Account Number',
          ),
          CommonTextFeildPart(
            controller: _confirmAccountNumber,
            keyboardType: TextInputType.number,
            title: 'Confirm Account Number',
            hintText: 'Enter Your Confirm Account Number',
          ),
          CommonTextFeildPart(
            controller: _IFSCCode,
            title: 'IFSC Code',
            hintText: 'Enter Your IFSC Code',
          ),
          Row(
            children: [
              CommonCheckBox(_termsAndCondition),
              Text(
                'I accept Terms & Condition and Privacy Policy',
                style: color00000s14w500,
              ),
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
                    if ((adharCardFront.value == '' &&
                            adharCardFrontNetwork.value == '') ||
                        (adharCardBack.value == '' &&
                            adharCardBackNetwork.value == '') ||
                        (pancard.value == '' && pancardNetwork.value == '') ||
                        cancelCheck.value == '' &&
                            cancelCheckNetwork.value == '') {
                      showSnackBar(
                          title: ApiConfig.error,
                          message: 'Select Document Images Please');
                    } else if (_bankName.value == 'Select Bank' ||
                        _branchName.text.isEmpty ||
                        _accountNumber.text.isEmpty ||
                        _IFSCCode.text.isEmpty) {
                      showSnackBar(
                          title: ApiConfig.error,
                          message: 'Fill Your Bank Details');
                    } else if (_accountNumber.text !=
                        _confirmAccountNumber.text) {
                      showSnackBar(
                          title: ApiConfig.error,
                          message: 'Check Accounts Number');
                    } else if (!_termsAndCondition.value) {
                      showSnackBar(
                        title: ApiConfig.error,
                        message: 'Accept Terms & Condition',
                      );
                    } else {
                      selectedIndex.value = selectedIndex.value + 1;
                    }
                  },
                  name: 'Submit',
                ),
              ),
            ],
          ),
        ],
      );

  Column FinishView() => Column(
        children: [
          SizedBox(
            width: Get.width,
            height: Get.height / 3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    AppImages.bg_for_finalStep,
                    width: Get.width,
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Thanks For Joining Gleekey!',
                          style: color00000s15w600,
                        ),
                        Text(
                          'You Have successfully joined as a host. Welcome your hosting journey starts here.',
                          style: color50perBlacks13w400,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          ' - Gleekey',
                          style: color50perBlacks13w400,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CommonButton(
                  onPressed: () {
                    selectedIndex.value = selectedIndex.value - 1;
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
                  onPressed: () async {
                    Map<String, dynamic> params = {
                      "first_name": _fName.text,
                      "last_name": _lName.text,
                      "address": _address1.text,
                      "address_2": _address2.text,
                      "country_id": _countryID.value,
                      "state_id": _stateID.value,
                      "city_id": _cityID.value,
                      "pincode": _pinCode.text,
                      "bank_name": _bankID.value,
                      "branch_name": _branchName.text,
                      "account_number": _confirmAccountNumber.text,
                      "ifsc_code": _IFSCCode.text,
                      "is_agree": _termsAndCondition.value ? 1 : 0,
                      "gst_number": _GST.text,
                    };

                    if (adharCardFront.value != '') {
                      params["aadhar_front"] = await dio.MultipartFile.fromFile(
                          adharCardFront.value,
                          filename: adharCardFront.value);
                    }
                    if (adharCardBack.value != '') {
                      params["aadhar_back"] = await dio.MultipartFile.fromFile(
                          adharCardBack.value,
                          filename: adharCardBack.value);
                    }
                    if (pancard.value != '') {
                      params["pancard"] = await dio.MultipartFile.fromFile(
                          pancard.value,
                          filename: pancard.value);
                    }
                    if (cancelCheck.value != '') {
                      params["canceled_check"] =
                          await dio.MultipartFile.fromFile(cancelCheck.value,
                              filename: cancelCheck.value);
                    }

                    /*
                    "pancard": await dio.MultipartFile.fromFile(pancard.value,
                    filename: pancard.value),
                    "canceled_check": await dio.MultipartFile.fromFile(
                    cancelCheck.value,
                    filename: cancelCheck.value),*/
                    print("POST KYC PARAMS $params");
                    loaderShow(context);
                    KycController.to.postKYCApi(
                      params: params,
                      isFormData: true,
                      error: (e) {
                        loaderHide();
                        showSnackBar(
                            title: ApiConfig.error, message: e.toString());
                      },
                      success: () {
                        widget.isAgent ?? false
                            ? KycController.to.becomeAnAgent()
                            : null;
                        GetUserController.to.getUserApi();
                        loaderHide();
                        Get.back();
                        showSnackBar(
                          title: ApiConfig.success,
                          message: KycController.to.postKycDataRes['message'],
                        );
                      },
                    );
                  },
                  name: 'Finish',
                ),
              ),
            ],
          ),
        ],
      );

  Column CommonChooseFileView({
    required String title,
    required RxString fileName,
    required RxString fileNameNetwork,
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
                : fileNameNetwork.value != ''
                    ? CachedNetworkImage(
                        imageUrl: fileNameNetwork.value,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CupertinoActivityIndicator(
                            color: AppColors.colorFE6927,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
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
      FormFieldValidator<String>? validator,
      AutovalidateMode? autovalidateMode,
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
            validator: validator,
            autovalidateMode: autovalidateMode,
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
          ),
        ],
      ),
    );
  }
}

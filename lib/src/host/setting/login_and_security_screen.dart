import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

import 'controller/security_controller.dart';

class LoginAndSecurityScreen extends StatefulWidget {
  const LoginAndSecurityScreen({Key? key}) : super(key: key);

  @override
  State<LoginAndSecurityScreen> createState() => _LoginAndSecurityScreenState();
}

class _LoginAndSecurityScreenState extends State<LoginAndSecurityScreen> {
  final TextEditingController _oldPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  RxBool isEditable = false.obs;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 17),
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
                        'Login & Security',
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
                      Text(
                        'Login',
                        style: color00000s15w600,
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Change Password',
                                            style: color50perBlacks13w400),
                                        /* Text('Last updated 20 days ago',
                                            style: color00000s14w500),*/
                                      ],
                                    ),
                                  ),
                                  isEditable.value
                                      ? InkWell(
                                          onTap: () {
                                            isEditable.value = false;
                                          },
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.color000000,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 12),
                                            child: const Text('Cancel'),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            isEditable.value = true;
                                          },
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        AppColors.color000000),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 12),
                                            child: const Text('Update'),
                                          ),
                                        ),
                                ],
                              ),
                              isEditable.value
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CommonTextFeildPart(
                                            controller: _oldPass,
                                            title: 'Old Password',
                                            obscureText: true),
                                        CommonTextFeildPart(
                                            controller: _newPass,
                                            title: 'New Password',
                                            obscureText: true),
                                        CommonTextFeildPart(
                                            controller: _confirmPass,
                                            title: 'Confirm Password',
                                            obscureText: true),
                                        CommonButton(
                                          onPressed: () {
                                            if (_newPass.text.isEmpty ||
                                                _confirmPass.text.isEmpty ||
                                                _oldPass.text.isEmpty) {
                                              showSnackBar(
                                                  title: ApiConfig.error,
                                                  message:
                                                      'Please Fill Form First.');
                                            } else if (_newPass.text.characters
                                                        .length <
                                                    6 ||
                                                _confirmPass.text.characters
                                                        .length <
                                                    6 ||
                                                _oldPass.text.characters
                                                        .length <
                                                    6) {
                                              showSnackBar(
                                                  title: ApiConfig.error,
                                                  message:
                                                      'Password Must be Greater Then 6 Characters');
                                            } else if (_newPass.text ==
                                                _confirmPass.text) {
                                              loaderShow(context);
                                              SecurityController.to
                                                  .changeSecurityPassApi(
                                                params: {
                                                  "old_password": _oldPass.text,
                                                  "new_password": _newPass.text,
                                                  "password_confirmation":
                                                      _confirmPass.text,
                                                },
                                                success: () {
                                                  loaderHide();
                                                  Get.back();
                                                  showSnackBar(
                                                    title: ApiConfig.success,
                                                    message: SecurityController
                                                        .to
                                                        .changePassRes[
                                                            'message']
                                                        .toString(),
                                                  );
                                                },
                                                error: (e) {
                                                  loaderHide();
                                                  showSnackBar(
                                                    title: ApiConfig.error,
                                                    message: e.toString(),
                                                  );
                                                },
                                              );
                                            } else {
                                              showSnackBar(
                                                title: ApiConfig.error,
                                                message:
                                                    'New password And Confirm Password Not Match.',
                                              );
                                            }
                                          },
                                          name: 'Change Password',
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              Divider(
                                color: AppColors.color000000.withOpacity(0.2),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          );
                        },
                      ),
                      // Text(
                      //   'Social Accounts',
                      //   style: color00000s15w600,
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Text('Email', style: color50perBlacks13w400),
                      //     ),
                      //     InkWell(
                      //       onTap: () {},
                      //       splashColor: Colors.transparent,
                      //       highlightColor: Colors.transparent,
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //             border:
                      //                 Border.all(color: AppColors.color000000),
                      //             borderRadius: BorderRadius.circular(6)),
                      //         padding: const EdgeInsets.symmetric(
                      //             vertical: 5, horizontal: 12),
                      //         child: const Text('Connect'),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child:
                      //           Text('Facebook', style: color50perBlacks13w400),
                      //     ),
                      //     InkWell(
                      //       onTap: () {},
                      //       splashColor: Colors.transparent,
                      //       highlightColor: Colors.transparent,
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //             border:
                      //                 Border.all(color: AppColors.color000000),
                      //             borderRadius: BorderRadius.circular(6)),
                      //         padding: const EdgeInsets.symmetric(
                      //             vertical: 5, horizontal: 12),
                      //         child: const Text('Connect'),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child:
                      //           Text('Google', style: color50perBlacks13w400),
                      //     ),
                      //     InkWell(
                      //       onTap: () {},
                      //       splashColor: Colors.transparent,
                      //       highlightColor: Colors.transparent,
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //             border:
                      //                 Border.all(color: AppColors.color000000),
                      //             borderRadius: BorderRadius.circular(6)),
                      //         padding: const EdgeInsets.symmetric(
                      //             vertical: 5, horizontal: 12),
                      //         child: const Text('Connect'),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Divider(
                      //   color: AppColors.color000000.withOpacity(0.2),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      /*  Text(
                        'Account',
                        style: color00000s15w600,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Educative Your',
                                style: color50perBlacks13w400),
                          ),
                          InkWell(
                            onTap: () {},
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.color000000),
                                  borderRadius: BorderRadius.circular(6)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              child: const Text('Deactivate'),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),*/
                    ]),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget CommonTextFeildPart(
      {String? title,
      required TextEditingController controller,
      Widget? suffix,
      bool readOnly = false,
      GestureTapCallback? onTap,
      int? maxLines = 1,
      ValueChanged<String>? onChanged,
      TextInputType? keyboardType,
      bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? '',
            style: color00000s14w500,
          ),
          const SizedBox(
            height: 5,
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
            obscureText: obscureText,
            decoration: InputDecoration(
              suffixIcon: suffix,
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

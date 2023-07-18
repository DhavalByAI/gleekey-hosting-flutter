// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:gleeky_flutter/utills/fade_slide_transition.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/style/constants.dart';
import 'package:gleeky_flutter/utills/style/palette.dart';
import 'package:gleeky_flutter/utills/text_fields_widgets/custom_textfield_common.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../../../API/api_config.dart';
import '../../../google_signIn/google_Sign_in.dart';
import '../../../shared_Preference/prefController.dart';
import '../../../shared_Preference/preferences_helper.dart';
import '../../agent/bottom/agent.dart';
import '../../host/Main/main_screen.dart';
import '../controller/userLogin_controller.dart';
import '../model/user_model.dart';
import 'login.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({Key? key}) : super(key: key);

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _formElementAnimation;
  bool isOTPField = false;
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String? emailError;
  int? otp;
  var space;
  RxString deviceId = ''.obs;
  RxString fcmToken = ''.obs;
  Future<void> getDeviceIDUsingPlugin() async {
    deviceId.value = (await PlatformDeviceId.getDeviceId) ?? '';
    print('DEVICE ID ${deviceId.value}');

    fcmToken.value = (await FirebaseMessaging.instance.getToken()) ?? '';
    log(fcmToken.value, name: 'fcmToken');
  }

  @override
  void initState() {
    super.initState();
    getDeviceIDUsingPlugin();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    var fadeSlideTween = Tween<double>(begin: 0.0, end: 1.0);
    _formElementAnimation = fadeSlideTween.animate(CurvedAnimation(
      parent: _animationController!,
      curve: const Interval(
        0.45,
        0.8,
        curve: Curves.easeInOut,
      ),
    ));
    _animationController!.forward();
  }

  @override
  dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    space = height > 650 ? kSpaceM : kSpaceS;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          children: [
            backGroudImage(),
            FadeSlideTransition(
                animation: _formElementAnimation!,
                additionalOffset: space,
                child: mainView()),
          ],
        ),
      ),
    );
  }

  Widget backGroudImage() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 1.6,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              image: DecorationImage(
                  image: AssetImage('assets/images/login_background_image.png'),
                  fit: BoxFit.fill)),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 1.6,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            color: kBlack.withOpacity(0.4),
          ),
        )
      ],
    );
  }

  Widget mainView() {
    return Card(
      margin: EdgeInsets.only(
          right: 27, left: 27, top: MediaQuery.of(context).size.height / 3.8),
      shape: Palette.businessCardShape,
      elevation: 6,
      child: Container(
        //height: 465,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: Column(
          children: [
            FadeSlideTransition(
              animation: _formElementAnimation!,
              additionalOffset: space,
              child: Text(
                'Welcome To',
                style: Palette.loginText,
              ),
            ),
            FadeSlideTransition(
              animation: _formElementAnimation!,
              additionalOffset: space,
              child: Container(
                height: MediaQuery.of(context).size.height / 16,
                width: MediaQuery.of(context).size.width / 3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/app_logo.png'))),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FadeSlideTransition(
              animation: _formElementAnimation!,
              additionalOffset: space,
              child: CustomTextfieldCommon(
                controller: isOTPField ? otpController : mobileController,
                label: isOTPField ? 'Enter OTP' : 'Mobile Number',
                hint: isOTPField ? 'Enter OTP' : 'Mobile Number',
                textInputType: TextInputType.phone,
                inputFormatters: [
                  isOTPField
                      ? LengthLimitingTextInputFormatter(4)
                      : LengthLimitingTextInputFormatter(10)
                ],
                validate: (val) {
                  if (mobileController.text.isEmpty) {
                    return isOTPField
                        ? "Please Enter Correct OTP"
                        : "Please Enter Correct Mobile Number";
                  } else {
                    return null;
                  }
                },
                errorText: emailError,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            FadeSlideTransition(
              animation: _formElementAnimation!,
              additionalOffset: space,
              child: isOTPField ? verifyAndLogin() : sendOTP(),
            ),
            const SizedBox(
              height: 15,
            ),
            FadeSlideTransition(
              animation: _formElementAnimation!,
              additionalOffset: space,
              child: loginBtn(),
            ),
            const SizedBox(
              height: 15,
            ),
            FadeSlideTransition(
              animation: _formElementAnimation!,
              additionalOffset: space,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 100,
                    child: Divider(
                      color: kDarkGrey,
                      thickness: 0.7,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'or login with',
                    style: Palette.commonText1,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const SizedBox(
                    width: 100,
                    child: Divider(
                      color: kDarkGrey,
                      thickness: 0.7,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FadeSlideTransition(
                animation: _formElementAnimation!,
                additionalOffset: space,
                child: socialMediaBtn()),
          ],
        ),
      ),
    );
  }

  Widget sendOTP() {
    return MaterialButton(
        shape: Palette.subCardShape,
        color: kOrange,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 45,
          child: Center(
            child: Text(
              'Send OTP',
              style: Palette.btnText,
            ),
          ),
        ),
        onPressed: () {
          loaderShow(context);
          otpApi(
              params: {
                'phone_number': mobileController.text.toString(),
                'device_token': deviceId.value,
                'fcm_token': fcmToken.value,
                'otp': ''
              },
              error: (e) {
                loaderHide();
                showSnackBar(title: ApiConfig.error, message: e.toString());
              },
              success: () {
                loaderHide();
                isOTPField = true;
                otpController.clear();
              });
        });
  }

  Future<bool?> otpApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
        ApiConfig.sendOTP,
        data: isFormData ? dio.FormData.fromMap(params) : params,
      );

      if (response.statusCode == 200) {
        // user_model = User_model.fromJson(response.data);
        log("user model api ${response.data}");

        // PreferencesHelper().setPreferencesStringData(PreferencesHelper.Token,
        //     PrefController.to.token.value = user_model?.accessToken ?? '-');
        // PreferencesHelper().setPreferencesStringData(
        //     PreferencesHelper.user_id,
        //     PrefController.to.user_id.value =
        //         (user_model?.data?.id ?? '-').toString());

        if (response.data != null) {
          if (response.data['status'] == true) {
            if (success != null) {
              setState(() {
                otp = response.data['otp'];
                success();
              });
            }
          } else {
            if (error != null) {
              error(response.data['message']);
            }
          }
          return true;
        } else {
          if (error != null) {
            error(response.data['message']);
          }
          return false;
        }
      } else {
        log("user model api ${response.data}");
        if (error != null) {
          error(jsonDecode(response.data)['message']);
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.data?['message'] ?? "Something went wrong");
      }
      log("DIO ERROR ${e.message}");
    }
    return null;
  }

  Future<bool?> loginApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
        ApiConfig.sendOTP,
        data: isFormData ? dio.FormData.fromMap(params) : params,
      );

      if (response.statusCode == 200) {
        user_model = User_model.fromJson(response.data);
        log("user model api ${response.data}");

        PreferencesHelper().setPreferencesStringData(PreferencesHelper.Token,
            PrefController.to.token.value = user_model?.accessToken ?? '-');
        PreferencesHelper().setPreferencesStringData(
            PreferencesHelper.user_id,
            PrefController.to.user_id.value =
                (user_model?.data?.id ?? '-').toString());

        if (response.data != null) {
          if (response.data['status'] == true) {
            if (success != null) {
              success();
            }
          } else {
            if (error != null) {
              error(response.data['message']);
            }
          }
          return true;
        } else {
          if (error != null) {
            error(response.data['message']);
          }
          return false;
        }
      } else {
        log("user model api ${response.data}");
        if (error != null) {
          error(jsonDecode(response.data)['message']);
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.data?['message'] ?? "Something went wrong");
      }
      log("DIO ERROR ${e.message}");
    }
    return null;
  }

  Widget verifyAndLogin() {
    return MaterialButton(
        shape: Palette.subCardShape,
        color: kOrange,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 45,
          child: Center(
            child: Text(
              'Verify & Login',
              style: Palette.btnText,
            ),
          ),
        ),
        onPressed: () {
          loaderShow(context);
          loginApi(
            params: {
              'phone_number': mobileController.text.toString(),
              'device_token': deviceId.value,
              'fcm_token': fcmToken.value,
              'otp': otpController.text.toString(),
            },
            success: () {
              loaderHide();
              selectedBottom.value = 0;
              agentSelectedBottom.value = 0;
              Get.offAll(() => (((user_model?.data?.userAgent ?? 0) != 1) ||
                      ((user_model?.data?.userHost ?? 0) != 0))
                  ? MainScreen()
                  : AgentMainScreen());
              isOTPField = true;
            },
            error: (e) {
              loaderHide();
              showSnackBar(title: ApiConfig.error, message: e.toString());
            },
          );
        });
  }

  Widget loginBtn() {
    return GestureDetector(
      onTap: () {
        Get.offAll(() => const Login());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: Palette.registerText1,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
            'Login',
            style: Palette.registerText2,
          )
        ],
      ),
    );
  }

  Widget forgetPassword() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PhoneLogin()));
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(
          'Forgot password?',
          style: Palette.forgetPassText,
          textAlign: TextAlign.end,
        ),
      ),
    );
  }

  Widget socialMediaBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(),
        GetBuilder<UserController>(builder: (_) {
          return InkWell(
            onTap: () async {
              GoogleSignInApi.logout();
              final user = await GoogleSignInApi.login();
              if (user == null) {
                log('LOGIN FAIL');
              } else {
                log('LOGIN SucessFul');
                log('LOGIN $user');
                log('LOGIN ${user.email} ${user.displayName}');

                loaderShow(context);
                _.socialApi(
                  params: {
                    'device_token': deviceId.value,
                    'fcm_token': fcmToken.value,
                    "oauth_provider": "google",
                    "oauth_uid": user.id,
                    "first_name": user.displayName,
                    "email": user.email,
                    "image": user.photoUrl.toString(),
                    'user_host': '1',
                  },
                  error: (e) {
                    loaderHide();

                    showSnackBar(title: ApiConfig.error, message: e.toString());
                  },
                  success: () {
                    loaderHide();
                    selectedBottom.value = 0;
                    agentSelectedBottom.value = 0;
                    Get.offAll(() =>
                        (((user_model?.data?.userAgent ?? 0) != 1) ||
                                ((user_model?.data?.userHost ?? 0) != 0))
                            ? MainScreen()
                            : AgentMainScreen());
                  },
                );
              }
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/google_icon.png',
                  ),
                ),
              ),
            ),
          );
        }),
        InkWell(
          onTap: () async {
            final LoginResult result = await FacebookAuth.instance
                .login(); // by default we request the email and the public profile

            // loginBehavior is only supported for Android devices, for ios it will be ignored
            // final result = await FacebookAuth.instance.login(
            //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
            //   loginBehavior: LoginBehavior
            //       .DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
            // );

            if (result.status == LoginStatus.success) {
              // get the user data
              // by default we get the userId, email,name and picture
              final userData = await FacebookAuth.instance.getUserData();
              log(userData.toString());
              // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
            } else {
              print("result.status ${result.status}");
              print("result.message ${result.message}");
            }
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/facebook_icon.png'),
              ),
            ),
          ),
        ),
        // GestureDetector(
        //   onTap: () {
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => const PhoneLogin()));
        //     // Navigator.push(context,
        //     //     MaterialPageRoute(builder: (context) => const PhoneLogin()));
        //   },
        //   child: Container(
        //     height: 30,
        //     width: 30,
        //     decoration: const BoxDecoration(
        //         image: DecorationImage(
        //             image: AssetImage('assets/images/phone_icon.png'))),
        //   ),
        // ),
        const SizedBox(),
      ],
    );
  }
}

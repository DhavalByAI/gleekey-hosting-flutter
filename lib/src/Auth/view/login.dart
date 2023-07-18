import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/google_signIn/google_Sign_in.dart';
import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
import 'package:gleeky_flutter/src/Auth/view/register.dart';
import 'package:gleeky_flutter/src/agent/bottom/agent.dart';
import 'package:gleeky_flutter/src/host/Main/main_screen.dart';
import 'package:gleeky_flutter/utills/fade_slide_transition.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/style/constants.dart';
import 'package:gleeky_flutter/utills/style/palette.dart';
import 'package:gleeky_flutter/utills/text_fields_widgets/custom_textfield_common.dart';
import 'package:gleeky_flutter/utills/text_fields_widgets/custom_textfield_password.dart';
import 'forgot_password.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'phone_login.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _formElementAnimation;

  UserController controller = Get.put(UserController());

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
    if (kDebugMode) {}
    getDeviceIDUsingPlugin();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    var fadeSlideTween = Tween<double>(begin: 0.0, end: 1.0);
    _formElementAnimation = fadeSlideTween.animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(
          0.45,
          0.8,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _animationController!.forward();
  }

  @override
  dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UserLoginController getControler = Get.find();

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
              child: Stack(
                children: [
                  mainView(),
                ],
              ),
            ),
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
              bottomRight: Radius.circular(50),
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/login_background_image.png'),
              fit: BoxFit.fill,
            ),
          ),
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
          right: 27, left: 27, top: MediaQuery.of(context).size.height / 4.0),
      shape: Palette.businessCardShape,
      elevation: 6,
      child: GetBuilder<UserController>(
        initState: (_) {},
        builder: (_) {
          return Container(
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
                        image: AssetImage('assets/images/app_logo.png'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: CustomTextfieldCommon(
                    controller: _.emailController,
                    label: 'Email / Phone Number',
                    hint: 'Enter Your Email / Phone Number',
                    textInputType: TextInputType.emailAddress,
                    validate: _.validate,
                    errorText: _.emailError,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: CustomTextfieldPass(
                    controller: _.passwordController,
                    label: 'Password',
                    hint: 'Password',
                    validate: _.validate,
                    errorText: _.passwordError,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: forgetPassword(),
                ),
                const SizedBox(
                  height: 14,
                ),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: loginBtn(),
                ),
                const SizedBox(
                  height: 18,
                ),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: registerBtn(),
                ),
                const SizedBox(
                  height: 20,
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
          );
        },
      ),
    );
  }

  Widget loginBtn() {
    return GetBuilder<UserController>(
      builder: (_) {
        return MaterialButton(
          shape: Palette.subCardShape,
          color: kOrange,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: Center(
              child: Text(
                'Login',
                style: Palette.btnText,
              ),
            ),
          ),
          onPressed: () async {
            _.validate();

            if (_.emailError == null && _.passwordError == null) {
              loaderShow(context);
              _.loginApi(
                params: {
                  'email': _.emailController.text,
                  'password': _.passwordController.text,
                  'device_token': deviceId.value,
                  'fcm_token': fcmToken.value,
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
                  Get.offAll(() => (((user_model?.data?.userAgent ?? 0) != 1) ||
                          ((user_model?.data?.userHost ?? 0) != 0))
                      ? MainScreen()
                      : AgentMainScreen());
                },
              );
            }
          },
        );
      },
    );
  }

  Widget registerBtn() {
    return GestureDetector(
      onTap: () {
        Get.offAll(() => const Register());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Not A Member?',
            style: Palette.registerText1,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
            'Register Here',
            style: Palette.registerText2,
          )
        ],
      ),
    );
  }

  Widget forgetPassword() {
    return GestureDetector(
      onTap: () {
        Get.offAll(() => const ForgotPassword());
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
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PhoneLogin()));
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const PhoneLogin()));
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/phone_icon.png'))),
          ),
        ),
        const SizedBox(),
      ],
    );
  }
}

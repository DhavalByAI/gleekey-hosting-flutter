// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gleeky_flutter/src/Auth/controller/forgot_pass_controller.dart';

import 'package:gleeky_flutter/utills/fade_slide_transition.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/style/constants.dart';
import 'package:gleeky_flutter/utills/style/palette.dart';
import 'package:gleeky_flutter/utills/text_fields_widgets/custom_textfield_common.dart';

import 'login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _formElementAnimation;

  TextEditingController emailController = TextEditingController();
  String? emailError;

  var space;

  @override
  void initState() {
    super.initState();

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
                controller: emailController,
                label: 'Email ID',
                hint: 'Email',
                textInputType: TextInputType.emailAddress,
                validate: (val) {
                  if (emailController.text.isEmpty) {
                    return "Enter Correct Email Address";
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
              child: sendLinkToMail(),
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

  Widget sendLinkToMail() {
    return MaterialButton(
        shape: Palette.subCardShape,
        color: kOrange,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 45,
          child: Center(
            child: Text(
              'Send Link to Mail',
              style: Palette.btnText,
            ),
          ),
        ),
        onPressed: () {
          if (emailController.text.isEmpty) {
            emailError = "Enter Email Address";
          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(emailController.text)) {
            emailError = "Enter Correct Email Address";
          } else {
            emailError = null;
            loaderShow(context);
            ForgotPasswordController.to.forgotPassApi(
                params: {"email": emailController.text},
                error: (e) {
                  loaderHide();
                  print(e.toString());
                },
                success: () {
                  loaderHide();
                });
          }
          setState(() {});
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
            MaterialPageRoute(builder: (context) => const ForgotPassword()));
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
        Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/google_icon.png'))),
        ),
        Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/facebook_icon.png'))),
        ),
        GestureDetector(
          onTap: () {},
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

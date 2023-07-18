import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/src/Auth/controller/userRegister_controller.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/fade_slide_transition.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/style/constants.dart';
import 'package:gleeky_flutter/utills/style/palette.dart';
import 'package:gleeky_flutter/utills/text_fields_widgets/custom_textfield_common.dart';
import 'package:gleeky_flutter/utills/text_fields_widgets/custom_textfield_password.dart';
import 'package:intl/intl.dart';

import '../controller/userLogin_controller.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _formElementAnimation;

  bool obsecure1 = true;
  bool obsecure2 = true;
  UserResistorController getController = Get.put(UserResistorController());
  var space;

  RxString countryCode = '91'.obs;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: kLoginAnimationDuration,
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
  Widget build(BuildContext context) {
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    space = height > 650 ? kSpaceM : kSpaceS;

    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
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
                bottomRight: Radius.circular(50)),
            color: kBlack.withOpacity(0.4),
          ),
        )
      ],
    );
  }

  Widget mainView() {
    return Card(
      margin: EdgeInsets.only(
          right: 27, left: 27, top: MediaQuery.of(context).size.height / 14),
      shape: Palette.businessCardShape,
      elevation: 6,
      child: Container(
        // height: 380,
        padding: const EdgeInsets.all(20),
        child: GetBuilder<UserResistorController>(
          initState: (_) {},
          builder: (_) {
            return Column(
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
                    controller: getController.firstNameController,
                    label: 'First Name',
                    hint: 'Enter your name',
                    errorText: _.firstNameError,
                    validate: _.validate,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: CustomTextfieldCommon(
                    controller: getController.lastNameController,
                    label: 'Last Name',
                    hint: 'Enter your name',
                    validate: _.validate,
                    errorText: _.lastNameError,
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
                    label: 'Email',
                    validate: _.validate,
                    hint: 'Enter your Email',
                    errorText: _.emailError,
                    textInputType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: CustomTextfieldCommon(
                    controller: getController.phoneController,
                    prefix: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            favorite: <String>['IN'],
                            countryListTheme: CountryListThemeData(
                              flagSize: 25,
                              backgroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                              bottomSheetHeight: Get.height /
                                  1.5, // Optional. Country list modal height
                              //Optional. Sets the border radius for the bottomsheet.
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              //Optional. Styles the search field.

                              inputDecoration: InputDecoration(
                                  // labelText: 'Search',
                                  hintText: 'Start typing to search',
                                  prefixIcon: const Icon(Icons.search),
                                  focusColor: AppColors.colorFE6927,
                                  iconColor: AppColors.colorFE6927,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.color000000
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.color000000
                                          .withOpacity(0.5),
                                    ),
                                  )),
                            ),
                            onSelect: (Country country) =>
                                countryCode.value = country.phoneCode);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '+ ${countryCode.value} ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: kBlack,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down_outlined)
                          ],
                        ),
                      ),
                    ),
                    label: 'Phone Number',
                    validate: _.validate,
                    hint: 'Enter your Phone Number',
                    textInputType: TextInputType.phone,
                    errorText: _.phoneError,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: CustomTextfieldPass(
                    controller: getController.passwordController,
                    label: 'Password',
                    hint: 'Password',
                    errorText: _.passwordError,
                    validate: _.validate,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: CustomTextfieldPass(
                    controller: getController.confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Confirm Password',
                    errorText: _.cnfmPasswordError,
                    validate: _.validate,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: CustomTextfieldCommon(
                    controller: getController.birthdateController,
                    label: 'Birthdate',
                    validate: _.validate,
                    onTap: () async {
                      _.birthdate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000, 01, 01),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.colorFE6927, // <-- SEE HERE
                                // onPrimary:
                                //     AppColors.colorFE6927, // <-- SEE HERE
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: AppColors
                                      .colorFE6927, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (_.birthdate != null) {
                        print(_
                            .birthdate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(_.birthdate!);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          _.birthdateController.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                    readOnly: true,
                    hint: 'Enter your Birthdate',
                    errorText: _.birthdateError,
                  ),
                ),
                const SizedBox(
                  height: 14,
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
                  child: loginBtn(),
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
                        'or register with',
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
            );
          },
        ),
      ),
    );
  }

  Widget registerBtn() {
    return GetBuilder<UserResistorController>(
      initState: (_) {},
      builder: (_) {
        return MaterialButton(
          shape: Palette.subCardShape,
          color: kOrange,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: Center(
              child: Text(
                'Sign Up',
                style: Palette.btnText,
              ),
            ),
          ),
          onPressed: () async {
            _.isValidate = true;
            _.validate();
            if (_.emailError == null &&
                _.firstNameError == null &&
                _.lastNameError == null &&
                _.phoneError == null &&
                _.passwordError == null &&
                _.cnfmPasswordError == null &&
                _.birthdateError == null) {
              loaderShow(context);

              Map<String, dynamic> params = {
                'first_name': _.firstNameController.text,
                'last_name': _.lastNameController.text,
                'email': _.emailController.text,
                'phone': _.phoneController.text,
                'carrier_code': countryCode.value.toString(),
                'formatted_phone':
                    '+' + countryCode.value.toString() + _.phoneController.text,
                'password': _.passwordController.text,
                'birthday_day': _.birthdate?.day.toString(),
                'birthday_month': _.birthdate?.month.toString(),
                'birthday_year': _.birthdate?.year.toString(),
                'confirm_password': _.confirmPasswordController.text,
                'user_host': '1'
              };
              log("REGISTER API PARAMS " + params.toString());
              _.getApi(
                params: params,
                success: () {
                  loaderHide();

                  Get.offAll(() => Login());
                  showSnackBar(
                      title: ApiConfig.success,
                      message:
                          'You have been registered on Gleekey successfully. Please verify your email to login');
                },
                error: (e) {
                  loaderHide();

                  showSnackBar(title: ApiConfig.error, message: e.toString());
                },
              );
            }
          },
        );
      },
    );
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

  Widget socialMediaBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(),
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
          onTap: () {
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
        SizedBox(),
      ],
    );
  }
}

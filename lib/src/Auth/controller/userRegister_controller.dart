import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/shared_Preference/preferences_helper.dart';
import 'package:gleeky_flutter/src/Auth/model/user_model.dart';
import 'package:gleeky_flutter/utills/baseconstant.dart';
import 'package:http/http.dart' as http;

import 'userLogin_controller.dart';

class UserResistorController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();

  DateTime? birthdate;

  String? emailError;
  String? firstNameError;
  String? lastNameError;
  String? phoneError;
  String? passwordError;
  String? cnfmPasswordError;
  String? birthdateError;

  bool isUserLogedIn = false;
  bool isValidate = false;

  String? email;
  String? password;

  getApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse(BaseConstant.BASE_URL + EndPoint.ragister),
        body: params,
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        PreferencesHelper().setPreferencesStringData(PreferencesHelper.Token,
            PrefController.to.token.value = user_model?.accessToken ?? '-');
        PreferencesHelper().setPreferencesStringData(
            PreferencesHelper.user_id,
            PrefController.to.user_id.value =
                user_model?.data?.id.toString() ?? '-');

        if (json.decode(response.body) != null) {
          if (result['status'] == true) {
            print('RESULT $result');
            user_model = User_model.fromJson(result);
            if (success != null) {
              success();
            }
          } else {
            if (error != null) {
              error(jsonDecode(response.body)['message']);
            }
          }
          return true;
        } else {
          if (error != null) {
            error(jsonDecode(response.body)['message']);
          }
          return false;
        }
      } else {
        log("user model api ${response.body}");
        if (error != null) {
          error(jsonDecode(response.body)['message']);
        }
      }
    } catch (e) {
      log(e.toString());
      if (error != null) {
        error("Something went wrong");
      }
    }

    update();
  }

  validate() {
    log("Velidating");
    emailError = emailValidator();
    firstNameError = firstNameValidator();
    lastNameError = lastNameValidator();
    phoneError = phoneValidator();
    passwordError = passwordValidator();
    cnfmPasswordError = cnfmpasswordValidator();
    birthdateError = birthdateValidator();
    update();
  }

  String? emailValidator() {
    if (emailController.text.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(emailController.text)) {
      return "Enter Correct Email Address";
    } else {
      return null;
    }
  }

  String? firstNameValidator() {
    if (firstNameController.text.isEmpty ||
        !RegExp(r'^[a-z A-Z]+$').hasMatch(firstNameController.text)) {
      return "Enter Correct First Name";
    } else {
      return null;
    }
  }

  String? lastNameValidator() {
    if (lastNameController.text.isEmpty ||
        !RegExp(r'^[a-z A-Z]+$').hasMatch(lastNameController.text)) {
      return "Enter Correct Last Name";
    } else {
      return null;
    }
  }

  String? phoneValidator() {
    if (phoneController.text.isEmpty) {
      return "Please Enter Phone Number";
    } else if (phoneController.text.characters.length < 5 ||
        phoneController.text.characters.length > 12) {
      return "Please Enter Correct Phone Number";
    } else {
      return null;
    }
  }

  String? passwordValidator() {
    if (passwordController.text.isEmpty) {
      return "Enter Password";
    } else if (passwordController.text.characters.length < 6) {
      return "Password Must be Greater Then 6 Characters";
    } else {
      return null;
    }
  }

  String? cnfmpasswordValidator() {
    if (confirmPasswordController.text.isEmpty) {
      return "Enter Password";
    } else if (confirmPasswordController.text.characters.length < 6) {
      return "Password Must be Greater Then 6 Characters";
    } else if (!(confirmPasswordController.text == passwordController.text)) {
      return "Password Not Match";
    } else {
      return null;
    }
  }

  String? birthdateValidator() {
    if (birthdate == null) {
      return "Please Select Birthdate.";
    }
    return null;
  }
}

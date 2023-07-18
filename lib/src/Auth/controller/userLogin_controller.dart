import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/shared_Preference/preferences_helper.dart';
import 'package:gleeky_flutter/src/Auth/model/user_model.dart';
import 'package:dio/dio.dart' as dio;

User_model? user_model;

class UserController extends GetxController {
  String? emailError;
  String? passwordError;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  validate() {
    log("Velidating");
    emailError = emailValidator();

    passwordError = passwordValidator();

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

  String? passwordValidator() {
    if (passwordController.text.isEmpty) {
      return "Enter Password";
    } else if (passwordController.text.characters.length < 6) {
      return "Password Must be Greater Then 6 Characters";
    } else {
      return null;
    }
  }

  Future<bool?> loginApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
        ApiConfig.login,
        data: isFormData ? dio.FormData.fromMap(params) : params,
      );

      if (response.statusCode == 200) {
        user_model = User_model.fromJson(response.data);
        log("user model api " + response.data.toString());

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
        log("user model api " + response.data.toString());
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

  Future<bool?> socialApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    log(params.toString(), name: 'SOCIAL SIGN IN');
    try {
      dio.Response response = await dio.Dio().post(
        ApiConfig.social_media_login,
        data: isFormData ? dio.FormData.fromMap(params) : params,
      );

      if (response.statusCode == 200) {
        user_model = User_model.fromJson(response.data);
        log("user model api " + response.data.toString());

        PreferencesHelper().setPreferencesStringData(PreferencesHelper.Token,
            PrefController.to.token.value = user_model?.accessToken ?? '-');

        log(user_model?.accessToken ?? '-', name: 'AUTH TOKEN');

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
        log("user model api " + response.data.toString());
        if (error != null) {
          error(jsonDecode(response.data)['message']);
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error((e.response?.data?['message'] ?? "Something went wrong"));
      }
      log("DIO ERROR ${e.message}");
    }
    return null;
  }
}

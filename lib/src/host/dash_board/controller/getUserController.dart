import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
import 'package:gleeky_flutter/src/Auth/model/user_model.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

class GetUserController extends GetxController {
  static GetUserController get to => Get.put(GetUserController());

  Future<bool?> getUserApi({
    Function? success,
    Function? error,
  }) async {
    try {
      dio.Response response = await dio.Dio().get(
        ApiConfig.get_user_info,
        options: dio.Options(
          headers: {'Authorization': 'Bearer ${PrefController.to.token.value}'},
          sendTimeout: 60000,
          receiveTimeout: 60000,
        ),
      );

      if (response.statusCode == 200) {
        log('GET USER DATA ${response.data}');
        if (response.data != null) {
          if (response.data['status'] == true) {
            var result = response.data;
            user_model = User_model.fromJson(result);
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
        if (error != null) {
          error(jsonDecode(response.data)['message']);
        }
      }
    } on dio.DioError catch (e) {
      if (e.type == dio.DioErrorType.connectTimeout) {
        Get.defaultDialog(
            title: 'Connection TimeOut',
            barrierDismissible: false,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            content: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Please try again after SomeTime',
                  style: color00000s14w500,
                )
              ],
            ),
            radius: 10);
      } else if (e.type == dio.DioErrorType.receiveTimeout) {
        Get.defaultDialog(
            title: 'Connection TimeOut',
            barrierDismissible: false,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            content: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Please try again after SomeTime',
                  style: color00000s14w500,
                )
              ],
            ),
            radius: 10);
      }
      if (error != null) {
        error(e.response?.statusMessage ?? "Something went wrong");
      }
    }
    return null;
  }
}

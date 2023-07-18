import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:gleeky_flutter/API/api_config.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get to => Get.put(ForgotPasswordController());

  RxMap<String, dynamic> forgotPassResponse = <String, dynamic>{}.obs;
  Future<bool?> forgotPassApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
        ApiConfig.forgotpass,
        data: isFormData ? dio.FormData.fromMap(params) : params,
      );

      if (response.statusCode == 200) {
        forgotPassResponse.value = response.data ?? {};

        if (response.data != null) {
          log('forgotPassResponse API ' + forgotPassResponse.value.toString());
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
        if (error != null) {
          error(jsonDecode(response.data)['message']);
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.statusMessage ?? "Something went wrong");
      }
    }
    return null;
  }
}

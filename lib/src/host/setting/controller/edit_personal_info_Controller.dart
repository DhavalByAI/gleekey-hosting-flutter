import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/src/Auth/view/login.dart';

class EditPersonalInfoController extends GetxController {
  static EditPersonalInfoController get to =>
      Get.put(EditPersonalInfoController());

  RxMap<String, dynamic> updateResponse = <String, dynamic>{}.obs;
  Future<bool?> editPersonalInfoAPI({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(ApiConfig.updateProfile,
          data: isFormData ? dio.FormData.fromMap(params) : params,
          options: dio.Options(headers: {
            'Authorization': 'Bearer ${PrefController.to.token.value}'
          }));

      if (response.statusCode == 200) {
        updateResponse.value = response.data ?? {};

        if (response.data != null) {
          print('updateResponse  ' + updateResponse.value.toString());
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
        error(e.response?.data['message'] ?? "Something went wrong");
        if (e.response?.data['message'] == "Token has expired") {
          Get.offAll(const Login());
        }
      }
    }
    return null;
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/src/Auth/view/login.dart';

class InsightController extends GetxController {
  static InsightController get to => Get.put(InsightController());

  RxList reviewsToWrite = [].obs;
  RxList reviewsByYou = [].obs;
  RxList expiredReviews = [].obs;

  RxMap<String, dynamic> insightApiResponse = <String, dynamic>{}.obs;
  Future<bool?> insightApi({
    required Map<String, dynamic> params,
    Map<String, dynamic>? query,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(ApiConfig.reviews,
          data: isFormData ? dio.FormData.fromMap(params) : params,
          queryParameters: query,
          options: dio.Options(headers: {
            'Authorization': 'Bearer ${PrefController.to.token.value}'
          }));

      if (response.statusCode == 200) {
        insightApiResponse.value = response.data ?? {};

        if (response.data != null) {
          log('insightApiResponse API ' + insightApiResponse.value.toString());
          if (response.data['status'] == true) {
            if (success != null) {
              success();
            }
          } else {
            if (error != null) {
              error(response.data['message'].toString());
            }
          }
          return true;
        } else {
          if (error != null) {
            error(response.data['message'].toString());
          }
          return false;
        }
      } else {
        if (error != null) {
          error(jsonDecode(response.data)['message'].toString());
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.data['message'].toString() ?? "Something went wrong");
        if (e.response?.data['message'] == "Token has expired") {
          Get.offAll(const Login());
        }
      }
    }
    return null;
  }
}

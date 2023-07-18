import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/src/Auth/view/login.dart';

class AgentDashboardController extends GetxController {
  static AgentDashboardController get to => Get.put(AgentDashboardController());

  RxMap<String, dynamic> getagentDashboardRes = <String, dynamic>{}.obs;

  Future<bool?> getagentDashboardApi(
      {Function? success, Function? error}) async {
    try {
      dio.Response response = await dio.Dio().get(ApiConfig.get_agent_dashboard,
          options: dio.Options(headers: {
            'Authorization': 'Bearer ${PrefController.to.token.value}'
          }));

      if (response.statusCode == 200) {
        getagentDashboardRes.value = response.data;
        log('getagentDashboardRes ${getagentDashboardRes.value}');

        if (response.data != null) {
          if (success != null) {
            success();
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
          Get.offAll(() => const Login());
        }
      }
    }
    return null;
  }
}

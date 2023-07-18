import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';

class HostingController extends GetxController {
  static HostingController get to => Get.put(HostingController());
  RxMap<String, dynamic> getStartHostRes = <String, dynamic>{}.obs;
  RxDouble sendPer = 0.0.obs;
  Future<bool?> hostPropertyApi(
      {required Map<String, dynamic> params,
      Function? success,
      Function? error,
      bool isFormData = false,
      required String id,
      required String step}) async {
    try {
      print("${ApiConfig.hostProperty}$id/$step");
      log("PARAMS ${params.toString()}");
      dio.Response response = await dio.Dio().post(
        "${ApiConfig.hostProperty}$id/$step",
        data: isFormData ? dio.FormData.fromMap(params) : params,
        options: dio.Options(
          headers: {'Authorization': 'Bearer ${PrefController.to.token.value}'},
        ),
        onSendProgress: (int sent, int total) {
          sendPer.value = ((sent * 100) / total);
        },
      );

      if (response.statusCode == 200) {
        getStartHostRes.value = response.data ?? {};

        log('getHost ===>>> ${getStartHostRes.value}');
        log('getHost Params ===>>> ${[params]}');

        if (response.data != null) {
          if (response.data['status'] == true) {
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
            error(response.data['message']);
          }
        }
      } else {
        if (error != null) {
          error(jsonDecode(response.data)['message']);
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.statusMessage ?? "Something Went Wrong");
      }
    }
    return null;
  }
}

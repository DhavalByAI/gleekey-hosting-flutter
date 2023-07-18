import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.put(NotificationController());

  RxMap<String, dynamic> getNotificationRes = <String, dynamic>{}.obs;

  RxList notificationList = [].obs;

  Future<bool?> getNotificationApi(
      {required Map<String, dynamic> params,
      Function? success,
      Function? error}) async {
    try {
      dio.Response response = await dio.Dio().post(
          ApiConfig.get_all_notification,
          data: params,
          options: dio.Options(headers: {
            'Authorization': 'Bearer ${PrefController.to.token.value}'
          }));

      if (response.statusCode == 200) {
        getNotificationRes.value = response.data;
        log('getNotificationRes.value ${getNotificationRes.value}');

        if (response.data['status'] != false) {
          notificationList.addAll(response.data['data'] ?? []);

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
      }
    }
    return null;
  }
}

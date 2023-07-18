import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';

class GetRoomNameController extends GetxController {
  static GetRoomNameController get to => Get.put(GetRoomNameController());

  RxMap<String, dynamic> getRoomName = <String, dynamic>{}.obs;

  Future<bool?> getRoomnameApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
        ApiConfig.get_all_room_names,
        data: isFormData ? dio.FormData.fromMap(params) : params,
        options: dio.Options(
          headers: {'Authorization': 'Bearer ${PrefController.to.token.value}'},
        ),
      );

      if (response.statusCode == 200) {
        getRoomName.value = response.data ?? {};

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

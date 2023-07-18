import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';

class DeletImageHotelController extends GetxController {
  static DeletImageHotelController get to =>
      Get.put(DeletImageHotelController());

  RxMap<String, dynamic> deleteImageResponse = <String, dynamic>{}.obs;

  Future<bool?> deletRoomImageApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
        ApiConfig.hotel_room_image_delete,
        data: params,
        options: dio.Options(
          headers: {'Authorization': 'Bearer ${PrefController.to.token.value}'},
        ),
      );

      if (response.statusCode == 200) {
        deleteImageResponse.value = response.data ?? {};

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

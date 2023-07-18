import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';

class GetPriceController extends GetxController {
  static GetPriceController get to => Get.put(GetPriceController());

  RxMap<String, dynamic> get_property_calender_priceRes =
      <String, dynamic>{}.obs;

  RxList OngoingReservation = [].obs;
  RxList UpcomingReservation = [].obs;
  RxList CompletedReservation = [].obs;

  Future<bool?> get_property_calender_price_Api({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
        ApiConfig.get_property_calender_price,
        data: params,
        options: dio.Options(
          headers: {'Authorization': 'Bearer ${PrefController.to.token.value}'},
        ),
      );

      if (response.statusCode == 200) {
        get_property_calender_priceRes.value = response.data ?? {};
        log('get_property_calender_priceRes ===>>> ${get_property_calender_priceRes.value}');

        if (response.data != null) {
          if (response.data['status'] == true) {
            OngoingReservation.addAll(
                get_property_calender_priceRes['reservations_data']
                        ?['current_bookings'] ??
                    []);
            UpcomingReservation.addAll(
                get_property_calender_priceRes['reservations_data']
                        ?['upcoming_bookings'] ??
                    []);
            CompletedReservation.addAll(
                get_property_calender_priceRes['reservations_data']
                        ?['completed_bookings'] ??
                    []);

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

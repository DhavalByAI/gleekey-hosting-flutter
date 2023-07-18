import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/src/Auth/view/login.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';

class DashBoardController extends GetxController {
  static DashBoardController get to => Get.put(DashBoardController());

  RxMap<String, dynamic> reservationResponse = <String, dynamic>{}.obs;

  RxList AllReservation = [].obs;
  RxList OngoingReservation = [].obs;
  RxList UpcomingReservation = [].obs;
  RxList CompletedReservation = [].obs;
  RxList CancelledReservation = [].obs;
  /*'bookings',
  'current_bookings',
  'upcoming_bookings',
  'completed_bookings',
  'expired_bookings',*/

  Future<bool?> reservationApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(ApiConfig.reservation,
          data: isFormData ? dio.FormData.fromMap(params) : params,
          options: dio.Options(headers: {
            'Authorization': 'Bearer ${PrefController.to.token.value}'
          }));

      if (response.statusCode == 200) {
        reservationResponse.value = response.data ?? {};

        if (response.data != null) {
          log('Reservation API ${reservationResponse.value}');
          if (response.data['status'] == true) {
            AllReservation.clear();
            OngoingReservation.clear();
            UpcomingReservation.clear();
            CompletedReservation.clear();
            CancelledReservation.clear();
            AllReservation.addAll(DashBoardController
                    .to.reservationResponse['data']?['bookings'] ??
                []);
            OngoingReservation.addAll(DashBoardController
                    .to.reservationResponse['data']?['current_bookings'] ??
                []);
            UpcomingReservation.addAll(DashBoardController
                    .to.reservationResponse['data']?['upcoming_bookings'] ??
                []);
            CompletedReservation.addAll(DashBoardController
                    .to.reservationResponse['data']?['completed_bookings'] ??
                []);
            CancelledReservation.addAll(DashBoardController
                    .to.reservationResponse['data']?['expired_bookings'] ??
                []);
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

  RxMap<String, dynamic> allPropertyResponse = <String, dynamic>{}.obs;
  RxList allPropertyListing = [].obs;

  Future<bool?> allPropertyApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
  }) async {
    try {
      log('All Listring Params $params');
      dio.Response response = await dio.Dio().get(ApiConfig.allProperties,
          queryParameters: params,
          options: dio.Options(headers: {
            'Authorization': 'Bearer ${PrefController.to.token.value}'
          }));

      if (response.statusCode == 200) {
        allPropertyResponse.value = response.data ?? {};

        if (response.data != null) {
          log('allPropertyResponse API ${allPropertyResponse.value}');
          if (response.data['status'] == true) {
            allPropertyListing.addAll(DashBoardController
                .to.allPropertyResponse['data']['properties']);

            /*   DashBoardController.to.allPropertyResponse['data']['properties']
                .sort((a, b) {
              //sorting in ascending order
              return DateTime.parse(a['updated_at'].toString())
                  .compareTo(DateTime.parse(b['updated_at'].toString()));
            });*/
            print('ALL LISTING DATA LENGTH ${allPropertyListing.length}');
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

  RxMap<String, dynamic> unlistedPropertyRes = <String, dynamic>{}.obs;
  Future<bool?> unlistedPropertyAPI({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(ApiConfig.allProperties,
          data: isFormData ? dio.FormData.fromMap(params) : params,
          options: dio.Options(headers: {
            'Authorization': 'Bearer ${PrefController.to.token.value}'
          }));

      if (response.statusCode == 200) {
        unlistedPropertyRes.value = response.data ?? {};

        if (response.data != null) {
          log('unlistedPropertyRes API ${unlistedPropertyRes.value}');
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
                ),
                const SizedBox(
                  height: 8,
                ),
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
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
            radius: 10);
      } else if (error != null) {
        error(e.response?.statusMessage ?? "Something went wrong");
      }
    }
    return null;
  }
}

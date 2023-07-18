import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';

class WishListController extends GetxController {
  static WishListController get to => Get.put(WishListController());

  RxMap<String, dynamic> wishListResponse = <String, dynamic>{}.obs;
  Future<bool?> wishListDataApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(ApiConfig.wishListData,
          data: isFormData ? dio.FormData.fromMap(params) : params,
          options: dio.Options(headers: {
            'Authorization': 'Bearer ${PrefController.to.token.value}'
          }));

      if (response.statusCode == 200) {
        wishListResponse.value = response.data ?? {};

        if (response.data != null) {
          log('wishListData API ' + wishListResponse.value.toString());
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

  RxMap<String, dynamic> addAndRemoveFromWishListRes = <String, dynamic>{}.obs;
  Future<bool?> addAndRemoveFromWishListApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(ApiConfig.addEditWishlist,
          data: isFormData ? dio.FormData.fromMap(params) : params,
          options: dio.Options(headers: {
            'Authorization': 'Bearer ${PrefController.to.token.value}'
          }));

      if (response.statusCode == 200) {
        addAndRemoveFromWishListRes.value = response.data ?? {};

        if (response.data != null) {
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

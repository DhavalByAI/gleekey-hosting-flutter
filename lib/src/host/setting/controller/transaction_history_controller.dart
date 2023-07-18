import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';

class TransactionHistoryControlller extends GetxController {
  static TransactionHistoryControlller get to =>
      Get.put(TransactionHistoryControlller());

  RxMap<String, dynamic> transactionHistoryResponse = <String, dynamic>{}.obs;
  RxList transactionHistoryData = [].obs;
  Future<bool?> transactionHistoryApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    print('PARAMS $params');
    try {
      dio.Response response = await dio.Dio().post(
        ApiConfig.transactionHistory,
        data: isFormData ? dio.FormData.fromMap(params) : params,
        options: dio.Options(
          headers: {'Authorization': 'Bearer ${PrefController.to.token.value}'},
        ),
      );

      if (response.statusCode == 200) {
        transactionHistoryResponse.value = response.data ?? {};

        if (response.data != null) {
          print('TRANSACTION HISTORY API ${transactionHistoryResponse.value}');
          if (response.data['status'] == true) {
            transactionHistoryData.value.addAll(TransactionHistoryControlller
                .to.transactionHistoryResponse['data']);

            log(transactionHistoryData.value.toString());
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

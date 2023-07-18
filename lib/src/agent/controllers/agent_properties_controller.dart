import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';

class AgentPropertiesController extends GetxController {
  static AgentPropertiesController get to =>
      Get.put(AgentPropertiesController());

  RxMap<String, dynamic> agentPropertiesResponse = <String, dynamic>{}.obs;
  RxList agentPropertiesList = [].obs;
  Future<bool?> agentPropertiesApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
          ApiConfig.agent_property_list,
          data: isFormData ? dio.FormData.fromMap(params) : params,
          options: dio.Options(headers: {
            'Authorization': 'Bearer ${PrefController.to.token.value}'
          }));

      if (response.statusCode == 200) {
        agentPropertiesResponse.value = response.data ?? {};

        if (response.data != null) {
          log('agentPropertiesResponse API ' +
              agentPropertiesResponse.value.toString());
          if (response.data['status'] == true) {
            agentPropertiesList
                .addAll(agentPropertiesResponse['data']?['properties'] ?? []);
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

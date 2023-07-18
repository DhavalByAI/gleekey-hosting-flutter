import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/src/Auth/view/login.dart';

class KycController extends GetxController {
  static KycController get to => Get.put(KycController());

  RxMap<String, dynamic> getCountryRes = <String, dynamic>{}.obs;
  Future<bool?> getCountryApi({
    Function? success,
    Function? error,
  }) async {
    try {
      dio.Response response = await dio.Dio().get(
        ApiConfig.get_country,
      );

      if (response.statusCode == 200) {
        if (response.data != null) {
          if (response.data['status'] == true) {
            getCountryRes.value = response.data;
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

  Future<bool?> becomeAnAgent({
    Function? success,
    Function? error,
  }) async {
    try {
      dio.Response response = await dio.Dio().get(
        ApiConfig.becomeAgent,
      );

      if (response.statusCode == 200) {
        if (response.data != null) {
          if (response.data['status'] == true) {
            getCountryRes.value = response.data;
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

  RxMap<String, dynamic> getStateRes = <String, dynamic>{}.obs;
  Future<bool?> getStateApi({
    required Map params,
    Function? success,
    Function? error,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
        ApiConfig.get_state,
        data: params,
      );

      if (response.statusCode == 200) {
        if (response.data != null) {
          if (response.data['status'] == true) {
            getStateRes.value = response.data;
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

  RxMap<String, dynamic> getCityRes = <String, dynamic>{}.obs;
  Future<bool?> getCityApi({
    required Map params,
    Function? success,
    Function? error,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
        ApiConfig.get_city,
        data: params,
      );

      if (response.statusCode == 200) {
        print('GET CITY API DATA ${response.data}');
        if (response.data != null) {
          if (response.data['status'] == true) {
            getCityRes.value = response.data;
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

  RxMap<String, dynamic> getbankListRes = <String, dynamic>{}.obs;
  Future<bool?> getBankListApi({
    Function? success,
    Function? error,
  }) async {
    try {
      dio.Response response = await dio.Dio().get(
        ApiConfig.get_bank_list,
      );

      if (response.statusCode == 200) {
        log('GET BNK LIST DATA ${response.data}');
        if (response.data != null) {
          if (response.data['status'] == true) {
            getbankListRes.value = response.data;
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

  RxMap<String, dynamic> getKYCResponse = <String, dynamic>{}.obs;
  Future<bool?> getKYCApi({
    Function? success,
    Function? error,
  }) async {
    try {
      dio.Response response = await dio.Dio().get(
        ApiConfig.get_kyc_data,
        options: dio.Options(
          headers: {'Authorization': 'Bearer ${PrefController.to.token.value}'},
        ),
      );

      if (response.statusCode == 200) {
        getKYCResponse.value = response.data ?? {};
        print('GET KYC DATA ${getKYCResponse.value}');
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
        error(e.response?.data['message'] ?? "Something went wrong");
        if (e.response?.data['message'] == "Token has expired") {
          Get.offAll(const Login());
        }
      }
    }
    return null;
  }

  RxMap<String, dynamic> postKycDataRes = <String, dynamic>{}.obs;

  Future<bool?> postKYCApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
        ApiConfig.post_user_kyc_data,
        data: isFormData ? dio.FormData.fromMap(params) : params,
        options: dio.Options(headers: {
          'Authorization': 'Bearer ${PrefController.to.token.value}'
        }),
      );

      if (response.statusCode == 200) {
        postKycDataRes.value = response.data ?? {};

        if (response.data != null) {
          log('postKycDataRes API ${postKycDataRes.value}');
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

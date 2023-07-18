import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class GoogleLocationController extends GetxController {
  static GoogleLocationController get to => Get.put(GoogleLocationController());

  RxMap<String, dynamic> getLocationFromLongAndlatitude =
      <String, dynamic>{}.obs;
  Future<bool?> getLocation({
    required String longitude,
    required String latitude,
    Function? success,
    Function? error,
  }) async {
    try {
      String host = 'https://maps.google.com/maps/api/geocode/json';
      final url =
          '$host?key=AIzaSyAsXCP8XNZCYRH6jcRQD1codAVPG8KJVs4&language=en&latlng=$latitude,$longitude';
      dio.Response response = await dio.Dio().get(url);

      if (response.statusCode == 200) {
        getLocationFromLongAndlatitude.value =
            response.data["results"][0] ?? {};

        log(response.data["results"][0].toString());

        Map location = (getLocationFromLongAndlatitude['formatted_address']
                    .toString()
                    .contains(',') &&
                getLocationFromLongAndlatitude['formatted_address']
                        .toString()
                        .split(',')
                        .length >=
                    2)
            ? {
                'AddressLine1':
                    getLocationFromLongAndlatitude['formatted_address']
                        .toString(),
                'Country': getLocationFromLongAndlatitude['formatted_address']
                        .toString()
                        .contains(',')
                    ? getLocationFromLongAndlatitude['formatted_address']
                        .toString()
                        .split(',')
                        .reversed
                        .toList()[0]
                        .toString()
                    : '',
                'State': getLocationFromLongAndlatitude['formatted_address']
                        .toString()
                        .contains(',')
                    ? (getLocationFromLongAndlatitude['formatted_address']
                            .toString()
                            .split(',')
                            .reversed
                            .toList()[1]
                            .toString()
                            .replaceFirst(' ', '')
                            .contains(' ')
                        ? getLocationFromLongAndlatitude['formatted_address']
                            .toString()
                            .split(',')
                            .reversed
                            .toList()[1]
                            .split(' ')[1]
                            .toString()
                        : getLocationFromLongAndlatitude['formatted_address']
                            .toString()
                            .split(',')
                            .reversed
                            .toList()[1]
                            .toString())
                    : '',
                'City': getLocationFromLongAndlatitude['formatted_address']
                        .toString()
                        .contains(',')
                    ? (getLocationFromLongAndlatitude['formatted_address']
                        .toString()
                        .split(',')
                        .reversed
                        .toList()[2]
                        .toString()
                        .split(' ')
                        .last
                        .toString())
                    : '',
                'Zip': getLocationFromLongAndlatitude['formatted_address']
                        .toString()
                        .contains(',')
                    ? (getLocationFromLongAndlatitude['formatted_address']
                            .toString()
                            .split(',')
                            .reversed
                            .toList()[1]
                            .toString()
                            .replaceFirst(' ', '')
                            .contains(' ')
                        ? getLocationFromLongAndlatitude['formatted_address']
                            .toString()
                            .split(',')
                            .reversed
                            .toList()[1]
                            .split(' ')[2]
                            .toString()
                        : '')
                    : ''
              }
            : {
                'AddressLine1':
                    getLocationFromLongAndlatitude['formatted_address']
                        .toString(),
                'Country': '',
                'State': '',
                'City': '',
                'Zip': ''
              };

        if (response.data != null) {
          if (success != null) {
            success(location);
          }
          return true;
        } else {
          if (error != null) {
            error('Something went wrong..');
          }
          return false;
        }
      } else {
        if (error != null) {
          error('Something went wrong..');
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.statusMessage ?? "Something went wrong");
      }
    }
    return null;
  }

  RxList pridiction = [].obs;

  getSuggestion({required String input}) async {
    String sessionToken = const Uuid().v4();

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=AIzaSyAsXCP8XNZCYRH6jcRQD1codAVPG8KJVs4&sessiontoken=$sessionToken';
    var response = await dio.Dio().get(request);
    if (response.statusCode == 200) {
      pridiction.value = response.data['predictions'];
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}

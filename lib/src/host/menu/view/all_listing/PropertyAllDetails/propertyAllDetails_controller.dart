import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'propertyAllDetails_model.dart';

class PropertyAllDetailsController extends GetxController {
  @override
  void onClose() {
    isDataLoaded = false;
    super.onClose();
  }

  PropertyAllDetails_model? propertyAllDetails_model;
  Data? PropertyData;
  CarouselController carouselController = CarouselController();
  var isDataLoaded = false;

  getApi(String slug) async {
    http.Response response = await http.post(
      Uri.parse('https://gleekey.in/api/viewProperties/$slug'),
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      propertyAllDetails_model = PropertyAllDetails_model.fromJson(result);
      PropertyData = propertyAllDetails_model!.data;
      isDataLoaded = true;
      log("got the data -- > slug: $slug");
    } else {
      printError(
          info: "PropertyAllDetailsController --> Not get data from api");
    }
    update();
  }
}

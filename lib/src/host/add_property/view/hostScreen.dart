import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/shared_Preference/prefController.dart';
import 'package:gleeky_flutter/src/host/add_property/controller/delete_hotel_room_image_controller.dart';
import 'package:gleeky_flutter/src/host/add_property/view/hosting_controller.dart';
import 'package:gleeky_flutter/src/host/dash_board/controller/dashboard_controller.dart';
import 'package:gleeky_flutter/utills/Google_map/google_map_controller.dart';
import 'package:gleeky_flutter/utills/Google_map/google_map_screen.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/commonWidget.dart';
import 'package:gleeky_flutter/utills/loder.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../menu/controller/menu_screen_controller.dart';
import 'package:dio/dio.dart' as dio;
import '../controller/get_roomName_controller.dart';

///step 4
final TextEditingController longitude = TextEditingController();
final TextEditingController latitude = TextEditingController();

///step 4
final TextEditingController countryController = TextEditingController();
final TextEditingController addressline1 = TextEditingController();
final TextEditingController fullAddress = TextEditingController();
final TextEditingController city = TextEditingController();
final TextEditingController state = TextEditingController();
final TextEditingController zip = TextEditingController();

class HostScreen extends StatefulWidget {
  final int pageNum;
  String? property_id;

  HostScreen({
    Key? key,
    this.pageNum = 0,
    this.property_id,
  }) : super(key: key);

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  String? propertyId;
  RxInt pageNum = 0.obs;
  RxInt propertyType = 0.obs;
  RxList customeRules = [''].obs;
  RxBool isHotel = false.obs;
  RxBool showHotelRooms = false.obs;
  RxBool isEditHotelRooms = false.obs;
  final ScrollController _scrollController = ScrollController();
  bool isPreview = true;

  ///use current location
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permission.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    isSelected.value = true;
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        markers.clear();
        log(position.toString());
        showLocation = LatLng(
          position.latitude,
          position.longitude,
        );
        controller?.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: showLocation, zoom: 10)
              //17 is new zoom level
              ),
        );
        Marker newMarker = Marker(
            markerId: MarkerId('$id'),
            position: showLocation,
            // infoWindow: InfoWindow(title: 'Gleekey'),
            icon: BitmapDescriptor.defaultMarker);
        markers.add(newMarker);
      });
      GoogleLocationController.to.getLocation(
          longitude: position.longitude.toString(),
          latitude: position.latitude.toString(),
          error: (e) {
            // loaderHide();
          },
          success: (loc) {
            addressline1.text = loc['AddressLine1'];
            countryController.text = loc['Country'];
            city.text = loc['City'];
            state.text = loc['State'];
            zip.text = loc['Zip'];
            // loaderHide();
          });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  ///step3
  final RxString _roomType = 'Please Select'.obs;
  final RxString _roomTypeID = ''.obs;
  RxList<Map<String, dynamic>> roomTypeList = <Map<String, dynamic>>[
    {'title': 'Please Select'}
  ].obs;
  final RxString _roomName = 'Please Select'.obs;
  final RxString _roomNameID = ''.obs;
  RxList<Map<String, dynamic>> roomNameList = <Map<String, dynamic>>[
    {'title': 'Please Select'}
  ].obs;

  final RxString _smokingPolicy = 'Non-smoking'.obs;
  final RxString _badType = ''.obs;
  final RxString _badTypeID = ''.obs;
  RxList<Map<String, dynamic>> badTypeList = <Map<String, dynamic>>[].obs;
  final RxString _numberOfBed = '1'.obs;
  final RxString _numberOfBedSuiteRooms = '1'.obs;
  final RxString _numberOfLivingSuiteRooms = '1'.obs;
  final RxList<Map<String, dynamic>> _numberOfLivingSuiteRoomsList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> _numberOfBedOeptionsList =
      <Map<String, dynamic>>[
    {
      'bedRooms': '1',
      'bed_options': [
        {'bedType': '', 'numberOfBed': '1', 'id': ''}
      ],
      'privet_room': false,
      'selected_index': 0,
      'guest_stay': '1'
    }
  ].obs;
  final RxString _numberOfBathSuiteRooms = '1'.obs;
  final RxString _squareMeterType = 'square meters'.obs;
  final RxString _breakFast = 'No'.obs;
  final TextEditingController _breakFastPrice = TextEditingController();
  final RxString _lunch = 'No'.obs;
  final TextEditingController _lunchPrice = TextEditingController();
  final RxString _dinner = 'No'.obs;
  final TextEditingController _dinnerPrice = TextEditingController();
  final RxString _extrabedCounter = '0'.obs;
  final TextEditingController _extrabedPrice = TextEditingController();
  RxBool extraBed = false.obs;

  ///image picker step3

  RxList roomPhoto = [''].obs;
  RxList roomPhotoNetwork = [].obs;
  /*
  final TextEditingController _numberOfBedroom = TextEditingController();
  final TextEditingController _numberOfLivingrooms = TextEditingController();
  final TextEditingController _numberOfBathrooms = TextEditingController();*/
  final TextEditingController _customName = TextEditingController();
  final TextEditingController _numberOfRooms = TextEditingController();
  // final TextEditingController _badType = TextEditingController();
  // final TextEditingController _numberOfBed = TextEditingController();
  final TextEditingController _howManyGuestCanStay =
      TextEditingController(text: '1');
  final TextEditingController _squareMeter = TextEditingController();
  final TextEditingController _rentPerNight = TextEditingController();

  ///step 9
  final TextEditingController _propertyTitle = TextEditingController();
  final TextEditingController _propertyDescription = TextEditingController();
  final TextEditingController _checkInTime =
      TextEditingController(text: "01:00 PM");
  final TextEditingController _checkOutTime =
      TextEditingController(text: "11:00 AM");
  final TextEditingController _openTime =
      TextEditingController(text: '8:00 AM');
  final TextEditingController _closeTime =
      TextEditingController(text: '6:00 PM');
  final TextEditingController _musicopenTime =
      TextEditingController(text: '8:00 AM');
  final TextEditingController _musiccloseTime =
      TextEditingController(text: '6:00 PM');

  ///step 10
  final TextEditingController _hostContactNumber = TextEditingController();
  final TextEditingController _careTakerContactNumber = TextEditingController();
  final TextEditingController _emergencyContactNumber = TextEditingController();

  ///step10
  final TextEditingController _priceExpectation =
      TextEditingController(text: '0');
  final TextEditingController _weekendPriceExpectation =
      TextEditingController(text: '0');

  final RxBool _showHostNo = false.obs;
  final RxBool _showCareTakerNo = false.obs;
  final RxBool _showEmergencyNo = false.obs;

  ///Image Picker
  RxString coverPhoto = ''.obs;
  List coverPhotoNetwork = [];
  List coverPhotoID = [];
  List amenitiesPhotoID = [];

  Future pickCoverImage() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      coverPhoto.value = image.path;
    } on PlatformException catch (e) {
      showSnackBar(title: ApiConfig.error, message: 'Failed to pick image: $e');
    }
  }

  RxString outDoor1Img = ''.obs;
  RxList outDoorImageNetwork = [].obs;
  RxList<String> outDoorImagesHotel = <String>['', '', ''].obs;
  List outDoorImageID = [];
  Future pickOutDoor1Image() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      outDoor1Img.value = image.path;
    } on PlatformException catch (e) {
      showSnackBar(title: ApiConfig.error, message: 'Failed to pick image: $e');
    }
  }

  RxString outDoor2Img = ''.obs;
  Future pickOutDoor2Image() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      outDoor2Img.value = image.path;
    } on PlatformException catch (e) {
      showSnackBar(title: ApiConfig.error, message: 'Failed to pick image: $e');
    }
  }

  // Future openPrevious() async {
  //   await Future.delayed(
  //     const Duration(milliseconds: 100),
  //     () {
  //       print('previousing');
  //       previous();
  //     },
  //   );
  // }

  RxString outDoor3Img = ''.obs;
  Future pickOutDoor3Image() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      outDoor3Img.value = image.path;
    } on PlatformException catch (e) {
      showSnackBar(title: ApiConfig.error, message: 'Failed to pick image: $e');
    }
  }

  ///step 12
  final TextEditingController _partnerCode = TextEditingController();
  final RxBool _information = false.obs;
  final RxBool _termsAndCondition = false.obs;
  List<Widget>? view;

  RxBool imgValidation = false.obs;

  // setting screen design
  // edit personal info screen design

  @override
  initState() {
    //pageNum.value = widget.pageNum;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (widget.pageNum == 10 || widget.pageNum == 0) && isPreview
          ? null
          : previous();
      isPreview = false;
    });
    // openPrevious();
    log("initState");
    propertyId = widget.property_id;
    pageNum.value =
        widget.pageNum == 10 || widget.pageNum == 0 ? 0 : 11 - widget.pageNum;

    // widget.pageNum == 10 || widget.pageNum == 0 ? null : previous();
    countryController.clear();
    addressline1.clear();
    fullAddress.clear();
    city.clear();
    state.clear();
    zip.clear();
    view = [
      step1(),
      step2(),
      step3(),
      step4(),
      step5(),
      step7(),
      step8(),
      step9(),
      step11(),
      step12(),
      step13(),
    ];
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DashBoardController.to.unlistedPropertyRes.clear();
        DashBoardController.to.unlistedPropertyAPI(
          params: {'status': 'All', 'page': 0, "limit": 10},
          error: (e) {
            showSnackBar(title: ApiConfig.error, message: e.toString());
          },
        );
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: CommonBottomBar(
          child: Obx(
            () {
              return ((view!.length - 1) == pageNum.value)
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        child: CommonButton(
                          onPressed: () {
                            print('FINISH PAGE NUMBER  ${pageNum.value}');

                            loaderShow(context);
                            HostingController.to.hostPropertyApi(
                              id: propertyId != null || propertyId != ''
                                  ? propertyId!
                                  : HostingController.to.getStartHostRes['data']
                                      ['property_id'],
                              step: 'booking',
                              params: {
                                'user_id': PrefController.to.user_id.value,
                                'id': propertyId != null || propertyId != ''
                                    ? propertyId
                                    : (MenuScreenController
                                                .to.getStartHostRes['data']
                                            ['property_id'])
                                        .toString(),
                                'submit': ''
                              },
                              success: () {
                                DashBoardController.to.unlistedPropertyRes
                                    .clear();
                                DashBoardController.to.unlistedPropertyAPI(
                                  params: {
                                    'status': 'Listed',
                                    'page': 0,
                                    "limit": 10
                                  },
                                  error: (e) {
                                    showSnackBar(
                                        title: ApiConfig.error,
                                        message: e.toString());
                                  },
                                );
                                loaderHide();

                                Get.back();
                                Get.closeAllSnackbars();
                                showSnackBar(
                                    title: ApiConfig.success,
                                    message: 'Property Host Successfully..');
                              },
                              error: (e) {
                                loaderHide();
                                showSnackBar(
                                    title: ApiConfig.error,
                                    message: e.toString());
                              },
                            );
                          },
                          name: 'Finish',
                        ),
                      ),
                    )
                  : pageNum.value > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              child: CommonButton(
                                onPressed: () {
                                  previous();
                                },
                                color: AppColors.colorEBEBEB,
                                style: colorfffffffs13w600.copyWith(
                                    color:
                                        AppColors.color000000.withOpacity(0.7)),
                                name: 'Previous',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              child: CommonButton(
                                onPressed: () async {
                                  if (pageNum.value == 1) {
                                    print('IN STEP ==>> ${pageNum.value} ');
                                    loaderShow(context);
                                    HostingController.to.hostPropertyApi(
                                        id: propertyId != null ||
                                                propertyId != ''
                                            ? propertyId
                                            : HostingController
                                                    .to.getStartHostRes['data']
                                                ['property_id'],
                                        step: 'describes_your_location',
                                        params: {
                                          'user_id':
                                              PrefController.to.user_id.value,
                                          'id': propertyId != null ||
                                                  propertyId != ''
                                              ? propertyId
                                              : (MenuScreenController
                                                          .to.getStartHostRes[
                                                      'data']['property_id'])
                                                  .toString(),
                                          'property_type': HostingController
                                                      .to.getStartHostRes[
                                                  'data']?['property_type']
                                              [propertyType.value]['id'],
                                          'stay_type': '1'
                                        },
                                        success: () {
                                          loaderHide();

                                          if (isHotel.value) {
                                            ///room type
                                            roomTypeList.clear();
                                            roomTypeList.add(
                                                {'title': 'Please Select'});
                                            ((HostingController.to.getStartHostRes[
                                                                'data']
                                                            ?['room_type'] ??
                                                        [])
                                                    .isNotEmpty)
                                                ? {
                                                    HostingController
                                                        .to
                                                        .getStartHostRes['data']
                                                            ?['room_type']
                                                        .forEach((element) {
                                                      roomTypeList.add(element);
                                                    })
                                                  }
                                                : null;

                                            ///bed type
                                            badTypeList.clear();
                                            ((HostingController.to.getStartHostRes[
                                                                'data']
                                                            ?['bed_type'] ??
                                                        [])
                                                    .isNotEmpty)
                                                ? {
                                                    HostingController
                                                        .to
                                                        .getStartHostRes['data']
                                                            ?['bed_type']
                                                        .forEach((element) {
                                                      badTypeList.add(element);
                                                    })
                                                  }
                                                : null;

                                            ///amenities
                                            amenities.clear();

                                            ((HostingController.to.getStartHostRes[
                                                                'data']?[
                                                            'hotel_amenities'] ??
                                                        [])
                                                    .isNotEmpty)
                                                ? {
                                                    HostingController
                                                        .to
                                                        .getStartHostRes['data']
                                                            ?['hotel_amenities']
                                                        .forEach((element) {
                                                      amenities.add(element);
                                                    })
                                                  }
                                                : null;

                                            for (var element in amenities) {
                                              element['itHas'] = false;
                                            }

                                            _numberOfBedOeptionsList[0]
                                                ['bed_options'] = [
                                              {
                                                'bedType': badTypeList[0]
                                                    ['name'],
                                                'numberOfBed': '1',
                                                'id': badTypeList[0]['id']
                                              }
                                            ];

                                            _badType.value =
                                                badTypeList[0]['name'];
                                            _badTypeID.value =
                                                badTypeList[0]['id'].toString();
                                            _numberOfBed.value =
                                                _numberOfBedOeptionsList[0]
                                                        ['bed_options'][0]
                                                    ['numberOfBed'];
                                            _badType.refresh();
                                            _numberOfBed.refresh();

                                            log(bedOpetionList.toString(),
                                                name: 'bedOpetionList');
                                            log(_badType.value,
                                                name: '_badType');
                                            log(_numberOfBed.value,
                                                name: '_numberOfBed');
                                          } else {
                                            categiry[0]['qty'] = int.parse(
                                                (HostingController.to.getStartHostRes[
                                                                    'data']
                                                                ?['result']
                                                            ?['square_feet'] ??
                                                        '0')
                                                    .toString());
                                            categiry[
                                                    1][
                                                'qty'] = int.parse((HostingController
                                                                .to.getStartHostRes[
                                                            'data']?['result']?[
                                                        'constructed_square_feet'] ??
                                                    '0')
                                                .toString());
                                          }

                                          view!.length > (pageNum.value + 1)
                                              ? pageNum.value =
                                                  pageNum.value + 1
                                              : null;
                                        },
                                        error: (e) {
                                          loaderHide();

                                          showSnackBar(
                                            title: ApiConfig.error,
                                            message: e.toString(),
                                          );
                                        });
                                  } else if (pageNum.value == 2) {
                                    print('IN STEP ==>> ${pageNum.value} ');

                                    print(categiry[1]['qty']);
                                    if (isHotel.value) {
                                      if (isEditHotelRooms.value) {
                                        Map<String, dynamic> params = {
                                          'user_id':
                                              PrefController.to.user_id.value,
                                          'id': propertyId != null ||
                                                  propertyId != ''
                                              ? propertyId
                                              : (MenuScreenController
                                                          .to.getStartHostRes[
                                                      'data']['property_id'])
                                                  .toString(),
                                        };

                                        loaderShow(context);
                                        HostingController.to.hostPropertyApi(
                                          id: propertyId != null ||
                                                  propertyId != ''
                                              ? propertyId
                                              : HostingController.to
                                                      .getStartHostRes['data']
                                                  ['property_id'],
                                          step: 'hotel_listing_info',
                                          params: params,
                                          success: () {
                                            loaderHide();

                                            showHotelRooms.value = true;
                                            view!.length > (pageNum.value + 1)
                                                ? pageNum.value =
                                                    pageNum.value + 1
                                                : null;
                                            if (HostingController.to
                                                            .getStartHostRes['data']
                                                        ['property_address'] !=
                                                    {} ||
                                                HostingController
                                                    .to
                                                    .getStartHostRes['data']
                                                        ['property_address']
                                                    .isNotEmpty) {
                                              countryController
                                                  .text = HostingController.to
                                                              .getStartHostRes['data']
                                                          ['property_address']
                                                      ?['country'] ??
                                                  '';
                                              state.text = HostingController.to
                                                              .getStartHostRes['data']
                                                          ['property_address']
                                                      ?['state'] ??
                                                  '';
                                              addressline1
                                                  .text = HostingController.to
                                                              .getStartHostRes['data']
                                                          ?['property_address']
                                                      ?['address_line_1'] ??
                                                  '';
                                              fullAddress
                                                  .text = HostingController.to
                                                              .getStartHostRes['data']
                                                          ?['property_address']
                                                      ?['address_line_2'] ??
                                                  '';
                                              city.text = HostingController.to
                                                              .getStartHostRes['data']
                                                          ?['property_address']
                                                      ?['city'] ??
                                                  '';
                                              zip.text = HostingController.to
                                                              .getStartHostRes['data']
                                                          ?['property_address']
                                                      ?['postal_code'] ??
                                                  "";
                                              longitude.text = HostingController
                                                              .to
                                                              .getStartHostRes['data']
                                                          ?['property_address']
                                                      ?['longitude'] ??
                                                  '';
                                              latitude.text = HostingController
                                                              .to
                                                              .getStartHostRes['data']
                                                          ?['property_address']
                                                      ?['latitude'] ??
                                                  '';
                                              markers.clear();

                                              showLocation = LatLng(
                                                double.parse((HostingController
                                                                        .to
                                                                        .getStartHostRes[
                                                                    'data']?[
                                                                'property_address']
                                                            ?['latitude'] ??
                                                        '21.1702')
                                                    .toString()),
                                                double.parse((HostingController
                                                                        .to
                                                                        .getStartHostRes[
                                                                    'data']?[
                                                                'property_address']
                                                            ?['longitude'] ??
                                                        '72.8311')
                                                    .toString()),
                                              );
                                              controller?.animateCamera(
                                                  CameraUpdate
                                                      .newCameraPosition(
                                                          CameraPosition(
                                                              target:
                                                                  showLocation,
                                                              zoom: 10)
                                                          //17 is new zoom level
                                                          ));
                                              Marker newMarker = Marker(
                                                  markerId: MarkerId('$id'),
                                                  position: LatLng(
                                                    double.parse((HostingController
                                                                            .to
                                                                            .getStartHostRes[
                                                                        'data']
                                                                    ?[
                                                                    'property_address']
                                                                ?['latitude'] ??
                                                            '21.1702')
                                                        .toString()),
                                                    double.parse((HostingController
                                                                            .to
                                                                            .getStartHostRes[
                                                                        'data']
                                                                    ?[
                                                                    'property_address']
                                                                ?[
                                                                'longitude'] ??
                                                            '72.8311')
                                                        .toString()),
                                                  ),
                                                  // infoWindow: InfoWindow(title: 'Gleekey'),
                                                  icon: BitmapDescriptor
                                                      .defaultMarker);
                                              markers.add(newMarker);
                                              id = id + 1;
                                            }

                                            print(
                                                'COUNTRY NAME ${countryController.text}');
                                          },
                                          error: (e) {
                                            loaderHide();

                                            showSnackBar(
                                              title: ApiConfig.error,
                                              message: e.toString(),
                                            );
                                          },
                                        );
                                      } else {
                                        if (_roomType.value ==
                                            'Please Select') {
                                          showSnackBar(
                                              title: ApiConfig.error,
                                              message:
                                                  'Please Select Room Type.');
                                        } else if (_roomName.value ==
                                            'Please Select') {
                                          showSnackBar(
                                              title: ApiConfig.error,
                                              message:
                                                  'Please Select Room Name.');
                                        } else if (_customName.text.isEmpty) {
                                          showSnackBar(
                                              title: ApiConfig.error,
                                              message:
                                                  'Please Enter Customer Name.');
                                        } else if (_customName.text.isEmpty) {
                                          showSnackBar(
                                              title: ApiConfig.error,
                                              message:
                                                  'Please Enter Customer Name.');
                                        } else if (_numberOfRooms
                                            .text.isEmpty) {
                                          showSnackBar(
                                              title: ApiConfig.error,
                                              message:
                                                  'Please Enter Number of Rooms.');
                                        } else if (_numberOfRooms
                                                .text.isNotEmpty &&
                                            int.parse(_numberOfRooms.text) <=
                                                0) {
                                          showSnackBar(
                                              title: ApiConfig.error,
                                              message:
                                                  'Must Have Minimum 1 Room');
                                        } else if (_rentPerNight.text.isEmpty) {
                                          showSnackBar(
                                              title: ApiConfig.error,
                                              message:
                                                  'Please Enter Rent of Room');
                                        } else if (_rentPerNight
                                                .text.isNotEmpty &&
                                            int.parse(_rentPerNight.text) <=
                                                0) {
                                          showSnackBar(
                                              title: ApiConfig.error,
                                              message:
                                                  'Rent Must be Greater then 0.');
                                        } else {
                                          log(
                                              _numberOfBedOeptionsList
                                                  .toString(),
                                              name: '_numberOfBedOeptionsList');
                                          RxList numberofSofa = [].obs;
                                          RxList numberofGuest = [].obs;
                                          RxList bedtypeOptionId = [].obs;
                                          RxList numberOfBedOptions = [].obs;
                                          RxList numberOfGuestOption = [].obs;
                                          RxList privateBathroomOption = [].obs;

                                          bedtypeOptionId.value = List.generate(
                                              _numberOfBedOeptionsList.length,
                                              (i) => List.generate(
                                                  _numberOfBedOeptionsList[i]
                                                          ['bed_options']
                                                      .length,
                                                  (j) =>
                                                      _numberOfBedOeptionsList[
                                                              i]['bed_options']
                                                          [j]['id']));
                                          numberOfBedOptions.value = List.generate(
                                              _numberOfBedOeptionsList.length,
                                              (i) => List.generate(
                                                  _numberOfBedOeptionsList[i]
                                                          ['bed_options']
                                                      .length,
                                                  (j) =>
                                                      _numberOfBedOeptionsList[
                                                              i]['bed_options']
                                                          [j]['numberOfBed']));

                                          log(numberOfGuestOption.toString(),
                                              name: 'number_of_guest_option');
                                          for (var element
                                              in _numberOfBedOeptionsList) {
                                            numberOfGuestOption
                                                .add(element['guest_stay']);
                                          }
                                          for (var element
                                              in _numberOfBedOeptionsList) {
                                            privateBathroomOption.add(
                                                element['privet_room']
                                                    ? 'Yes'
                                                    : 'No');
                                          }
                                          for (var element
                                              in _numberOfLivingSuiteRoomsList) {
                                            numberofSofa
                                                .add(element['bedRooms']);
                                          }
                                          for (var element
                                              in _numberOfLivingSuiteRoomsList) {
                                            numberofGuest.add(element['guest']);
                                          }
                                          Map<String, dynamic> params = {
                                            'user_id':
                                                PrefController.to.user_id.value,
                                            'id': propertyId != null ||
                                                    propertyId != ''
                                                ? propertyId
                                                : (MenuScreenController
                                                            .to.getStartHostRes[
                                                        'data']['property_id'])
                                                    .toString(),
                                            'room_type_id': _roomTypeID.value,
                                            'room_name_id': _roomNameID.value,
                                            'custome_name': _customName.text,
                                            'smoking_policy':
                                                _smokingPolicy.value,
                                            'number_of_rooms':
                                                _numberOfRooms.text,
                                            'number_of_bedrooms':
                                                _roomType.value != 'Suite'
                                                    ? '0'
                                                    : _numberOfBedSuiteRooms
                                                        .value,
                                            "number_of_living_rooms":
                                                _roomType.value != 'Suite'
                                                    ? '0'
                                                    : _numberOfLivingSuiteRooms
                                                        .value,
                                            "number_of_bathrooms":
                                                _roomType.value != 'Suite'
                                                    ? '0'
                                                    : _numberOfBathSuiteRooms
                                                        .value,
                                            /* 'number_of_guest':_howManyGuestCanStay.text,*/
                                            "room_size": _squareMeter.text,
                                            "room_measunit":
                                                _squareMeterType.value ==
                                                        "square meters"
                                                    ? 'sq_meters'
                                                    : 'sq_feet',
                                            "breakfast_included": _breakFast
                                                        .value ==
                                                    'Yes, it\'s optional'
                                                ? 'optional'
                                                : _breakFast.value ==
                                                        'Yes,it\'s included in the price'
                                                    ? 'included'
                                                    : _breakFast.value,
                                            "breakfast_price":
                                                _breakFastPrice.text,
                                            "lunch_included": _lunch.value ==
                                                    'Yes, it\'s optional'
                                                ? 'optional'
                                                : _lunch.value ==
                                                        'Yes,it\'s included in the price'
                                                    ? 'included'
                                                    : _lunch.value,
                                            "lunch_price": _lunchPrice.text,
                                            "dinner_included": _dinner.value ==
                                                    'Yes, it\'s optional'
                                                ? 'optional'
                                                : _dinner.value ==
                                                        'Yes,it\'s included in the price'
                                                    ? 'included'
                                                    : _dinner.value,
                                            "dinner_price": _dinnerPrice.text,
                                            "extra_beds_available":
                                                extraBed.value ? 'Yes' : 'No',
                                            "max_extra_beds":
                                                _extrabedCounter.value,
                                            "extra_bed_price":
                                                _extrabedPrice.text,
                                            'room_price_x_persons':
                                                _rentPerNight.text,
                                            "amenities[]":
                                                amenitiesIdsHotel.value,
                                            'bedtype_option_id':
                                                _roomType.value == 'Single'
                                                    ? []
                                                    : jsonEncode(
                                                        bedtypeOptionId.value),
                                            'number_of_bed_options': _roomType
                                                        .value ==
                                                    'Single'
                                                ? []
                                                : jsonEncode(
                                                    numberOfBedOptions.value),
                                            'number_of_guest_option[]':
                                                _roomType.value == 'Single'
                                                    ? []
                                                    : numberOfGuestOption.value,
                                            'private_bathroom_option[]':
                                                _roomType.value == 'Single'
                                                    ? []
                                                    : privateBathroomOption
                                                        .value,
                                            "num_sofabeds_in_livingroom[]":
                                                _roomType.value == 'Suite'
                                                    ? numberofSofa.value
                                                    : [],
                                            "num_guests_in_livingroom[]":
                                                _roomType.value == 'Suite'
                                                    ? numberofGuest.value
                                                    : [],
                                            "proceed": 'Continue',
                                            // 'private_bathroom_option':privetBathroom.value,
                                          };

                                          RxList roomImages = [].obs;
                                          roomPhoto.isNotEmpty
                                              ? roomPhoto
                                                  .forEach((element) async {
                                                  if (element != '') {
                                                    roomImages.add(await dio
                                                            .MultipartFile
                                                        .fromFile(
                                                            element.toString(),
                                                            filename: element
                                                                .toString()));
                                                  }
                                                  print(
                                                      'roomImages $roomImages');
                                                })
                                              : [];

                                          await Future.delayed(
                                              const Duration(seconds: 1));
                                          params['images[]'] = roomImages;

                                          log('PARAMS $params', name: 'PARAMS');

                                          loaderShow(context);
                                          HostingController.to.hostPropertyApi(
                                            id: propertyId != null ||
                                                    propertyId != ''
                                                ? propertyId
                                                : HostingController.to
                                                        .getStartHostRes['data']
                                                    ['property_id'],
                                            step: 'hotel_basic_information',
                                            params: params,
                                            isFormData: true,
                                            success: () {
                                              loaderHide();

                                              /* view!.length > (pageNum.value + 1)
                                               ? pageNum.value =
                                               pageNum.value + 1
                                               : null;*/

                                              showHotelRooms.value = true;
                                            },
                                            error: (e) {
                                              loaderHide();

                                              showSnackBar(
                                                title: ApiConfig.error,
                                                message: e.toString(),
                                              );
                                            },
                                          );
                                        }
                                      }
                                    } else {
                                      if (categiry[1]['qty'] > 0) {
                                        loaderShow(context);
                                        HostingController.to.hostPropertyApi(
                                          id: propertyId != null ||
                                                  propertyId != ''
                                              ? propertyId
                                              : HostingController.to
                                                      .getStartHostRes['data']
                                                  ['property_id'],
                                          step: 'construction_area',
                                          params: {
                                            'user_id':
                                                PrefController.to.user_id.value,
                                            'id': propertyId != null ||
                                                    propertyId != ''
                                                ? propertyId
                                                : (MenuScreenController
                                                            .to.getStartHostRes[
                                                        'data']['property_id'])
                                                    .toString(),
                                            'square_feet': categiry[0]['qty'],
                                            'constructed_square_feet':
                                                categiry[1]['qty']
                                          },
                                          success: () {
                                            loaderHide();

                                            view!.length > (pageNum.value + 1)
                                                ? pageNum.value =
                                                    pageNum.value + 1
                                                : null;

                                            /*countryController
                                            addressline1
                                            fullAddress
                                            city
                                            state
                                            zip*/

                                            if (HostingController.to
                                                            .getStartHostRes['data']
                                                        ['property_address'] !=
                                                    {} ||
                                                HostingController
                                                    .to
                                                    .getStartHostRes['data']
                                                        ['property_address']
                                                    .isNotEmpty) {
                                              countryController
                                                  .text = HostingController.to
                                                      .getStartHostRes['data'][
                                                  'property_address']['country'];
                                              state.text = HostingController.to
                                                      .getStartHostRes['data']
                                                  ['property_address']['state'];
                                              addressline1
                                                  .text = HostingController
                                                          .to.getStartHostRes[
                                                      'data']['property_address']
                                                  ['address_line_1'];
                                              fullAddress
                                                  .text = HostingController
                                                          .to.getStartHostRes[
                                                      'data']['property_address']
                                                  ['address_line_2'];
                                              city.text = HostingController.to
                                                      .getStartHostRes['data']
                                                  ['property_address']['city'];
                                              zip.text = HostingController
                                                          .to.getStartHostRes[
                                                      'data']['property_address']
                                                  ['postal_code'];
                                              longitude.text = HostingController
                                                          .to.getStartHostRes[
                                                      'data']['property_address']
                                                  ['longitude'];
                                              latitude.text = HostingController
                                                          .to.getStartHostRes[
                                                      'data']['property_address']
                                                  ['latitude'];
                                              markers.clear();

                                              showLocation = LatLng(
                                                double.parse((HostingController
                                                                        .to
                                                                        .getStartHostRes[
                                                                    'data']?[
                                                                'property_address']
                                                            ?['latitude'] ??
                                                        '21.1702')
                                                    .toString()),
                                                double.parse((HostingController
                                                                        .to
                                                                        .getStartHostRes[
                                                                    'data']?[
                                                                'property_address']
                                                            ?['longitude'] ??
                                                        '72.8311')
                                                    .toString()),
                                              );
                                              controller?.animateCamera(
                                                  CameraUpdate
                                                      .newCameraPosition(
                                                          CameraPosition(
                                                              target:
                                                                  showLocation,
                                                              zoom: 10)
                                                          //17 is new zoom level
                                                          ));
                                              Marker newMarker = Marker(
                                                  markerId: MarkerId('$id'),
                                                  position: LatLng(
                                                    double.parse((HostingController
                                                                            .to
                                                                            .getStartHostRes[
                                                                        'data']
                                                                    ?[
                                                                    'property_address']
                                                                ?['latitude'] ??
                                                            '21.1702')
                                                        .toString()),
                                                    double.parse((HostingController
                                                                            .to
                                                                            .getStartHostRes[
                                                                        'data']
                                                                    ?[
                                                                    'property_address']
                                                                ?[
                                                                'longitude'] ??
                                                            '72.8311')
                                                        .toString()),
                                                  ),
                                                  // infoWindow: InfoWindow(title: 'Gleekey'),
                                                  icon: BitmapDescriptor
                                                      .defaultMarker);
                                              markers.add(newMarker);
                                              id = id + 1;
                                            }

                                            print(
                                                'COUNTRY NAME ${countryController.text}');
                                          },
                                          error: (e) {
                                            loaderHide();

                                            showSnackBar(
                                              title: ApiConfig.error,
                                              message: e.toString(),
                                            );
                                          },
                                        );
                                      } else {
                                        showSnackBar(
                                          title: ApiConfig.error,
                                          message:
                                              'Value Must Be Greater then 0',
                                        );
                                      }
                                    }
                                  } else if (pageNum.value == 3) {
                                    print('IN STEP ==>> ${pageNum.value} ');

                                    if (latitude.text.isEmpty ||
                                        longitude.text.isEmpty ||
                                        countryController.text.isEmpty ||
                                        addressline1.text.isEmpty ||
                                        fullAddress.text.isEmpty ||
                                        city.text.isEmpty ||
                                        state.text.isEmpty ||
                                        zip.text.isEmpty) {
                                      showSnackBar(
                                          title: ApiConfig.error,
                                          message: 'Fill Form First');
                                    } else {
                                      loaderShow(context);
                                      HostingController.to.hostPropertyApi(
                                          id: propertyId != null ||
                                                  propertyId != ''
                                              ? propertyId
                                              : HostingController.to
                                                      .getStartHostRes['data']
                                                  ['property_id'],
                                          step: 'location',
                                          params: {
                                            'user_id':
                                                PrefController.to.user_id.value,
                                            'id': propertyId != null ||
                                                    propertyId != ''
                                                ? propertyId
                                                : (MenuScreenController
                                                            .to.getStartHostRes[
                                                        'data']['property_id'])
                                                    .toString(),
                                            'latitude': latitude.text,
                                            'longitude': longitude.text,
                                            'country': countryController.text,
                                            'address_line_1': addressline1.text,
                                            'address_line_2': fullAddress.text,
                                            'city': city.text,
                                            'state': state.text,
                                            'postal_code': zip.text,
                                          },
                                          success: () {
                                            loaderHide();
                                            if (isHotel.value) {
                                              view!.length > (pageNum.value + 2)
                                                  ? pageNum.value =
                                                      pageNum.value + 2
                                                  : null;
                                            } else {
                                              view!.length > (pageNum.value + 1)
                                                  ? pageNum.value =
                                                      pageNum.value + 1
                                                  : null;
                                            }

                                            if (isHotel.value) {
                                              log('COVER PHOTO FROM LOCATION');
                                              coverPhotoNetwork =
                                                  HostingController.to
                                                          .getStartHostRes['data']
                                                      ['cover_photo_photos'];
                                              outDoorImageNetwork
                                                  .value = HostingController.to
                                                          .getStartHostRes['data']
                                                      ?[
                                                      'outdoor_image_photos'] ??
                                                  [];
                                              outDoorImageNetwork.refresh();

                                              outDoorImageNetwork.length > 3
                                                  ? outDoorImagesHotel.value =
                                                      List.generate(
                                                      outDoorImageNetwork
                                                          .length,
                                                      (index) => '',
                                                    )
                                                  : outDoorImagesHotel.value = [
                                                      '',
                                                      '',
                                                      ''
                                                    ];
                                              outDoorImagesHotel.refresh();
                                              log(
                                                  outDoorImageNetwork.length
                                                      .toString(),
                                                  name: 'outDoorImageNetwork');
                                              log(
                                                  outDoorImagesHotel.length
                                                      .toString(),
                                                  name: 'outDoorImagesHotel');
                                            }

                                            pickImg.value = basic.value;

                                            basic[0]['qty'] = int.parse(
                                                (HostingController.to.getStartHostRes[
                                                                    'data']
                                                                ?['result']
                                                            ?['guest'] ??
                                                        '0')
                                                    .toString());

                                            pickImg[0]['imgPath'] =
                                                RxList.generate(basic[0]['qty'],
                                                    (imgIndex) => '');
                                            print(
                                                "no. of Guest${pickImg[0]['imgPath']}");
                                            basic[1]['qty'] = int.parse(
                                                (HostingController.to.getStartHostRes[
                                                                    'data']
                                                                ?['result']
                                                            ?['bedrooms'] ??
                                                        '0')
                                                    .toString());

                                            pickImg[1]['imgPath'] =
                                                RxList.generate(basic[1]['qty'],
                                                    (imgIndex) => '');
                                            basic[2]['qty'] = int.parse(
                                                (HostingController.to.getStartHostRes[
                                                                    'data']
                                                                ?['result']?[
                                                            'extra_mattress'] ??
                                                        '0')
                                                    .toString());
                                            pickImg[2]['imgPath'] =
                                                RxList.generate(
                                                    pickImg[2]['qty'],
                                                    (imgIndex) => '');
                                            basic[3]['qty'] = int.parse(
                                                (HostingController.to.getStartHostRes[
                                                                    'data']
                                                                ?['result']
                                                            ?['living_rooms'] ??
                                                        '0')
                                                    .toString());
                                            pickImg[3]['imgPath'] =
                                                RxList.generate(
                                                    pickImg[3]['qty'],
                                                    (imgIndex) => '');
                                            basic[4]['qty'] = int.parse(
                                                (HostingController.to.getStartHostRes[
                                                                    'data']
                                                                ?['result']
                                                            ?['kitchen'] ??
                                                        '0')
                                                    .toString());
                                            pickImg[4]['imgPath'] =
                                                RxList.generate(
                                                    pickImg[4]['qty'],
                                                    (imgIndex) => '');
                                            basic[5]['qty'] = int.parse(
                                                (HostingController.to.getStartHostRes[
                                                                    'data']
                                                                ?['result']
                                                            ?['bathrooms'] ??
                                                        '0')
                                                    .toString());
                                            pickImg[5]['imgPath'] =
                                                RxList.generate(
                                                    pickImg[5]['qty'],
                                                    (imgIndex) => '');
                                          },
                                          error: (e) {
                                            loaderHide();
                                            showSnackBar(
                                                title: ApiConfig.error,
                                                message: e.toString());
                                          });
                                    }
                                  } else if (pageNum.value == 4) {
                                    imgValidation.value = false;
                                    print('IN STEP ==>> ${pageNum.value} ');

                                    imgValidation.value =
                                        (basic[0]['qty'] > 0 &&
                                            basic[1]['qty'] > 0 &&
                                            basic[5]['qty'] > 0);
                                    if (imgValidation.value) {
                                      loaderShow(context);
                                      HostingController.to.hostPropertyApi(
                                          id: propertyId != null ||
                                                  propertyId != ''
                                              ? propertyId
                                              : HostingController.to
                                                      .getStartHostRes['data']
                                                  ['property_id'],
                                          step: 'basics',
                                          params: {
                                            'user_id':
                                                PrefController.to.user_id.value,
                                            'id': propertyId != null ||
                                                    propertyId != ''
                                                ? propertyId
                                                : (MenuScreenController
                                                            .to.getStartHostRes[
                                                        'data']['property_id'])
                                                    .toString(),
                                            'guest': basic[0]['qty'],
                                            'bedrooms': basic[1]['qty'],
                                            'extra_mattress': basic[2]['qty'],
                                            'living_rooms': basic[3]['qty'],
                                            'kitchen': basic[4]['qty'],
                                            'bathrooms': basic[5]['qty'],
                                          },
                                          success: () {
                                            loaderHide();
                                            view!.length > (pageNum.value + 1)
                                                ? pageNum.value =
                                                    pageNum.value + 1
                                                : null;
                                            coverPhotoNetwork =
                                                HostingController.to
                                                        .getStartHostRes['data']
                                                    ['cover_photo_photos'];
                                            outDoorImageNetwork
                                                .value = HostingController.to
                                                        .getStartHostRes['data']
                                                    ?['outdoor_image_photos'] ??
                                                [];
                                            outDoorImageNetwork.refresh();
                                            outDoorImagesHotel.value =
                                                List.generate(
                                              outDoorImageNetwork.length,
                                              (index) => '',
                                            );
                                            outDoorImagesHotel.refresh();
                                            log(
                                                outDoorImageNetwork.length
                                                    .toString(),
                                                name: 'outDoorImageNetwork');
                                            log(
                                                outDoorImagesHotel.length
                                                    .toString(),
                                                name: 'outDoorImagesHotel');
                                            /*List data = [
                                              '1',
                                              '2',
                                              '3',
                                              '4'
                                            ];
                                            List data2 = ['5', '6'];

                                            List data3 = List.generate(
                                                data.length,
                                                    (index) => '');
                                            data3.replaceRange(
                                                0, data2.length, data2);
                                            print(data3);*/
                                            pickImg[1][
                                                'networkImage'] = HostingController
                                                        .to
                                                        .getStartHostRes['data']
                                                    ?['bedroom_photos'] ??
                                                [];
                                            print(
                                                'bedroom_photos  ${pickImg[1]['networkImage']}');
                                            print(
                                                'bedroom_photos  ${pickImg[1]['networkImage'].isEmpty}');
                                            pickImg[3][
                                                'networkImage'] = HostingController
                                                        .to
                                                        .getStartHostRes['data']
                                                    ?['living_room_photos'] ??
                                                [];

                                            pickImg[4][
                                                'networkImage'] = HostingController
                                                        .to
                                                        .getStartHostRes['data']
                                                    ?['kitchen_image_photos'] ??
                                                [];

                                            pickImg[5][
                                                'networkImage'] = HostingController
                                                        .to
                                                        .getStartHostRes['data']
                                                    ?[
                                                    'bathroom_image_photos'] ??
                                                [];
                                            pickImg.refresh();
                                            print('COVER PHOTO APP $pickImg');
                                          },
                                          error: (e) {
                                            loaderHide();
                                            showSnackBar(
                                                title: ApiConfig.error,
                                                message: e.toString());
                                          });
                                      amenitiesPhotoID.clear();
                                      outDoorImageID.clear();
                                      coverPhotoID.clear();
                                      print("PICK IMG LIST $pickImg");
                                    } else {
                                      showSnackBar(
                                          title: ApiConfig.error,
                                          message:
                                              'Guest Number, Bedrooms, and Bathroom Must be grater than 0 or equal to 1');
                                    }
                                  } else if (pageNum.value == 5) {
                                    if ((((HostingController.to.getStartHostRes['data']?['bathroom_image_photos'] ?? []).isNotEmpty) ||
                                        ((HostingController.to.getStartHostRes['data']
                                                    ?['bedroom_photos'] ??
                                                [])
                                            .isNotEmpty) ||
                                        ((HostingController.to.getStartHostRes['data']
                                                    ?['living_room_photos'] ??
                                                [])
                                            .isNotEmpty) ||
                                        ((HostingController.to.getStartHostRes['data']
                                                    ?['kitchen_image_photos'] ??
                                                [])
                                            .isNotEmpty) ||
                                        ((HostingController.to
                                                        .getStartHostRes['data']
                                                    ?['cover_photo_photos'] ??
                                                [])
                                            .isNotEmpty) ||
                                        ((HostingController.to
                                                        .getStartHostRes['data']
                                                    ?['outdoor_image_photos'] ??
                                                [])
                                            .isNotEmpty))) {
                                      log('EDIT IMAGES YES');
                                      HostingController.to.sendPer.value = 0.0;
                                      Map<String, dynamic> params = {
                                        'user_id':
                                            PrefController.to.user_id.value,
                                        'id': propertyId != null ||
                                                propertyId != ''
                                            ? propertyId
                                            : (MenuScreenController.to
                                                        .getStartHostRes['data']
                                                    ['property_id'])
                                                .toString(),
                                        'variant_photo_id[]': amenitiesPhotoID,
                                        'variant_outdoor_id[]': outDoorImageID,
                                        'variant_cover_id[]': coverPhotoID,
                                        'edit_photo': 'edit'
                                      };
                                      RxList badroom = [].obs;
                                      RxList livingRoom = [].obs;
                                      RxList kitchen = [].obs;
                                      RxList bathroom = [].obs;

                                      log('pickImg-=>   $pickImg');
                                      pickImg[1]['qty'] > 0
                                          ? pickImg[1]['imgPath'].forEach(
                                              (element) async {
                                                if (element != '') {
                                                  badroom.add(
                                                    await dio.MultipartFile
                                                        .fromFile(
                                                            element.toString(),
                                                            filename: element
                                                                .toString()),
                                                  );
                                                }
                                                print('badroom $badroom');
                                              },
                                            )
                                          : [];
                                      pickImg[3]['qty'] > 0
                                          ? pickImg[3]['imgPath']
                                              .forEach((element) async {
                                              if (element != '') {
                                                livingRoom.add(
                                                    await dio.MultipartFile
                                                        .fromFile(
                                                            element.toString(),
                                                            filename: element
                                                                .toString()));
                                              }
                                            })
                                          : [];
                                      pickImg[4]['qty'] > 0
                                          ? pickImg[4]['imgPath']
                                              .forEach((element) async {
                                              if (element != '') {
                                                kitchen.add(
                                                    await dio.MultipartFile
                                                        .fromFile(
                                                            element.toString(),
                                                            filename: element
                                                                .toString()));
                                              }
                                            })
                                          : [];
                                      pickImg[5]['qty'] > 0
                                          ? pickImg[5]['imgPath']
                                              .forEach((element) async {
                                              if (element != '') {
                                                bathroom.add(
                                                    await dio.MultipartFile
                                                        .fromFile(
                                                            element.toString(),
                                                            filename: element
                                                                .toString()));
                                              }
                                            })
                                          : [];

                                      if (coverPhoto.value != '') {
                                        params['cover_photo'] =
                                            await dio.MultipartFile.fromFile(
                                                coverPhoto.value,
                                                filename: coverPhoto.value);
                                      }

                                      if (isHotel.value) {
                                        List outdoor = [];

                                        outDoorImagesHotel
                                            .forEach((element) async {
                                          if (element != '') {
                                            outdoor.add(await dio.MultipartFile
                                                .fromFile(element.toString(),
                                                    filename:
                                                        element.toString()));
                                          }
                                        });

                                        params['outdoor_image[]'] = outdoor;
                                        /*params['new_outdoor_image[]'] = outdoor.skip(outDoorImageID.length);*/
                                      } else {
                                        if (outDoor1Img.value != '' ||
                                            outDoor2Img.value != '' ||
                                            outDoor3Img.value != '') {
                                          List outdoor = [];
                                          if (outDoor1Img.value != '') {
                                            outdoor.add(
                                              await dio.MultipartFile.fromFile(
                                                  outDoor1Img.value,
                                                  filename: outDoor1Img.value),
                                            );
                                          }
                                          if (outDoor2Img.value != '') {
                                            outdoor.add(
                                              await dio.MultipartFile.fromFile(
                                                  outDoor2Img.value,
                                                  filename: outDoor2Img.value),
                                            );
                                          }
                                          if (outDoor3Img.value != '') {
                                            outdoor.add(
                                              await dio.MultipartFile.fromFile(
                                                  outDoor3Img.value,
                                                  filename: outDoor3Img.value),
                                            );
                                          }
                                          params['outdoor_image[]'] = outdoor;
                                        }
                                      }

                                      params['bedroom_image[]'] = badroom;
                                      params['living_room[]'] = livingRoom;

                                      params['kitchen_image[]'] = kitchen;
                                      params['bathroom_image[]'] = bathroom;

                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      Get.defaultDialog(
                                          title: 'Uploading Images',
                                          barrierDismissible: false,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 12,
                                          ),
                                          content: Column(
                                            children: [
                                              Obx(() {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child:
                                                      LinearProgressIndicator(
                                                    value: HostingController
                                                            .to.sendPer.value /
                                                        100,
                                                    color:
                                                        AppColors.colorFE6927,
                                                    backgroundColor:
                                                        AppColors.colorE6E6E6,
                                                    minHeight: 8,
                                                  ),
                                                );
                                              }),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Obx(() {
                                                return Text(
                                                  'Progress ${HostingController.to.sendPer.value.toInt()}%',
                                                  style: color00000s14w500,
                                                );
                                              })
                                            ],
                                          ),
                                          radius: 10);
                                      HostingController.to.hostPropertyApi(
                                          id: propertyId != null ||
                                                  propertyId != ''
                                              ? propertyId
                                              : HostingController.to
                                                      .getStartHostRes['data']
                                                  ['property_id'],
                                          step: 'photos',
                                          isFormData: true,
                                          params: params,
                                          success: () {
                                            Get.back();
                                            // loaderHide();

                                            view!.length > (pageNum.value + 1)
                                                ? pageNum.value =
                                                    pageNum.value + 1
                                                : null;

                                            amenitiesPhotoID.clear();
                                            outDoorImageID.clear();
                                            coverPhotoID.clear();

                                            amenities_publishs.clear();
                                            amenities_standouts.clear();
                                            amenities_Safetys.clear();

                                            amenities_publishs
                                                .value = HostingController.to
                                                        .getStartHostRes['data']
                                                    ?['amenities_publishs'] ??
                                                [];
                                            amenities_standouts
                                                .value = HostingController.to
                                                        .getStartHostRes['data']
                                                    ?['amenities_standouts'] ??
                                                [];
                                            amenities_Safetys
                                                .value = HostingController.to
                                                        .getStartHostRes['data']
                                                    ?['amenities_Safetys'] ??
                                                [];
                                            //here
                                            for (var element
                                                in amenities_publishs) {
                                              element['qty'] = 0;
                                            }
                                            for (var element
                                                in amenities_standouts) {
                                              element['qty'] = false;
                                            }
                                            for (var element
                                                in amenities_Safetys) {
                                              element['qty'] = false;
                                            }

                                            //changes
                                            var selectedIDs = [];
                                            HostingController
                                                .to
                                                .getStartHostRes['data']
                                                    ?['all_select_amenities']
                                                .forEach((element) {
                                              selectedIDs
                                                  .add(element['amenities_id']);
                                            });
                                            print(
                                                "selected amenities$selectedIDs");

                                            for (var e
                                                in amenities_publishs.value) {
                                              e['id'] = e['id'].toString();
                                              print(
                                                  "test ${e['id']} + $selectedIDs");
                                              // print(selectedIDs.contains(
                                              //     e['id'].toString()));
                                              selectedIDs.contains(
                                                      e['id'].toString())
                                                  ? {
                                                      HostingController
                                                          .to
                                                          .getStartHostRes[
                                                              'data']?[
                                                              'all_select_amenities']
                                                          .forEach((element) {
                                                        print(
                                                            "here${element['amenities_id']}compare${e['id']}");

                                                        element['amenities_id'] ==
                                                                e['id']
                                                            ? e['qty'] = int
                                                                .parse(element[
                                                                    'quantity'])
                                                            : 0;
                                                      })
                                                    }
                                                  : null;
                                            }
                                            for (var e
                                                in amenities_standouts.value) {
                                              e['id'] = e['id'].toString();
                                              print("test ${e['id']}");
                                              selectedIDs.contains(
                                                      e['id'].toString())
                                                  ? (HostingController
                                                      .to
                                                      .getStartHostRes['data']?[
                                                          'all_select_amenities']
                                                      .forEach((element) {
                                                      print(
                                                          "here${element['id']}compare${e['id']}");

                                                      element['amenities_id'] ==
                                                              e['id']
                                                          ? e['qty'] = true
                                                          : false;
                                                    }))
                                                  : null;
                                            }
                                            for (var e
                                                in amenities_Safetys.value) {
                                              e['id'] = e['id'].toString();
                                              print("test ${e['id']}");
                                              selectedIDs.contains(
                                                      e['id'].toString())
                                                  ? (HostingController
                                                      .to
                                                      .getStartHostRes['data']?[
                                                          'all_select_amenities']
                                                      .forEach((element) {
                                                      print(
                                                          "here${element['amenities_id']}compare${e['id']}");

                                                      element['amenities_id'] ==
                                                              e['id']
                                                          ? e['qty'] = true
                                                          : false;
                                                    }))
                                                  : null;
                                            }
                                            //till here
                                          },
                                          error: (e) {
                                            Get.back();
                                            // loaderHide();

                                            showSnackBar(
                                              title: ApiConfig.error,
                                              message: e.toString(),
                                            );
                                          });
                                    } else {
                                      log('EDIT IMAGES NOO');

                                      if (isHotel.value) {
                                        if (coverPhoto.value != '') {
                                          RxList outdoor = [].obs;

                                          outDoorImagesHotel
                                              .forEach((element) async {
                                            element != ''
                                                ? outdoor.add(await dio
                                                        .MultipartFile
                                                    .fromFile(
                                                        element.toString(),
                                                        filename:
                                                            element.toString()))
                                                : null;
                                          });
                                          await Future.delayed(
                                              const Duration(seconds: 1));
                                          imgValidation.value =
                                              outDoorImagesHotel.every(
                                                  (element) => element != '');
                                          if (imgValidation.value) {
                                            HostingController.to.sendPer.value =
                                                0.0;
                                            Get.defaultDialog(
                                                title: 'Uploading Images',
                                                barrierDismissible: false,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 12,
                                                ),
                                                content: Column(
                                                  children: [
                                                    Obx(() {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child:
                                                            LinearProgressIndicator(
                                                          value:
                                                              HostingController
                                                                      .to
                                                                      .sendPer
                                                                      .value /
                                                                  100,
                                                          color: AppColors
                                                              .colorFE6927,
                                                          backgroundColor:
                                                              AppColors
                                                                  .colorE6E6E6,
                                                          minHeight: 8,
                                                        ),
                                                      );
                                                    }),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Obx(() {
                                                      return Text(
                                                        'Progress ${HostingController.to.sendPer.value.toInt()}%',
                                                        style:
                                                            color00000s14w500,
                                                      );
                                                    })
                                                  ],
                                                ),
                                                radius: 10);

                                            // loaderShow(context);
                                            HostingController.to
                                                .hostPropertyApi(
                                                    id: propertyId != null ||
                                                            propertyId != ''
                                                        ? propertyId
                                                        : HostingController.to
                                                                .getStartHostRes[
                                                            'data']['property_id'],
                                                    step: 'photos',
                                                    isFormData: true,
                                                    params: {
                                                      'user_id': PrefController
                                                          .to.user_id.value,
                                                      'id': propertyId !=
                                                                  null ||
                                                              propertyId != ''
                                                          ? propertyId
                                                          : (MenuScreenController
                                                                          .to
                                                                          .getStartHostRes[
                                                                      'data'][
                                                                  'property_id'])
                                                              .toString(),
                                                      'cover_photo': await dio
                                                              .MultipartFile
                                                          .fromFile(
                                                              coverPhoto.value,
                                                              filename:
                                                                  coverPhoto
                                                                      .value),
                                                      'outdoor_image[]':
                                                          outdoor,
                                                    },
                                                    success: () {
                                                      Get.back();
                                                      // loaderHide();
                                                      view!.length >
                                                              (pageNum.value +
                                                                  1)
                                                          ? pageNum.value =
                                                              pageNum.value + 1
                                                          : null;
                                                      amenities_publishs
                                                          .clear();

                                                      amenities_standouts
                                                          .clear();

                                                      amenities_Safetys.clear();

                                                      amenities_publishs
                                                          .value = HostingController
                                                                      .to
                                                                      .getStartHostRes[
                                                                  'data']?[
                                                              'amenities_publishs'] ??
                                                          [];
                                                      amenities_standouts
                                                          .value = HostingController
                                                                      .to
                                                                      .getStartHostRes[
                                                                  'data']?[
                                                              'amenities_standouts'] ??
                                                          [];
                                                      amenities_Safetys
                                                          .value = HostingController
                                                                      .to
                                                                      .getStartHostRes[
                                                                  'data']?[
                                                              'amenities_Safetys'] ??
                                                          [];
                                                      //here
                                                      for (var element
                                                          in amenities_publishs) {
                                                        element['qty'] = 0;
                                                      }
                                                      for (var element
                                                          in amenities_standouts) {
                                                        element['qty'] = false;
                                                      }
                                                      for (var element
                                                          in amenities_Safetys) {
                                                        element['qty'] = false;
                                                      }

                                                      //changes
                                                      var selectedIDs = [];
                                                      HostingController
                                                          .to
                                                          .getStartHostRes[
                                                              'data']?[
                                                              'all_select_amenities']
                                                          .forEach((element) {
                                                        selectedIDs.add(element[
                                                            'amenities_id']);
                                                      });
                                                      print(
                                                          "selected$selectedIDs");

                                                      for (var e
                                                          in amenities_publishs
                                                              .value) {
                                                        print(
                                                            "test ${e['id']}");
                                                        selectedIDs.contains(
                                                                e['id'])
                                                            ? (HostingController
                                                                .to
                                                                .getStartHostRes[
                                                                    'data']?[
                                                                    'all_select_amenities']
                                                                .forEach(
                                                                    (element) {
                                                                print(
                                                                    "here${element['id']}compare${e['id']}");

                                                                element['amenities_id'] ==
                                                                        e['id']
                                                                    ? e['qty'] =
                                                                        element[
                                                                            'quantity']
                                                                    : 0;
                                                              }))
                                                            : null;
                                                      }
                                                      for (var e
                                                          in amenities_standouts
                                                              .value) {
                                                        print(
                                                            "test ${e['id']}");
                                                        selectedIDs.contains(
                                                                e['id'])
                                                            ? (HostingController
                                                                .to
                                                                .getStartHostRes[
                                                                    'data']?[
                                                                    'all_select_amenities']
                                                                .forEach(
                                                                    (element) {
                                                                print(
                                                                    "here${element['id']}compare${e['id']}");

                                                                element['amenities_id'] ==
                                                                        e['id']
                                                                    ? e['qty'] =
                                                                        (element['quantity'] ==
                                                                                1)
                                                                            ? true
                                                                            : false
                                                                    : false;
                                                              }))
                                                            : null;
                                                      }
                                                      for (var e
                                                          in amenities_Safetys
                                                              .value) {
                                                        print(
                                                            "test ${e['id']}");
                                                        selectedIDs.contains(
                                                                e['id'])
                                                            ? (HostingController
                                                                .to
                                                                .getStartHostRes[
                                                                    'data']?[
                                                                    'all_select_amenities']
                                                                .forEach(
                                                                    (element) {
                                                                print(
                                                                    "here${element['id']}compare${e['id']}");

                                                                element['amenities_id'] ==
                                                                        e['id']
                                                                    ? e['qty'] =
                                                                        (element['quantity'] ==
                                                                                1)
                                                                            ? true
                                                                            : false
                                                                    : false;
                                                              }))
                                                            : null;
                                                      }
                                                      //till here
                                                      print(amenities_publishs
                                                              .length
                                                              .toString() +
                                                          amenities_standouts
                                                              .length
                                                              .toString() +
                                                          amenities_Safetys
                                                              .length
                                                              .toString());
                                                      log(amenities_publishs
                                                          .toString());
                                                    },
                                                    error: (e) {
                                                      Get.back();
                                                      // loaderHide();

                                                      showSnackBar(
                                                        title: ApiConfig.error,
                                                        message: e.toString(),
                                                      );
                                                    });
                                          } else {
                                            showSnackBar(
                                              title: ApiConfig.error,
                                              message: 'Pick Category Image',
                                            );
                                          }
                                        } else {
                                          showSnackBar(
                                            title: ApiConfig.error,
                                            message: 'Pick Image',
                                          );
                                        }
                                      } else {
                                        if (((coverPhoto.value != '')) ||
                                            (outDoor1Img.value != '') ||
                                            (outDoor2Img.value != '') ||
                                            (outDoor3Img.value != '')) {
                                          RxList badroom = [].obs;
                                          RxList livingRoom = [].obs;
                                          RxList kitchen = [].obs;
                                          RxList bathroom = [].obs;
                                          pickImg[1]['qty'] > 0
                                              ? pickImg[1]['imgPath']
                                                  .forEach((element) async {
                                                  badroom.add(await dio
                                                          .MultipartFile
                                                      .fromFile(
                                                          element.toString(),
                                                          filename: element
                                                              .toString()));
                                                })
                                              : [];
                                          pickImg[3]['qty'] > 0
                                              ? pickImg[3]['imgPath']
                                                  .forEach((element) async {
                                                  livingRoom.add(await dio
                                                          .MultipartFile
                                                      .fromFile(
                                                          element.toString(),
                                                          filename: element
                                                              .toString()));
                                                })
                                              : [];
                                          pickImg[4]['qty'] > 0
                                              ? pickImg[4]['imgPath']
                                                  .forEach((element) async {
                                                  kitchen.add(await dio
                                                          .MultipartFile
                                                      .fromFile(
                                                          element.toString(),
                                                          filename: element
                                                              .toString()));
                                                })
                                              : [];
                                          pickImg[5]['qty'] > 0
                                              ? pickImg[5]['imgPath']
                                                  .forEach((element) async {
                                                  bathroom.add(await dio
                                                          .MultipartFile
                                                      .fromFile(
                                                          element.toString(),
                                                          filename: element
                                                              .toString()));
                                                })
                                              : [];
                                          print("bedroom $badroom");
                                          print("living_room $livingRoom");
                                          print("kitchen $kitchen");
                                          print("bathroom $bathroom");
                                          for (var element in pickImg) {
                                            if ((element['qty'] > 0) &&
                                                element['imgPath'] != null) {
                                              imgValidation.value =
                                                  element['imgPath'].every(
                                                      (element) =>
                                                          element != '');
                                            }
                                          }

                                          if (imgValidation.value) {
                                            HostingController.to.sendPer.value =
                                                0.0;
                                            Get.defaultDialog(
                                                title: 'Uploading Images',
                                                barrierDismissible: false,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 12,
                                                ),
                                                content: Column(
                                                  children: [
                                                    Obx(() {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child:
                                                            LinearProgressIndicator(
                                                          value:
                                                              HostingController
                                                                      .to
                                                                      .sendPer
                                                                      .value /
                                                                  100,
                                                          color: AppColors
                                                              .colorFE6927,
                                                          backgroundColor:
                                                              AppColors
                                                                  .colorE6E6E6,
                                                          minHeight: 8,
                                                        ),
                                                      );
                                                    }),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Obx(() {
                                                      return Text(
                                                        'Progress ${HostingController.to.sendPer.value.toInt()}%',
                                                        style:
                                                            color00000s14w500,
                                                      );
                                                    })
                                                  ],
                                                ),
                                                radius: 10);

                                            // loaderShow(context);
                                            HostingController.to
                                                .hostPropertyApi(
                                                    id: propertyId != null ||
                                                            propertyId != ''
                                                        ? propertyId
                                                        : HostingController.to
                                                                .getStartHostRes[
                                                            'data']['property_id'],
                                                    step: 'photos',
                                                    isFormData: true,
                                                    params: {
                                                      'user_id': PrefController
                                                          .to.user_id.value,
                                                      'id': propertyId !=
                                                                  null ||
                                                              propertyId != ''
                                                          ? propertyId
                                                          : (MenuScreenController
                                                                          .to
                                                                          .getStartHostRes[
                                                                      'data'][
                                                                  'property_id'])
                                                              .toString(),
                                                      'cover_photo': await dio
                                                              .MultipartFile
                                                          .fromFile(
                                                              coverPhoto.value,
                                                              filename:
                                                                  coverPhoto
                                                                      .value),
                                                      'outdoor_image[]': [
                                                        await dio.MultipartFile
                                                            .fromFile(
                                                                outDoor1Img
                                                                    .value,
                                                                filename:
                                                                    outDoor1Img
                                                                        .value),
                                                        await dio.MultipartFile
                                                            .fromFile(
                                                                outDoor2Img
                                                                    .value,
                                                                filename:
                                                                    outDoor2Img
                                                                        .value),
                                                        await dio.MultipartFile
                                                            .fromFile(
                                                                outDoor3Img
                                                                    .value,
                                                                filename:
                                                                    outDoor3Img
                                                                        .value),
                                                      ],
                                                      'bedroom_image[]':
                                                          badroom.value,
                                                      'living_room[]':
                                                          livingRoom.value,
                                                      'kitchen_image[]':
                                                          kitchen.value,
                                                      'bathroom_image[]':
                                                          bathroom.value,
                                                    },
                                                    success: () {
                                                      Get.back();
                                                      // loaderHide();
                                                      view!.length >
                                                              (pageNum.value +
                                                                  1)
                                                          ? pageNum.value =
                                                              pageNum.value + 1
                                                          : null;
                                                      amenities_publishs
                                                          .clear();

                                                      amenities_standouts
                                                          .clear();

                                                      amenities_Safetys.clear();

                                                      amenities_publishs
                                                          .value = HostingController
                                                                      .to
                                                                      .getStartHostRes[
                                                                  'data']?[
                                                              'amenities_publishs'] ??
                                                          [];
                                                      amenities_standouts
                                                          .value = HostingController
                                                                      .to
                                                                      .getStartHostRes[
                                                                  'data']?[
                                                              'amenities_standouts'] ??
                                                          [];
                                                      amenities_Safetys
                                                          .value = HostingController
                                                                      .to
                                                                      .getStartHostRes[
                                                                  'data']?[
                                                              'amenities_Safetys'] ??
                                                          [];
                                                      //here
                                                      for (var element
                                                          in amenities_publishs) {
                                                        element['qty'] = 0;
                                                      }
                                                      for (var element
                                                          in amenities_standouts) {
                                                        element['qty'] = false;
                                                      }
                                                      for (var element
                                                          in amenities_Safetys) {
                                                        element['qty'] = false;
                                                      }

                                                      //changes
                                                      var selectedIDs = [];
                                                      HostingController
                                                          .to
                                                          .getStartHostRes[
                                                              'data']?[
                                                              'all_select_amenities']
                                                          .forEach((element) {
                                                        selectedIDs.add(element[
                                                            'amenities_id']);
                                                      });
                                                      print(
                                                          "selected$selectedIDs");

                                                      for (var e
                                                          in amenities_publishs
                                                              .value) {
                                                        print(
                                                            "test ${e['id']}");
                                                        selectedIDs.contains(
                                                                e['id'])
                                                            ? (HostingController
                                                                .to
                                                                .getStartHostRes[
                                                                    'data']?[
                                                                    'all_select_amenities']
                                                                .forEach(
                                                                    (element) {
                                                                print(
                                                                    "here${element['id']}compare${e['id']}");

                                                                element['amenities_id'] ==
                                                                        e['id']
                                                                    ? e['qty'] =
                                                                        element[
                                                                            'quantity']
                                                                    : 0;
                                                              }))
                                                            : null;
                                                      }
                                                      for (var e
                                                          in amenities_standouts
                                                              .value) {
                                                        print(
                                                            "test ${e['id']}");
                                                        selectedIDs.contains(
                                                                e['id'])
                                                            ? (HostingController
                                                                .to
                                                                .getStartHostRes[
                                                                    'data']?[
                                                                    'all_select_amenities']
                                                                .forEach(
                                                                    (element) {
                                                                print(
                                                                    "here${element['id']}compare${e['id']}");

                                                                element['amenities_id'] ==
                                                                        e['id']
                                                                    ? e['qty'] =
                                                                        (element['quantity'] ==
                                                                                1)
                                                                            ? true
                                                                            : false
                                                                    : false;
                                                              }))
                                                            : null;
                                                      }
                                                      for (var e
                                                          in amenities_Safetys
                                                              .value) {
                                                        print(
                                                            "test ${e['id']}");
                                                        selectedIDs.contains(
                                                                e['id'])
                                                            ? (HostingController
                                                                .to
                                                                .getStartHostRes[
                                                                    'data']?[
                                                                    'all_select_amenities']
                                                                .forEach(
                                                                    (element) {
                                                                print(
                                                                    "here${element['id']}compare${e['id']}");

                                                                element['amenities_id'] ==
                                                                        e['id']
                                                                    ? e['qty'] =
                                                                        (element['quantity'] ==
                                                                                1)
                                                                            ? true
                                                                            : false
                                                                    : false;
                                                              }))
                                                            : null;
                                                      }
                                                      //till here
                                                      print(amenities_publishs
                                                              .length
                                                              .toString() +
                                                          amenities_standouts
                                                              .length
                                                              .toString() +
                                                          amenities_Safetys
                                                              .length
                                                              .toString());
                                                      log(amenities_publishs
                                                          .toString());
                                                    },
                                                    error: (e) {
                                                      Get.back();
                                                      // loaderHide();

                                                      showSnackBar(
                                                        title: ApiConfig.error,
                                                        message: e.toString(),
                                                      );
                                                    });
                                          } else {
                                            showSnackBar(
                                              title: ApiConfig.error,
                                              message: 'Pick Category Image',
                                            );
                                          }
                                        } else {
                                          showSnackBar(
                                            title: ApiConfig.error,
                                            message: 'Pick Image',
                                          );
                                        }
                                      }
                                    }
                                  } else if (pageNum.value == 6) {
                                    RxList amenitiesPublishstemp = [].obs;
                                    RxList amenitiesStandoutstemp = [].obs;
                                    RxList amenitiesSafetystemp = [].obs;

                                    ///amenities
                                    for (var element in amenities_publishs) {
                                      if (element['qty'] > 0) {
                                        amenitiesPublishstemp.add(element);
                                      }
                                    }
                                    for (var element in amenities_standouts) {
                                      if (element['qty']) {
                                        amenitiesStandoutstemp.add(element);
                                      }
                                    }
                                    for (var element in amenities_Safetys) {
                                      if (element['qty']) {
                                        amenitiesSafetystemp.add(element);
                                      }
                                    }

                                    print('AMINENTS');
                                    print('HOTEL ${isHotel.value}');
                                    print(
                                        amenitiesPublishstemp.value.toString());
                                    print(amenitiesStandoutstemp.value
                                        .toString());
                                    print(
                                        amenitiesSafetystemp.value.toString());

                                    ///AMINITIE API CHANGES
                                    loaderShow(context);
                                    HostingController.to.hostPropertyApi(
                                      id: propertyId != null || propertyId != ''
                                          ? propertyId
                                          : HostingController
                                                  .to.getStartHostRes['data']
                                              ['property_id'],
                                      step: 'amenities',
                                      params: {
                                        'user_id':
                                            PrefController.to.user_id.value,
                                        'id': propertyId != null ||
                                                propertyId != ''
                                            ? propertyId
                                            : (MenuScreenController.to
                                                        .getStartHostRes['data']
                                                    ['property_id'])
                                                .toString(),
                                        'amenities_post': {
                                          'standouts_amenities':
                                              amenitiesStandoutstemp.value,
                                          'safety_amenities':
                                              amenitiesSafetystemp.value,
                                          'amenities':
                                              amenitiesPublishstemp.value,
                                        }
                                      },
                                      success: () {
                                        loaderHide();
                                        view!.length > (pageNum.value + 1)
                                            ? pageNum.value = pageNum.value + 1
                                            : null;
                                        allGuest.value = false;
                                        corporatesGuest.value = false;
                                        couple.value = false;
                                        allMale.value = false;
                                        family.value = false;
                                        nonVegFood.value = false;
                                        vegFood.value = false;
                                        insideAlcohole.value = false;
                                        outsideAlcohole.value = false;
                                        bothAlcohole.value = false;
                                        insideSmoke.value = false;
                                        outsideSmoke.value = false;
                                        bothSmoke.value = false;

                                        _propertyTitle.text = HostingController
                                                    .to.getStartHostRes['data']
                                                ?['result']?['name'] ??
                                            '';
                                        _propertyDescription.text =
                                            HostingController
                                                            .to.getStartHostRes[
                                                        'data']?['result']
                                                    ?['property_description'] ??
                                                '';

                                        _checkInTime.text = HostingController
                                                .to
                                                .getStartHostRes['data']
                                                    ?['property_house_rule']
                                                    ?['check_in_time']
                                                .toString()
                                                .substring(0, 5) ??
                                            "01:00 PM";
                                        _checkOutTime.text = HostingController
                                                .to
                                                .getStartHostRes['data']
                                                    ?['property_house_rule']
                                                    ?['check_out_time']
                                                .toString()
                                                .substring(0, 5) ??
                                            "11:00 AM";

                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['guest_allowed'] ??
                                                '')
                                            .toString()
                                            .contains('all')) {
                                          allGuest.value = true;
                                          corporatesGuest.value =
                                              allGuest.value;
                                          couple.value = allGuest.value;
                                          allMale.value = allGuest.value;
                                          family.value = allGuest.value;
                                        }
                                        log(
                                            (HostingController.to.getStartHostRes[
                                                                'data']?[
                                                            'property_house_rule']
                                                        ?['guest_allowed'] ??
                                                    [])
                                                .toString(),
                                            name: 'GUEST ALLOWED');
                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['guest_allowed'] ??
                                                '')
                                            .toString()
                                            .contains('Corporates Guest')) {
                                          corporatesGuest.value = true;
                                        }
                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['guest_allowed'] ??
                                                '')
                                            .toString()
                                            .contains('Couple Allowed')) {
                                          couple.value = true;
                                        }
                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['guest_allowed'] ??
                                                '')
                                            .toString()
                                            .contains('All Male Group')) {
                                          allMale.value = true;
                                        }
                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['guest_allowed'] ??
                                                '')
                                            .toString()
                                            .contains('Local Id Allow')) {
                                          allMale.value = true;
                                        }
                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['guest_allowed'] ??
                                                '')
                                            .toString()
                                            .contains('Local Id Not Allow')) {
                                          family.value = true;
                                        }
                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['guest_allowed'] ??
                                                '')
                                            .toString()
                                            .contains('Family Allowed')) {
                                          family.value = true;
                                        }

                                        petFriendly.value = (HostingController.to
                                                                .getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['pet_friendly'] ??
                                                '')
                                            .toString();
                                        swimmingPoolTimming
                                            .value = (HostingController.to
                                                            .getStartHostRes['data']
                                                        ?['property_house_rule']
                                                    ?['pool_time'] ??
                                                '')
                                            .toString();
                                        _openTime.text = HostingController
                                                .to
                                                .getStartHostRes['data']
                                                    ?['property_house_rule']
                                                    ?['pool_open_time']
                                                .toString()
                                                .substring(0, 5) ??
                                            '8:00 AM';
                                        _closeTime.text = HostingController
                                                .to
                                                .getStartHostRes['data']
                                                    ?['property_house_rule']
                                                    ?['pool_close_time']
                                                .toString()
                                                .substring(0, 5) ??
                                            '6:00 PM';

                                        loudMucisTimming
                                            .value = (HostingController.to
                                                            .getStartHostRes['data']
                                                        ?['property_house_rule']
                                                    ?['loud_music_time'] ??
                                                '')
                                            .toString();
                                        _musicopenTime.text = HostingController
                                                        .to
                                                        .getStartHostRes['data']
                                                    ?['property_house_rule']
                                                ?['loud_music_open_time'] ??
                                            '';
                                        _musiccloseTime.text = HostingController
                                                            .to.getStartHostRes[
                                                        'data']
                                                    ?['property_house_rule']
                                                ?['loud_music_close_time'] ??
                                            '';

                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['food_allowed'] ??
                                                '')
                                            .toString()
                                            .contains('Non Veg')) {
                                          nonVegFood.value = true;
                                        }
                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['food_allowed'] ??
                                                '')
                                            .toString()
                                            .contains('Veg')) {
                                          vegFood.value = true;
                                        }

                                        ///Alcohole Allowed
                                        alcoholeAllowed
                                            .value = (HostingController.to
                                                            .getStartHostRes['data']
                                                        ?['property_house_rule']
                                                    ?['is_alcohol_allowed'] ??
                                                '')
                                            .toString();

                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['alcohol_allowed_side'] ??
                                                "")
                                            .toString()
                                            .contains('Inside')) {
                                          insideAlcohole.value = true;
                                        }
                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['alcohol_allowed_side'] ??
                                                '')
                                            .toString()
                                            .contains('Outside')) {
                                          outsideAlcohole.value = true;
                                        }
                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['alcohol_allowed_side'] ??
                                                '')
                                            .toString()
                                            .contains('Both')) {
                                          bothAlcohole.value = true;
                                          insideAlcohole.value = true;
                                          outsideAlcohole.value = true;
                                        }

                                        ///smoking view
                                        smokingAllowed
                                            .value = (HostingController.to
                                                            .getStartHostRes['data']
                                                        ?['property_house_rule']
                                                    ?['is_smoking_allowed'] ??
                                                '')
                                            .toString();

                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['smoking_allowed'] ??
                                                '')
                                            .toString()
                                            .contains('Inside')) {
                                          insideSmoke.value = true;
                                        }
                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['smoking_allowed'] ??
                                                '')
                                            .toString()
                                            .contains('Outside')) {
                                          outsideSmoke.value = true;
                                        }
                                        if ((HostingController.to.getStartHostRes[
                                                            'data']
                                                        ?['property_house_rule']
                                                    ?['smoking_allowed'] ??
                                                '')
                                            .toString()
                                            .contains('Both')) {
                                          bothSmoke.value = true;
                                          insideSmoke.value = true;
                                          outsideSmoke.value = true;
                                        }
                                        customeRules.clear();
                                        customeRules.add('');
                                        if ((HostingController.to.getStartHostRes[
                                                            'data']?[
                                                        'property_custom_house_rule'] ??
                                                    []) !=
                                                null &&
                                            (HostingController.to.getStartHostRes[
                                                            'data']?[
                                                        'property_custom_house_rule'] ??
                                                    []) !=
                                                []) {
                                          HostingController
                                              .to
                                              .getStartHostRes['data']
                                                  ['property_custom_house_rule']
                                              .forEach((element) {
                                            log(element.toString());
                                            if (element['title'] != null &&
                                                element != null &&
                                                element['title'] != '') {
                                              customeRules.add(
                                                  element['title'].toString());
                                            }
                                          });
                                        }

                                        log('HOUSE RULE $customeRules');
                                      },
                                      error: (e) {
                                        loaderHide();
                                        showSnackBar(
                                            title: ApiConfig.error,
                                            message: e.toString());
                                      },
                                    );
                                    // view!.length > (pageNum.value + 1)
                                    //     ? pageNum.value = pageNum.value + 1
                                    //     : null;
                                  } else if (pageNum.value == 7) {
                                    if (_propertyTitle.text.isEmpty ||
                                        _propertyDescription.text.isEmpty) {
                                      showSnackBar(
                                          title: ApiConfig.error,
                                          message:
                                              'Property Title And Description Required');
                                    } else {
                                      Map<String, dynamic> params = {
                                        'user_id':
                                            PrefController.to.user_id.value,
                                        'id': propertyId != null ||
                                                propertyId != ''
                                            ? propertyId
                                            : (MenuScreenController.to
                                                        .getStartHostRes['data']
                                                    ['property_id'])
                                                .toString(),
                                        'name': _propertyTitle.text,
                                        'summary': _propertyDescription.text,
                                        "host_house_rule": customeRules.value,
                                        "check_in": _checkInTime.text,
                                        "check_out": _checkOutTime.text,
                                        "pool_open_time": _openTime.text,
                                        "pool_close_time": _closeTime.text,
                                        "loud_music_open_time":
                                            _musicopenTime.text,
                                        "loud_music_close_time":
                                            _musiccloseTime.text,
                                      };

                                      List guest = [];

                                      if (allGuest.value) {
                                        guest = [
                                          'all',
                                          'Corporates Guest',
                                          'Couple Allowed',
                                          isHotel.value
                                              ? 'Local Id Allow'
                                              : 'All Male Group',
                                          isHotel.value
                                              ? 'Local Id Not Allow'
                                              : 'Family Allowed'
                                        ];
                                        params['guest_allowed'] = guest;
                                      } else if (corporatesGuest.value ||
                                          couple.value ||
                                          allMale.value ||
                                          family.value) {
                                        corporatesGuest.value
                                            ? guest.add('Corporates Guest')
                                            : null;
                                        couple.value
                                            ? guest.add('Couple Allowed')
                                            : null;
                                        allMale.value
                                            ? guest.add(isHotel.value
                                                ? 'Local Id Allow'
                                                : 'All Male Group')
                                            : null;
                                        family.value
                                            ? guest.add(isHotel.value
                                                ? 'Local Id Not Allow'
                                                : 'Family Allowed')
                                            : null;
                                        params['guest_allowed'] = guest;
                                      }
                                      if (petFriendly.value != '') {
                                        params['pet_friendly'] =
                                            petFriendly.value;
                                      } else {
                                        null;
                                      }
                                      if (swimmingPoolTimming.value != "") {
                                        params['pool_time'] =
                                            swimmingPoolTimming.value;
                                      }
                                      if (loudMucisTimming.value != '') {
                                        params['loud_music_time'] =
                                            loudMucisTimming.value;
                                      } else {
                                        null;
                                      }
                                      if (nonVegFood.value || vegFood.value) {
                                        List food = [];
                                        nonVegFood.value
                                            ? food.add('Non Veg')
                                            : null;
                                        vegFood.value ? food.add('Veg') : null;
                                        params['food_allowed'] = food;
                                      }
                                      if (alcoholeAllowed.value != '') {
                                        params['is_alcohol_allowed'] =
                                            alcoholeAllowed.value;

                                        if (bothAlcohole.value) {
                                          params['alcohol_allowed_side'] = [
                                            'Inside',
                                            'Outside',
                                            'Both'
                                          ];
                                        } else if (insideAlcohole.value ||
                                            outsideAlcohole.value) {
                                          List alcohole = [];

                                          insideAlcohole.value
                                              ? alcohole.add('Inside')
                                              : null;
                                          outsideAlcohole.value
                                              ? alcohole.add('Outside')
                                              : null;

                                          params['alcohol_allowed_side'] =
                                              alcohole;
                                        }
                                      } else {
                                        null;
                                      }
                                      print(bothSmoke.value.toString());
                                      if (smokingAllowed.value != '') {
                                        params['is_smoking_allowed'] =
                                            smokingAllowed.value;
                                        if (bothSmoke.value) {
                                          params['smoking_allowed'] = [
                                            'Inside',
                                            'Outside',
                                            'Both'
                                          ];
                                        } else if (insideSmoke.value ||
                                            outsideSmoke.value) {
                                          List smoking = [];

                                          insideSmoke.value
                                              ? smoking.add('Inside')
                                              : null;
                                          outsideSmoke.value
                                              ? smoking.add('Outside')
                                              : null;

                                          params['smoking_allowed'] = smoking;
                                        }
                                      } else {
                                        null;
                                      }
                                      log('DESCRIPTION API PARAMS $params');
                                      loaderShow(context);
                                      HostingController.to.hostPropertyApi(
                                        id: propertyId != null ||
                                                propertyId != ''
                                            ? propertyId
                                            : HostingController
                                                    .to.getStartHostRes['data']
                                                ['property_id'],
                                        step: 'description',
                                        params: params,
                                        success: () {
                                          loaderHide();
                                          view!.length > (pageNum.value + 1)
                                              ? pageNum.value =
                                                  pageNum.value + 1
                                              : null;
                                          Airbnb.value = false;
                                          StayVista.value = false;
                                          Makemytrip.value = false;
                                          Bookingcom.value = false;
                                          Other.value = false;
                                          _showHostNo.value = false;
                                          _showCareTakerNo.value = false;
                                          _showEmergencyNo.value = false;
                                          _priceExpectation.text =
                                              (HostingController.to
                                                              .getStartHostRes[
                                                          'data']['price'] ??
                                                      '0')
                                                  .toString();
                                          _weekendPriceExpectation
                                              .text = (HostingController
                                                          .to.getStartHostRes[
                                                      'data']['weekend_price'] ??
                                                  '0')
                                              .toString();

                                          firstFiveDiscount.value =
                                              HostingController
                                                  .to
                                                  .getStartHostRes['data']
                                                      ['result']
                                                      ['is_first_booking']
                                                  .toString();

                                          _hostContactNumber
                                              .text = (HostingController.to
                                                      .getStartHostRes['data']?[
                                                  'result']?['owner_number'] ??
                                              '');
                                          _careTakerContactNumber
                                              .text = (HostingController
                                                          .to.getStartHostRes[
                                                      'data']?['result']
                                                  ?['care_taker_number'] ??
                                              '');
                                          _emergencyContactNumber
                                              .text = (HostingController
                                                          .to.getStartHostRes[
                                                      'data']?['result']
                                                  ?['emergency_number'] ??
                                              '');

                                          _showHostNo.value =
                                              (HostingController.to.getStartHostRes[
                                                                          'data']
                                                                      ?[
                                                                      'result']
                                                                  ?[
                                                                  'is_owner_number'] ??
                                                              '')
                                                          .toString() ==
                                                      "1"
                                                  ? true
                                                  : false;
                                          _showCareTakerNo.value =
                                              (HostingController.to.getStartHostRes[
                                                                          'data']
                                                                      ?[
                                                                      'result']
                                                                  ?[
                                                                  'is_care_taker_number'] ??
                                                              '')
                                                          .toString() ==
                                                      "1"
                                                  ? true
                                                  : false;
                                          _showEmergencyNo.value =
                                              (HostingController.to.getStartHostRes[
                                                                          'data']
                                                                      ?[
                                                                      'result']
                                                                  ?[
                                                                  'is_emergency_number'] ??
                                                              '')
                                                          .toString() ==
                                                      "1"
                                                  ? true
                                                  : false;

                                          otherWebSite
                                              .value = (HostingController
                                                              .to.getStartHostRes[
                                                          'data']?['result']
                                                      ?['is_other_website'] ??
                                                  '')
                                              .toString();

                                          if ((HostingController
                                                              .to.getStartHostRes[
                                                          'data']?['result']
                                                      ?['other_website'] ??
                                                  '')
                                              .toString()
                                              .contains('Airbnb')) {
                                            Airbnb.value = true;
                                          }
                                          if ((HostingController
                                                              .to.getStartHostRes[
                                                          'data']?['result']
                                                      ?['other_website'] ??
                                                  '')
                                              .toString()
                                              .contains('OYO')) {
                                            Airbnb.value = true;
                                          }
                                          if ((HostingController
                                                              .to.getStartHostRes[
                                                          'data']?['result']
                                                      ?['other_website'] ??
                                                  '')
                                              .toString()
                                              .contains('Agoda')) {
                                            StayVista.value = true;
                                          }
                                          if ((HostingController
                                                              .to.getStartHostRes[
                                                          'data']?['result']
                                                      ?['other_website'] ??
                                                  '')
                                              .toString()
                                              .contains('Stay Vista')) {
                                            StayVista.value = true;
                                          }

                                          if ((HostingController
                                                              .to.getStartHostRes[
                                                          'data']?['result']
                                                      ?['other_website'] ??
                                                  '')
                                              .toString()
                                              .contains('Booking.com')) {
                                            Bookingcom.value = true;
                                          }
                                          if ((HostingController
                                                              .to.getStartHostRes[
                                                          'data']?['result']
                                                      ?['other_website'] ??
                                                  '')
                                              .toString()
                                              .contains('Makemytrip')) {
                                            Makemytrip.value = true;
                                          }
                                          if ((HostingController
                                                              .to.getStartHostRes[
                                                          'data']?['result']
                                                      ?['other_website_name'] ??
                                                  '')
                                              .toString()
                                              .contains('Other')) {
                                            Other.value = true;
                                          }

                                          OtherController
                                              .text = (HostingController
                                                              .to.getStartHostRes[
                                                          'data']?['result']
                                                      ?['name_other_website'] ??
                                                  '')
                                              .toString();
                                        },
                                        error: (e) {
                                          loaderHide();
                                          showSnackBar(
                                            title: ApiConfig.error,
                                            message: e.toString(),
                                          );
                                        },
                                      );
                                    }
                                  } else if (pageNum.value == 8) {
                                    if (int.parse(_priceExpectation.text) < 1 &&
                                        (!isHotel.value)) {
                                      showSnackBar(
                                          title: ApiConfig.error,
                                          message:
                                              'Price must be greater then 1rs');
                                    } else if ((_hostContactNumber
                                            .text.isEmpty) ||
                                        _careTakerContactNumber.text.isEmpty ||
                                        _emergencyContactNumber.text.isEmpty) {
                                      showSnackBar(
                                          title: ApiConfig.error,
                                          message:
                                              'Please Fill Contact Number of Host,Care taker, and Emergency Number');
                                    } else if ((_hostContactNumber.text.characters
                                                .length !=
                                            10) ||
                                        _careTakerContactNumber
                                                .text.characters.length !=
                                            10 ||
                                        _emergencyContactNumber
                                                .text.characters.length !=
                                            10) {
                                      showSnackBar(
                                          title: ApiConfig.error,
                                          message:
                                              'Contact Number Must be in 10 Digits');
                                    } else if (_showHostNo.value == false &&
                                        _showCareTakerNo.value == false &&
                                        _showEmergencyNo.value == false &&
                                        (!isHotel.value)) {
                                      showSnackBar(
                                          title: ApiConfig.error,
                                          message:
                                              'Please select at least one option, Which number can customers see');
                                    } else if (Other.value &&
                                        OtherController.text.isEmpty) {
                                      showSnackBar(
                                          title: ApiConfig.error,
                                          message: 'Please Enter Website Name');
                                    } else {
                                      Map<String, dynamic> params = {
                                        'user_id':
                                            PrefController.to.user_id.value,
                                        'id': propertyId != null ||
                                                propertyId != ''
                                            ? propertyId
                                            : (MenuScreenController.to
                                                        .getStartHostRes['data']
                                                    ['property_id'])
                                                .toString(),
                                        'price': _priceExpectation.text,
                                        'weekend_price':
                                            _weekendPriceExpectation.text,
                                        'owner_number': _hostContactNumber.text,
                                        'care_taker_number':
                                            _careTakerContactNumber.text,
                                        'emergency_number':
                                            _emergencyContactNumber.text,
                                        'is_first_booking':
                                            firstFiveDiscount.value
                                      };
                                      _showHostNo.value
                                          ? params['is_owner_number'] = 1
                                          : null;
                                      _showCareTakerNo.value
                                          ? params['is_care_taker_number'] = 1
                                          : null;
                                      _showEmergencyNo.value
                                          ? params['is_emergency_number'] = 1
                                          : null;
                                      otherWebSite.value != ''
                                          ? params['is_other_website'] =
                                              otherWebSite.value
                                          : null;

                                      if (Airbnb.value ||
                                          Bookingcom.value ||
                                          StayVista.value ||
                                          Makemytrip.value) {
                                        List otherdata = [];
                                        Airbnb.value
                                            ? otherdata.add(isHotel.value
                                                ? 'OYO'
                                                : 'Airbnb')
                                            : null;
                                        Bookingcom.value
                                            ? otherdata.add('Booking.com')
                                            : null;
                                        StayVista.value
                                            ? otherdata.add(isHotel.value
                                                ? 'Agoda'
                                                : 'Stay Vista')
                                            : null;
                                        Makemytrip.value
                                            ? otherdata.add('Makemytrip')
                                            : null;

                                        params['other_website'] = otherdata;
                                      }

                                      if (Other.value) {
                                        params['other_website_name'] = 'Other';
                                        params['name_other_website'] =
                                            OtherController.text;
                                      }

                                      print('PARAMS $params');
                                      loaderShow(context);
                                      HostingController.to.hostPropertyApi(
                                          id: propertyId != null ||
                                                  propertyId != ''
                                              ? propertyId
                                              : HostingController.to
                                                      .getStartHostRes['data']
                                                  ['property_id'],
                                          step: 'pricing',
                                          params: params,
                                          success: () {
                                            loaderHide();
                                            view!.length > (pageNum.value + 1)
                                                ? pageNum.value =
                                                    pageNum.value + 1
                                                : null;
                                          },
                                          error: (e) {
                                            loaderHide();
                                            showSnackBar(
                                                title: ApiConfig.error,
                                                message: e.toString());
                                          });
                                    }
                                  } else if (pageNum.value == 9) {
                                    if (_termsAndCondition.value &&
                                        _information.value) {
                                      loaderShow(context);
                                      HostingController.to.hostPropertyApi(
                                          id: propertyId != null ||
                                                  propertyId != ''
                                              ? propertyId
                                              : HostingController.to
                                                      .getStartHostRes['data']
                                                  ['property_id'],
                                          step: 'provide_property',
                                          params: {
                                            'user_id':
                                                PrefController.to.user_id.value,
                                            'id': propertyId != null ||
                                                    propertyId != ''
                                                ? propertyId
                                                : (MenuScreenController
                                                            .to.getStartHostRes[
                                                        'data']['property_id'])
                                                    .toString(),
                                            'sponser_code':
                                                'GK-${_partnerCode.text}',
                                            'verified_property':
                                                _information.value ? '1' : '0',
                                            'is_agree': _termsAndCondition.value
                                                ? '1'
                                                : '0',
                                          },
                                          success: () {
                                            loaderHide();
                                            view!.length > (pageNum.value + 1)
                                                ? pageNum.value =
                                                    pageNum.value + 1
                                                : null;
                                          },
                                          error: (e) {
                                            loaderHide();
                                            showSnackBar(
                                                title: ApiConfig.error,
                                                message: e.toString());
                                          });
                                    } else {
                                      showSnackBar(
                                          title: ApiConfig.error,
                                          message:
                                              'Please Accept The Terms & Conditions');
                                    }
                                  } else if (pageNum.value == 10) {
                                    loaderShow(context);
                                    HostingController.to.hostPropertyApi(
                                        id: propertyId != null ||
                                                propertyId != ''
                                            ? propertyId
                                            : HostingController
                                                    .to.getStartHostRes['data']
                                                ['property_id'],
                                        step: 'booking',
                                        params: {
                                          'user_id':
                                              PrefController.to.user_id.value,
                                          'id': propertyId != null ||
                                                  propertyId != ''
                                              ? propertyId
                                              : (MenuScreenController
                                                          .to.getStartHostRes[
                                                      'data']['property_id'])
                                                  .toString(),
                                        },
                                        success: () {
                                          loaderHide();
                                          view!.length > (pageNum.value + 1)
                                              ? pageNum.value =
                                                  pageNum.value + 1
                                              : null;
                                        },
                                        error: (e) {
                                          loaderHide();
                                          showSnackBar(
                                              title: ApiConfig.error,
                                              message: e.toString());
                                        });
                                  } else {
                                    view!.length > (pageNum.value + 1)
                                        ? pageNum.value = pageNum.value + 1
                                        : null;
                                  }

                                  log("STEP NUMBER ${pageNum.value}");
                                  _scrollController.animateTo(
                                      //go to top of scroll
                                      0, //scroll offset to go
                                      duration: const Duration(
                                          milliseconds:
                                              200), //duration of scroll
                                      curve: Curves.fastOutSlowIn //scroll type
                                      );
                                },
                                name: 'Next',
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 17),
                            child: CommonButton(
                              onPressed: () {
                                widget.property_id == null
                                    ? MenuScreenController.to.getStartHostApi(
                                        params: {
                                            'user_id':
                                                PrefController.to.user_id.value
                                          },
                                        error: (e) {
                                          loaderHide();
                                          showSnackBar(
                                              title: ApiConfig.error,
                                              message: e.toString());
                                          log(e.toString());
                                        },
                                        success: () {
                                          setState(() {
                                            propertyId = (MenuScreenController
                                                        .to
                                                        .getStartHostRes['data']
                                                    ['property_id'])
                                                .toString();
                                          });
                                          HostingController.to.hostPropertyApi(
                                            id: propertyId != null ||
                                                    propertyId != ''
                                                ? propertyId ?? ''
                                                : (MenuScreenController
                                                            .to.getStartHostRes[
                                                        'data']['property_id'])
                                                    .toString(),
                                            step: 'set_location',
                                            params: {
                                              'user_id': PrefController
                                                  .to.user_id.value,
                                              'id': propertyId != null ||
                                                      propertyId != ''
                                                  ? propertyId
                                                  : (MenuScreenController.to
                                                              .getStartHostRes[
                                                          'data']['property_id'])
                                                      .toString(),
                                            },
                                            success: () {
                                              loaderHide();
                                              view!.length > (pageNum.value + 1)
                                                  ? pageNum.value =
                                                      pageNum.value + 1
                                                  : null;

                                              propertyType
                                                  .value = HostingController.to
                                                              .getStartHostRes['data'][
                                                          'property_select_type'] ==
                                                      null
                                                  ? 0
                                                  : HostingController
                                                      .to
                                                      .getStartHostRes['data']
                                                          ?['property_type']
                                                      .indexWhere((element) =>
                                                          element['id'] ==
                                                          HostingController.to
                                                                  .getStartHostRes['data']
                                                              ['property_select_type']['id']);

                                              if ((HostingController.to
                                                                      .getStartHostRes[
                                                                  'data']?[
                                                              'property_select_type']
                                                          ?['name'] ??
                                                      '') ==
                                                  "Hotel") {
                                                isHotel.value = true;
                                              }
                                            },
                                            error: (e) {
                                              loaderHide();
                                              showSnackBar(
                                                  title: ApiConfig.error,
                                                  message: e.toString());
                                            },
                                          );
                                          loaderHide();
                                        })
                                    : HostingController.to.hostPropertyApi(
                                        id: propertyId != null ||
                                                propertyId != ''
                                            ? propertyId ?? ''
                                            : (MenuScreenController.to
                                                        .getStartHostRes['data']
                                                    ['property_id'])
                                                .toString(),
                                        step: 'set_location',
                                        params: {
                                          'user_id':
                                              PrefController.to.user_id.value,
                                          'id': propertyId != null ||
                                                  propertyId != ''
                                              ? propertyId
                                              : (MenuScreenController
                                                          .to.getStartHostRes[
                                                      'data']['property_id'])
                                                  .toString(),
                                        },
                                        success: () {
                                          loaderHide();
                                          view!.length > (pageNum.value + 1)
                                              ? pageNum.value =
                                                  pageNum.value + 1
                                              : null;

                                          propertyType.value = HostingController
                                                          .to
                                                          .getStartHostRes['data']
                                                      [
                                                      'property_select_type'] ==
                                                  null
                                              ? 0
                                              : HostingController
                                                  .to
                                                  .getStartHostRes['data']
                                                      ?['property_type']
                                                  .indexWhere((element) =>
                                                      element['id'] ==
                                                      HostingController.to
                                                              .getStartHostRes['data']
                                                          ['property_select_type']['id']);

                                          if ((HostingController.to.getStartHostRes[
                                                              'data']?[
                                                          'property_select_type']
                                                      ?['name'] ??
                                                  '') ==
                                              "Hotel") {
                                            isHotel.value = true;
                                          }
                                        },
                                        error: (e) {
                                          loaderHide();
                                          showSnackBar(
                                              title: ApiConfig.error,
                                              message: e.toString());
                                        },
                                      );

                                loaderShow(context);
                              },
                              name: 'Start',
                            ),
                          ),
                        );
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Obx(
              () {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    IconButton(
                      onPressed: () {
                        DashBoardController.to.unlistedPropertyRes.clear();

                        DashBoardController.to.unlistedPropertyAPI(
                          params: {'status': 'Listed', 'page': 0, "limit": 10},
                          error: (e) {
                            showSnackBar(
                                title: ApiConfig.error, message: e.toString());
                          },
                        );
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                      ),
                    ),
                    /*  Obx(() {
                      return IgnorePointer(
                        ignoring: true,
                        child: SliderTheme(
                          data: const SliderThemeData(
                            trackHeight: 12,

                            // thumbShape: SliderComponentShape.noThumb,
                          ),
                          child: Slider(
                              value: pageNum.value.toDouble(),
                              onChanged: (val) {},
                              min: -1,
                              max: (view!.length - 1).toDouble(),
                              inactiveColor: AppColors.colorE6E6E6,
                              activeColor: AppColors.colorFE6927),
                        ),
                      );
                    }),*/
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: LinearProgressIndicator(
                          backgroundColor: AppColors.colorE6E6E6,
                          color: AppColors.colorFE6927,
                          value:
                              ((pageNum.value + 1) * 100 / view!.length) / 100,
                          minHeight: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: view![pageNum.value],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  previous() {
    log('pageNum.value ${pageNum.value}');
    if (pageNum.value == 2) {
      print('set_location');
      loaderShow(context);
      HostingController.to.hostPropertyApi(
          id: propertyId != null || propertyId != ''
              ? propertyId!
              : (MenuScreenController.to.getStartHostRes['data']['property_id'])
                  .toString(),
          step: 'set_location',
          params: {
            'user_id': PrefController.to.user_id.value,
            'id': propertyId != null || propertyId != ''
                ? propertyId
                : (MenuScreenController.to.getStartHostRes['data']
                        ['property_id'])
                    .toString(),
            'is_previous': 1,
          },
          success: () {
            loaderHide();
            view!.length > (pageNum.value - 1)
                ? pageNum.value = pageNum.value - 1
                : null;

            propertyType.value = HostingController.to.getStartHostRes['data']
                        ['property_select_type'] ==
                    null
                ? 0
                : HostingController.to.getStartHostRes['data']?['property_type']
                    .indexWhere((element) =>
                        element['id'] ==
                        HostingController.to.getStartHostRes['data']
                            ['property_select_type']['id']);
          },
          error: (e) {
            loaderHide();
            showSnackBar(title: ApiConfig.error, message: e.toString());
          });
    } else if (pageNum.value == 3) {
      print('describes_your_location');
      loaderShow(context);
      HostingController.to.hostPropertyApi(
          id: propertyId != null || propertyId != ''
              ? propertyId
              : HostingController.to.getStartHostRes['data']['property_id'],
          step: 'describes_your_location',
          params: {
            'user_id': PrefController.to.user_id.value,
            'id': propertyId != null || propertyId != ''
                ? propertyId
                : (MenuScreenController.to.getStartHostRes['data']
                        ['property_id'])
                    .toString(),
            'is_previous': 1,
          },
          success: () {
            loaderHide();
            view!.length > (pageNum.value - 1)
                ? pageNum.value = pageNum.value - 1
                : null;

            categiry[0]['qty'] = int.parse((HostingController.to
                        .getStartHostRes['data']?['result']?['square_feet'] ??
                    '0')
                .toString());
            categiry[1]['qty'] = int.parse(
                (HostingController.to.getStartHostRes['data']?['result']
                            ?['constructed_square_feet'] ??
                        '0')
                    .toString());
          },
          error: (e) {
            loaderHide();
            showSnackBar(
              title: ApiConfig.error,
              message: e.toString(),
            );
          });
    } else if (pageNum.value == 4) {
      print('construction_area');
      loaderShow(context);
      HostingController.to.hostPropertyApi(
          id: propertyId != null || propertyId != ''
              ? propertyId
              : HostingController.to.getStartHostRes['data']['property_id'],
          step: 'construction_area',
          params: {
            'user_id': PrefController.to.user_id.value,
            'id': propertyId != null || propertyId != ''
                ? propertyId
                : (MenuScreenController.to.getStartHostRes['data']
                        ['property_id'])
                    .toString(),
            'is_previous': 1,
          },
          success: () {
            loaderHide();

            view!.length > (pageNum.value - 1)
                ? pageNum.value = pageNum.value - 1
                : null;

            if (HostingController.to.getStartHostRes['data']
                        ['property_address'] !=
                    {} ||
                HostingController.to.getStartHostRes['data']['property_address']
                    .isNotEmpty) {
              countryController.text = HostingController
                  .to.getStartHostRes['data']['property_address']['country'];
              state.text = HostingController.to.getStartHostRes['data']
                  ['property_address']['state'];
              addressline1.text = HostingController.to.getStartHostRes['data']
                  ['property_address']['address_line_1'];
              fullAddress.text = HostingController.to.getStartHostRes['data']
                  ['property_address']['address_line_2'];
              city.text = HostingController.to.getStartHostRes['data']
                  ['property_address']['city'];
              zip.text = HostingController.to.getStartHostRes['data']
                  ['property_address']['postal_code'];
              longitude.text = HostingController.to.getStartHostRes['data']
                  ['property_address']['longitude'];
              latitude.text = HostingController.to.getStartHostRes['data']
                  ['property_address']['latitude'];
              markers.clear();

              showLocation = LatLng(
                double.parse((HostingController.to.getStartHostRes['data']
                            ?['property_address']?['latitude'] ??
                        '21.1702')
                    .toString()),
                double.parse((HostingController.to.getStartHostRes['data']
                            ?['property_address']?['longitude'] ??
                        '72.8311')
                    .toString()),
              );
              controller?.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: showLocation, zoom: 10)
                  //17 is new zoom level
                  ));
              Marker newMarker = Marker(
                  markerId: MarkerId('$id'),
                  position: LatLng(
                    double.parse((HostingController.to.getStartHostRes['data']
                                ?['property_address']?['latitude'] ??
                            '21.1702')
                        .toString()),
                    double.parse((HostingController.to.getStartHostRes['data']
                                ?['property_address']?['longitude'] ??
                            '72.8311')
                        .toString()),
                  ),
                  // infoWindow: InfoWindow(title: 'Gleekey'),
                  icon: BitmapDescriptor.defaultMarker);
              markers.add(newMarker);
              id = id + 1;
            }

            print('COUNTRY NAME ${countryController.text}');
          },
          error: (e) {
            loaderHide();

            showSnackBar(title: ApiConfig.error, message: e.toString());
          });
    } else if (pageNum.value == 5) {
      print('location');
      loaderShow(context);
      HostingController.to.hostPropertyApi(
          id: propertyId != null || propertyId != ''
              ? propertyId
              : HostingController.to.getStartHostRes['data']['property_id'],
          step: 'location',
          params: {
            'user_id': PrefController.to.user_id.value,
            'id': propertyId != null || propertyId != ''
                ? propertyId
                : (MenuScreenController.to.getStartHostRes['data']
                        ['property_id'])
                    .toString(),
            'is_previous': 1,
          },
          success: () {
            loaderHide();
            if (isHotel.value) {
              view!.length > (pageNum.value + -2)
                  ? pageNum.value = pageNum.value - 2
                  : null;
            } else {
              view!.length > (pageNum.value - 1)
                  ? pageNum.value = pageNum.value - 1
                  : null;
            }

            pickImg.value = basic.value;

            basic[0]['qty'] = int.parse((HostingController
                        .to.getStartHostRes['data']?['result']?['guest'] ??
                    '0')
                .toString());

            pickImg[0]['imgPath'] =
                RxList.generate(basic[0]['qty'], (imgIndex) => '');
            print("no. of Guest${pickImg[0]['imgPath']}");
            basic[1]['qty'] = int.parse((HostingController
                        .to.getStartHostRes['data']?['result']?['bedrooms'] ??
                    '0')
                .toString());

            pickImg[1]['imgPath'] =
                RxList.generate(basic[1]['qty'], (imgIndex) => '');
            basic[2]['qty'] = int.parse(
                (HostingController.to.getStartHostRes['data']?['result']
                            ?['extra_mattress'] ??
                        '0')
                    .toString());
            pickImg[2]['imgPath'] =
                RxList.generate(pickImg[2]['qty'], (imgIndex) => '');
            basic[3]['qty'] = int.parse((HostingController.to
                        .getStartHostRes['data']?['result']?['living_rooms'] ??
                    '0')
                .toString());
            pickImg[3]['imgPath'] =
                RxList.generate(pickImg[3]['qty'], (imgIndex) => '');
            basic[4]['qty'] = int.parse((HostingController
                        .to.getStartHostRes['data']?['result']?['kitchen'] ??
                    '0')
                .toString());
            pickImg[4]['imgPath'] =
                RxList.generate(pickImg[4]['qty'], (imgIndex) => '');
            basic[5]['qty'] = int.parse((HostingController
                        .to.getStartHostRes['data']?['result']?['bathrooms'] ??
                    '0')
                .toString());
            pickImg[5]['imgPath'] =
                RxList.generate(pickImg[5]['qty'], (imgIndex) => '');
          },
          error: (e) {
            loaderHide();

            showSnackBar(title: ApiConfig.error, message: e.toString());
          });
    } else if (pageNum.value == 6) {
      print('basic');
      loaderShow(context);
      HostingController.to.hostPropertyApi(
          id: propertyId != null || propertyId != ''
              ? propertyId
              : HostingController.to.getStartHostRes['data']['property_id'],
          step: 'basics',
          params: {
            'user_id': PrefController.to.user_id.value,
            'id': propertyId != null || propertyId != ''
                ? propertyId
                : (MenuScreenController.to.getStartHostRes['data']
                        ['property_id'])
                    .toString(),
            'is_previous': 1,
          },
          success: () {
            loaderHide();
            view!.length > (pageNum.value - 1)
                ? pageNum.value = pageNum.value - 1
                : null;
            coverPhotoNetwork = HostingController.to.getStartHostRes['data']
                ['cover_photo_photos'];
            outDoorImageNetwork.value = HostingController
                    .to.getStartHostRes['data']?['outdoor_image_photos'] ??
                [];
            outDoorImageNetwork.refresh();

            outDoorImagesHotel.value = List.generate(
              outDoorImageNetwork.length,
              (index) => '',
            );
            outDoorImagesHotel.refresh();
            log(outDoorImageNetwork.length.toString(),
                name: 'outDoorImageNetwork');
            log(outDoorImagesHotel.length.toString(),
                name: 'outDoorImagesHotel');

            /*List data = [
                                              '1',
                                              '2',
                                              '3',
                                              '4'
                                            ];
                                            List data2 = ['5', '6'];

                                            List data3 = List.generate(
                                                data.length,
                                                    (index) => '');
                                            data3.replaceRange(
                                                0, data2.length, data2);
                                            print(data3);*/

            ///bedroom_photos
            // here
            pickImg[1]['qty'] = (HostingController.to.getStartHostRes['data']
                        ?['bedroom_photos'] ??
                    [])
                .length;
            pickImg[1]['networkImage'] = HostingController
                    .to.getStartHostRes['data']?['bedroom_photos'] ??
                [];

            ///living_room_photos
            pickImg[3]['qty'] = (HostingController.to.getStartHostRes['data']
                        ?['living_room_photos'] ??
                    [])
                .length;
            pickImg[3]['networkImage'] = HostingController
                    .to.getStartHostRes['data']?['living_room_photos'] ??
                [];

            ///kitchen_image_photos
            pickImg[4]['qty'] = (HostingController.to.getStartHostRes['data']
                        ?['kitchen_image_photos'] ??
                    [])
                .length;
            pickImg[4]['networkImage'] = HostingController
                    .to.getStartHostRes['data']?['kitchen_image_photos'] ??
                [];

            ///bathroom_image_photos
            pickImg[5]['qty'] = (HostingController.to.getStartHostRes['data']
                        ?['bathroom_image_photos'] ??
                    [])
                .length;
            pickImg[5]['networkImage'] = HostingController
                    .to.getStartHostRes['data']?['bathroom_image_photos'] ??
                [];
            pickImg.refresh();
            print(
                'Length  bedroom_photos${pickImg[1]['qty']}   living_room_photos${pickImg[3]['qty']}  kitchen_image_photos${pickImg[4]['qty']}   bathroom_image_photos${pickImg[5]['qty']}');

            pickImg[1]['imgPath'] =
                List.generate(pickImg[1]['qty'], (index) => '');
            pickImg[3]['imgPath'] =
                List.generate(pickImg[3]['qty'], (index) => '');
            pickImg[4]['imgPath'] =
                List.generate(pickImg[4]['qty'], (index) => '');
            pickImg[5]['imgPath'] =
                List.generate(pickImg[5]['qty'], (index) => '');
          },
          error: (e) {
            loaderHide();
            showSnackBar(title: ApiConfig.error, message: e.toString());
          });
      print("PICK IMG LIST $pickImg");
    } else if (pageNum.value == 7) {
      print('photos');
      loaderShow(context);
      HostingController.to.hostPropertyApi(
          id: propertyId != null || propertyId != ''
              ? propertyId
              : HostingController.to.getStartHostRes['data']['property_id'],
          step: 'photos',
          isFormData: true,
          params: {
            'user_id': PrefController.to.user_id.value,
            'id': propertyId != null || propertyId != ''
                ? propertyId
                : (MenuScreenController.to.getStartHostRes['data']
                        ['property_id'])
                    .toString(),
            'is_previous': 1,
          },
          success: () {
            loaderHide();
            view!.length > (pageNum.value - 1)
                ? pageNum.value = pageNum.value - 1
                : null;

            amenities_publishs.clear();
            amenities_standouts.clear();
            amenities_Safetys.clear();

            amenities_publishs.value = HostingController
                    .to.getStartHostRes['data']?['amenities_publishs'] ??
                [];
            amenities_standouts.value = HostingController
                    .to.getStartHostRes['data']?['amenities_standouts'] ??
                [];
            amenities_Safetys.value = HostingController
                    .to.getStartHostRes['data']?['amenities_Safetys'] ??
                [];
            //here
            for (var element in amenities_publishs) {
              element['qty'] = 0;
            }
            for (var element in amenities_standouts) {
              element['qty'] = false;
            }
            for (var element in amenities_Safetys) {
              element['qty'] = false;
            }

            //changes
            var selectedIDs = [];
            HostingController
                .to.getStartHostRes['data']?['all_select_amenities']
                .forEach((element) {
              selectedIDs.add(element['amenities_id']);
            });
            print("selected$selectedIDs");

            for (var e in amenities_publishs.value) {
              print("test ${e['id']}");
              selectedIDs.contains(e['id'].toString())
                  ? (HostingController
                      .to.getStartHostRes['data']?['all_select_amenities']
                      .forEach((element) {
                      print("here${element['id']}compare${e['id']}");

                      element['amenities_id'] == e['id']
                          ? e['qty'] = element['quantity']
                          : 0;
                    }))
                  : null;
            }
            for (var e in amenities_standouts.value) {
              print("test ${e['id']}");
              selectedIDs.contains(e['id'].toString())
                  ? (HostingController
                      .to.getStartHostRes['data']?['all_select_amenities']
                      .forEach((element) {
                      print("here${element['id']}compare${e['id']}");

                      element['amenities_id'] == e['id']
                          ? e['qty'] = (element['quantity'] == 1) ? true : false
                          : false;
                    }))
                  : null;
            }
            for (var e in amenities_Safetys.value) {
              print("test ${e['id']}");
              selectedIDs.contains(e['id'])
                  ? (HostingController
                      .to.getStartHostRes['data']?['all_select_amenities']
                      .forEach((element) {
                      print("here${element['id']}compare${e['id']}");

                      element['amenities_id'] == e['id']
                          ? e['qty'] = (element['quantity'] == 1) ? true : false
                          : false;
                    }))
                  : null;
            }
            //till here
            print(amenities_publishs.length.toString() +
                amenities_standouts.length.toString() +
                amenities_Safetys.length.toString());
            log(amenities_publishs.toString());
          },
          error: (e) {
            loaderHide();

            showSnackBar(
              title: ApiConfig.error,
              message: e.toString(),
            );
          });
    } else if (pageNum.value == 8) {
      print('amenities');
      loaderShow(context);
      HostingController.to.hostPropertyApi(
        id: propertyId != null || propertyId != ''
            ? propertyId
            : HostingController.to.getStartHostRes['data']['property_id'],
        step: 'amenities',
        params: {
          'user_id': PrefController.to.user_id.value,
          'id': propertyId != null || propertyId != ''
              ? propertyId
              : (MenuScreenController.to.getStartHostRes['data']['property_id'])
                  .toString(),
          'is_previous': 1,
        },
        success: () {
          loaderHide();
          view!.length > (pageNum.value - 1)
              ? pageNum.value = pageNum.value - 1
              : null;
          allGuest.value = false;
          corporatesGuest.value = false;
          couple.value = false;
          allMale.value = false;
          family.value = false;
          nonVegFood.value = false;
          vegFood.value = false;
          insideAlcohole.value = false;
          outsideAlcohole.value = false;
          bothAlcohole.value = false;
          insideSmoke.value = false;
          outsideSmoke.value = false;
          bothSmoke.value = false;

          _propertyTitle.text = HostingController.to.getStartHostRes['data']
                  ?['result']?['name'] ??
              '';
          _propertyDescription.text =
              HostingController.to.getStartHostRes['data']?['result']
                      ?['property_description'] ??
                  '';

          _checkInTime.text = HostingController.to.getStartHostRes['data']
                  ?['property_house_rule']?['check_in_time'] ??
              "01:00 PM";
          _checkOutTime.text = HostingController.to.getStartHostRes['data']
                  ?['property_house_rule']?['check_out_time'] ??
              "11:00 AM";

          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['guest_allowed'] ??
                  '')
              .toString()
              .contains('all')) {
            allGuest.value = true;
            corporatesGuest.value = allGuest.value;
            couple.value = allGuest.value;
            allMale.value = allGuest.value;
            family.value = allGuest.value;
          }

          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['guest_allowed'] ??
                  '')
              .toString()
              .contains('Corporates Guest')) {
            corporatesGuest.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['guest_allowed'] ??
                  '')
              .toString()
              .contains('Couple Allowed')) {
            couple.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['guest_allowed'] ??
                  '')
              .toString()
              .contains('All Male Group')) {
            allMale.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['guest_allowed'] ??
                  '')
              .toString()
              .contains('Local Id Allow')) {
            allMale.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['guest_allowed'] ??
                  '')
              .toString()
              .contains('Local Id Not Allow')) {
            family.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['guest_allowed'] ??
                  '')
              .toString()
              .contains('Family Allowed')) {
            family.value = true;
          }

          petFriendly.value = (HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['pet_friendly'] ??
                  '')
              .toString();
          swimmingPoolTimming.value =
              (HostingController.to.getStartHostRes['data']
                          ?['property_house_rule']?['pool_time'] ??
                      '')
                  .toString();
          _openTime.text = HostingController.to.getStartHostRes['data']
                  ?['property_house_rule']?['pool_open_time'] ??
              '8:00 AM';
          _closeTime.text = HostingController.to.getStartHostRes['data']
                  ?['property_house_rule']?['pool_close_time'] ??
              '6:00 PM';

          loudMucisTimming.value = (HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['loud_music_time'] ??
                  '')
              .toString();
          _musicopenTime.text = HostingController.to.getStartHostRes['data']
                  ?['property_house_rule']?['loud_music_open_time'] ??
              '';
          _musiccloseTime.text = HostingController.to.getStartHostRes['data']
                  ?['property_house_rule']?['loud_music_close_time'] ??
              '';

          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['food_allowed'] ??
                  '')
              .toString()
              .contains('Non Veg')) {
            nonVegFood.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['food_allowed'] ??
                  '')
              .toString()
              .contains('Veg')) {
            vegFood.value = true;
          }

          ///Alcohole Allowed
          alcoholeAllowed.value = (HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['is_alcohol_allowed'] ??
                  '')
              .toString();

          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['alcohol_allowed_side'] ??
                  "")
              .toString()
              .contains('Inside')) {
            insideAlcohole.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['alcohol_allowed_side'] ??
                  '')
              .toString()
              .contains('Outside')) {
            outsideAlcohole.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['alcohol_allowed_side'] ??
                  '')
              .toString()
              .contains('Both')) {
            bothAlcohole.value = true;
            insideAlcohole.value = true;
            outsideAlcohole.value = true;
          }

          ///smoking view
          smokingAllowed.value = (HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['is_smoking_allowed'] ??
                  '')
              .toString();

          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['smoking_allowed'] ??
                  '')
              .toString()
              .contains('Inside')) {
            insideSmoke.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['smoking_allowed'] ??
                  '')
              .toString()
              .contains('Outside')) {
            outsideSmoke.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']
                      ?['property_house_rule']?['smoking_allowed'] ??
                  '')
              .toString()
              .contains('Both')) {
            bothSmoke.value = true;
            insideSmoke.value = true;
            outsideSmoke.value = true;
          }
          customeRules.clear();
          customeRules.add('');
          if ((HostingController.to.getStartHostRes['data']
                          ?['property_custom_house_rule'] ??
                      []) !=
                  null &&
              (HostingController.to.getStartHostRes['data']
                          ?['property_custom_house_rule'] ??
                      []) !=
                  []) {
            HostingController
                .to.getStartHostRes['data']['property_custom_house_rule']
                .forEach((element) {
              log(element.toString());
              if (element['title'] != null &&
                  element != null &&
                  element['title'] != '') {
                customeRules.add(element['title'].toString());
              }
            });
          }

          log('HOUSE RULE $customeRules');
        },
        error: (e) {
          loaderHide();
          showSnackBar(title: ApiConfig.error, message: e.toString());
        },
      );
    } else if (pageNum.value == 9) {
      print('description');
      loaderShow(context);
      HostingController.to.hostPropertyApi(
        id: propertyId != null || propertyId != ''
            ? propertyId
            : HostingController.to.getStartHostRes['data']['property_id'],
        step: 'description',
        params: {
          'user_id': PrefController.to.user_id.value,
          'id': propertyId != null || propertyId != ''
              ? propertyId
              : (MenuScreenController.to.getStartHostRes['data']['property_id'])
                  .toString(),
          'is_previous': 1,
        },
        success: () {
          loaderHide();
          view!.length > (pageNum.value - 1)
              ? pageNum.value = pageNum.value - 1
              : null;
          Airbnb.value = false;
          StayVista.value = false;
          Makemytrip.value = false;
          Bookingcom.value = false;
          Other.value = false;
          _showHostNo.value = false;
          _showCareTakerNo.value = false;
          _showEmergencyNo.value = false;
          _priceExpectation.text =
              (HostingController.to.getStartHostRes['data']['price'] ?? '0')
                  .toString();
          _weekendPriceExpectation.text =
              (HostingController.to.getStartHostRes['data']['weekend_price'] ??
                      '0')
                  .toString();
          firstFiveDiscount.value = HostingController
              .to.getStartHostRes['data']['result']['is_first_booking']
              .toString();

          _hostContactNumber.text = (HostingController
                  .to.getStartHostRes['data']?['result']?['owner_number'] ??
              '');
          _careTakerContactNumber.text = (HostingController.to
                  .getStartHostRes['data']?['result']?['care_taker_number'] ??
              '');
          _emergencyContactNumber.text = (HostingController
                  .to.getStartHostRes['data']?['result']?['emergency_number'] ??
              '');

          _showHostNo.value = (HostingController.to.getStartHostRes['data']
                              ?['result']?['is_owner_number'] ??
                          '')
                      .toString() ==
                  "1"
              ? true
              : false;
          _showCareTakerNo.value = (HostingController.to.getStartHostRes['data']
                              ?['result']?['is_care_taker_number'] ??
                          '')
                      .toString() ==
                  "1"
              ? true
              : false;
          _showEmergencyNo.value = (HostingController.to.getStartHostRes['data']
                              ?['result']?['is_emergency_number'] ??
                          '')
                      .toString() ==
                  "1"
              ? true
              : false;

          otherWebSite.value = (HostingController.to.getStartHostRes['data']
                      ?['result']?['is_other_website'] ??
                  '')
              .toString();

          if ((HostingController.to.getStartHostRes['data']?['result']
                      ?['other_website'] ??
                  '')
              .toString()
              .contains('Airbnb')) {
            Airbnb.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']?['result']
                      ?['other_website'] ??
                  '')
              .toString()
              .contains('Stay Vista')) {
            StayVista.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']?['result']
                      ?['other_website'] ??
                  '')
              .toString()
              .contains('OYO')) {
            Airbnb.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']?['result']
                      ?['other_website'] ??
                  '')
              .toString()
              .contains('Agoda')) {
            StayVista.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']?['result']
                      ?['other_website'] ??
                  '')
              .toString()
              .contains('Booking.com')) {
            Bookingcom.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']?['result']
                      ?['other_website'] ??
                  '')
              .toString()
              .contains('Makemytrip')) {
            Makemytrip.value = true;
          }
          if ((HostingController.to.getStartHostRes['data']?['result']
                      ?['other_website_name'] ??
                  '')
              .toString()
              .contains('Other')) {
            Other.value = true;
          }

          OtherController.text = (HostingController.to.getStartHostRes['data']
                      ?['result']?['name_other_website'] ??
                  '')
              .toString();
        },
        error: (e) {
          loaderHide();
          showSnackBar(
            title: ApiConfig.error,
            message: e.toString(),
          );
        },
      );
    } else {
      view!.length > (pageNum.value - 1)
          ? pageNum.value = pageNum.value - 1
          : null;
    }
  }

  Widget step1() {
    return Column(
      children: [
        Image.asset(
          AppImages.homeImg,
        ),
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppColors.colorffffff,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 5,
                  color: Color.fromRGBO(0, 0, 0, 0.05))
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step 1',
                style: color00000s14w500,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Set your location details',
                style: color00000s20w600,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Provide details regarding the kind of property you have in this phase and whether visitors will book the complete property or simply a room. Also, add how many people can stay in your property',
                style: color50perBlacks13w400,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List data = [
    {'img': AppImages.villaIcon, 'name': 'Villa'},
    {'img': AppImages.farnIcon, 'name': 'Farm House'},
    {'img': AppImages.hotelIcon, 'name': 'Hotel'},
    {'img': AppImages.homeIcon, 'name': 'Home'}
  ];
  Widget step2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Which of these perfectly describes your location?',
          style: color00000s18w600,
        ),
        const SizedBox(
          height: 30,
        ),
        Obx(() {
          return HostingController.to.getStartHostRes['data']
                      ?['property_type'] ==
                  null
              ? const SizedBox()
              : GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 40,
                      crossAxisSpacing: 40),
                  shrinkWrap: true,
                  children: List.generate(
                    (HostingController.to.getStartHostRes['data']
                            ?['property_type'])
                        .length,
                    (index) => StreamBuilder(
                      stream: propertyType.stream,
                      builder: (context, snapshot) {
                        return InkWell(
                          onTap: index > 1
                              ? null
                              : () {
                                  propertyType.value = index;

                                  isHotel.value = (data[propertyType.value]
                                          ['name'] ==
                                      'Hotel');
                                  print(HostingController
                                              .to.getStartHostRes['data']
                                          ?['property_type'][propertyType.value]
                                      ['id']);
                                },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: propertyType.value == index
                                            ? AppColors.colorFE6927
                                            : AppColors.color1C2534
                                                .withOpacity(0.2),
                                      ),
                                      color: AppColors.colorffffff),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: ApiConfig
                                                  .Property_Image_Url +
                                              HostingController
                                                          .to.getStartHostRes[
                                                      'data']['property_type']
                                                  [index]['icon'],
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: CupertinoActivityIndicator(
                                              color: AppColors.colorFE6927,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          height: 50,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          HostingController
                                                  .to.getStartHostRes['data']
                                              ['property_type'][index]['name'],
                                          style: colorfffffffs13w600.copyWith(
                                              color: AppColors.color000000),
                                        ),
                                        index > 1
                                            ? Text(
                                                'Coming soon',
                                                style:
                                                    color00000s14w500.copyWith(
                                                        color: AppColors
                                                            .color9a0400),
                                              )
                                            : const SizedBox(),
                                      ]),
                                ),
                              ),
                              Positioned(
                                right: Get.width * 0.025,
                                top: Get.height * 0.01,
                                child: propertyType.value == index
                                    ? Image.asset(
                                        AppImages.checkedIcon,
                                        height: 30,
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
        })
      ],
    );
  }

  ///step 3

  RxList categiry = [
    {'img': AppImages.areaIcon, 'name': 'Area (Sq.Ft.)', 'qty': 0},
    {
      'img': AppImages.constructedIcon,
      'name': 'Constructed (Sq.Ft.)',
      'qty': 0
    },
  ].obs;

  RxList<Map<String, dynamic>> bedOpetionList = <Map<String, dynamic>>[
    {'bedType': '', 'numberOfBed': '1'}
  ].obs;

  RxList<Map<String, dynamic>> amenities = <Map<String, dynamic>>[].obs;

  RxList amenitiesIdsHotel = [].obs;
  RxBool privetBathroom = false.obs;
  Widget step3() {
    RxInt selectedRoom = 0.obs;

    ///others
    return Obx(
      () {
        return isHotel.value
            ? (!showHotelRooms.value)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Do You Provide Property?',
                        style: color00000s18w600,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Details',
                        style: color00000s15w600,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Room Type',
                              style: color00000s14w500,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.color000000.withOpacity(0.2),
                                ),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: DropdownButton(
                                value: _roomType.value,
                                underline: const SizedBox(),
                                borderRadius: BorderRadius.circular(6),
                                style: color00000s14w500,
                                isExpanded: true,
                                icon: Icon(Icons.keyboard_arrow_down_rounded,
                                    size: 20, color: AppColors.color000000),
                                items: List.generate(
                                  roomTypeList.length,
                                  (index) => DropdownMenuItem(
                                    value: roomTypeList[index]['title'],
                                    child: Text(roomTypeList[index]['title'],
                                        style: color00000s14w500),
                                    onTap: () {
                                      _roomName.value = 'Please Select';
                                      roomNameList.value = [
                                        {'title': 'Please Select'}
                                      ];
                                      roomNameList.refresh();
                                      _roomTypeID.value =
                                          roomTypeList[index]['id'].toString();
                                      loaderShow(context);
                                      GetRoomNameController.to.getRoomnameApi(
                                          params: {
                                            'room_type_id': roomTypeList[index]
                                                ['id'],
                                          },
                                          success: () {
                                            loaderHide();
                                            ((GetRoomNameController.to.getRoomName[
                                                                'data']?[
                                                            'get_room_names'] ??
                                                        [])
                                                    .isNotEmpty)
                                                ? {
                                                    GetRoomNameController
                                                        .to
                                                        .getRoomName['data']
                                                            ?['get_room_names']
                                                        .forEach((element) {
                                                      roomNameList.add(element
                                                          as Map<String,
                                                              dynamic>);
                                                    })
                                                  }
                                                : null;
                                          },
                                          error: (e) {
                                            loaderHide();
                                            showSnackBar(
                                                title: ApiConfig.error,
                                                message: e.toString());
                                          });
                                    },
                                  ),
                                ),
                                onChanged: (_) {
                                  _roomType.value = _.toString();
                                  _numberOfBedOeptionsList.value = [
                                    {
                                      'bedRooms': '1',
                                      'bed_options': [
                                        {
                                          'bedType': badTypeList[0]['name'],
                                          'numberOfBed': '1',
                                          'id': _badTypeID.value
                                        }
                                      ],
                                      'privet_room': false,
                                      'selected_index': 0,
                                      'guest_stay': '1',
                                    }
                                  ];
                                  _numberOfBedOeptionsList.refresh();
                                  if (_roomType.value == 'Suite') {
                                    _numberOfLivingSuiteRoomsList.add({
                                      'bedRooms': '1',
                                      'guest': '1',
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      /* CommonDropDownHotel(title: 'Room Type',dropdownList: ['Please Select','A', 'B', 'C', 'D'],dropdownValue: _roomType,),*/
                      _roomType.value == 'Please Select'
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Room Name',
                                    style: color00000s14w500,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: AppColors.color000000
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: DropdownButton(
                                      value: _roomName.value,
                                      underline: const SizedBox(),
                                      borderRadius: BorderRadius.circular(6),
                                      style: color00000s14w500,
                                      isExpanded: true,
                                      icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          size: 20,
                                          color: AppColors.color000000),
                                      items: List.generate(
                                          roomNameList.length,
                                          (index) => DropdownMenuItem(
                                              onTap: () {
                                                _roomNameID.value =
                                                    roomNameList[index]['id']
                                                        .toString();
                                              },
                                              value: roomNameList[index]
                                                  ['title'],
                                              child: Text(
                                                  roomNameList[index]['title'],
                                                  style: color00000s14w500))),
                                      onChanged: (_) {
                                        _roomName.value = _.toString();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      _roomType.value == 'Please Select'
                          ? const SizedBox()
                          : CommonTextFeildPart(
                              title: 'Custom Name',
                              controller: _customName,
                            ),
                      CommonDropDownHotel(
                          title: 'Smoking Policy',
                          dropdownList: ['Non-smoking', 'Smoking'],
                          dropdownValue: _smokingPolicy),
                      CommonTextFeildPart(
                        title: 'Number Of Rooms',
                        controller: _numberOfRooms,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onTap: () {},
                      ),
                      _roomType.value == 'Suite'
                          ? CommonDropDownHotel(
                              title: 'Number Of bedrooms',
                              dropdownList: [
                                '0',
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                                '6',
                                '7',
                                '8',
                                '9'
                              ],
                              dropdownValue: _numberOfBedSuiteRooms,
                              onChanged: (val) {
                                _numberOfBedSuiteRooms.value = val.toString();
                                _numberOfBedOeptionsList.value = List.generate(
                                    int.parse(_numberOfBedSuiteRooms.value),
                                    (index) => {
                                          'bedRooms': '1',
                                          'bed_options': [
                                            {
                                              'bedType': _badType.value,
                                              'numberOfBed': '1',
                                              'id': _badTypeID.value
                                            }
                                          ],
                                          'privet_room': false,
                                          'selected_index': 0,
                                          'guest_stay': '1',
                                        });
                              })
                          : const SizedBox(),
                      _roomType.value == 'Suite'
                          ? CommonDropDownHotel(
                              title: 'Number Of living rooms',
                              dropdownList: ['0', '1', '2', '3', '4', '5'],
                              dropdownValue: _numberOfLivingSuiteRooms,
                              onChanged: (_) {
                                _numberOfLivingSuiteRooms.value = _;
                                _numberOfLivingSuiteRoomsList.value =
                                    List.generate(
                                        int.parse(
                                            _numberOfLivingSuiteRooms.value),
                                        (index) => {
                                              'bedRooms': '1',
                                              'guest': '1',
                                            });
                              })
                          : const SizedBox(),
                      _roomType.value == 'Suite'
                          ? CommonDropDownHotel(
                              title: 'Number Of bathrooms',
                              dropdownList: [
                                '0',
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                                '6',
                                '7',
                                '8',
                                '9'
                              ],
                              dropdownValue: _numberOfBathSuiteRooms,
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Divider(
                          color: AppColors.color000000.withOpacity(0.5),
                          endIndent: 30,
                          indent: 30,
                        ),
                      ),
                      _roomType.value == 'Single'
                          ? const SizedBox()
                          : Column(
                              children: List.generate(
                                  _numberOfBedOeptionsList.length,
                                  (index) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Bed Options ${index + 1}',
                                            style: color00000s15w600,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: StreamBuilder(
                                                stream: _numberOfBedOeptionsList
                                                    .stream,
                                                builder: (context, snapshot) {
                                                  return Row(
                                                    children: List.generate(
                                                      _numberOfBedOeptionsList[
                                                                  index]
                                                              ['bed_options']
                                                          .length,
                                                      (i) => SizedBox(
                                                        width: Get.width / 2.5,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                InkWell(
                                                                    onTap: () {
                                                                      _numberOfBedOeptionsList[
                                                                              index]
                                                                          [
                                                                          'selected_index'] = i;
                                                                      /*_badType.value =  _numberOfBedOeptionsList[index]['bed_options'][i]['bedType'];
                                     _numberOfBed.value =
                                         _numberOfBedOeptionsList[index]['bed_options'][i]['numberOfBed'].toString();*/
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus();

                                                                      _numberOfBedOeptionsList
                                                                          .refresh();
                                                                    },
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    child: Text(
                                                                        'Bed Option ${i + 1}')),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                i > 0
                                                                    ? InkWell(
                                                                        onTap:
                                                                            () {
                                                                          _numberOfBedOeptionsList[index]['bed_options']
                                                                              .removeAt(i);
                                                                          _numberOfBedOeptionsList
                                                                              .refresh();
                                                                          showSnackBar(
                                                                              title: ApiConfig.success,
                                                                              message: 'Bed Removed');
                                                                        },
                                                                        highlightColor:
                                                                            Colors
                                                                                .transparent,
                                                                        splashColor:
                                                                            Colors
                                                                                .transparent,
                                                                        child:
                                                                            CircleAvatar(
                                                                          minRadius:
                                                                              10,
                                                                          backgroundColor:
                                                                              AppColors.color828282,
                                                                          child: Icon(
                                                                              Icons.close,
                                                                              color: AppColors.colorffffff,
                                                                              size: 15),
                                                                        ))
                                                                    : const SizedBox()
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Divider(
                                                              color: _numberOfBedOeptionsList[
                                                                              index]
                                                                          [
                                                                          'selected_index'] ==
                                                                      i
                                                                  ? AppColors
                                                                      .colorFE6927
                                                                  : AppColors
                                                                      .color000000
                                                                      .withOpacity(
                                                                          0.2),
                                                              thickness:
                                                                  _numberOfBedOeptionsList[index]
                                                                              [
                                                                              'selected_index'] ==
                                                                          i
                                                                      ? 3
                                                                      : 1,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'What kind of beds are available in this room?',
                                                  style: color00000s14w500,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                      color: AppColors
                                                          .color000000
                                                          .withOpacity(0.2),
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16),
                                                  child: DropdownButton<String>(
                                                    // value:_numberOfBedOeptionsList[index]['bed_options'][_numberOfBedOeptionsList[index]['selected_index']]['bedType']+index.toString(),
                                                    hint: Text(
                                                        _numberOfBedOeptionsList[
                                                                        index][
                                                                    'bed_options']
                                                                [
                                                                _numberOfBedOeptionsList[
                                                                        index]
                                                                    [
                                                                    'selected_index']]
                                                            ['bedType'],
                                                        style:
                                                            color00000s14w500),
                                                    underline: const SizedBox(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    style: color00000s14w500,
                                                    isExpanded: true,
                                                    icon: Icon(
                                                        Icons
                                                            .keyboard_arrow_down_rounded,
                                                        size: 20,
                                                        color: AppColors
                                                            .color000000),
                                                    items: List.generate(
                                                      badTypeList.length,
                                                      (index2) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                        value:
                                                            badTypeList[index2]
                                                                ['name'],
                                                        child: Text(
                                                            badTypeList[index2]
                                                                ['name'],
                                                            style:
                                                                color00000s14w500),
                                                        onTap: () {
                                                          _numberOfBedOeptionsList[
                                                                          index]
                                                                      [
                                                                      'bed_options']
                                                                  [
                                                                  _numberOfBedOeptionsList[
                                                                          index]
                                                                      [
                                                                      'selected_index']]
                                                              [
                                                              'id'] = badTypeList[
                                                                  index2]['id']
                                                              .toString();
                                                        },
                                                      ),
                                                    ),

                                                    onChanged: (_) {
                                                      _numberOfBedOeptionsList[
                                                                      index][
                                                                  'bed_options']
                                                              [
                                                              _numberOfBedOeptionsList[
                                                                      index]
                                                                  [
                                                                  'selected_index']]
                                                          [
                                                          'bedType'] = _.toString();
                                                      _numberOfBedOeptionsList
                                                          .refresh();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Number Of Bed',
                                                  style: color00000s14w500,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                      color: AppColors
                                                          .color000000
                                                          .withOpacity(0.2),
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16),
                                                  child: DropdownButton<String>(
                                                      // value:_numberOfBedOeptionsList[index]['bed_options'][_numberOfBedOeptionsList[index]['selected_index']]['bedType']+index.toString(),
                                                      hint: Text(
                                                          _numberOfBedOeptionsList[index]
                                                                          ['bed_options']
                                                                      [_numberOfBedOeptionsList[index]['selected_index']]
                                                                  [
                                                                  'numberOfBed']
                                                              .toString(),
                                                          style:
                                                              color00000s14w500),
                                                      underline:
                                                          const SizedBox(),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      style: color00000s14w500,
                                                      isExpanded: true,
                                                      icon:
                                                          Icon(Icons.keyboard_arrow_down_rounded,
                                                              size: 20,
                                                              color: AppColors
                                                                  .color000000),
                                                      items: List.generate(
                                                          [
                                                            '1',
                                                            '2',
                                                            '3',
                                                            '4',
                                                            '5',
                                                            '6',
                                                            '7',
                                                            '8',
                                                            '9',
                                                            '10',
                                                            '11',
                                                            '12'
                                                          ].length,
                                                          (index2) =>
                                                              DropdownMenuItem<String>(
                                                                value: [
                                                                  '1',
                                                                  '2',
                                                                  '3',
                                                                  '4',
                                                                  '5',
                                                                  '6',
                                                                  '7',
                                                                  '8',
                                                                  '9',
                                                                  '10',
                                                                  '11',
                                                                  '12'
                                                                ][index2],
                                                                child: Text(
                                                                    [
                                                                      '1',
                                                                      '2',
                                                                      '3',
                                                                      '4',
                                                                      '5',
                                                                      '6',
                                                                      '7',
                                                                      '8',
                                                                      '9',
                                                                      '10',
                                                                      '11',
                                                                      '12'
                                                                    ][index2],
                                                                    style:
                                                                        color00000s14w500),
                                                              )),
                                                      onChanged: (_) {
                                                        _numberOfBedOeptionsList[
                                                                    index]
                                                                ['bed_options'][
                                                            _numberOfBedOeptionsList[
                                                                    index][
                                                                'selected_index']]['numberOfBed'] = _
                                                            .toString();
                                                        _numberOfBedOeptionsList
                                                            .refresh();
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: CommonButton(
                                              onPressed: () {
                                                _numberOfBedOeptionsList[index]
                                                        ['bed_options']
                                                    .add({
                                                  'bedType': _badType.value,
                                                  'numberOfBed': '1',
                                                  'id': _badTypeID.value
                                                });
                                                _numberOfBedOeptionsList
                                                    .refresh();
                                                log(
                                                    _numberOfBedOeptionsList[
                                                                index]
                                                            ['bed_options']
                                                        .toString(),
                                                    name: 'bed_options');
                                              },
                                              name: 'Add Another Bed',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          CommonTextFeildPart(
                                              controller: TextEditingController(
                                                  text:
                                                      _numberOfBedOeptionsList[
                                                          index]['guest_stay']),
                                              title:
                                                  'How Many Guests Can Stay In This Room?',
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                _numberOfBedOeptionsList[index]
                                                        ['guest_stay'] =
                                                    value.toString();
                                              }),
                                          _roomType.value != 'Suite'
                                              ? const SizedBox()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Private Bathroom',
                                                      style: color00000s14w500,
                                                    ),
                                                    CommonCheckBox(
                                                        RxBool(
                                                            _numberOfBedOeptionsList[
                                                                    index][
                                                                'privet_room']),
                                                        onChanged: (value) {
                                                      _numberOfBedOeptionsList[
                                                                  index]
                                                              ['privet_room'] =
                                                          value;
                                                      _numberOfBedOeptionsList
                                                          .refresh();
                                                    })
                                                  ],
                                                ),
                                          _roomType.value == 'Suite'
                                              ? const SizedBox(
                                                  height: 15,
                                                )
                                              : const SizedBox(),
                                        ],
                                      )),
                            ),
                      _roomType.value == 'Suite'
                          ? Column(
                              children: List.generate(
                                _numberOfLivingSuiteRoomsList.length,
                                (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Living Room ${index + 1}',
                                        style: color00000s15w600,
                                      ),
                                      CommonDropDownHotel(
                                          title:
                                              'Number of sofa beds in the room',
                                          dropdownList: [
                                            '1',
                                            '2',
                                            '3',
                                            '4',
                                            '5',
                                            '6',
                                            '7',
                                            '8',
                                            '9',
                                            '10',
                                            '11',
                                            '12'
                                          ],
                                          dropdownValue: RxString(
                                              _numberOfLivingSuiteRoomsList[
                                                  index]['bedRooms']),
                                          onChanged: (_) {
                                            _numberOfLivingSuiteRoomsList[index]
                                                ['bedRooms'] = _.toString();
                                            _numberOfLivingSuiteRoomsList
                                                .refresh();
                                          }),
                                      CommonTextFeildPart(
                                        title:
                                            'How many guests can stay in this room?',
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: TextEditingController(
                                            text: _numberOfLivingSuiteRoomsList[
                                                index]['guest']),
                                        onChanged: (_) {
                                          _numberOfLivingSuiteRoomsList[index]
                                              ['guest'] = _.toString();
                                        },
                                      ),
                                      Divider(
                                        color: AppColors.color000000
                                            .withOpacity(0.5),
                                        endIndent: 30,
                                        indent: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Room Size ( Optional )',
                        style: color00000s18w600,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CommonTextFeildPart(
                              controller: _squareMeter,
                              title: 'Size of Room',
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: CommonDropDownHotel(
                                  title: 'Feet/Meters',
                                  dropdownList: [
                                    'square meters',
                                    'square feet'
                                  ],
                                  dropdownValue: _squareMeterType))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Divider(
                          color: AppColors.color000000.withOpacity(0.5),
                          endIndent: 30,
                          indent: 30,
                        ),
                      ),
                      Text(
                        'Do You have any other special amenities?',
                        style: color00000s18w600,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      StreamBuilder(
                        stream: amenities.stream,
                        builder: (context, snapshot) {
                          return GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                              amenities.length,
                              (index) => InkWell(
                                onTap: () {
                                  amenities[index]['itHas'] =
                                      !amenities[index]['itHas'];
                                  amenities.refresh();
                                  if (amenities[index]['itHas']) {
                                    amenitiesIdsHotel
                                        .add(amenities[index]['id']);
                                  } else {
                                    amenitiesIdsHotel
                                        .remove(amenities[index]['id']);
                                  }
                                  log(amenitiesIdsHotel.toString());
                                },
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: (amenities[index]
                                                          ['itHas'])
                                                      ? AppColors.colorFE6927
                                                      : AppColors.color1C2534
                                                          .withOpacity(0.2),
                                                  width: 2),
                                              color: AppColors.colorffffff),
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: HostingController.to
                                                                  .getStartHostRes[
                                                              'amenities_base_url'] +
                                                          '/' +
                                                          amenities[index][
                                                              'amenitie_icon'] ??
                                                      '',
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          Center(
                                                    child:
                                                        CupertinoActivityIndicator(
                                                      color:
                                                          AppColors.colorFE6927,
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  height: 35,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  amenities[index]['title'],
                                                  style: colorfffffffs13w600
                                                      .copyWith(
                                                          color: AppColors
                                                              .color000000),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                )
                                              ]),
                                        ),
                                      ),
                                      Positioned(
                                          right: Get.width * 0.02,
                                          top: Get.height * 0.005,
                                          child: (amenities[index]['itHas'])
                                              ? Image.asset(
                                                  AppImages.checkedIcon,
                                                  height: 20,
                                                )
                                              : const SizedBox())
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Divider(
                          color: AppColors.color000000.withOpacity(0.5),
                          endIndent: 30,
                          indent: 30,
                        ),
                      ),
                      Text(
                        'Room Images',
                        style: color00000s15w600,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Obx(() {
                        return roomPhotoNetwork.isEmpty
                            ? const SizedBox()
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: roomPhotoNetwork.length,
                                itemBuilder: (context, index) => Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: AppColors.color000000
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    (roomPhotoNetwork[index]
                                                                ['photo'] ??
                                                            '')
                                                        .toString(),
                                                placeholder: (context, url) =>
                                                    CupertinoActivityIndicator(
                                                  color: AppColors.colorFE6927,
                                                ),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Icon(Icons
                                                        .error_outline_outlined),
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        right: 10,
                                        top: 15,
                                        child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                //context: _scaffoldKey.currentContext,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 12,
                                                      vertical: 12,
                                                    ),
                                                    scrollable: true,
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            'Are you want to Delete Image from Room?',
                                                            style:
                                                                color00000s18w600,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Get.back();
                                                          },
                                                          child: const Icon(
                                                            Icons.close,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 17),
                                                        child: CommonButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          color: AppColors
                                                              .colorEBEBEB,
                                                          style: colorfffffffs13w600
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .color000000
                                                                      .withOpacity(
                                                                          0.7)),
                                                          name: 'No',
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 17),
                                                        child: CommonButton(
                                                          onPressed: () {
                                                            Get.back();
                                                            loaderShow(context);
                                                            DeletImageHotelController
                                                                .to
                                                                .deletRoomImageApi(
                                                                    params: {
                                                                  "id": (roomPhotoNetwork[index]
                                                                              [
                                                                              'id'] ??
                                                                          '')
                                                                      .toString()
                                                                },
                                                                    error: (e) {
                                                                      loaderHide();
                                                                      showSnackBar(
                                                                          title: ApiConfig
                                                                              .error,
                                                                          message:
                                                                              e.toString());
                                                                    },
                                                                    success:
                                                                        () {
                                                                      loaderHide();
                                                                      showSnackBar(
                                                                          title: ApiConfig
                                                                              .success,
                                                                          message:
                                                                              'Image Deleted Successfully');
                                                                      roomPhotoNetwork
                                                                          .removeAt(
                                                                              index);
                                                                      roomPhotoNetwork
                                                                          .refresh();
                                                                    });
                                                          },
                                                          name: 'Yes',
                                                        ),
                                                      ),
                                                    ],
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: AppColors
                                                    .colorffffff
                                                    .withOpacity(0.5),
                                                child: Icon(
                                                  Icons.close,
                                                  color: AppColors.color000000,
                                                )))),
                                  ],
                                ),
                              );
                      }),
                      roomPhoto.isEmpty
                          ? const SizedBox()
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemCount: roomPhoto.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 5),
                                child: InkWell(
                                  onTap: () async {
                                    try {
                                      var image = await ImagePicker().pickImage(
                                          source: ImageSource.gallery);
                                      if (image == null) return;
                                      roomPhoto[index] = image.path;
                                    } on PlatformException catch (e) {
                                      showSnackBar(
                                        title: ApiConfig.error,
                                        message: 'Failed to pick image: $e',
                                      );
                                    }
                                    roomPhoto.refresh();

                                    print('IMAGE PATH  ${roomPhoto[index]}');
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppColors.color000000
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      child: roomPhoto[index] == ''
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 40,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color:
                                                        AppColors.color000000,
                                                  ),
                                                  Text(
                                                    'Add Room Image',
                                                    style: color00000s14w500,
                                                  )
                                                ],
                                              ),
                                            )
                                          : Image.file(
                                              File(roomPhoto[index]),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CommonButton(
                            onPressed: () {
                              roomPhoto.add('');
                            },
                            name: 'Add Extra Image'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Divider(
                          color: AppColors.color000000.withOpacity(0.5),
                          endIndent: 30,
                          indent: 30,
                        ),
                      ),
                      Text(
                        'Add Meals',
                        style: color00000s15w600,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CommonDropDownHotel(
                        title: 'Is breakfast available to guests?',
                        dropdownList: [
                          'No',
                          'Yes,it\'s included in the price',
                          'Yes, it\'s optional'
                        ],
                        dropdownValue: _breakFast,
                      ),
                      _breakFast.value == 'Yes, it\'s optional'
                          ? CommonTextFeildPart(
                              controller: _breakFastPrice,
                              Hinttext: '0',
                              prefix: Icon(Icons.currency_rupee,
                                  color: AppColors.color000000),
                              title:
                                  'Price for breakfast (per person, per day, including all fees and taxes)',
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )
                          : const SizedBox(),
                      CommonDropDownHotel(
                        title: 'Is Lunch available to guests?',
                        dropdownList: [
                          'No',
                          'Yes,it\'s included in the price',
                          'Yes, it\'s optional'
                        ],
                        dropdownValue: _lunch,
                      ),
                      _lunch.value == 'Yes, it\'s optional'
                          ? CommonTextFeildPart(
                              controller: _lunchPrice,
                              Hinttext: '0',
                              prefix: Icon(Icons.currency_rupee,
                                  color: AppColors.color000000),
                              title:
                                  'Price for lunch (per person, per day, including all fees and taxes)',
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )
                          : const SizedBox(),
                      CommonDropDownHotel(
                        title: 'Is Dinner available to guests?',
                        dropdownList: [
                          'No',
                          'Yes,it\'s included in the price',
                          'Yes, it\'s optional'
                        ],
                        dropdownValue: _dinner,
                      ),
                      _dinner.value == 'Yes, it\'s optional'
                          ? CommonTextFeildPart(
                              controller: _dinnerPrice,
                              Hinttext: '0',
                              prefix: Icon(Icons.currency_rupee,
                                  color: AppColors.color000000),
                              title:
                                  'Price for dinner (per person, per day, including all fees and taxes)',
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Divider(
                          color: AppColors.color000000.withOpacity(0.5),
                          endIndent: 30,
                          indent: 30,
                        ),
                      ),
                      Text(
                        'Extra Bed Options',
                        style: color00000s15w600,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              extraBed.value = false;
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: extraBed.value == false
                                    ? AppColors.colorFE6927
                                    : AppColors.colorffffff,
                                border: Border.all(
                                  color: extraBed.value == false
                                      ? AppColors.colorffffff
                                      : AppColors.color000000,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              child: Text(
                                'No',
                                style: color00000s14w500.copyWith(
                                  color: extraBed.value == false
                                      ? AppColors.colorffffff
                                      : AppColors.color000000,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              extraBed.value = true;
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: extraBed.value
                                    ? AppColors.colorFE6927
                                    : AppColors.colorffffff,
                                border: Border.all(
                                  color: extraBed.value
                                      ? AppColors.colorffffff
                                      : AppColors.color000000,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              child: Text(
                                'Yes',
                                style: color00000s14w500.copyWith(
                                  color: extraBed.value
                                      ? AppColors.colorffffff
                                      : AppColors.color000000,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      extraBed.value == true
                          ? const SizedBox(
                              height: 10,
                            )
                          : const SizedBox(),
                      extraBed.value == true
                          ? CommonDropDownHotel(
                              title:
                                  'Select the number of extra beds that can be added.',
                              dropdownList: ['0', '1', '2', '3', '4'],
                              dropdownValue: _extrabedCounter)
                          : const SizedBox(),
                      _extrabedCounter.value == '0' || extraBed.value == false
                          ? const SizedBox()
                          : CommonTextFeildPart(
                              controller: _extrabedPrice,
                              title: 'Per Person Price',
                              prefix: Icon(Icons.currency_rupee,
                                  color: AppColors.color000000),
                              Hinttext: '0',
                              keyboardType: TextInputType.number,
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Divider(
                          color: AppColors.color000000.withOpacity(0.5),
                          endIndent: 30,
                          indent: 30,
                        ),
                      ),
                      Text(
                        'Base Price Per Night',
                        style: color00000s15w600,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.color000000.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        child: Text(
                          'This is the lowest price that we automatically apply to this room for all dates. Before your property goes live, you can set seasonal pricing on your property dashboard.',
                          style: color50perBlacks13w400,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonTextFeildPart(
                        controller: _rentPerNight,
                        title: 'INR / per night',
                        prefix: Icon(Icons.currency_rupee,
                            color: AppColors.color000000),
                        Hinttext: '0',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      isEditHotelRooms.value
                          ? Align(
                              alignment: Alignment.center,
                              child: CommonButton(
                                onPressed: () async {
                                  if (_roomType.value == 'Please Select') {
                                    showSnackBar(
                                        title: ApiConfig.error,
                                        message: 'Please Select Room Type.');
                                  } else if (_roomName.value ==
                                      'Please Select') {
                                    showSnackBar(
                                        title: ApiConfig.error,
                                        message: 'Please Select Room Name.');
                                  } else if (_customName.text.isEmpty) {
                                    showSnackBar(
                                        title: ApiConfig.error,
                                        message: 'Please Enter Customer Name.');
                                  } else if (_customName.text.isEmpty) {
                                    showSnackBar(
                                        title: ApiConfig.error,
                                        message: 'Please Enter Customer Name.');
                                  } else if (_numberOfRooms.text.isEmpty) {
                                    showSnackBar(
                                        title: ApiConfig.error,
                                        message:
                                            'Please Enter Number of Rooms.');
                                  } else if (_numberOfRooms.text.isNotEmpty &&
                                      int.parse(_numberOfRooms.text) <= 0) {
                                    showSnackBar(
                                        title: ApiConfig.error,
                                        message: 'Must Have Minimum 1 Room');
                                  } else if (_rentPerNight.text.isEmpty) {
                                    showSnackBar(
                                        title: ApiConfig.error,
                                        message: 'Please Enter Rent of Room');
                                  } else if (_rentPerNight.text.isNotEmpty &&
                                      int.parse(_rentPerNight.text) <= 0) {
                                    showSnackBar(
                                        title: ApiConfig.error,
                                        message:
                                            'Rent Must be Greater then 0.');
                                  } else {
                                    /* view!.length > (pageNum.value + 1)
                                     ? pageNum.value =
                                     pageNum.value + 1
                                         : null;*/

                                    log(_numberOfBedOeptionsList.toString(),
                                        name: '_numberOfBedOeptionsList');
                                    RxList numberofSofa = [].obs;
                                    RxList numberofGuest = [].obs;
                                    RxList bedtypeOptionId = [].obs;
                                    RxList numberOfBedOptions = [].obs;
                                    RxList numberOfGuestOption = [].obs;
                                    RxList privateBathroomOption = [].obs;

                                    bedtypeOptionId.value = List.generate(
                                        _numberOfBedOeptionsList.length,
                                        (i) => List.generate(
                                            _numberOfBedOeptionsList[i]
                                                    ['bed_options']
                                                .length,
                                            (j) => _numberOfBedOeptionsList[i]
                                                ['bed_options'][j]['id']));
                                    numberOfBedOptions.value = List.generate(
                                        _numberOfBedOeptionsList.length,
                                        (i) => List.generate(
                                            _numberOfBedOeptionsList[i]
                                                    ['bed_options']
                                                .length,
                                            (j) => _numberOfBedOeptionsList[i]
                                                    ['bed_options'][j]
                                                ['numberOfBed']));

                                    log(numberOfGuestOption.toString(),
                                        name: 'number_of_guest_option');
                                    for (var element
                                        in _numberOfBedOeptionsList) {
                                      numberOfGuestOption
                                          .add(element['guest_stay']);
                                    }
                                    for (var element
                                        in _numberOfBedOeptionsList) {
                                      privateBathroomOption.add(
                                          element['privet_room']
                                              ? 'Yes'
                                              : 'No');
                                    }
                                    for (var element
                                        in _numberOfLivingSuiteRoomsList) {
                                      numberofSofa.add(element['bedRooms']);
                                    }
                                    for (var element
                                        in _numberOfLivingSuiteRoomsList) {
                                      numberofGuest.add(element['guest']);
                                    }
                                    Map<String, dynamic> params = {
                                      'user_id':
                                          PrefController.to.user_id.value,
                                      'id': propertyId != null ||
                                              propertyId != ''
                                          ? propertyId
                                          : (MenuScreenController.to
                                                      .getStartHostRes['data']
                                                  ['property_id'])
                                              .toString(),
                                      'hotel_room_id': HostingController
                                                  .to.getStartHostRes['data']
                                              ?['hotel_room_id'] ??
                                          '',
                                      'room_type_id': _roomTypeID.value,
                                      'room_name_id': _roomNameID.value,
                                      'custome_name': _customName.text,
                                      'smoking_policy': _smokingPolicy.value,
                                      'number_of_rooms': _numberOfRooms.text,
                                      'number_of_bedrooms':
                                          _roomType.value != 'Suite'
                                              ? '0'
                                              : _numberOfBedSuiteRooms.value,
                                      "number_of_living_rooms":
                                          _roomType.value != 'Suite'
                                              ? '0'
                                              : _numberOfLivingSuiteRooms.value,
                                      "number_of_bathrooms":
                                          _roomType.value != 'Suite'
                                              ? '0'
                                              : _numberOfBathSuiteRooms.value,
                                      /* 'number_of_guest':_howManyGuestCanStay.text,*/
                                      "room_size": _squareMeter.text,
                                      "room_measunit": _squareMeterType.value ==
                                              "square meters"
                                          ? 'sq_meters'
                                          : 'sq_feet',
                                      "breakfast_included": _breakFast.value ==
                                              'Yes, it\'s optional'
                                          ? 'optional'
                                          : _breakFast.value ==
                                                  'Yes,it\'s included in the price'
                                              ? 'included'
                                              : _breakFast.value,
                                      "breakfast_price": _breakFastPrice.text,
                                      "lunch_included": _lunch.value ==
                                              'Yes, it\'s optional'
                                          ? 'optional'
                                          : _lunch.value ==
                                                  'Yes,it\'s included in the price'
                                              ? 'included'
                                              : _lunch.value,
                                      "lunch_price": _lunchPrice.text,
                                      "dinner_included": _dinner.value ==
                                              'Yes, it\'s optional'
                                          ? 'optional'
                                          : _dinner.value ==
                                                  'Yes,it\'s included in the price'
                                              ? 'included'
                                              : _dinner.value,
                                      "dinner_price": _dinnerPrice.text,
                                      "extra_beds_available":
                                          extraBed.value ? 'Yes' : 'No',
                                      "max_extra_beds": _extrabedCounter.value,
                                      "extra_bed_price": _extrabedPrice.text,
                                      'room_price_x_persons':
                                          _rentPerNight.text,
                                      "amenities[]": amenitiesIdsHotel.value,
                                      'bedtype_option_id': _roomType.value ==
                                              'Single'
                                          ? []
                                          : jsonEncode(bedtypeOptionId.value),
                                      'number_of_bed_options':
                                          _roomType.value == 'Single'
                                              ? []
                                              : jsonEncode(
                                                  numberOfBedOptions.value),
                                      'number_of_guest_option[]':
                                          _roomType.value == 'Single'
                                              ? []
                                              : numberOfGuestOption.value,
                                      'private_bathroom_option[]':
                                          _roomType.value == 'Single'
                                              ? []
                                              : privateBathroomOption.value,
                                      "num_sofabeds_in_livingroom[]":
                                          _roomType.value == 'Suite'
                                              ? numberofSofa.value
                                              : [],
                                      "num_guests_in_livingroom[]":
                                          _roomType.value == 'Suite'
                                              ? numberofGuest.value
                                              : [],
                                      "proceed": 'update_room',
                                      // 'private_bathroom_option':privetBathroom.value,
                                    };

                                    RxList roomImages = [].obs;
                                    roomPhoto.isNotEmpty
                                        ? roomPhoto.forEach((element) async {
                                            if (element != '') {
                                              roomImages.add(await dio
                                                      .MultipartFile
                                                  .fromFile(element.toString(),
                                                      filename:
                                                          element.toString()));
                                            }
                                            print('roomImages $roomImages');
                                          })
                                        : [];

                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    params['images[]'] = roomImages;
                                  }
                                },
                                name: 'Update Room Details',
                              ),
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: CommonButton(
                                onPressed: () {
                                  Map<String, dynamic> params = {
                                    'user_id': PrefController.to.user_id.value,
                                    'id': propertyId != null || propertyId != ''
                                        ? propertyId
                                        : (MenuScreenController
                                                    .to.getStartHostRes['data']
                                                ['property_id'])
                                            .toString(),
                                  };

                                  loaderShow(context);
                                  HostingController.to.hostPropertyApi(
                                    id: propertyId != null || propertyId != ''
                                        ? propertyId
                                        : HostingController
                                                .to.getStartHostRes['data']
                                            ['property_id'],
                                    step: 'hotel_listing_info',
                                    params: params,
                                    success: () {
                                      loaderHide();

                                      isEditHotelRooms.value = true;
                                      showHotelRooms.value = true;
                                    },
                                    error: (e) {
                                      loaderHide();

                                      showSnackBar(
                                        title: ApiConfig.error,
                                        message: e.toString(),
                                      );
                                    },
                                  );
                                },
                                name: 'Skip',
                              ),
                            ) /*const SizedBox()*/,
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Layout & Pricing',
                        style: color00000s18w600,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Tell us about your first room. After entering all the necessary info, you can fill in the details of your other rooms.',
                        style: color50perBlacks13w400,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      (HostingController.to.getStartHostRes['data']
                                      ?['get_hotel_listing_datas'] ??
                                  [])
                              .isEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: AppColors.colorffffff,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 5,
                                    spreadRadius: 5,
                                    color: Color.fromRGBO(0, 0, 0, 0.05),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'No Room data Available',
                                      style: color00000s15w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: List.generate(
                                (HostingController.to.getStartHostRes['data']
                                            ?['get_hotel_listing_datas'] ??
                                        [])
                                    .length,
                                (index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: AppColors.colorffffff,
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 5,
                                            spreadRadius: 5,
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.05),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              (HostingController.to.getStartHostRes[
                                                                      'data']?[
                                                                  'get_hotel_listing_datas']
                                                              [index]
                                                          ?['custome_name'] ??
                                                      '')
                                                  .toString(),
                                              style: color00000s15w600,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${HostingController.to.getStartHostRes['data']?['get_hotel_listing_datas'][index]?['number_of_rooms'] ?? ''} X',
                                              style: color00000s14w500,
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                roomPhoto.clear();
                                                Map<String, dynamic> params = {
                                                  'user_id': PrefController
                                                      .to.user_id.value,
                                                  'id': propertyId != null ||
                                                          propertyId != ''
                                                      ? propertyId
                                                      : (MenuScreenController.to
                                                                      .getStartHostRes[
                                                                  'data']
                                                              ['property_id'])
                                                          .toString(),
                                                  'hotel_room_id': (HostingController
                                                                          .to
                                                                          .getStartHostRes[
                                                                      'data']?[
                                                                  'get_hotel_listing_datas']
                                                              [index]?['id'] ??
                                                          '')
                                                      .toString(),
                                                };

                                                loaderShow(context);
                                                HostingController.to
                                                    .hostPropertyApi(
                                                  id: propertyId != null ||
                                                          propertyId != ''
                                                      ? propertyId
                                                      : HostingController.to
                                                              .getStartHostRes[
                                                          'data']['property_id'],
                                                  step: 'edit_hotel_room',
                                                  params: params,
                                                  success: () {
                                                    /// ROOM TYPE EDIT
                                                    _roomType
                                                        .value = (HostingController
                                                                            .to
                                                                            .getStartHostRes[
                                                                        'data']
                                                                    ?[
                                                                    'get_hotel_room_detail']
                                                                ?[
                                                                'room_type_name'] ??
                                                            '')
                                                        .toString();
                                                    _roomTypeID
                                                        .value = (HostingController
                                                                            .to
                                                                            .getStartHostRes[
                                                                        'data']
                                                                    ?[
                                                                    'get_hotel_room_detail']
                                                                ?[
                                                                'room_type_id'] ??
                                                            '')
                                                        .toString();
                                                    roomNameList.value = [
                                                      {'title': 'Please Select'}
                                                    ];
                                                    roomNameList.refresh();

                                                    GetRoomNameController.to
                                                        .getRoomnameApi(
                                                            params: {
                                                          'room_type_id':
                                                              (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'room_type_id'] ??
                                                                      '')
                                                                  .toString(),
                                                        },
                                                            success: () {
                                                              loaderHide();
                                                              ((GetRoomNameController
                                                                              .to
                                                                              .getRoomName['data']?['get_room_names'] ??
                                                                          [])
                                                                      .isNotEmpty)
                                                                  ? {
                                                                      GetRoomNameController
                                                                          .to
                                                                          .getRoomName[
                                                                              'data']
                                                                              ?[
                                                                              'get_room_names']
                                                                          .forEach(
                                                                              (element) {
                                                                        roomNameList.add(element as Map<
                                                                            String,
                                                                            dynamic>);
                                                                      })
                                                                    }
                                                                  : null;

                                                              /// remove commit when variables are set.
                                                              showHotelRooms
                                                                      .value =
                                                                  false;
                                                              isEditHotelRooms
                                                                  .value = true;

                                                              /// ROOM NAME EDIT
                                                              _roomName
                                                                  .value = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'room_name'] ??
                                                                      '')
                                                                  .toString();
                                                              _roomNameID
                                                                  .value = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'room_name_id'] ??
                                                                      '')
                                                                  .toString();
                                                              log(
                                                                  _roomNameID
                                                                      .value,
                                                                  name:
                                                                      'ROOM NAME ID EDIT');

                                                              ///CUSTOME NAME
                                                              _customName
                                                                  .text = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'custome_name'] ??
                                                                      '')
                                                                  .toString();
                                                              log(
                                                                  _customName
                                                                      .text,
                                                                  name:
                                                                      'CUSTOME NAME ID EDIT');

                                                              ///SMOKING POLICY
                                                              _smokingPolicy
                                                                  .value = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'smoking_policy'] ??
                                                                      '')
                                                                  .toString();
                                                              log(
                                                                  _smokingPolicy
                                                                      .value,
                                                                  name:
                                                                      'SMOKING ID EDIT');

                                                              ///NUMBER OF ROOMS
                                                              _numberOfRooms
                                                                  .text = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'number_of_rooms'] ??
                                                                      '')
                                                                  .toString();
                                                              log(
                                                                  _numberOfRooms
                                                                      .text,
                                                                  name:
                                                                      'NUMBER OF ROOMS EDIT');

                                                              ///NUMBER OF BEDROOMS
                                                              _numberOfBedSuiteRooms
                                                                  .value = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'number_of_bedrooms'] ??
                                                                      '')
                                                                  .toString();
                                                              log(
                                                                  _numberOfBedSuiteRooms
                                                                      .value,
                                                                  name:
                                                                      'NUMBER OF BEDROOMS EDIT');

                                                              ///NUMBER OF LIVING ROOM
                                                              _numberOfLivingSuiteRooms
                                                                  .value = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'number_of_living_rooms'] ??
                                                                      '')
                                                                  .toString();
                                                              log(
                                                                  _numberOfLivingSuiteRooms
                                                                      .value,
                                                                  name:
                                                                      'NUMBER OF LIVING ROOMS EDIT');

                                                              ///NUMBER OF BATH ROOM
                                                              _numberOfBathSuiteRooms
                                                                  .value = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'number_of_bathrooms'] ??
                                                                      '')
                                                                  .toString();
                                                              log(
                                                                  _numberOfBathSuiteRooms
                                                                      .value,
                                                                  name:
                                                                      'NUMBER OF BATH ROOMS EDIT');

                                                              ///ROOM SIZE
                                                              _squareMeter
                                                                  .text = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'room_size'] ??
                                                                      '')
                                                                  .toString();
                                                              log(
                                                                  _squareMeter
                                                                      .text,
                                                                  name:
                                                                      'ROOM SIZE EDIT');

                                                              ///ROOM SIZE TYPE
                                                              _squareMeterType
                                                                  .value = ((HostingController.to.getStartHostRes['data']?['get_hotel_room_detail']?['room_measunit'] ??
                                                                              'sq_meters')
                                                                          .toString()) ==
                                                                      'sq_meters'
                                                                  ? 'square meters'
                                                                  : 'square feet';
                                                              log(
                                                                  _squareMeterType
                                                                      .value,
                                                                  name:
                                                                      'ROOM SIZE TYPE EDIT');

                                                              ///RENT PER NIGHT
                                                              _rentPerNight
                                                                  .text = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'room_price_x_persons'] ??
                                                                      '')
                                                                  .toString();
                                                              log(
                                                                  _rentPerNight
                                                                      .text,
                                                                  name:
                                                                      'RENT PER NIGHT EDIT');

                                                              ///BREAK FAST INCLUDED
                                                              _breakFast
                                                                  .value = ((HostingController.to.getStartHostRes['data']?['get_hotel_room_detail']?['breakfast_included'] ??
                                                                              'No')
                                                                          .toString() ==
                                                                      'No')
                                                                  ? 'No'
                                                                  : ((HostingController.to.getStartHostRes['data']?['get_hotel_room_detail']?['breakfast_included'] ?? 'No')
                                                                              .toString() ==
                                                                          'optional')
                                                                      ? 'Yes, it\'s optional'
                                                                      : 'Yes,it\'s included in the price';
                                                              log(
                                                                  _breakFast
                                                                      .value,
                                                                  name:
                                                                      'Breakfast Included EDIT');

                                                              ///BREAK FAST PRICE
                                                              _breakFastPrice
                                                                  .text = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'breakfast_price'] ??
                                                                      '')
                                                                  .toString();
                                                              log(
                                                                  _breakFastPrice
                                                                      .text,
                                                                  name:
                                                                      'BREAKFAST PRICE EDIT');

                                                              ///LUNCH INCLUDED
                                                              _lunch
                                                                  .value = ((HostingController.to.getStartHostRes['data']?['get_hotel_room_detail']?['lunch_included'] ??
                                                                              'No')
                                                                          .toString() ==
                                                                      'No')
                                                                  ? 'No'
                                                                  : ((HostingController.to.getStartHostRes['data']?['get_hotel_room_detail']?['lunch_included'] ?? 'No')
                                                                              .toString() ==
                                                                          'optional')
                                                                      ? 'Yes, it\'s optional'
                                                                      : 'Yes,it\'s included in the price';
                                                              log(_lunch.value,
                                                                  name:
                                                                      'LUNCH Included EDIT');

                                                              ///LUNCH PRICE
                                                              _lunchPrice
                                                                  .text = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'lunch_price'] ??
                                                                      '')
                                                                  .toString();
                                                              log(
                                                                  _lunchPrice
                                                                      .text,
                                                                  name:
                                                                      'LUNCH PRICE EDIT');

                                                              ///DINNER INCLUDED
                                                              _dinner
                                                                  .value = ((HostingController.to.getStartHostRes['data']?['get_hotel_room_detail']?['dinner_included'] ??
                                                                              'No')
                                                                          .toString() ==
                                                                      'No')
                                                                  ? 'No'
                                                                  : ((HostingController.to.getStartHostRes['data']?['get_hotel_room_detail']?['dinner_included'] ?? 'No')
                                                                              .toString() ==
                                                                          'optional')
                                                                      ? 'Yes, it\'s optional'
                                                                      : 'Yes,it\'s included in the price';
                                                              log(_dinner.value,
                                                                  name:
                                                                      'DINNER Included EDIT');

                                                              ///DINNER PRICE
                                                              _dinnerPrice
                                                                  .text = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'dinner_price'] ??
                                                                      '')
                                                                  .toString();
                                                              log(
                                                                  _dinnerPrice
                                                                      .text,
                                                                  name:
                                                                      'DINNER PRICE EDIT');

                                                              /// EXTRA BED OPTION
                                                              extraBed.value =
                                                                  (HostingController.to.getStartHostRes['data']?['get_hotel_room_detail']?['extra_beds_available'] ?? '0')
                                                                              .toString() ==
                                                                          '0'
                                                                      ? false
                                                                      : true;
                                                              log(
                                                                  extraBed.value
                                                                      .toString(),
                                                                  name:
                                                                      'EXTRABED EDIT');

                                                              ///EXTRA BED COUNTER

                                                              _extrabedCounter
                                                                  .value = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'max_extra_beds'] ??
                                                                      '0')
                                                                  .toString();
                                                              log(
                                                                  _extrabedCounter
                                                                      .value
                                                                      .toString(),
                                                                  name:
                                                                      'EXTRABED COUNTER EDIT');

                                                              ///EXTRA BED PRICE
                                                              _extrabedPrice
                                                                  .text = (HostingController
                                                                              .to
                                                                              .getStartHostRes['data']?['get_hotel_room_detail']
                                                                          ?[
                                                                          'extra_bed_price'] ??
                                                                      '')
                                                                  .toString();
                                                              log(
                                                                  _extrabedPrice
                                                                      .text
                                                                      .toString(),
                                                                  name:
                                                                      'EXTRABED PRICE EDIT');

                                                              /// AMENITIES
                                                              for (var element
                                                                  in amenities) {
                                                                element['itHas'] =
                                                                    false;
                                                              }
                                                              HostingController
                                                                  .to
                                                                  .getStartHostRes[
                                                                      'data']?[
                                                                      'selected_hotel_amenities']
                                                                  .forEach(
                                                                      (element) {
                                                                for (var ameList
                                                                    in amenities) {
                                                                  if ((ameList[
                                                                              'id']
                                                                          .toString() ==
                                                                      element['amenities_id']
                                                                          .toString())) {
                                                                    ameList['itHas'] =
                                                                        true;
                                                                  } else {}
                                                                  amenities
                                                                      .refresh();
                                                                }
                                                              });

                                                              log(
                                                                  amenities
                                                                      .toString(),
                                                                  name:
                                                                      'AMENITIES  EDIT');
                                                            },
                                                            error: (e) {
                                                              loaderHide();
                                                              showSnackBar(
                                                                  title:
                                                                      ApiConfig
                                                                          .error,
                                                                  message: e
                                                                      .toString());
                                                            });

                                                    _numberOfLivingSuiteRoomsList
                                                        .clear();

                                                    ///LiVING ROOM
                                                    HostingController
                                                        .to
                                                        .getStartHostRes['data']
                                                            ?[
                                                            'get_living_room_options']
                                                        .forEach((element) {
                                                      _numberOfLivingSuiteRoomsList
                                                          .add({
                                                        'bedRooms': element[
                                                                'num_sofabeds_in_livingroom']
                                                            .toString(),
                                                        'guest': element[
                                                                'num_guests_in_livingroom']
                                                            .toString(),
                                                      });
                                                    });
                                                    _numberOfLivingSuiteRoomsList
                                                        .refresh();
                                                    roomPhoto.clear();

                                                    ///Images

                                                    roomPhotoNetwork.clear();
                                                    (HostingController.to
                                                                        .getStartHostRes[
                                                                    'data']?[
                                                                'get_property_room_photos'] ??
                                                            [])
                                                        .forEach((element) {
                                                      roomPhotoNetwork
                                                          .add(element);
                                                    });
                                                    roomPhotoNetwork.refresh();
                                                    log(
                                                        roomPhotoNetwork
                                                            .toString(),
                                                        name:
                                                            'ROOM PHOTO NETWORK EDIT');

                                                    ///BED OPTION
                                                    List bedOpetion = [];
                                                    (HostingController.to
                                                                        .getStartHostRes[
                                                                    'data']?[
                                                                'get_bad_type_options'] ??
                                                            {})
                                                        .forEach((key, value) {
                                                      bedOpetion.add(value);
                                                    });

                                                    log(bedOpetion.toString(),
                                                        name: 'bedOpetion');

                                                    _numberOfBedOeptionsList.value =
                                                        List.generate(
                                                            bedOpetion.length,
                                                            (index) => {
                                                                  "bed_options": List
                                                                      .generate(
                                                                          bedOpetion[index]
                                                                              .length,
                                                                          (val) =>
                                                                              {
                                                                                'bedType': bedOpetion[index][val]['bed_name'],
                                                                                'numberOfBed': bedOpetion[index][val]['number_of_bed_options'],
                                                                                'id': bedOpetion[index][val]['bed_type_id'],
                                                                              }),
                                                                  'privet_room':
                                                                      (bedOpetion[index][0]?['private_bathroom_option'] ?? '') ==
                                                                              'Yes'
                                                                          ? true
                                                                          : false,
                                                                  'selected_index':
                                                                      0,
                                                                  'guest_stay':
                                                                      (bedOpetion[index][0]
                                                                              ?[
                                                                              'number_of_guest_option'] ??
                                                                          ''),
                                                                });

                                                    _numberOfBedOeptionsList
                                                        .refresh();
                                                  },
                                                  error: (e) {
                                                    loaderHide();
                                                    showSnackBar(
                                                      title: ApiConfig.error,
                                                      message: e.toString(),
                                                    );
                                                  },
                                                );
                                              },
                                              highlightColor:
                                                  Colors.transparent,
                                              splashColor: Colors.transparent,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: AppColors.colorFE6927,
                                                ),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: AppColors.colorffffff,
                                                ),
                                              )),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: AppColors.colorFE6927,
                                            ),
                                            child: Icon(
                                              Icons.delete,
                                              color: AppColors.colorffffff,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CommonButton(
                          onPressed: () {
                            showHotelRooms.value = false;
                            isEditHotelRooms.value = false;
                            _numberOfBedOeptionsList.value = [
                              {
                                'bedRooms': '1',
                                'bed_options': [
                                  {'bedType': '', 'numberOfBed': '1', 'id': ''}
                                ],
                                'privet_room': false,
                                'selected_index': 0,
                                'guest_stay': '1'
                              }
                            ];
                            _numberOfBedOeptionsList[0]['bed_options'] = [
                              {
                                'bedType': badTypeList[0]['name'],
                                'numberOfBed': '1',
                                'id': badTypeList[0]['id']
                              }
                            ];
                            _roomType.value = 'Please Select';
                            _roomTypeID.value = '';
                            _roomName.value = 'Please Select';
                            _roomNameID.value = '';
                            _customName.clear();
                            _smokingPolicy.value = 'Non-smoking';
                            _numberOfRooms.clear();
                            _numberOfBedSuiteRooms.value = '1';
                            _numberOfLivingSuiteRooms.value = '1';
                            _numberOfBathSuiteRooms.value = '1';
                            _squareMeter.clear();
                            _squareMeterType.value = 'square meters';
                            _breakFast.value = 'No';
                            _breakFastPrice.clear();
                            _lunch.value = 'No';
                            _lunchPrice.clear();
                            _dinner.value = 'No';
                            _dinnerPrice.clear();
                            extraBed.value = false;
                            _extrabedCounter.value = '0';
                            _extrabedPrice.clear();
                            _rentPerNight.clear();
                            for (var element in amenities) {
                              element['itHas'] = false;
                            }
                            roomPhoto.value = [''];
                          },
                          name: 'Add More Room',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Provide your total area and construction area',
                    style: color00000s18w600,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      categiry.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.color000000.withOpacity(0.12),
                                spreadRadius: 5,
                                blurRadius: 5,
                              ),
                            ],
                            color: AppColors.colorffffff,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Image.asset(categiry[index]['img'],
                                        height: 40),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        categiry[index]['name'],
                                        style: colorfffffffs13w600.copyWith(
                                            color: AppColors.color000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      categiry[index]['qty'] > 0
                                          ? categiry[index]['qty'] =
                                              categiry[index]['qty'] - 1
                                          : null;
                                      categiry.refresh();
                                    },
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: AppColors.colorFE6927),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.remove,
                                          size: 20,
                                          color: AppColors.colorffffff,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: SizedBox(
                                      width: Get.width / 5,
                                      child: StreamBuilder(
                                          stream: categiry.stream,
                                          builder: (context, snapshot) {
                                            return TextFormField(
                                              controller: TextEditingController(
                                                text: categiry[index]['qty']
                                                    .toString(),
                                              ),
                                              style: color00000s14w500,
                                              textAlign: TextAlign.center,
                                              cursorColor:
                                                  AppColors.colorFE6927,
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (val) {
                                                if (val == '') {
                                                  categiry[index]['qty'] = 0;
                                                } else {
                                                  categiry[index]['qty'] =
                                                      int.parse(val);
                                                }
                                                print(
                                                    "categiry[1]['qty'] ${categiry[1]['qty']}");
                                              },
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 12),
                                                isDense: true,
                                                // hintText: categiry[index]
                                                //         ['qty']
                                                //     .toString(),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    color: AppColors.color000000
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    color: AppColors.color000000
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    color: AppColors.color000000
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      /*data[index]['qty'] > 0
                                            ?*/
                                      categiry[index]['qty'] =
                                          categiry[index]['qty'] + 1;
                                      /*: null;*/
                                      categiry.refresh();
                                    },
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: AppColors.colorFE6927),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.add,
                                          size: 20,
                                          color: AppColors.colorffffff,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }

  Padding CommonDropDownHotel(
      {required String title,
      required List<String> dropdownList,
      required RxString dropdownValue,
      ValueChanged? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: color00000s14w500,
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.color000000.withOpacity(0.2),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: dropdownValue.value,
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(6),
              style: color00000s14w500,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  size: 20, color: AppColors.color000000),
              items: dropdownList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: color00000s14w500),
                );
              }).toList(),
              onChanged: onChanged ??
                  (_) {
                    dropdownValue.value = _.toString();
                  },
            ),
          ),
        ],
      ),
    );
  }

  RxBool isSelected = false.obs;
  Widget step4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where\'s your place located?',
          style: color00000s18w600,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          'Your address is only shared with guests after they’ve made a reservation.',
          style: color50perBlacks13w400,
        ),
        const SizedBox(
          height: 8,
        ),
        // const SizedBox(
        //   height: 5,
        // ),
        // Text(
        //   'Country',
        //   style: color00000s14w500,
        // ),
        // const SizedBox(
        //   height: 5,
        // ),
        // Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(6),
        //     border: Border.all(
        //       color: AppColors.color000000.withOpacity(0.5),
        //     ),
        //   ),
        //   padding: EdgeInsets.symmetric(horizontal: 16),
        //   child: DropdownButton<String>(
        //     value: 'A',
        //     underline: SizedBox(),
        //     borderRadius: BorderRadius.circular(6),
        //     style: color00000s14w500,
        //     isExpanded: true,
        //     icon: Icon(Icons.keyboard_arrow_down_rounded,
        //         size: 20, color: AppColors.color000000),
        //     items: <String>['A', 'B', 'C', 'D'].map((String value) {
        //       return DropdownMenuItem<String>(
        //         value: value,
        //         child: Text(value, style: color00000s14w500),
        //       );
        //     }).toList(),
        //     onChanged: (_) {},
        //   ),
        // ),
        // const SizedBox(
        //   height: 5,
        // ),
        Align(
          alignment: Alignment.center,
          child: CommonButton(
            onPressed: _getCurrentPosition,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.my_location, color: AppColors.colorffffff),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Use Current Location',
                  style: colorfffffffs13w600,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        CommonTextFeildPart(
            title: 'Country *',
            controller: countryController,
            suffix: Icon(Icons.keyboard_arrow_down_rounded,
                size: 20, color: AppColors.color000000),
            readOnly: true,
            onTap: () {
              showCountryPicker(
                  context: context,
                  favorite: ['IN'],
                  countryListTheme: CountryListThemeData(
                    flagSize: 25,
                    backgroundColor: Colors.white,
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.blueGrey),
                    bottomSheetHeight:
                        Get.height / 1.5, // Optional. Country list modal height
                    //Optional. Sets the border radius for the bottomsheet.
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    //Optional. Styles the search field.

                    inputDecoration: InputDecoration(
                        // labelText: 'Search',
                        hintText: 'Start typing to search',
                        prefixIcon: const Icon(Icons.search),
                        focusColor: AppColors.colorFE6927,
                        iconColor: AppColors.colorFE6927,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.color000000.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.color000000.withOpacity(0.5),
                          ),
                        )),
                  ),
                  onSelect: (Country country) =>
                      countryController.text = country.name);
            }),
        CommonTextFeildPart(title: 'State / Region *', controller: state),
        CommonTextFeildPart(
            title: 'City / Town / District *', controller: city),
        CommonTextFeildPart(title: 'Full Address', controller: fullAddress),
        CommonTextFeildPart(
            title: 'Set Google Maps Location/Nearest Landmark *',
            controller: addressline1,
            onChanged: (val) {
              isSelected.value = false;
              GoogleLocationController.to
                  .getSuggestion(input: addressline1.text);
            }),
        Obx(
          () {
            return isSelected.value && addressline1.text.isNotEmpty
                ? const SizedBox()
                : StreamBuilder(
                    stream: GoogleLocationController.to.pridiction.stream,
                    builder: (context, snapshot) {
                      return addressline1.text.isNotEmpty ||
                              GoogleLocationController.to.pridiction.length > 1
                          ? Container(
                              decoration: BoxDecoration(
                                color: AppColors.colorffffff,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 5,
                                    spreadRadius: 5,
                                    color: Color.fromRGBO(0, 0, 0, 0.05),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  GoogleLocationController.to.pridiction.length,
                                  (index) => InkWell(
                                    onTap: () async {
                                      markers.clear();
                                      FocusScope.of(context).unfocus();
                                      addressline1.text =
                                          GoogleLocationController.to
                                              .pridiction[index]['description']
                                              .toString();
                                      isSelected.value = true;

                                      List<Location> locations =
                                          await locationFromAddress(
                                              addressline1.text);

                                      print(locations[0].longitude);
                                      print(locations[0].latitude);
                                      showLocation = LatLng(
                                          locations[0].latitude,
                                          locations[0].longitude);
                                      controller?.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                  target: showLocation,
                                                  zoom: 10)
                                              //17 is new zoom level
                                              ));
                                      Marker newMarker = Marker(
                                          markerId: MarkerId('$id'),
                                          position: LatLng(
                                              locations[0].latitude,
                                              locations[0].longitude),
                                          // infoWindow: InfoWindow(title: 'Gleekey'),
                                          icon: BitmapDescriptor.defaultMarker);
                                      markers.add(newMarker);
                                      id = id + 1;

                                      latitude.text =
                                          locations[0].latitude.toString();
                                      longitude.text =
                                          locations[0].longitude.toString();
                                      // loaderShow(context);
                                      GoogleLocationController.to.getLocation(
                                        longitude: longitude.text,
                                        latitude: latitude.text,
                                        error: (e) {
                                          // loaderHide();
                                        },
                                        success: (loc) {
                                          addressline1.text =
                                              loc['AddressLine1'];
                                          countryController.text =
                                              loc['Country'];
                                          city.text = loc['City'];
                                          state.text = loc['State'];
                                          zip.text = loc['Zip'];
                                          // loaderHide();
                                        },
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(GoogleLocationController
                                            .to.pridiction[index]['description']
                                            .toString()),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Divider(
                                            color: AppColors.color000000
                                                .withOpacity(0.2),
                                            indent: 10,
                                            endIndent: 10,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox();
                    },
                  );
          },
        ),

        CommonTextFeildPart(
            title: 'ZIP / Postal Code *',
            controller: zip,
            keyboardType: TextInputType.number),
        const SizedBox(
          height: 15,
        ),
        // Container(
        //   height: 210,
        //   width: Get.width,
        //   child: Image.asset(
        //     AppImages.mapImg,
        //     fit: BoxFit.fill,
        //   ),
        // ),
        SizedBox(
          height: 210,
          width: Get.width,
          child: const GooleMapWidget(),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  RxList pickImg = [].obs;

  ///step 5
  RxList basic = [
    {'img': AppImages.areaIcon, 'name': 'Guest Allowed', 'qty': 0},
    {'img': AppImages.bedroomIcon, 'name': 'Bedrooms', 'qty': 0},
    {'img': AppImages.extraMattersIcon, 'name': 'Extra Mattress', 'qty': 0},
    {'img': AppImages.living_roomIcon, 'name': 'Living Rooms', 'qty': 0},
    {'img': AppImages.kitchenIcon, 'name': 'Kitchen', 'qty': 0},
    {'img': AppImages.bathRoomIcon, 'name': 'Bathroom', 'qty': 0},
  ].obs;

  Widget step5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add some basics details about your Property',
          style: color00000s18w600,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          'You can add more details later on',
          style: color50perBlacks13w400,
        ),
        const SizedBox(
          height: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            basic.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.color000000.withOpacity(0.12),
                        spreadRadius: 5,
                        blurRadius: 5,
                      ),
                    ],
                    color: AppColors.colorffffff),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(basic[index]['img'], height: 40),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            basic[index]['name'],
                            style: colorfffffffs13w600.copyWith(
                                color: AppColors.color000000),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            basic[index]['qty'] > 0
                                ? basic[index]['qty'] = basic[index]['qty'] - 1
                                : null;
                            basic.refresh();
                            pickImg.value = basic.value;
                            pickImg[index]['imgPath'] = RxList.generate(
                                pickImg[index]['qty'], (imgIndex) => '');
                          },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColors.colorFE6927),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.remove,
                                size: 20,
                                color: AppColors.colorffffff,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: SizedBox(
                            width: Get.width / 5,
                            child: StreamBuilder(
                                stream: basic.stream,
                                builder: (context, snapshot) {
                                  return TextFormField(
                                    controller: TextEditingController(
                                      text: basic[index]['qty'].toString(),
                                    ),
                                    style: color00000s14w500,
                                    textAlign: TextAlign.center,
                                    cursorColor: AppColors.colorFE6927,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      basic[index]['qty'] =
                                          int.parse(val.toString());
                                      val.isEmpty
                                          ? basic[index]['qty'] = 0
                                          : null;
                                    },
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 12),
                                      isDense: true,
                                      // hintText: categiry[index]
                                      //         ['qty']
                                      //     .toString(),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                          color: AppColors.color000000
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                          color: AppColors.color000000
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                          color: AppColors.color000000
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            /*data[index]['qty'] > 0
                                        ?*/
                            basic[index]['qty'] = basic[index]['qty'] + 1;
                            /*: null;*/
                            basic.refresh();
                            pickImg.value = basic.value;
                            pickImg[index]['imgPath'] = RxList.generate(
                                pickImg[index]['qty'], (imgIndex) => '');
                          },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColors.colorFE6927),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.add,
                                size: 20,
                                color: AppColors.colorffffff,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget step7() {
    return StreamBuilder(
      stream: pickImg.stream,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Included some images of your property?',
              style: color00000s18w600,
            ),
            // const SizedBox(
            //   height: 4,
            // ),
            // Text(
            //   'Include some images of your property?',
            //   style: color50perBlacks13w400,
            // ),
            const SizedBox(
              height: 13,
            ),
            Text(
              'Add Cover Photo',
              style: color00000s15w600,
            ),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: InkWell(
                  onTap: () {
                    pickCoverImage().then((value) {
                      if (coverPhoto.value != '') {
                        if (coverPhotoNetwork.isNotEmpty &&
                            coverPhotoNetwork != []) {
                          if (coverPhotoID
                              .contains(coverPhotoNetwork[0]['id'])) {
                          } else {
                            coverPhotoID.add(coverPhotoNetwork[0]['id']);
                          }
                        }
                      }
                    });
                    print("coverPhotoID $coverPhotoID");
                    print("outDoorImageID $outDoorImageID");
                    print("amenitiesPhotoID $amenitiesPhotoID");
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 110,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: AppColors.color000000.withOpacity(0.5))),
                      child: coverPhotoNetwork.isNotEmpty &&
                              coverPhoto.value == ''
                          ? CachedNetworkImage(
                              imageUrl: coverPhotoNetwork[0]['image'],
                              placeholder: (context, url) =>
                                  CupertinoActivityIndicator(
                                color: AppColors.colorFE6927,
                              ),
                              errorWidget: (context, url, error) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: AppColors.color000000,
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Add Photo',
                                      style: color00000s14w500,
                                    ),
                                  )
                                ],
                              ),
                              fit: BoxFit.cover,
                            )
                          : coverPhoto.value == ''
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 40,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: AppColors.color000000,
                                      ),
                                      Text(
                                        'Add Cover Photo',
                                        style: color00000s14w500,
                                      )
                                    ],
                                  ),
                                )
                              : Image.file(
                                  File(coverPhoto.value),
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Outdoor Images',
              style: color00000s15w600,
            ),
            const SizedBox(
              height: 8,
            ),
            Obx(() {
              return isHotel.value
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          itemCount: outDoorImagesHotel.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () async {
                              try {
                                var image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (image == null) return;

                                outDoorImagesHotel[index] = image.path;
                              } on PlatformException catch (e) {
                                showSnackBar(
                                    title: ApiConfig.error,
                                    message: 'Failed to pick image: $e');
                              }

                              if (outDoorImagesHotel[index] != '') {
                                if (outDoorImageNetwork.isNotEmpty &&
                                    outDoorImageNetwork != []) {
                                  if (outDoorImageID.contains(
                                      outDoorImageNetwork[index]['id'])) {
                                  } else {
                                    outDoorImageID
                                        .add(outDoorImageNetwork[index]['id']);
                                  }
                                }
                              }
                              outDoorImagesHotel.refresh();

                              print('IMAGEPATH  ${outDoorImagesHotel[index]}');
                            },
                            child: outDoorImageNetwork.isNotEmpty &&
                                    ((outDoorImageNetwork.length - 1) >=
                                        index) &&
                                    outDoorImagesHotel[index] == ''
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                      imageUrl: outDoorImageNetwork[index]
                                          ['image'],
                                      placeholder: (context, url) =>
                                          CupertinoActivityIndicator(
                                        color: AppColors.colorFE6927,
                                      ),
                                      errorWidget: (context, url, error) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: AppColors.color000000,
                                          ),
                                          Flexible(
                                            child: Text(
                                              'Add Photo',
                                              style: color00000s14w500,
                                            ),
                                          )
                                        ],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppColors.color000000
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      child: /*coverPhotoNetwork.isNotEmpty &&
                          coverPhoto.value == ''
                          ? CachedNetworkImage(
                          imageUrl: '',
                          placeholder: (context, url) =>
                            CupertinoActivityIndicator(
                              color: AppColors.colorFE6927,
                            ),
                          errorWidget: (context, url, error) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: AppColors.color000000,
                            ),
                            Flexible(
                              child: Text(
                                'Add Photo',
                                style: color00000s14w500,
                              ),
                            )
                          ],
                          ),
                          fit: BoxFit.cover,
                          )
                          :*/
                                          outDoorImagesHotel[index] == ''
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 40,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.add,
                                                        color: AppColors
                                                            .color000000,
                                                      ),
                                                      Text(
                                                        'Add Image',
                                                        style:
                                                            color00000s14w500,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Image.file(
                                                  File(outDoorImagesHotel[
                                                      index]),
                                                  fit: BoxFit.cover,
                                                ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CommonButton(
                                width: 180,
                                onPressed: () {
                                  outDoorImagesHotel.length > 3
                                      ? outDoorImagesHotel.removeLast()
                                      : null;
                                },
                                name: 'Remove Image'),
                            const SizedBox(
                              width: 10,
                            ),
                            CommonButton(
                                width: 180,
                                onPressed: () {
                                  outDoorImagesHotel.add('');
                                },
                                name: 'Add Image'),
                          ],
                        ),
                      ],
                    )
                  : Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: InkWell(
                              onTap: () {
                                pickOutDoor1Image().then((value) {
                                  if (outDoor1Img.value != '') {
                                    if (outDoorImageNetwork.isNotEmpty &&
                                        outDoorImageNetwork != []) {
                                      if (outDoorImageID.contains(
                                          outDoorImageNetwork[0]['id'])) {
                                        print('hahahaha');
                                      } else {
                                        outDoorImageID
                                            .add(outDoorImageNetwork[0]['id']);
                                      }
                                    }
                                  }
                                });
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                height: Get.width / 3.3,
                                width: Get.width / 3.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color:
                                        AppColors.color000000.withOpacity(0.5),
                                  ),
                                ),
                                child: outDoorImageNetwork.isNotEmpty &&
                                        outDoorImageNetwork[0]['image'] !=
                                            null &&
                                        outDoor1Img.value == ''
                                    ? CachedNetworkImage(
                                        imageUrl: outDoorImageNetwork[0]
                                            ['image'],
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(
                                          color: AppColors.colorFE6927,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: AppColors.color000000,
                                            ),
                                            Flexible(
                                              child: Text(
                                                'Add Photo',
                                                style: color00000s14w500,
                                              ),
                                            )
                                          ],
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : outDoor1Img.value == ''
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: AppColors.color000000,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'Add Photo',
                                                  style: color00000s14w500,
                                                ),
                                              )
                                            ],
                                          )
                                        : Image.file(
                                            File(outDoor1Img.value),
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: InkWell(
                              onTap: () {
                                pickOutDoor2Image().then((value) {
                                  if (outDoor2Img.value != '') {
                                    if (outDoorImageNetwork.isNotEmpty &&
                                        outDoorImageNetwork != []) {
                                      if (outDoorImageID.contains(
                                          outDoorImageNetwork[1]['id'])) {
                                        print('hahahaha');
                                      } else {
                                        outDoorImageID
                                            .add(outDoorImageNetwork[1]['id']);
                                      }
                                    }
                                  }
                                });
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                height: Get.width / 3.3,
                                width: Get.width / 3.3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: AppColors.color000000
                                            .withOpacity(0.5))),
                                child: outDoorImageNetwork.isNotEmpty &&
                                        outDoorImageNetwork[1]['image'] !=
                                            null &&
                                        outDoor2Img.value == ''
                                    ? CachedNetworkImage(
                                        imageUrl: outDoorImageNetwork[1]
                                            ['image'],
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(
                                          color: AppColors.colorFE6927,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: AppColors.color000000,
                                            ),
                                            Flexible(
                                              child: Text(
                                                'Add Photo',
                                                style: color00000s14w500,
                                              ),
                                            )
                                          ],
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : outDoor2Img.value == ''
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: AppColors.color000000,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'Add Photo',
                                                  style: color00000s14w500,
                                                ),
                                              )
                                            ],
                                          )
                                        : Image.file(
                                            File(outDoor2Img.value),
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: InkWell(
                              onTap: () {
                                pickOutDoor3Image().then((value) {
                                  if (outDoor3Img.value != '') {
                                    if (outDoorImageNetwork.isNotEmpty &&
                                        outDoorImageNetwork != []) {
                                      if (outDoorImageID.contains(
                                          outDoorImageNetwork[2]['id'])) {
                                        print('hahahaha');
                                      } else {
                                        outDoorImageID
                                            .add(outDoorImageNetwork[2]['id']);
                                      }
                                    }
                                  }
                                });
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                height: Get.width / 3.3,
                                width: Get.width / 3.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color:
                                        AppColors.color000000.withOpacity(0.5),
                                  ),
                                ),
                                child: outDoorImageNetwork.isNotEmpty &&
                                        outDoorImageNetwork[2]['image'] !=
                                            null &&
                                        outDoor3Img.value == ''
                                    ? CachedNetworkImage(
                                        imageUrl: outDoorImageNetwork[2]
                                            ['image'],
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(
                                          color: AppColors.colorFE6927,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: AppColors.color000000,
                                            ),
                                            Flexible(
                                              child: Text(
                                                'Add Photo',
                                                style: color00000s14w500,
                                              ),
                                            )
                                          ],
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : outDoor3Img.value == ''
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: AppColors.color000000,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'Add Photo',
                                                  style: color00000s14w500,
                                                ),
                                              )
                                            ],
                                          )
                                        : Image.file(
                                            File(outDoor3Img.value),
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
            }),
            Obx(() {
              return isHotel.value
                  ? const SizedBox()
                  : StreamBuilder(
                      stream: pickImg.stream,
                      builder: (context, snapshot) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(pickImg.length, (index) {
                            if (pickImg[index]['qty'] == 0 ||
                                pickImg[index]['name'] == 'Guest Allowed' ||
                                pickImg[index]['name'] == 'Extra Mattress') {
                              return const SizedBox();
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pickImg[index]['name'],
                                      style: color00000s15w600,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: GridView(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 16,
                                          crossAxisSpacing: 15,
                                        ),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children: List.generate(
                                          pickImg[index]['qty'],
                                          (i) => ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: InkWell(
                                              onTap: () async {
                                                try {
                                                  var image =
                                                      await ImagePicker()
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                  if (image == null) return;

                                                  pickImg[index]['imgPath'][i] =
                                                      image.path;

                                                  if (image.path != null ||
                                                      image.path != '') {
                                                    if (pickImg[index][
                                                                'networkImage'] !=
                                                            null &&
                                                        pickImg[index]
                                                                ['networkImage']
                                                            .isNotEmpty &&
                                                        pickImg[index][
                                                                'networkImage'] !=
                                                            []) {
                                                      if (amenitiesPhotoID
                                                          .contains(pickImg[
                                                                      index][
                                                                  'networkImage']
                                                              ?[i]['id'])) {
                                                        print('hahahaha');
                                                      } else {
                                                        amenitiesPhotoID.add(
                                                            pickImg[index][
                                                                    'networkImage']
                                                                ?[i]['id']);
                                                      }
                                                    }
                                                  }
                                                } on PlatformException catch (e) {
                                                  showSnackBar(
                                                      title: ApiConfig.error,
                                                      message:
                                                          'Failed to pick image: $e');
                                                }
                                                pickImg.refresh();
                                                print(
                                                    'IMAGE PATH  ${pickImg[index]['imgPath'][i]}');
                                                print(
                                                    'IMAGE PATH  ${pickImg[index]}');
                                              },
                                              highlightColor:
                                                  Colors.transparent,
                                              splashColor: Colors.transparent,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: AppColors.color000000
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                child: (pickImg[index]['networkImage'] !=
                                                                null &&
                                                            pickImg[index]['networkImage']
                                                                .isNotEmpty) &&
                                                        (pickImg[index]['imgPath']
                                                                    [i] ==
                                                                '' ||
                                                            pickImg[index]['imgPath'] ==
                                                                null)
                                                    ? CachedNetworkImage(
                                                        imageUrl: pickImg[index]
                                                                    [
                                                                    'networkImage']
                                                                ?[i]['image'] ??
                                                            '',
                                                        placeholder: (context,
                                                                url) =>
                                                            CupertinoActivityIndicator(
                                                          color: AppColors
                                                              .colorFE6927,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.add,
                                                              color: AppColors
                                                                  .color000000,
                                                            ),
                                                            Flexible(
                                                              child: Text(
                                                                'Add Photo',
                                                                style:
                                                                    color00000s14w500,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : pickImg[index]['imgPath'][i] ==
                                                                '' ||
                                                            pickImg[index][
                                                                    'imgPath'] ==
                                                                null
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 50,
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons.add,
                                                                  color: AppColors
                                                                      .color000000,
                                                                ),
                                                                Text(
                                                                  'Add Photo',
                                                                  style:
                                                                      color00000s14w500,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Image.file(
                                                            File(pickImg[index]['imgPath'][i]),
                                                            fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          }),
                        );
                      });
            }),
          ],
        );
      },
    );
  }

  ///amenities step 8
  RxList amenities_publishs = [].obs;
  RxList amenities_standouts = [].obs;
  RxList amenities_Safetys = [].obs;

  Widget step8() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services offered to the guests',
          style: color00000s18w600,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          'You can add more amenities later on also after you publish your listing',
          style: color50perBlacks13w400,
        ),
        const SizedBox(
          height: 13,
        ),
        StreamBuilder(
            stream: amenities_publishs.stream,
            builder: (context, snapshot) {
              return amenities_publishs.isEmpty
                  ? const SizedBox()
                  : GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, childAspectRatio: 2 / 3),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        amenities_publishs.length,
                        (index) => SizedBox(
                          width: double.maxFinite,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: (amenities_publishs[
                                                              index]['qty'] >
                                                          0)
                                                      ? AppColors.colorFE6927
                                                      : AppColors.color1C2534
                                                          .withOpacity(0.2),
                                                  width: 2),
                                              color: AppColors.colorffffff),
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: HostingController
                                                            .to.getStartHostRes[
                                                        'amenities_base_url'] +
                                                    '/' +
                                                    '${amenities_publishs[index]['amenitie_icon']}',
                                                placeholder: (context, url) =>
                                                    CupertinoActivityIndicator(
                                                  color: AppColors.colorFE6927,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                height: 35,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                amenities_publishs[index]
                                                    ['title'],
                                                style: colorfffffffs13w600
                                                    .copyWith(
                                                  color: AppColors.color000000,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          right: Get.height * 0.02,
                                          top: Get.height * 0.002,
                                          child: (amenities_publishs[index]
                                                      ['qty'] >
                                                  0
                                              ? Image.asset(
                                                  AppImages.checkedIcon,
                                                  height: 20,
                                                )
                                              : const SizedBox()))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          amenities_publishs[index]['qty'] > 0
                                              ? amenities_publishs[index]
                                                      ['qty'] =
                                                  amenities_publishs[index]
                                                          ['qty'] -
                                                      1
                                              : null;
                                          amenities_publishs.refresh();
                                        },
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: AppColors.colorFE6927),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.remove,
                                              size: 18,
                                              color: AppColors.colorffffff,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: StreamBuilder(
                                              stream: amenities_publishs.stream,
                                              builder: (context, snapshot) {
                                                return TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                    text: amenities_publishs[
                                                            index]['qty']
                                                        .toString(),
                                                  ),
                                                  style: color00000s14w500,
                                                  textAlign: TextAlign.center,
                                                  cursorColor:
                                                      AppColors.colorFE6927,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (val) {
                                                    amenities_publishs[index]
                                                            ['qty'] =
                                                        int.parse(val);
                                                    val.isEmpty
                                                        ? amenities_publishs[
                                                            index]['qty'] = 0
                                                        : null;
                                                  },
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      vertical: 10,
                                                      horizontal: 8,
                                                    ),
                                                    isDense: true,
                                                    // hintText: categiry[index]
                                                    //         ['qty']
                                                    //     .toString(),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      borderSide: BorderSide(
                                                        color: AppColors
                                                            .color000000
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      borderSide: BorderSide(
                                                        color: AppColors
                                                            .color000000
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      borderSide: BorderSide(
                                                        color: AppColors
                                                            .color000000
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          /*data[index]['qty'] > 0
                                                  ?*/
                                          amenities_publishs[index]['qty'] =
                                              amenities_publishs[index]['qty'] +
                                                  1;
                                          /*: null;*/
                                          amenities_publishs.refresh();
                                        },
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: AppColors.colorFE6927),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.add,
                                              size: 18,
                                              color: AppColors.colorffffff,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
            }),
        Obx(() {
          return amenities_publishs.isEmpty
              ? const SizedBox()
              : const SizedBox(
                  height: 20,
                );
        }),
        Obx(() {
          return amenities_standouts.isNotEmpty
              ? Text(
                  'Do you have any other special amenities?',
                  style: color00000s18w600,
                )
              : const SizedBox();
        }),
        const SizedBox(
          height: 13,
        ),
        StreamBuilder(
            stream: amenities_standouts.stream,
            builder: (context, snapshot) {
              return amenities_standouts.isEmpty
                  ? const SizedBox()
                  : GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, childAspectRatio: 2 / 2),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        amenities_standouts.length,
                        (index) => SizedBox(
                          width: double.maxFinite,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () {
                                amenities_standouts[index]['qty'] =
                                    !amenities_standouts[index]['qty'];
                                amenities_standouts.refresh();
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: (amenities_standouts[
                                                            index]['qty'])
                                                        ? AppColors.colorFE6927
                                                        : AppColors.color1C2534
                                                            .withOpacity(0.2),
                                                    width: 2),
                                                color: AppColors.colorffffff),
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: HostingController
                                                                .to
                                                                .getStartHostRes[
                                                            'amenities_base_url'] +
                                                        '/' +
                                                        '${amenities_standouts[index]['amenitie_icon']}',
                                                    placeholder: (context,
                                                            url) =>
                                                        CupertinoActivityIndicator(
                                                      color:
                                                          AppColors.colorFE6927,
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    height: 35,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    amenities_standouts[index]
                                                        ['title'],
                                                    style: colorfffffffs13w600
                                                        .copyWith(
                                                            color: AppColors
                                                                .color000000),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                  )
                                                ]),
                                          ),
                                        ),
                                        Positioned(
                                            right: Get.height * 0.02,
                                            top: Get.height * 0.002,
                                            child: (amenities_standouts[index]
                                                    ['qty']
                                                ? Image.asset(
                                                    AppImages.checkedIcon,
                                                    height: 20,
                                                  )
                                                : const SizedBox()))
                                      ],
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(vertical: 15),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  //     children: [
                                  //       InkWell(
                                  //         onTap: () {
                                  //           amenities_standouts[index]['qty'] > 0
                                  //               ? amenities_standouts[index]['qty'] =
                                  //                   amenities_standouts[index]['qty'] -
                                  //                       1
                                  //               : null;
                                  //           amenities_standouts.refresh();
                                  //         },
                                  //         highlightColor: Colors.transparent,
                                  //         splashColor: Colors.transparent,
                                  //         child: Container(
                                  //           decoration: BoxDecoration(
                                  //               borderRadius: BorderRadius.circular(6),
                                  //               color: AppColors.colorFE6927),
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.all(8),
                                  //             child: Icon(
                                  //               Icons.remove,
                                  //               size: 18,
                                  //               color: AppColors.colorffffff,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       Flexible(
                                  //         child: Text(
                                  //             amenities_standouts[index]['qty']
                                  //                 .toString(),
                                  //             style: color00000s18w600),
                                  //       ),
                                  //       InkWell(
                                  //         onTap: () {
                                  //           /*data[index]['qty'] > 0
                                  //                         ?*/
                                  //           amenities_standouts[index]['qty'] =
                                  //               amenities_standouts[index]['qty'] + 1;
                                  //           /*: null;*/
                                  //           amenities_standouts.refresh();
                                  //         },
                                  //         highlightColor: Colors.transparent,
                                  //         splashColor: Colors.transparent,
                                  //         child: Container(
                                  //           decoration: BoxDecoration(
                                  //               borderRadius: BorderRadius.circular(6),
                                  //               color: AppColors.colorFE6927),
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.all(8),
                                  //             child: Icon(
                                  //               Icons.add,
                                  //               size: 18,
                                  //               color: AppColors.colorffffff,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
            }),
        const SizedBox(
          height: 20,
        ),
        Obx(() {
          return amenities_Safetys.isNotEmpty
              ? Text(
                  'Other Safety Items In Your Location',
                  style: color00000s18w600,
                )
              : const SizedBox();
        }),
        const SizedBox(
          height: 13,
        ),
        StreamBuilder(
            stream: amenities_Safetys.stream,
            builder: (context, snapshot) {
              return amenities_Safetys.isEmpty
                  ? const SizedBox()
                  : GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, childAspectRatio: 2 / 2),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        amenities_Safetys.length,
                        (index) => SizedBox(
                          width: double.maxFinite,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () {
                                amenities_Safetys[index]['qty'] =
                                    !amenities_Safetys[index]['qty'];
                                amenities_Safetys.refresh();
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: (amenities_Safetys[
                                                            index]['qty'])
                                                        ? AppColors.colorFE6927
                                                        : AppColors.color1C2534
                                                            .withOpacity(0.2),
                                                    width: 2),
                                                color: AppColors.colorffffff),
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: HostingController
                                                                .to
                                                                .getStartHostRes[
                                                            'amenities_base_url'] +
                                                        '/' +
                                                        '${amenities_Safetys[index]['amenitie_icon']}',
                                                    placeholder: (context,
                                                            url) =>
                                                        CupertinoActivityIndicator(
                                                      color:
                                                          AppColors.colorFE6927,
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    height: 35,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    amenities_Safetys[index]
                                                        ['title'],
                                                    style: colorfffffffs13w600
                                                        .copyWith(
                                                            color: AppColors
                                                                .color000000),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                  )
                                                ]),
                                          ),
                                        ),
                                        Positioned(
                                            right: Get.height * 0.02,
                                            top: Get.height * 0.002,
                                            child: (amenities_Safetys[index]
                                                    ['qty']
                                                ? Image.asset(
                                                    AppImages.checkedIcon,
                                                    height: 20,
                                                  )
                                                : const SizedBox()))
                                      ],
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(vertical: 15),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  //     children: [
                                  //       InkWell(
                                  //         onTap: () {
                                  //           amenities_Safetys[index]['qty'] > 0
                                  //               ? amenities_Safetys[index]['qty'] =
                                  //                   amenities_Safetys[index]['qty'] - 1
                                  //               : null;
                                  //           amenities_Safetys.refresh();
                                  //         },
                                  //         highlightColor: Colors.transparent,
                                  //         splashColor: Colors.transparent,
                                  //         child: Container(
                                  //           decoration: BoxDecoration(
                                  //               borderRadius: BorderRadius.circular(6),
                                  //               color: AppColors.colorFE6927),
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.all(8),
                                  //             child: Icon(
                                  //               Icons.remove,
                                  //               size: 18,
                                  //               color: AppColors.colorffffff,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       Flexible(
                                  //         child: Text(
                                  //             amenities_Safetys[index]['qty']
                                  //                 .toString(),
                                  //             style: color00000s18w600),
                                  //       ),
                                  //       InkWell(
                                  //         onTap: () {
                                  //           /*data[index]['qty'] > 0
                                  //                         ?*/
                                  //           amenities_Safetys[index]['qty'] =
                                  //               amenities_Safetys[index]['qty'] + 1;
                                  //           /*: null;*/
                                  //           amenities_Safetys.refresh();
                                  //         },
                                  //         highlightColor: Colors.transparent,
                                  //         splashColor: Colors.transparent,
                                  //         child: Container(
                                  //           decoration: BoxDecoration(
                                  //               borderRadius: BorderRadius.circular(6),
                                  //               color: AppColors.colorFE6927),
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.all(8),
                                  //             child: Icon(
                                  //               Icons.add,
                                  //               size: 18,
                                  //               color: AppColors.colorffffff,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
            }),
      ],
    );
  }

  RxBool allGuest = false.obs;
  RxBool corporatesGuest = false.obs;
  RxBool couple = false.obs;
  RxBool allMale = false.obs;
  RxBool family = false.obs;
  RxBool nonVegFood = false.obs;
  RxBool vegFood = false.obs;
  RxBool insideAlcohole = false.obs;
  RxBool outsideAlcohole = false.obs;
  RxBool bothAlcohole = false.obs;
  RxBool insideSmoke = false.obs;
  RxBool outsideSmoke = false.obs;
  RxBool bothSmoke = false.obs;
  RxString petFriendly = ''.obs;
  RxString foodAllowed = ''.obs;
  RxString alcoholeAllowed = ''.obs;
  RxString smokingAllowed = ''.obs;
  RxString swimmingPoolTimming = ''.obs;
  RxString loudMucisTimming = ''.obs;

  Widget step9() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Provide your property with a title and description',
            style: color00000s18w600,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'Short and unique titles work best. You can always edit it later',
            style: color50perBlacks13w400,
          ),
          const SizedBox(
            height: 20,
          ),
          CommonTextFeildPart(
              title: 'Property Title', controller: _propertyTitle),
          CommonTextFeildPart(
              title: 'Property Description',
              controller: _propertyDescription,
              maxLines: 4),
          const SizedBox(
            height: 8,
          ),
          Text(
            'House Rules',
            style: color00000s18w600,
          ),
          const SizedBox(
            height: 8,
          ),
          CommonTextFeildPart(
            title: 'Check-in Time',
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                initialTime: const TimeOfDay(hour: 13, minute: 00),
                context: context,
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(
                          // change the border color
                          primary: AppColors.colorFE6927,
                          background: AppColors.colorE6E6E6),
                      // button colors
                      buttonTheme: ButtonThemeData(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.colorFE6927,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedTime != null) {
                setState(() {
                  _checkInTime.text =
                      pickedTime.format(context); //set the value of text field.
                });
              } else {
                print("Time is not selected");
              }
            },
            readOnly: true,
            controller: _checkInTime,
          ),
          CommonTextFeildPart(
            title: 'Check-out Time',
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                initialTime: const TimeOfDay(hour: 11, minute: 00),
                context: context,
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(
                        // change the border color
                        primary: AppColors.colorFE6927,
                        background: AppColors.colorE6E6E6,
                      ),
                      // button colors
                      buttonTheme: ButtonThemeData(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.colorFE6927,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedTime != null) {
                print(pickedTime.format(context)); //output 10:51 PM

                setState(() {
                  _checkOutTime.text = pickedTime
                      .format(context)
                      .toString(); //set the value of text field.
                });
              } else {
                print("Time is not selected");
              }
            },
            readOnly: true,
            controller: _checkOutTime,
          ),
          Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Guests Allowed',
                style: color00000s18w600,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  CommonCheckBox(
                    allGuest,
                    onChanged: (val) {
                      allGuest.value = !allGuest.value;
                      corporatesGuest.value = allGuest.value;
                      couple.value = allGuest.value;
                      allMale.value = allGuest.value;
                      family.value = allGuest.value;
                    },
                  ),
                  Text('All Guests Are Allowed', style: color00000s14w500),
                ],
              ),
              Row(
                children: [
                  CommonCheckBox(corporatesGuest, onChanged: (val) {
                    corporatesGuest.value = !corporatesGuest.value;
                    if (corporatesGuest.value &&
                        couple.value &&
                        allMale.value &&
                        family.value) {
                      allGuest.value = true;
                    } else {
                      allGuest.value = false;
                    }
                  }),
                  Text('Corporates Guest Allowed', style: color00000s14w500),
                ],
              ),
              Row(
                children: [
                  CommonCheckBox(couple, onChanged: (val) {
                    couple.value = !couple.value;
                    if (corporatesGuest.value &&
                        couple.value &&
                        allMale.value &&
                        family.value) {
                      allGuest.value = true;
                    } else {
                      allGuest.value = false;
                    }
                  }),
                  Text('Couple Allowed', style: color00000s14w500),
                ],
              ),
              Row(
                children: [
                  CommonCheckBox(allMale, onChanged: (val) {
                    allMale.value = !allMale.value;
                    if (corporatesGuest.value &&
                        couple.value &&
                        allMale.value &&
                        family.value) {
                      allGuest.value = true;
                    } else {
                      allGuest.value = false;
                    }
                  }),
                  Text(isHotel.value ? 'Local Id Allow' : 'All Male Group',
                      style: color00000s14w500),
                ],
              ),
              Row(
                children: [
                  CommonCheckBox(family, onChanged: (val) {
                    family.value = !family.value;
                    if (corporatesGuest.value &&
                        couple.value &&
                        allMale.value &&
                        family.value) {
                      allGuest.value = true;
                    } else {
                      allGuest.value = false;
                    }
                  }),
                  Text(isHotel.value ? 'Local Id Not Allow' : 'Family Allowed',
                      style: color00000s14w500),
                ],
              ),
            ],
          ),
          Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
          const SizedBox(
            height: 8,
          ),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Pet Friendly',
                  style: color00000s18w600,
                ),
                const SizedBox(
                  height: 8,
                ),
                RadioListTile(
                  title: Text("Yes", style: color00000s14w500),
                  value: "Yes",
                  groupValue: petFriendly.value,
                  activeColor: AppColors.colorFE6927,
                  onChanged: (value) {
                    petFriendly.value = value.toString();
                    print(petFriendly.value.toString());
                  },
                ),
                RadioListTile(
                  title: Text("No", style: color00000s14w500),
                  value: "No",
                  groupValue: petFriendly.value,
                  activeColor: AppColors.colorFE6927,
                  onChanged: (value) {
                    petFriendly.value = value.toString();
                    print(petFriendly.value.toString());
                  },
                ),
              ],
            );
          }),
          Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
          const SizedBox(
            height: 8,
          ),
          Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Swimming Pool Timing',
                    style: color00000s18w600,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  RadioListTile(
                    title: Text("24 Hours", style: color00000s14w500),
                    value: "24 Hours",
                    groupValue: swimmingPoolTimming.value,
                    activeColor: AppColors.colorFE6927,
                    onChanged: (value) {
                      swimmingPoolTimming.value = value.toString();
                      print(swimmingPoolTimming.value.toString());
                    },
                  ),
                  RadioListTile(
                    title: Text("Set Custom Time", style: color00000s14w500),
                    value: "Custom Time",
                    groupValue: swimmingPoolTimming.value,
                    activeColor: AppColors.colorFE6927,
                    onChanged: (value) {
                      swimmingPoolTimming.value = value.toString();
                      print(swimmingPoolTimming.value.toString());
                    },
                  ),
                  swimmingPoolTimming.value == "Custom Time"
                      ? Column(
                          children: [
                            CommonTextFeildPart(
                              title: 'Open Time',
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime:
                                      const TimeOfDay(hour: 8, minute: 00),
                                  context: context,
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme: ColorScheme.light(
                                            // change the border color
                                            primary: AppColors.colorFE6927,
                                            background: AppColors.colorE6E6E6),
                                        // button colors
                                        buttonTheme: ButtonThemeData(
                                          colorScheme: ColorScheme.light(
                                            primary: AppColors.colorFE6927,
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedTime != null) {
                                  setState(() {
                                    _openTime.text = pickedTime.format(
                                        context); //set the value of text field.
                                  });
                                } else {
                                  print("Time is not selected");
                                }
                              },
                              readOnly: true,
                              controller: _openTime,
                            ),
                            CommonTextFeildPart(
                              title: 'Close Time',
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime:
                                      const TimeOfDay(hour: 18, minute: 00),
                                  context: context,
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme: ColorScheme.light(
                                            // change the border color
                                            primary: AppColors.colorFE6927,
                                            background: AppColors.colorE6E6E6),
                                        // button colors
                                        buttonTheme: ButtonThemeData(
                                          colorScheme: ColorScheme.light(
                                            primary: AppColors.colorFE6927,
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedTime != null) {
                                  print(pickedTime
                                      .format(context)); //output 10:51 PM

                                  setState(() {
                                    _closeTime.text = pickedTime
                                        .format(context)
                                        .toString(); //set the value of text field.
                                  });
                                } else {
                                  print("Time is not selected");
                                }
                              },
                              readOnly: true,
                              controller: _closeTime,
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              );
            },
          ),
          Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
          const SizedBox(
            height: 8,
          ),
          isHotel.value
              ? const SizedBox()
              : Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Loud Music Timing',
                        style: color00000s18w600,
                      ),
                      RadioListTile(
                        title: Text("24 Hours", style: color00000s14w500),
                        value: "24 Hours",
                        groupValue: loudMucisTimming.value,
                        activeColor: AppColors.colorFE6927,
                        onChanged: (value) {
                          loudMucisTimming.value = value.toString();
                          print(loudMucisTimming.value.toString());
                        },
                      ),
                      RadioListTile(
                        title:
                            Text("Set Custom Time", style: color00000s14w500),
                        value: "Custom Time",
                        groupValue: loudMucisTimming.value,
                        activeColor: AppColors.colorFE6927,
                        onChanged: (value) {
                          loudMucisTimming.value = value.toString();
                          print(loudMucisTimming.value.toString());
                        },
                      ),
                      loudMucisTimming.value == "Custom Time"
                          ? Column(
                              children: [
                                CommonTextFeildPart(
                                  title: 'Open Time',
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      initialTime:
                                          const TimeOfDay(hour: 8, minute: 00),
                                      context: context,
                                      builder: (context, child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme: ColorScheme.light(
                                                // change the border color
                                                primary: AppColors.colorFE6927,
                                                background:
                                                    AppColors.colorE6E6E6),
                                            // button colors
                                            buttonTheme: ButtonThemeData(
                                              colorScheme: ColorScheme.light(
                                                primary: AppColors.colorFE6927,
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );

                                    if (pickedTime != null) {
                                      setState(() {
                                        _musicopenTime.text = pickedTime.format(
                                            context); //set the value of text field.
                                      });
                                    } else {
                                      print("Time is not selected");
                                    }
                                  },
                                  readOnly: true,
                                  controller: _musicopenTime,
                                ),
                                CommonTextFeildPart(
                                  title: 'Close Time',
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      initialTime:
                                          const TimeOfDay(hour: 18, minute: 00),
                                      context: context,
                                      builder: (context, child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme: ColorScheme.light(
                                                // change the border color
                                                primary: AppColors.colorFE6927,
                                                background:
                                                    AppColors.colorE6E6E6),
                                            // button colors
                                            buttonTheme: ButtonThemeData(
                                              colorScheme: ColorScheme.light(
                                                primary: AppColors.colorFE6927,
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );

                                    if (pickedTime != null) {
                                      print(pickedTime
                                          .format(context)); //output 10:51 PM

                                      setState(() {
                                        _musiccloseTime.text = pickedTime
                                            .format(context)
                                            .toString(); //set the value of text field.
                                      });
                                    } else {
                                      print("Time is not selected");
                                    }
                                  },
                                  readOnly: true,
                                  controller: _musiccloseTime,
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  );
                }),
          isHotel.value
              ? const SizedBox()
              : Divider(
                  color: AppColors.color000000.withOpacity(0.2),
                ),
          isHotel.value
              ? const SizedBox()
              : const SizedBox(
                  height: 8,
                ),
          isHotel.value
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Food Allowed',
                      style: color00000s18w600,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        CommonCheckBox(nonVegFood),
                        Flexible(
                          child: Text(
                            'Non Veg',
                            style: color000000s12w400,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        CommonCheckBox(vegFood),
                        Flexible(
                          child: Text(
                            'Veg',
                            style: color000000s12w400,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
          isHotel.value
              ? const SizedBox()
              : Divider(
                  color: AppColors.color000000.withOpacity(0.2),
                ),
          isHotel.value
              ? const SizedBox()
              : const SizedBox(
                  height: 8,
                ),
          isHotel.value
              ? const SizedBox()
              : Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Alcohol Allowed',
                        style: color00000s18w600,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      RadioListTile(
                        title: Text("Yes", style: color00000s14w500),
                        value: "Yes",
                        groupValue: alcoholeAllowed.value,
                        activeColor: AppColors.colorFE6927,
                        onChanged: (value) {
                          alcoholeAllowed.value = value.toString();
                          print(alcoholeAllowed.value.toString());
                        },
                      ),
                      alcoholeAllowed.value == "Yes"
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    CommonCheckBox(outsideAlcohole,
                                        onChanged: (val) {
                                      outsideAlcohole.value =
                                          !outsideAlcohole.value;

                                      if (outsideAlcohole.value &&
                                          insideAlcohole.value) {
                                        bothAlcohole.value = true;
                                      } else {
                                        bothAlcohole.value = false;
                                      }
                                    }),
                                    Flexible(
                                      child: Text(
                                        'Outside',
                                        style: color000000s12w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CommonCheckBox(insideAlcohole,
                                        onChanged: (val) {
                                      insideAlcohole.value =
                                          !insideAlcohole.value;

                                      if (outsideAlcohole.value &&
                                          insideAlcohole.value) {
                                        bothAlcohole.value = true;
                                      } else {
                                        bothAlcohole.value = false;
                                      }
                                    }),
                                    Flexible(
                                      child: Text(
                                        'Inside',
                                        style: color000000s12w400,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    CommonCheckBox(bothAlcohole,
                                        onChanged: (val) {
                                      bothAlcohole.value = !bothAlcohole.value;

                                      outsideAlcohole.value =
                                          bothAlcohole.value;
                                      insideAlcohole.value = bothAlcohole.value;
                                      if (outsideAlcohole.value &&
                                          insideAlcohole.value) {
                                        bothAlcohole.value = true;
                                      } else {
                                        bothAlcohole.value = false;
                                      }
                                    }),
                                    Flexible(
                                      child: Text(
                                        'Both',
                                        style: color000000s12w400,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox(),
                      RadioListTile(
                        title: Text("No", style: color00000s14w500),
                        value: "No",
                        groupValue: alcoholeAllowed.value,
                        activeColor: AppColors.colorFE6927,
                        onChanged: (value) {
                          alcoholeAllowed.value = value.toString();
                          print(alcoholeAllowed.value.toString());
                        },
                      ),
                    ],
                  );
                }),
          isHotel.value
              ? const SizedBox()
              : Divider(
                  color: AppColors.color000000.withOpacity(0.2),
                ),
          isHotel.value
              ? const SizedBox()
              : const SizedBox(
                  height: 8,
                ),
          isHotel.value
              ? const SizedBox()
              : Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Smoking Allowed',
                        style: color00000s18w600,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      RadioListTile(
                        title: Text("Yes", style: color00000s14w500),
                        value: "Yes",
                        groupValue: smokingAllowed.value,
                        activeColor: AppColors.colorFE6927,
                        onChanged: (value) {
                          smokingAllowed.value = value.toString();
                          print(smokingAllowed.value.toString());
                        },
                      ),
                      smokingAllowed.value == "Yes"
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    CommonCheckBox(outsideSmoke,
                                        onChanged: (val) {
                                      outsideSmoke.value = !outsideSmoke.value;

                                      if (outsideSmoke.value &&
                                          insideSmoke.value) {
                                        bothSmoke.value = true;
                                      } else {
                                        bothSmoke.value = false;
                                      }
                                    }),
                                    Flexible(
                                      child: Text(
                                        'Outside',
                                        style: color000000s12w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CommonCheckBox(insideSmoke,
                                        onChanged: (val) {
                                      insideSmoke.value = !insideSmoke.value;

                                      if (outsideSmoke.value &&
                                          insideSmoke.value) {
                                        bothSmoke.value = true;
                                      } else {
                                        bothSmoke.value = false;
                                      }
                                    }),
                                    Flexible(
                                      child: Text(
                                        'Inside',
                                        style: color000000s12w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CommonCheckBox(bothSmoke, onChanged: (val) {
                                      bothSmoke.value = !bothSmoke.value;

                                      outsideSmoke.value = bothSmoke.value;
                                      insideSmoke.value = bothSmoke.value;
                                      if (outsideSmoke.value &&
                                          insideSmoke.value) {
                                        bothSmoke.value = true;
                                      } else {
                                        bothSmoke.value = false;
                                      }
                                    }),
                                    Flexible(
                                      child: Text(
                                        'Both',
                                        style: color000000s12w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox(),
                      RadioListTile(
                        title: Text("No", style: color00000s14w500),
                        value: "No",
                        groupValue: smokingAllowed.value,
                        activeColor: AppColors.colorFE6927,
                        onChanged: (value) {
                          smokingAllowed.value = value.toString();
                          print(smokingAllowed.value.toString());
                        },
                      ),
                    ],
                  );
                }),
          isHotel.value
              ? const SizedBox()
              : Divider(
                  color: AppColors.color000000.withOpacity(0.2),
                ),
          isHotel.value
              ? const SizedBox()
              : const SizedBox(
                  height: 8,
                ),
          Text(
            'Add Custom Rules',
            style: color00000s18w600,
          ),
          const SizedBox(
            height: 8,
          ),
          Obx(() {
            return Column(
              children: List.generate(
                customeRules.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: color00000s14w500,
                          restorationId: index.toString(),
                          cursorColor: AppColors.colorFE6927,
                          initialValue: customeRules[index].toString(),
                          onChanged: (val) {
                            customeRules[index] = val;
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Enter House Rules.',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: AppColors.color000000.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: AppColors.color000000.withOpacity(0.5),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: AppColors.color000000.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      IconButton(
                          onPressed: () {
                            index == 0
                                ? customeRules.add('')
                                : customeRules.removeAt(index);
                          },
                          icon: Icon(index == 0
                              ? Icons.add
                              : Icons.delete_outline_outlined))
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(
            height: 20,
          ),
        ],
      );
    });
  }

  /* Widget step10() {
    return Column(
      children: [
        Image.asset(
          AppImages.homeImg,
        ),
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppColors.colorffffff,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 5,
                  color: Color.fromRGBO(0, 0, 0, 0.05))
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step 3',
                style: color00000s14w500,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Complete your details and publish it',
                style: color00000s20w600,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Provide details regarding the kind of property you have in this phase and whether visitors will book the complete property or simply a room. Also, add how many people can stay in your property',
                style: color50perBlacks13w400,
              ),
            ],
          ),
        ),
      ],
    );
  }*/

  RxString firstFiveDiscount = '0'.obs;
  RxString otherWebSite = ''.obs;
  RxBool Airbnb = false.obs;
  RxBool StayVista = false.obs;
  RxBool Makemytrip = false.obs;
  RxBool Bookingcom = false.obs;
  RxBool Other = false.obs;
  TextEditingController OtherController = TextEditingController();

  Widget step11() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isHotel.value ? 'Hotel Information' : 'Price Expectation',
            style: color00000s18w600,
          ),
          const SizedBox(
            height: 4,
          ),
          isHotel.value
              ? const SizedBox()
              : Text(
                  'You can change it anytime.',
                  style: color50perBlacks13w400,
                ),
          isHotel.value
              ? const SizedBox()
              : const SizedBox(
                  height: 20,
                ),
          isHotel.value
              ? const SizedBox()
              : Row(
                  children: [
                    InkWell(
                      onTap: () {
                        (int.parse(_priceExpectation.text) > 0)
                            ? _priceExpectation.text =
                                (int.parse(_priceExpectation.text) - 1)
                                    .toString()
                            : _priceExpectation.text = _priceExpectation.text;
                        FocusScope.of(context).unfocus();
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColors.colorFE6927),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.remove,
                            size: 25,
                            color: AppColors.colorffffff,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextFormField(
                      style: color00000s14w500,
                      cursorColor: AppColors.colorFE6927,
                      controller: _priceExpectation,
                      // inputFormatters: <TextInputFormatter>[
                      //   // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      //   FilteringTextInputFormatter.digitsOnly
                      // ],
                      onChanged: (val) {},
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: AppColors.color000000.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: AppColors.color000000.withOpacity(0.5),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: AppColors.color000000.withOpacity(0.5),
                          ),
                        ),
                      ),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _priceExpectation.text =
                            (int.parse(_priceExpectation.text) + 1).toString();
                        FocusScope.of(context).unfocus();
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColors.colorFE6927),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.add,
                            size: 25,
                            color: AppColors.colorffffff,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          isHotel.value ? const SizedBox() : const SizedBox(height: 10),
          isHotel.value
              ? const SizedBox()
              : Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Property Price / Per Night',
                    style: color00000s15w600.copyWith(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
          isHotel.value ? const SizedBox() : const SizedBox(height: 12),
          Obx(() {
            return Column(
              children: [
                isHotel.value
                    ? const SizedBox()
                    : Text(
                        'Places like yours in your area usually range from ₹ ${(double.parse((HostingController.to.getStartHostRes['data']['current_property_price'] ?? 0).toString()) - 500).toStringAsFixed(2)} to ₹ ${(double.parse((HostingController.to.getStartHostRes['data']['current_property_price'] ?? 0).toString()) + 500).toStringAsFixed(2)}',
                        style: color50perBlacks13w400,
                        textAlign: TextAlign.center,
                      ),
                const SizedBox(height: 12),
                isHotel.value
                    ? const SizedBox()
                    : Row(
                        children: [
                          InkWell(
                            onTap: () {
                              (int.parse(_weekendPriceExpectation.text) > 0)
                                  ? _weekendPriceExpectation.text = (int.parse(
                                              _weekendPriceExpectation.text) -
                                          1)
                                      .toString()
                                  : _weekendPriceExpectation.text =
                                      _weekendPriceExpectation.text;
                              FocusScope.of(context).unfocus();
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: AppColors.colorFE6927),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.remove,
                                  size: 25,
                                  color: AppColors.colorffffff,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextFormField(
                            style: color00000s14w500,
                            cursorColor: AppColors.colorFE6927,
                            controller: _weekendPriceExpectation,
                            // inputFormatters: <TextInputFormatter>[
                            //   // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            //   FilteringTextInputFormatter.digitsOnly
                            // ],
                            onChanged: (val) {},
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: AppColors.color000000.withOpacity(0.5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: AppColors.color000000.withOpacity(0.5),
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: AppColors.color000000.withOpacity(0.5),
                                ),
                              ),
                            ),
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              _weekendPriceExpectation.text =
                                  (int.parse(_weekendPriceExpectation.text) + 1)
                                      .toString();
                              FocusScope.of(context).unfocus();
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: AppColors.colorFE6927),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.add,
                                  size: 25,
                                  color: AppColors.colorffffff,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                isHotel.value ? const SizedBox() : const SizedBox(height: 10),
                isHotel.value
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Weekend Price (optional)',
                          style: color00000s15w600.copyWith(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                isHotel.value ? const SizedBox() : const SizedBox(height: 12),
                Divider(
                    indent: 30,
                    endIndent: 30,
                    color: AppColors.colorFE6927.withOpacity(0.5)),
                const SizedBox(height: 12),
                Text(
                  'Choose one option from below to get quick bookings and increase visibility.',
                  style: color00000s15w600,
                ),
                const SizedBox(height: 12),
                // Align(
                //   alignment: Alignment.center,
                //   child: Container(
                //     width: Get.width,
                //     decoration: BoxDecoration(
                //       color: AppColors.colorffffff,
                //       borderRadius: BorderRadius.circular(10),
                //       boxShadow: const [
                //         BoxShadow(
                //             blurRadius: 5,
                //             spreadRadius: 5,
                //             color: Color.fromRGBO(0, 0, 0, 0.05))
                //       ],
                //     ),
                //     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                //     child: Column(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Image.asset(
                //               AppImages.discountIcon,
                //               height: 25,
                //             ),
                //             const SizedBox(
                //               width: 8,
                //             ),
                //             Text(
                //               'Offer',
                //               style: color00000s15w600,
                //             )
                //           ],
                //         ),
                //         const SizedBox(
                //           height: 12,
                //         ),
                //         CommonTextFeildPart(
                //             controller: _weeklyDiscount,
                //             title: 'Weekly Discount Percent (%)',
                //             keyboardType: TextInputType.number),
                //         CommonTextFeildPart(
                //             controller: _monthlyDiscount,
                //             title: 'Monthly Discount Percent (%)',
                //             keyboardType: TextInputType.number)
                //       ],
                //     ),
                //   ),
                // ),
                RadioListTile(
                  title: Text("5% off on first five booking",
                      style: color00000s14w500),
                  value: "5",
                  groupValue: firstFiveDiscount.value,
                  activeColor: AppColors.colorFE6927,
                  onChanged: (value) {
                    firstFiveDiscount.value = value.toString();
                    print(firstFiveDiscount.value.toString());
                  },
                ),
                RadioListTile(
                  title: Text("10% off on first five booking",
                      style: color00000s14w500),
                  value: "10",
                  groupValue: firstFiveDiscount.value,
                  activeColor: AppColors.colorFE6927,
                  onChanged: (value) {
                    firstFiveDiscount.value = value.toString();
                    print(firstFiveDiscount.value.toString());
                  },
                ),
                RadioListTile(
                  title: Text("15% off on first five booking",
                      style: color00000s14w500),
                  value: "15",
                  groupValue: firstFiveDiscount.value,
                  activeColor: AppColors.colorFE6927,
                  onChanged: (value) {
                    firstFiveDiscount.value = value.toString();
                    print(firstFiveDiscount.value.toString());
                  },
                ),
                RadioListTile(
                  title: Text("20% off on first five booking",
                      style: color00000s14w500),
                  value: "20",
                  groupValue: firstFiveDiscount.value,
                  activeColor: AppColors.colorFE6927,
                  onChanged: (value) {
                    firstFiveDiscount.value = value.toString();
                    print(firstFiveDiscount.value.toString());
                  },
                ),
                RadioListTile(
                  title: Text("No interested", style: color00000s14w500),
                  value: "0",
                  groupValue: firstFiveDiscount.value,
                  activeColor: AppColors.colorFE6927,
                  onChanged: (value) {
                    firstFiveDiscount.value = value.toString();
                    print(firstFiveDiscount.value.toString());
                  },
                ),
              ],
            );
          }),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Share Your Contact Details',
            style: color00000s18w600,
          ),
          const SizedBox(
            height: 8,
          ),
          CommonTextFeildPart(
            title: 'Host Contact No. *',
            controller: _hostContactNumber,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10)
            ],
            keyboardType: TextInputType.phone,
          ),
          CommonTextFeildPart(
            title: 'Care Taker Contact No. *',
            controller: _careTakerContactNumber,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10)
            ],
            keyboardType: TextInputType.phone,
          ),
          CommonTextFeildPart(
            title: 'Emergency Number *',
            controller: _emergencyContactNumber,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10)
            ],
            keyboardType: TextInputType.phone,
          ),
          Divider(
            color: AppColors.color000000.withOpacity(0.2),
          ),
          (isHotel.value)
              ? const SizedBox()
              : const SizedBox(
                  height: 8,
                ),
          (isHotel.value)
              ? const SizedBox()
              : Text(
                  'Which number you would like to show to customers ?',
                  style: color00000s18w600,
                ),
          (isHotel.value)
              ? const SizedBox()
              : const SizedBox(
                  height: 8,
                ),
          (isHotel.value)
              ? const SizedBox()
              : Row(
                  children: [
                    CommonCheckBox(_showHostNo),
                    Flexible(
                      child: Text(
                        'Host Contact No.',
                        style: color000000s12w400,
                      ),
                    )
                  ],
                ),
          (isHotel.value)
              ? const SizedBox()
              : Row(
                  children: [
                    CommonCheckBox(_showCareTakerNo),
                    Flexible(
                      child: Text(
                        'Care Taker Contact No.',
                        style: color000000s12w400,
                      ),
                    )
                  ],
                ),
          (isHotel.value)
              ? const SizedBox()
              : Row(
                  children: [
                    CommonCheckBox(_showEmergencyNo),
                    Flexible(
                      child: Text(
                        'Emergency Contact No.',
                        style: color000000s12w400,
                      ),
                    )
                  ],
                ),
          (isHotel.value)
              ? const SizedBox()
              : Divider(
                  color: AppColors.color000000.withOpacity(0.2),
                ),
          const SizedBox(
            height: 8,
          ),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Does your property is listed on other website?',
                  style: color00000s18w600,
                ),
                const SizedBox(
                  height: 8,
                ),
                RadioListTile(
                  title: Text("Yes", style: color00000s14w500),
                  value: "Yes",
                  groupValue: otherWebSite.value,
                  activeColor: AppColors.colorFE6927,
                  onChanged: (value) {
                    otherWebSite.value = value.toString();
                    print(otherWebSite.value.toString());
                  },
                ),
                otherWebSite.value == "Yes"
                    ? Column(
                        children: [
                          Row(
                            children: [
                              CommonCheckBox(
                                Airbnb,
                                onChanged: (val) {
                                  Airbnb.value = !Airbnb.value;
                                },
                              ),
                              Flexible(
                                child: Text(
                                  isHotel.value ? 'OYO' : 'Airbnb',
                                  style: color000000s12w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CommonCheckBox(
                                StayVista,
                                onChanged: (val) {
                                  StayVista.value = !StayVista.value;
                                },
                              ),
                              Flexible(
                                child: Text(
                                  isHotel.value ? 'Agoda' : 'Stay Vista',
                                  style: color000000s12w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CommonCheckBox(
                                Makemytrip,
                                onChanged: (val) {
                                  Makemytrip.value = !Makemytrip.value;
                                },
                              ),
                              Flexible(
                                child: Text(
                                  'Makemytrip',
                                  style: color000000s12w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CommonCheckBox(
                                Bookingcom,
                                onChanged: (val) {
                                  Bookingcom.value = !Bookingcom.value;
                                },
                              ),
                              Flexible(
                                child: Text(
                                  'Booking.com',
                                  style: color000000s12w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CommonCheckBox(
                                Other,
                                onChanged: (val) {
                                  Other.value = !Other.value;
                                },
                              ),
                              Flexible(
                                child: Text(
                                  'Other',
                                  style: color000000s12w400,
                                ),
                              ),
                            ],
                          ),
                          Other.value
                              ? CommonTextFeildPart(
                                  title: 'Name Other Website *',
                                  controller: OtherController)
                              : const SizedBox()
                        ],
                      )
                    : const SizedBox(),
                RadioListTile(
                  title: Text("No", style: color00000s14w500),
                  value: "No",
                  groupValue: otherWebSite.value,
                  activeColor: AppColors.colorFE6927,
                  onChanged: (value) {
                    otherWebSite.value = value.toString();
                  },
                ),
              ],
            );
          }),
          const SizedBox(
            height: 8,
          ),
        ],
      );
    });
  }

  Widget step12() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return isHotel.value
              ? const SizedBox()
              : Text(
                  'Do you have Glee partner referral code',
                  style: color00000s18w600,
                );
        }),
        const SizedBox(
          height: 25,
        ),
        Obx(() {
          return isHotel.value
              ? const SizedBox()
              : CommonTextFeildPart(
                  prefix: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Text('GK-'),
                  ),
                  title: 'Glee Partner Code (Optional)',
                  controller: _partnerCode,
                );
        }),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColors.colorffffff,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorE6E6E6,
                  spreadRadius: 3,
                  blurRadius: 3,
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Text(
                      'TERMS AND CONDITIONS BETWEEN OWNER AND GLEEKEY HOSPITALITY',
                      style: color00000s18w600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Text(
                  'The terms and conditions are led down for managing and leasing of the property:',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 10),
                Text(
                  'Gleekey hospitality (as defined below) (“GKH”, “we”, “us”, or “our”)',
                  style: color00000s15w600,
                ),
                const SizedBox(height: 10),
                Text(
                  'Owner hereby employs Gleekey hospitality to rent, lease etc said property subject to the terms and conditions',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'Terms and Conditions of GKH in connection with the management of said property are as follows:',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'We will be liable to pay agreed sum as per the mutually agreed amounts.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'GKH is not responsible for implicit charges which are not determined. The owner shall at no time charge any extra charges, taxes and/or levies, over and above what has been specified at the time of booking. The owner can only charge the customer for any additional facility used by the customer which was not included while making the booking.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'All descriptions on the services and/or amenities at the website as provided by owner and available for view by customers/third parties should actually be provided for. If details provided do not match then this shall comprise of material breach by owner and owner shall indemnify the GKH for any and all claims by customers/third parties arising from the same.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'The owner shall at all times honor all bookings and reservations done by customers, once the booking is confirmed. Further, owner shall ensure that, once confirmed to the customer, no bookings shall be cancelled and/or modified, without the express consent of the relevant customer. Further, in case the owner is unable to honor any such booking or reservation due to any reason whatsoever, the same shall be considered as a material breach. In such a case the owner shall, at all times make accommodation at comparable (if not identical) or better alternate accommodation, at its own cost and expenses, to honor the confirmed bookings or reservations. The owner shall be solely responsible for any consumer complaint arising out or in relation to owner’s inability to honor the bookings. bookings or reservations. The owner shall be solely responsible for any consumer complaint arising out or in relation to owner’s inability to honor the bookings.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'Accordingly, any booking made through GKH does not imply that the accommodation services are being provided by GKH which only acts as a technology platform to enable bookings to be made by the customer with the owner. All accommodation services will be provided by owner to the customer.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'Owner agrees and undertakes to defend, indemnify and hold harmless the GKH and its affiliates, officers and employees from any and all claims, demands, action suits or proceedings, liabilities, losses, costs, expenses (including legal fees) or damages asserted. owner agrees to discharge all tax liabilities arising as a result of accommodation services provided by it to the customer. owner also undertakes to provide to GKH with necessary documents to prove discharge of any tax in case the same is being demanded by any authority from us.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'It has full right, title and interest in and to all trade names, trademarks, service marks, logos, symbols, proprietary marks and other intellectual property marks ("IPR") which it provides to GKH , for use related to the services.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'The owner agrees and undertakes that GKH shall be at liberty to offer discounts to the customers on behalf of the owner to the extent as may be offered on mutually decided by the GKH and owner.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'The owner is bound to accept a customer as a contractual party, and to handle the online reservation in compliance with the information contained on the GKH website at the time the reservation was made, including any supplementary information and/or wishes made known by the customer.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'The Owner shall be update all information of Changes related to the property on website . In different seasons It shall be the Owner\'s responsibility to provide all information regarding the availability of property and facilities, amenities that it is open or closed at a given.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'GKH shall not be responsible for any repairs, replacements and decorating necessary to maintain said property in its present condition and for the operating efficiency of said property. The expense of any of the repairs or maintain shall be bear by the owner of the property.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'No special, punitive or consequential damages shall be recoverable from the GKH. It is further expressly understood and agreed that the we shall not be liable to any third person for the damages or injuries which the said third person may incur directly or indirectly, as a result of any errors or omissions of the owner or in connection with any bookings.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'We shall have the authority to negotiate, prepare and execute all booking and to cancel and modify existing booking as a service provider by notified.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'Owner shall safeguard and keep confidential the information and shall not disclose to any other person or entity.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'GKH shall advertise for marketing of the availability for rent of the property or any part thereof via digitalization instruments and Owner allows marketing from all types of digital and manual instruments.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'GKH may conduct an independent/third party inspection of any property being rented by owner and customers may verify for the accuracy or completeness of details provided by owner.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'As a pre-condition of use of Platform, Warne that, owner shall not use this Platform for any purpose that is unlawful, unauthorized, or inconsistent with these terms, and the owner agrees that this access to use this Platform will terminate immediately if User\'s/owner violate of these stipulation. GKH reserves the right, at its sole discretion, to block/terminate owner access to this Platform and its content at any time, with or without notice.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'GKH reserves the right to amend and update the Terms and Conditions as and when required without any prior communication and which should be also acceptable to the Owner.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'Owner agrees to hold Gleekui hospitality harmless from all damage suits in connection with the management of said property and from liability from injury suffered by any customers or other person whomsoever and to carry, at Owner\'s expense. GKH also shall not be liable for any mistake of fact or law or for anything which we may do or refrain from doing hereunder. If suit is brought to collect GKH compensation or if GKH successfully defends any action brought against GKH by the Owner, relating to said property, or GKH management thereof, Owner agrees to pay all costs incurred by GKH in connection with such action, including reasonable attorney fees.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'If owner breaches this Agreement, GKH reserves the right to recover any amounts due to be paid by to customer, and to take appropriate legal action as it deems necessary.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 10),
                Text(
                  'Dispute resolution:',
                  style: color00000s15w600,
                ),
                const SizedBox(height: 10),
                Text(
                  '1. This terms and conditions shall be construed and enforced in accordance with the laws of India without regard to the choice of law principles thereof.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  '2. The head office of GKH is situated at Surat and the all management from at Surat location. so that, the jurisdiction regarding any complaint/ suit will at surat(Gujarat). the parties shall refer any unresolved disputes to the exclusive jurisdiction of courts in SURAT(GUJARAT).',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  '3. Any controversy or claim arising out of or relating to this agreement, including but not limited to its enforcement, arbitrability or interpretation shall be submitted to final and binding arbitration, to be held in Surat, Gujarat, India, before a single arbitrator.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  '4. The arbitrator shall be selected by mutual agreement of the parties or, if the parties cannot agree, then the arbitrator shall be appointed by the court.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  '5. The arbitration shall be a confidential proceeding, closed to the general public. The arbitrator shall issue a written opinion stating the essential findings and conclusions upon which the arbitrator’s award is based. The parties will share equally in payment of the arbitrator’s fees and arbitration expenses and any other costs unique to the arbitration hearing (recognising that each side bears its own deposition, witness, expert and attorney’s fees, and other expenses to the same extent as if the matter were being heard in court).',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 5),
                Text(
                  'This terms and conditions may amended or modified at any time by Gleekey hospitality. we do not discriminate based on race, colour, creed, religion, sex, national origin, age, handicap or familial status and will comply with all federal, state and local fair housing and civil rights laws and with all equal opportunity requirements. owner can use the website by accepting the terms and condition set by GKH.',
                  style: color00000s14w500,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    CommonCheckBox(_information),
                    Flexible(
                      child: Text(
                        'Details & Pictures provided are all genuine',
                        style: color000000s12w400,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CommonCheckBox(_termsAndCondition),
                    Flexible(
                      child: Text(
                        'I agree to the',
                        style: color000000s12w400,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        ' Terms and Condition',
                        style: color000000s12w400.copyWith(
                            color: AppColors.colorFE6927,
                            decoration: TextDecoration.underline),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget step13() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: Get.height * 0.25),
          child: Image.asset(AppImages.joiningBgImg),
        ),
      ],
    );
  }

  Widget CommonTextFeildPart(
      {String? title,
      required TextEditingController controller,
      Widget? suffix,
      Widget? prefix,
      String? Hinttext,
      bool readOnly = false,
      GestureTapCallback? onTap,
      int? maxLines = 1,
      List<TextInputFormatter>? inputFormatters,
      ValueChanged<String>? onChanged,
      TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? '',
            style: color00000s14w500,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            onTap: onTap,
            style: color00000s14w500,
            maxLines: maxLines,
            cursorColor: AppColors.colorFE6927,
            keyboardType: keyboardType,
            controller: controller,
            readOnly: readOnly,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              suffixIcon: suffix,
              prefixIcon: prefix,
              hintText: Hinttext,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: AppColors.color000000.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: AppColors.color000000.withOpacity(0.5),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: AppColors.color000000.withOpacity(0.5),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

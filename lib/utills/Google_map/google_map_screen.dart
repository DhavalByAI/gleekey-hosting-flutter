import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/src/host/add_property/view/hostScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'google_map_controller.dart';

class GooleMapWidget extends StatefulWidget {
  const GooleMapWidget({Key? key}) : super(key: key);

  @override
  State<GooleMapWidget> createState() => _GooleMapWidgetState();
}

RxList<Marker> markers = <Marker>[].obs;

int id = 1;
LatLng showLocation = const LatLng(21.1702, 72.8311);
GoogleMapController? controller;

class _GooleMapWidgetState extends State<GooleMapWidget> {
  ///map

  @override
  initState() {
    latitude.text = '21.1702';
    longitude.text = '72.8311';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: markers.stream,
        builder: (context, snapshot) {
          return GoogleMap(
            mapType: MapType.terrain,
            markers: markers.map((e) => e).toSet(),
            initialCameraPosition:
                CameraPosition(target: showLocation, zoom: 15),
            onMapCreated: (GoogleMapController con) {
              markers.clear();
              Marker newMarker = Marker(
                  markerId: MarkerId('$id'),
                  position:
                      LatLng(showLocation.latitude, showLocation.longitude),
                  // infoWindow: InfoWindow(title: 'NEW'),
                  icon: BitmapDescriptor.defaultMarker);
              markers.add(newMarker);
              id = id + 1;
              controller = con;

              // setState(() {});
            },
            onTap: (LatLng lat) {
              markers.clear();

              Marker newMarker = Marker(
                  markerId: MarkerId('$id'),
                  position: LatLng(lat.latitude, lat.longitude),
                  // infoWindow: InfoWindow(title: 'Gleekey'),
                  icon: BitmapDescriptor.defaultMarker);
              markers.add(newMarker);
              id = id + 1;
              latitude.text = lat.latitude.toString();
              longitude.text = lat.longitude.toString();
              // loaderShow(context);
              GoogleLocationController.to.getLocation(
                  longitude: longitude.text,
                  latitude: latitude.text,
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

              setState(() {});
            },
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            zoomControlsEnabled: true,
          );
        },
      ),
    );
  }
}

import 'dart:async';
import 'dart:collection';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sac_wallet/client/user_client.dart';

import 'business_details.dart';

class BusinessListMapView extends StatefulWidget {
  BusinessListMapViewState createState() => BusinessListMapViewState();
}

class BusinessListMapViewState extends State<BusinessListMapView> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = new HashSet<Marker>();
  Map markers = {};

  late Position _currentPosition;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(18.516008, 73.9167402),
      //tilt: 59.440717697143555,
      zoom: 14.151926040649414);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(18.516008, 73.9167402), zoom: 12.0),
        onCameraMove: (CameraPosition position) {
          EasyDebounce.debounce(
              'update_markers_from_server',
              // <-- An ID for this particular debouncer
              Duration(milliseconds: 1500), // <-- The debounce duration
              () => _populateNewData(
                  position.target.latitude,
                  position.target.longitude,
                  position.zoom) // <-- The target method
              );
        },
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        myLocationButtonEnabled: true,
        trafficEnabled: true,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  _updatePosition(double lat, double long, double zoom) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          lat,
          long,
        ),
        zoom: zoom)));
    EasyDebounce.debounce(
        'update_markers_from_server', // <-- An ID for this particular debouncer
        Duration(milliseconds: 1500), // <-- The debounce duration
        () => _populateNewData(lat, long, zoom) // <-- The target method
        );
  }

  _populateNewData(double lat, double long, double zoom) {
    UserClient().getBusinessNearMe(lat: lat, long: long).then((res) {
      setState(() {
        res.forEach((element) {
          _markers.add(Marker(
            markerId: MarkerId(element.id),
            position: LatLng(element.location!.coordinates[1],
                element.location!.coordinates[0]),
            infoWindow: InfoWindow(
                title: '${element.name}',
                snippet: '${element.category}',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BusinessDetails(element)));
                }),
          ));
        });
      });
    });
  }

  _getCurrentLocation() async {
    Position position = await _determinePosition();
    //..forceAndroidLocationManager;
    setState(() {
      _currentPosition = position;
      print("Location ${position.longitude}, ${position.latitude}");
    });
    _updatePosition(position.latitude, position.longitude, 12.0);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

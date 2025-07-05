import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rebook_app/Screens/cart/payment-scree.dart';
import 'package:rebook_app/Screens/history/model/historymaodel.dart';
import 'package:rebook_app/location/model/locationmodel.dart';

class Gps extends StatefulWidget {
  HistoryModel historymaodel;
  double totalPrice;

  Gps({required this.historymaodel, required this.totalPrice});

  // static const CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(30.230125, 31.269013),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  State<Gps> createState() => _GpsState();
}

class _GpsState extends State<Gps> {
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  Location location = Location();
  LocationData? locationData;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.033333, 31.233334), // Default to Cairo, Egypt
    zoom: 18.0,
  );

  bool _serviceEnabled = false;

  @override
  void initState() {
    super.initState();
    canAccessLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GPS",style: TextStyle(color: Colors.blue),),
        centerTitle: true,
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.hybrid,
        zoomControlsEnabled: false,
        cameraTargetBounds: CameraTargetBounds(
          LatLngBounds(
            northeast:
                LatLng(31.916667, 35.000000), // Top right corner of Egypt
            southwest:
                LatLng(22.000000, 25.000000), // Bottom left corner of Egypt
          ),
        ),
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('payment'),
        icon: const Icon(Icons.location_on_outlined),
      ),
    );
  }

  Future<void> canAccessLocation() async {
    bool permissionGranted = await isPermissionGranted();
    if (!permissionGranted) return;

    bool serviceEnabled = await isServicesEnabled();
    if (!serviceEnabled) return;

    locationData = await location.getLocation();
    if (locationData != null) {
      _initialPosition = CameraPosition(
        target: LatLng(locationData!.latitude!, locationData!.longitude!),
        zoom: 14.4746,
      );
      print(
          "------------------------------------------- ${locationData!.latitude} ${locationData!.longitude}");
      setState(() {});
      final GoogleMapController controller = await _controller.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
    }
  }

  Future<void> _goToTheLake() async {
    bool permissionGranted = await isPermissionGranted();
    if (!permissionGranted) return;

    bool serviceEnabled = await isServicesEnabled();
    if (!serviceEnabled) return;

    locationData = await location.getLocation();
    if (locationData != null) {
      _initialPosition = CameraPosition(
        target: LatLng(locationData!.latitude!, locationData!.longitude!),
        zoom: 14.4746,
      );
      print(
          "------------------------------------------- ${locationData!.latitude} ${locationData!.longitude}");

      // Creating history model with updated location data
      HistoryModel data = HistoryModel(
        orderType: widget.historymaodel.orderType,
        items: widget.historymaodel.items,
        userId: widget.historymaodel.userId,
        serviceModel: widget.historymaodel.serviceModel,
        locationModel: LocationModel(
            latitude: locationData!.latitude!,
            longitude: locationData!.longitude!),
      );

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              historymaodel: data,
              totalPrice: widget.totalPrice,
            ),
          ));
    }
  }

  Future<bool> isPermissionGranted() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }
    return _permissionGranted == PermissionStatus.granted;
  }


  Future<bool> isServicesEnabled() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
    return _serviceEnabled;
  }
}

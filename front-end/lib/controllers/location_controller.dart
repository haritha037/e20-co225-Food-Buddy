import 'dart:convert';

import 'package:food_buddy_frontend/data/repository/category_repo.dart';
import 'package:food_buddy_frontend/data/repository/location_repo.dart';
import 'package:food_buddy_frontend/data/repository/product_repo.dart';
import 'package:food_buddy_frontend/models/categories.dart';
import 'package:food_buddy_frontend/models/products.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  final LocationRepo locationRepo;

  LocationController({required this.locationRepo});

  List<LatLng> _routePoints = [];
  List<LatLng> get routePoints => _routePoints;

  double? _distance;
  double? get distance => _distance;
  void clearDistance() {
    _distance = null;
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  late Position _myLocation;
  Position get myLocation => _myLocation;

  Map<String, String?> _myLocationAddress = {};
  Map get myLocationAddress => _myLocationAddress;

  double _searchRadius = 5;
  double get searchRadius => _searchRadius;
  void setSearchRadius(double r) {
    _searchRadius = r;
    update();
  }

  // ROUTE POINTS
  Future<void> getRoutePoints({
    required double lon1,
    required double lat1,
    required double lon2,
    required double lat2,
  }) async {
    _isLoading = true;

    Response response = await locationRepo.getRoutePoints(
        lon1: lon1, lat1: lat1, lon2: lon2, lat2: lat2);

    if (response.statusCode == 200) {
      print('got route points');

      _routePoints = [];

      var router = jsonDecode(response.bodyString!)['routes'][0]['geometry']
          ['coordinates'];

      _distance =
          jsonDecode(response.bodyString!)['routes'][0]['distance'] / 1000;
      print('distance : $_distance');
      update();

      for (int i = 0; i < router.length; i++) {
        var reep = router[i].toString();
        reep = reep.replaceAll("[", "");
        reep = reep.replaceAll("]", "");
        var lat1 = reep.split(',');
        var long1 = reep.split(",");
        _routePoints.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
      }

      update();
    } else {
      print(response.statusCode);
      print('Fetching route points failed');
    }
    _isLoading = false;

    print(_routePoints);

    print('*****************isLoading in controller = $isLoading');
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<void> getMyLocation() async {
    _isLoading = true;
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
      _isLoading = false;
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _myLocation = await Geolocator.getCurrentPosition();

    print('***************got my location');

    await getAddressFromLatLng(_myLocation.latitude, _myLocation.longitude);

    _isLoading = false;
    update();
  }

  Future<void> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];

      print(jsonEncode(place));

      _myLocationAddress = {
        'locality': place.locality,
        'subLocality': place.subLocality,
        'subAdministrativeArea': place.subAdministrativeArea
      };

      print(_myLocationAddress);
    } catch (e) {
      print(e);
    }
  }
}

import 'package:food_buddy_frontend/controllers/auth_controller.dart';
import 'package:food_buddy_frontend/controllers/category_controller.dart';
import 'package:food_buddy_frontend/controllers/location_controller.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class Resources {
  static Future<void> loadResources() async {
    try {
      // Run both futures in parallel
      await Future.wait([
        Get.find<CategoryController>().getAllCategories(),
        Get.find<LocationController>().getMyLocation(),
      ]);

      Position myLocation = Get.find<LocationController>().myLocation;
      double radius = Get.find<LocationController>().searchRadius;

      await Future.wait([
        Get.find<ProductController>().getNearbyProducts(radius),
        Get.find<ProductController>().getAllProducts(),
        Get.find<LocationController>()
            .getAddressFromLatLng(myLocation.latitude, myLocation.longitude)
      ]);

      Get.find<AuthController>().getUserToken();
      await Get.find<AuthController>().getSignedInUser();
    } catch (e) {
      // Handle errors if any of the futures throw an exception
      print("An error occurred while loading resources: $e");
    }
  }
}

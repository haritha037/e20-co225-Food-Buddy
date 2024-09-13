import 'dart:ffi';

import 'package:food_buddy_frontend/controllers/auth_controller.dart';
import 'package:food_buddy_frontend/controllers/category_controller.dart';
import 'package:food_buddy_frontend/controllers/file_controller.dart';
import 'package:food_buddy_frontend/controllers/location_controller.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/data/api/api_client.dart';
import 'package:food_buddy_frontend/data/repository/auth_repo.dart';
import 'package:food_buddy_frontend/data/repository/category_repo.dart';
import 'package:food_buddy_frontend/data/repository/file_repo.dart';
import 'package:food_buddy_frontend/data/repository/location_repo.dart';
import 'package:food_buddy_frontend/data/repository/product_repo.dart';
import 'package:food_buddy_frontend/data/repository/shop_repo.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  // create an instance of shared prefernces
  final sharedPreferences = await SharedPreferences.getInstance();
  // load the instance into the app
  Get.lazyPut(
    () => sharedPreferences,
  );
  //
  // API CLIENT
  Get.lazyPut(
    () => ApiClient(appBaseUrl: AppConstants.BASE_URL),
  );

  // REPOS
  Get.lazyPut(
    () => ProductRepo(apiClient: Get.find()),
  );
  Get.lazyPut(
    () => CategoryRepo(apiClient: Get.find()),
  );
  Get.lazyPut(
    () => ShopRepo(apiClient: Get.find()),
  );
  Get.lazyPut(
    () => LocationRepo(apiClient: Get.find()),
  );
  Get.lazyPut(
    () => AuthRepo(
      apiClient: Get.find(),
      sharedPreferences: Get.find(),
    ),
  );
  Get.lazyPut(
    () => FileRepo(
      apiClient: Get.find(),
    ),
  );

  // CONTROLLERS
  Get.lazyPut(
    () => ProductController(
      productRepo: Get.find(),
      fileController: Get.find(),
    ),
  );
  Get.lazyPut(
    () => CategoryController(
      categoryRepo: Get.find(),
    ),
  );
  Get.lazyPut(
    () => ShopController(
      shopRepo: Get.find(),
      fileController: Get.find(),
    ),
  );
  Get.lazyPut(
    () => LocationController(
      locationRepo: Get.find(),
    ),
  );
  Get.lazyPut(
    () => AuthController(
      authRepo: Get.find(),
    ),
  );
  Get.lazyPut(
    () => FileController(
      fileRepo: Get.find(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/controllers/auth_controller.dart';
import 'package:food_buddy_frontend/controllers/category_controller.dart';
import 'package:food_buddy_frontend/controllers/file_controller.dart';
import 'package:food_buddy_frontend/controllers/location_controller.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/pages/home_page.dart';
import 'package:food_buddy_frontend/pages/product_details_page.dart';
import 'package:food_buddy_frontend/routes/route_helper.dart';
import 'package:get/get.dart';
import 'helper/dependencies.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // GET ALL PRODUCTS
    Get.find<ProductController>();
    Get.find<CategoryController>();
    Get.find<ShopController>();
    Get.find<LocationController>();
    Get.find<AuthController>();
    Get.find<FileController>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // home: ProductDetailsPage(),
      //home: HomePage(),
      initialRoute: RouteHelper.getSplashScreen(),
      getPages: RouteHelper.routes,
    );
  }
}

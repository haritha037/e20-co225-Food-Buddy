import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/controllers/auth_controller.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/models/shop.dart';
import 'package:food_buddy_frontend/models/user.dart';
import 'package:food_buddy_frontend/pages/auth/sign_in_page.dart';
import 'package:food_buddy_frontend/pages/my%20shop%20page/my_shop_details.dart';
import 'package:food_buddy_frontend/pages/shop%20page/shop_details_page.dart';
import 'package:food_buddy_frontend/pages/shop%20page/shop_sign_up_page.dart';
import 'package:food_buddy_frontend/pages/shop%20page/sign_in_prompt.dart';
import 'package:food_buddy_frontend/widgets/loading_indicator.dart';
import 'package:get/get.dart';

class ShopOnNav extends StatelessWidget {
  const ShopOnNav({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        User user = authController.user;
        if (!user.isSignedIn) {
          return SignInPage();
        } else if (!user.hasShop) {
          return ShopSignUpPage();
        } else {
          print('******************shop on nav');
          Get.find<ShopController>().getMyShop();
          return GetBuilder<ShopController>(
            builder: (shopController) {
              if (shopController.isLoading) {
                return LoadingIndicator();
              } else {
                Shop shop = shopController.shopOnShopDetails;
                Get.find<ProductController>().getProductsByShop(shop.shopId);
                return GetBuilder<ProductController>(
                  builder: (productController) {
                    return productController.isLoading
                        ? LoadingIndicator()
                        : MyShopDetails();
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}

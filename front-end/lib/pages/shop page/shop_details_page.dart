import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/controllers/location_controller.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/pages/shop%20page/shop_info.dart';
import 'package:food_buddy_frontend/pages/shop%20page/shop_products.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/widgets/loading_indicator.dart';
import 'package:get/get.dart';

class ShopDetailsPage extends StatelessWidget {
  const ShopDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<LocationController>().clearDistance();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: AppColors.iconColorPurple,
          bottom: const TabBar(
              indicatorColor: AppColors.mainColor,
              indicatorSize: TabBarIndicatorSize.label,
              // isScrollable: true,
              tabs: [
                Tab(
                  icon: Icon(Icons.fastfood_outlined),
                  text: 'Products',
                ),
                Tab(
                  icon: Icon(Icons.info_outlined),
                  text: 'Shop Info',
                ),
              ]),
        ),
        body: GetBuilder<ShopController>(
          builder: (shopController) {
            return GetBuilder<ProductController>(
              builder: (productController) {
                return GetBuilder<LocationController>(
                  builder: (locationController) {
                    if (shopController.isLoading ||
                        productController.isLoading ||
                        locationController.isLoading) {
                      //print('still in shop details');
                      return const LoadingIndicator();
                    }

                    return const TabBarView(
                      children: [
                        ShopProducts(),
                        ShopInfo(),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

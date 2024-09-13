import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/models/shop.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/app_bar_widget.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/loading_indicator.dart';
import 'package:food_buddy_frontend/widgets/shop_card.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';
import 'package:get/get.dart';

class ShopsPage extends StatelessWidget {
  const ShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Shop> allShops = Get.find<ShopController>().allShopsList;
    print('allShops length : ${allShops.length}');

    return Scaffold(
      appBar: const AppBarWidget(title: "Shops"),
      body: GetBuilder<ShopController>(
        builder: (shopController) {
          List<Shop> allShops = shopController.allShopsList;
          //
          // CONTENT WINDOW
          return shopController.isLoading
              ? const LoadingIndicator()
              : Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20 * Dimentions.hUnit),
                  // color: Colors.black38,
                  child: ListView(
                    children: List.generate(
                      allShops.length,
                      (index) {
                        //
                        // SHOP ITEM
                        return ShopCard(shop: allShops[index]);
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }
}

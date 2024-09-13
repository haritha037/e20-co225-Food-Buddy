import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/models/products.dart';
import 'package:food_buddy_frontend/models/shop.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/loading_indicator.dart';
import 'package:food_buddy_frontend/widgets/not_found.dart';
import 'package:food_buddy_frontend/widgets/product%20card/product_card.dart';
import 'package:get/get.dart';

class ShopProducts extends StatelessWidget {
  const ShopProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopController>(
      builder: (shopController) {
        var shop = Get.find<ShopController>().shopOnShopDetails;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10 * Dimentions.hUnit),
          child: GetBuilder<ProductController>(
            builder: (productController) {
              List<Product> productsByShop = productController.productsByShop;

              Widget content = productsByShop.isEmpty
                  ? const NotFound(message: 'No products')
                  : ListView.builder(
                      itemCount: productsByShop.length,
                      itemBuilder: (context, index) => ProductCard(
                        product: productsByShop[index],
                      ),
                    );

              return productController.isLoading
                  ? const LoadingIndicator()
                  : content;
            },
          ),
        );
      },
    );
  }
}

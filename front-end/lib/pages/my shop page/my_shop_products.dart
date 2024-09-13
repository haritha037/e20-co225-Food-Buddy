import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/models/products.dart';
import 'package:food_buddy_frontend/models/shop.dart';
import 'package:food_buddy_frontend/pages/my%20shop%20page/add_product_page.dart';
import 'package:food_buddy_frontend/pages/my%20shop%20page/update_product_page.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/loading_indicator.dart';
import 'package:food_buddy_frontend/widgets/not_found.dart';
import 'package:food_buddy_frontend/widgets/product%20card/my_product_card.dart';
import 'package:food_buddy_frontend/widgets/product%20card/product_card.dart';
import 'package:get/get.dart';

class MyShopProducts extends StatelessWidget {
  const MyShopProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ShopController>(
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
                        itemBuilder: (context, index) => FocusedMenuHolder(
                          //animateMenuItems: true,
                          menuWidth: Dimentions.screenWidth / 2,
                          blurSize: 3,
                          blurBackgroundColor: Colors.black,
                          onPressed: () {},
                          menuItems: [
                            //
                            // EDIT BUTTON
                            FocusedMenuItem(
                              trailingIcon: Icon(Icons.edit),
                              title: BigText(
                                text: 'Edit',
                                color: Colors.black87,
                                size: 16 * Dimentions.hUnit,
                              ),
                              onPressed: () {
                                _editProduct(productsByShop[index]);
                              },
                            ),
                            //
                            // DELETE BUTTON
                            FocusedMenuItem(
                                trailingIcon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.redAccent,
                                title: BigText(
                                  text: 'Delete',
                                  color: Colors.white,
                                  size: 16 * Dimentions.hUnit,
                                ),
                                onPressed: () {
                                  productController
                                      .deleteProduct(productsByShop[index]);
                                }),
                          ],
                          //
                          // PRODUCT CARD
                          child: MyProductCard(
                            product: productsByShop[index],
                          ),
                        ),
                      );

                return productController.isLoading
                    ? const LoadingIndicator()
                    : content;
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddProductPage());
        },
        backgroundColor: AppColors.mainColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  void _editProduct(Product product) {
    Get.to(() => UpdateProductPage(product: product));
  }
}

import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/controllers/location_controller.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/models/shop.dart';
import 'package:food_buddy_frontend/routes/route_helper.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';
import 'package:get/get.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;
  const ShopCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        int shopId = shop.shopId;
        // download the shop details
        Get.find<ShopController>().getShopById(shopId);
        Get.find<ProductController>().getProductsByShop(shopId);
        Get.toNamed(
          RouteHelper.getShopDetails(),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10 * Dimentions.hUnit),
        padding: EdgeInsets.only(bottom: 10 * Dimentions.hUnit),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20 * Dimentions.hUnit),
          // color: Colors.black38,
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            // SHOP IMAGE
            Container(
              width: double.maxFinite,
              height: 200 * Dimentions.hUnit,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20 * Dimentions.hUnit),
                  topRight: Radius.circular(20 * Dimentions.hUnit),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    AppConstants.BASE_URL +
                        AppConstants.SHOP_IMAGE_URI +
                        shop.image,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            //
            // SHOP DETAILS
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10 * Dimentions.hUnit,
                vertical: 10 * Dimentions.hUnit,
              ),
              decoration: BoxDecoration(
                border: const Border(
                  left: BorderSide(
                    color: Color.fromARGB(255, 230, 230, 230),
                    width: 1,
                  ),
                  right: BorderSide(
                    color: Color.fromARGB(255, 230, 230, 230),
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 230, 230, 230),
                    width: 1,
                  ),
                  // No top border specified
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20 * Dimentions.hUnit),
                  bottomRight: Radius.circular(20 * Dimentions.hUnit),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      // SHOP TITLE
                      BigText(text: shop.shopName),
                      //
                      // SHOP LOCATION(last 2 lines of the address)
                      SmallText(
                        text:
                            '${shop.address.addressLine2}, ${shop.address.addressLine3}',
                      )
                    ],
                  ),
                  const Icon(Icons.favorite_outline),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

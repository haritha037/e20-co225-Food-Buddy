import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/models/shop.dart';
import 'package:food_buddy_frontend/routes/route_helper.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';
import 'package:get/get.dart';

class ShopOnMap extends StatefulWidget {
  final Shop shop;
  const ShopOnMap({super.key, required this.shop});

  @override
  State<ShopOnMap> createState() => _ShopOnMapState();
}

class _ShopOnMapState extends State<ShopOnMap> {
  bool detailsBoxVisibility = false;

  void toggleDetailsBox() {
    setState(() {
      detailsBoxVisibility = !detailsBoxVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    Shop shop = widget.shop;
    return Container(
      // color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //
          // DETAILS BOX
          if (detailsBoxVisibility == true)
            GestureDetector(
              onTap: () {
                // download the shop details
                Get.find<ShopController>().getShopById(shop.shopId);
                Get.find<ProductController>().getProductsByShop(shop.shopId);
                Get.toNamed(
                  RouteHelper.getShopDetails(),
                );
              },
              child: Container(
                width: 200 * Dimentions.hUnit,
                height: 150 * Dimentions.hUnit,
                padding: EdgeInsets.all(10 * Dimentions.hUnit),
                decoration: BoxDecoration(
                  // color: Colors.white,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF87f4b5),
                      Color(0xFF93cbf1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20 * Dimentions.hUnit),
                ),
                child: Column(
                  children: [
                    Text(
                      shop.shopName,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.darkTextColor),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(20 * Dimentions.hUnit),
                          color: AppColors.iconColorGreenLight,
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
                    )
                  ],
                ),
              ),
            ),

          //
          // ICON
          GestureDetector(
            onTap: toggleDetailsBox,
            child: Icon(
              Icons.location_on_sharp,
              color: AppColors.redColor,
              size: 50 * Dimentions.hUnit,
            ),
          ),
        ],
      ),
    );
  }
}

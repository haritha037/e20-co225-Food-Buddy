import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/models/products.dart';
import 'package:food_buddy_frontend/routes/route_helper.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/discount_details.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        int productId = product.productId;
        // download the product
        Get.find<ProductController>().getProductById(productId);
        Get.toNamed(
          RouteHelper.getProductDetails(),
        );
      },
      child: Container(
        //height: 200 * Dimentions.hUnit,
        margin: EdgeInsets.symmetric(vertical: 10 * Dimentions.hUnit),
        decoration: BoxDecoration(
          //color: Colors.white.withOpacity(0.8),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFf5cbd9),
              Color(0xFFf4bccd),
              Color(0xFFcacff9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Shadow color with opacity
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          borderRadius: BorderRadius.circular(30 * Dimentions.hUnit),
        ),
        child: Container(
          padding: EdgeInsets.all(12 * Dimentions.hUnit),
          child: Row(
            children: [
              //
              // MEAL DETAILS
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    // SHOP ICON AND NAME
                    Row(
                      children: [
                        Icon(
                          Icons.storefront_sharp,
                          size: 24 * Dimentions.hUnit,
                          color: AppColors.mainColorShade,
                        ),
                        SizedBox(width: 5 * Dimentions.hUnit),
                        BigText(
                          text: product.shopName,
                          color: AppColors.mainColorShade,
                          fontWeight: FontWeight.w400,
                          size: 16 * Dimentions.hUnit,
                        )
                      ],
                    ),
                    //
                    // PRODUCT NAME
                    BigText(
                      text: product.productName.toUpperCase(),
                      size: 16 * Dimentions.hUnit,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 20 * Dimentions.hUnit),
                    //
                    // DISCOUNT DETAILS
                    DiscountDetails(
                      originalPrice: product.originalPrice,
                      discountedPrice: product.discountedPrice,
                      discountPercentage: product.discountPercentage,
                    ),
                  ],
                ),
              ),

              //
              // MEAL IMAGE
              Container(
                width: 150 * Dimentions.hUnit,
                height: 150 * Dimentions.hUnit,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 117, 86, 120),
                  borderRadius: BorderRadius.circular(
                    30 * Dimentions.hUnit,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      AppConstants.BASE_URL +
                          AppConstants.PRODUCT_IMAGE_URI +
                          product.image,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

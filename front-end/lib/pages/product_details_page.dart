import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/models/products.dart';
import 'package:food_buddy_frontend/routes/route_helper.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/discount_details.dart';
import 'package:food_buddy_frontend/widgets/expandable_text.dart';
import 'package:food_buddy_frontend/widgets/icon_and_text_widget.dart';
import 'package:food_buddy_frontend/widgets/loading_indicator.dart';
import 'package:food_buddy_frontend/widgets/phone_number.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  String changeDateTimeFormat(String inputDateTimeString) {
    // input format
    DateFormat inputDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");

    // DateTime object for the inputted string
    DateTime dateTime = inputDateFormat.parse(inputDateTimeString);

    // Required format
    DateFormat requiredDateFormat = DateFormat("yyyy-MM-dd hh:mm a");

    // output string
    return requiredDateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.mainColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_sharp),
        ),
        // actions: [
        //   Container(
        //     margin: EdgeInsets.only(right: 5 * Dimentions.hUnit),
        //     child: const Icon(Icons.shopping_cart_outlined),
        //   ),
        // ],
      ),
      body: GetBuilder<ProductController>(
        builder: (productController) {
          print('*********************inside builder');

          if (productController.isLoading) {
            return const LoadingIndicator();
          }
          var product = productController.productOnProductDetails;
          print('**********************************product - $product');
          return Stack(
            children: [
              //
              // IMAGE
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  height: 250 * Dimentions.hUnit,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    image: DecorationImage(
                      image: NetworkImage(
                        AppConstants.BASE_URL +
                            AppConstants.PRODUCT_IMAGE_URI +
                            product.image,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              //
              // DETAILS BOX
              Positioned(
                top: (250 - 25) * Dimentions.hUnit,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  //color: Colors.black26,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20 * Dimentions.hUnit,
                    vertical: 15 * Dimentions.hUnit,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30 * Dimentions.hUnit),
                      topLeft: Radius.circular(30 * Dimentions.hUnit),
                    ),
                    color: Colors.white,
                    // gradient: const LinearGradient(
                    //   colors: [
                    //     Color(0xFFf6cfbe),
                    //     Color(0xFFb9dcf2),
                    //   ],
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      // PRODUCT TITLE
                      BigText(
                        text: product.productName.toUpperCase(),
                        fontWeight: FontWeight.w700,
                        // size: 23 * Dimentions.hUnit,
                      ),
                      SizedBox(height: 15 * Dimentions.hUnit),
                      //
                      // DISCOUNT DETAILS
                      DiscountDetails(
                        originalPrice: product.originalPrice,
                        discountedPrice: product.discountedPrice,
                        discountPercentage: product.discountPercentage,
                      ),
                      SizedBox(height: 15 * Dimentions.hUnit),
                      //
                      // VALID UNTIL
                      IconAndTextWidget(
                        icon: Icons.access_time,
                        text:
                            'valid until: ${changeDateTimeFormat(product.validUntil)}',
                        backgroundColor: AppColors.iconColorPurpleLight,
                        iconColor: AppColors.iconColorPurple,
                        iconSize: 32 * Dimentions.hUnit,
                        textSize: 15 * Dimentions.hUnit,
                        textColor: AppColors.lightGreyColor,
                      ),
                      SizedBox(height: 10 * Dimentions.hUnit),
                      //
                      // PHONE NUMBER
                      Row(
                        //mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 185 * Dimentions.hUnit,
                            child: IconAndTextWidget(
                              icon: Icons.phone,
                              text: 'Reserve your order',
                              backgroundColor: AppColors.iconColorYellowLight,
                              iconColor: AppColors.iconColorYellow,
                              iconSize: 32 * Dimentions.hUnit,
                              textSize: 15 * Dimentions.hUnit,
                              textColor: AppColors.lightGreyColor,
                            ),
                          ),
                          SizedBox(width: 10 * Dimentions.hUnit),
                          PhoneNumber(
                              phoneNumber: product.shopPhoneNumber,
                              size: 15 * Dimentions.hUnit),
                        ],
                      ),
                      SizedBox(height: 10 * Dimentions.hUnit),
                      //
                      // SHOP
                      Row(
                        children: [
                          Container(
                            width: 205 * Dimentions.hUnit,
                            child: IconAndTextWidget(
                              icon: Icons.storefront_outlined,
                              text: 'See more offers from',
                              backgroundColor: AppColors.iconColorGreenLight,
                              iconColor: AppColors.iconColorGreen,
                              iconSize: 32 * Dimentions.hUnit,
                              textSize: 15 * Dimentions.hUnit,
                              textColor: AppColors.lightGreyColor,
                            ),
                          ),
                          SizedBox(width: 10 * Dimentions.hUnit),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                int shopId = product.shopId;
                                // download the shop details
                                Get.find<ShopController>().getShopById(shopId);
                                Get.find<ProductController>()
                                    .getProductsByShop(shopId);

                                Get.toNamed(
                                  RouteHelper.getShopDetails(),
                                );
                              },
                              child: BigText(
                                text: product.shopName,
                                size: 15 * Dimentions.hUnit,
                                color: AppColors.pinkColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //
                      // HORIZONTAL LINE
                      Divider(
                        color: AppColors.lightGreyColor,
                        height: 20 *
                            Dimentions
                                .hUnit, // The space between the divider and the content above and below it
                        thickness: 0.5,
                      ),
                      //
                      // DESCRIPTION
                      Expanded(
                        child: SingleChildScrollView(
                          child: ExpandableText(text: product.description),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ), //
      // BOTTOM ACTION (CART RELATED)
      // bottomNavigationBar: Container(
      //   height: 100 * Dimentions.hUnit,
      //   padding: EdgeInsets.symmetric(horizontal: 10 * Dimentions.hUnit),
      //   decoration: BoxDecoration(
      //     color: AppColors.mainColorLight,
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(30 * Dimentions.hUnit),
      //       topRight: Radius.circular(30 * Dimentions.hUnit),
      //     ),
      //   ),
      //   child: Row(
      //     children: [
      //       //
      //       // ADD-REMOVE BUTTON
      //       Container(
      //         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.circular(20 * Dimentions.hUnit),
      //         ),
      //         child: Row(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Icon(
      //               Icons.remove,
      //               color: AppColors.lightGreyColor,
      //             ),
      //             SizedBox(width: 8 * Dimentions.wUnit),
      //             BigText(text: '0'),
      //             SizedBox(width: 8 * Dimentions.wUnit),
      //             Icon(
      //               Icons.add,
      //               color: AppColors.lightGreyColor,
      //             ),
      //           ],
      //         ),
      //       ),
      //       Spacer(),
      //       //
      //       // ADD TO CART BUTTON
      //       Container(
      //         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      //         decoration: BoxDecoration(
      //           color: AppColors.mainColor,
      //           borderRadius: BorderRadius.circular(20 * Dimentions.hUnit),
      //         ),
      //         child: BigText(
      //           text: 'Add to cart',
      //           color: Colors.white,
      //           fontWeight: FontWeight.w500,
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}

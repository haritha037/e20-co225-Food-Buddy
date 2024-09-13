import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';

class DiscountDetails extends StatelessWidget {
  final double originalPrice;
  final double discountedPrice;
  final int discountPercentage;

  const DiscountDetails(
      {super.key,
      required this.originalPrice,
      required this.discountedPrice,
      required this.discountPercentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        //
        // PRICE
        BigText(text: 'LKR ${discountedPrice.ceil()}'),
        //
        // DISCOUNT
        Row(
          children: [
            //
            // ORIGINAL PRICE
            Text(
              'LKR ${originalPrice.ceil()}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                decorationColor: AppColors.mainColorDarkGrey,
                color: AppColors.mainColorDarkGrey,
                fontSize: 16 * Dimentions.hUnit,
              ),
            ),
            SizedBox(width: 10 * Dimentions.hUnit),
            //
            // DISCOUNT PERCENTAGE
            Container(
              // width: 120 * Dimentions.hUnit,
              // height: 30 * Dimentions.hUnit,
              padding: EdgeInsets.symmetric(
                horizontal: 15 * Dimentions.hUnit,
                vertical: 5 * Dimentions.hUnit,
              ),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(30 * Dimentions.hUnit),
              ),
              child: Center(
                child: BigText(
                  text: '$discountPercentage% off',
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

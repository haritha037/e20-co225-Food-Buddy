import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';

class CategoryImageAndText extends StatelessWidget {
  final String image;
  final String categoryName;
  const CategoryImageAndText(
      {super.key, required this.image, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110 * Dimentions.hUnit,
      margin: EdgeInsets.symmetric(horizontal: 5 * Dimentions.wUnit),
      //padding: EdgeInsets.all(4 * Dimentions.hUnit),
      // color: Colors.amber,
      child: Column(
        children: [
          //
          // CATEGORY IMAGE
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                image: NetworkImage(AppConstants.BASE_URL +
                    AppConstants.CATEGORY_IMAGE_URI +
                    image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 4 * Dimentions.hUnit),
          //
          // CATEGORY NAME
          Expanded(
            child: BigText(
              text: categoryName,
              size: 15 * Dimentions.hUnit,
            ),
          ),
        ],
      ),
    );
  }
}

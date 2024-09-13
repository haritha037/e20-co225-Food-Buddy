import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';

class SearchOptionButton extends StatelessWidget {
  final String text;

  const SearchOptionButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100 * Dimentions.hUnit,
      padding: EdgeInsets.symmetric(
        horizontal: 10 * Dimentions.hUnit,
        vertical: 5 * Dimentions.hUnit,
      ),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20 * Dimentions.hUnit),
      ),
      child: Center(
        child: SmallText(
          text: text,
          color: AppColors.darkGreyColor,
          size: 12 * Dimentions.hUnit,
        ),
      ),
    );
  }
}

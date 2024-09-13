import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';

class BigText extends StatelessWidget {
  Color color;
  final String text;
  double size;
  TextOverflow overflow;
  FontWeight? fontWeight;

  BigText(
      {super.key,
      this.color = AppColors.darkTextColor,
      required this.text,
      this.overflow = TextOverflow.ellipsis,
      this.size = 0,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: 1,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: 'Roboto',
        fontSize: size == 0 ? 20 * Dimentions.hUnit : size,
      ),
    );
  }
}

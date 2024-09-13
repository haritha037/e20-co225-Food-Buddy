import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';

class SmallText extends StatelessWidget {
  Color color;
  final String text;
  double size;
  double height;

  SmallText({
    super.key,
    this.color = AppColors.lightGreyColor,
    required this.text,
    this.size = 0,
    this.height = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        // overflow: TextOverflow.ellipsis,
        color: color,
        fontFamily: 'Roboto',
        fontSize: size == 0 ? 12 * Dimentions.hUnit : size,
        height: height,
      ),
    );
  }
}

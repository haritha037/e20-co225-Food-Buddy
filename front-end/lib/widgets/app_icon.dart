import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double iconSize;

  const AppIcon({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(iconSize / 2.0),
        color: backgroundColor,
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize * 3 / 4.0,
          color: iconColor,
        ),
      ),
    );
  }
}

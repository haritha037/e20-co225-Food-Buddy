import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/app_icon.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';

class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double iconSize;
  final double textSize;
  final Color textColor;
  double? gap;
  final String text;

  IconAndTextWidget(
      {super.key,
      required this.icon,
      required this.text,
      required this.backgroundColor,
      required this.iconColor,
      required this.iconSize,
      required this.textSize,
      required this.textColor,
      this.gap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ICON
        AppIcon(
            icon: icon,
            backgroundColor: backgroundColor,
            iconColor: iconColor,
            iconSize: iconSize),

        SizedBox(width: gap ?? 10 * Dimentions.hUnit),
        // TEXT
        Expanded(
          child: BigText(
            text: text,
            size: textSize,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

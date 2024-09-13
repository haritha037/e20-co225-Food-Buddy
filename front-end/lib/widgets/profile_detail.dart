import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/icon_and_text_widget.dart';

class ProfileDetail extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const ProfileDetail(
      {super.key,
      required this.text,
      required this.icon,
      required this.backgroundColor,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30 * Dimentions.hUnit),
      height: 100 * Dimentions.hUnit,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 2 * Dimentions.hUnit),
            color: Colors.grey.withOpacity(0.1),
          ),
        ],
      ),
      child: IconAndTextWidget(
        icon: icon,
        text: text,
        backgroundColor: backgroundColor,
        iconColor: iconColor,
        iconSize: 50 * Dimentions.hUnit,
        textSize: 20 * Dimentions.hUnit,
        textColor: AppColors.darkGreyColor,
        gap: 20 * Dimentions.hUnit,
      ),
    );
  }
}

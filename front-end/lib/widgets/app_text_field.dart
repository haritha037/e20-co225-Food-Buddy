import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';

class AppTextField extends StatelessWidget {
  final Color iconColor;
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final bool isObscure;
  final TextInputType textInputType;
  final FocusNode? focusNode;
  final String? label;

  const AppTextField(
      {super.key,
      required this.controller,
      required this.iconColor,
      required this.hintText,
      this.isObscure = false,
      this.textInputType = TextInputType.text,
      this.focusNode,
      this.label,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 20 * Dimentions.hUnit),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * Dimentions.hUnit),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              // spreadRadius: 5,
              offset: const Offset(0, 5))
        ],
      ),
      child: TextField(
        focusNode: focusNode,
        obscureText: isObscure,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.lightGreyColor,
          ),

          hintStyle: TextStyle(
            color: AppColors.lightGreyColor,
            fontWeight: FontWeight.w400,
            fontSize: 15 * Dimentions.hUnit,
          ),

          //
          // ICON
          prefixIcon: Icon(
            icon,
            color: iconColor,
          ),
          //
          // FOCUSED BORDER
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10 * Dimentions.hUnit),
            borderSide: const BorderSide(
              width: 1.0,
              color: AppColors.mainColor,
            ),
          ),
          //
          // ENABLED BORDER
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10 * Dimentions.hUnit),
            borderSide: const BorderSide(
              width: 1.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

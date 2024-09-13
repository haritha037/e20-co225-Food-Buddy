import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String message,
    {bool isError = true, String title = 'Error'}) {
  Get.closeAllSnackbars();
  Get.snackbar(
    title,
    message,
    titleText: BigText(
      text: title,
      color: isError ? Colors.white : AppColors.darkTextColor,
    ),
    colorText: isError ? Colors.white : AppColors.darkTextColor,
    backgroundColor: isError ? Colors.redAccent : Colors.red.shade100,
  );
}

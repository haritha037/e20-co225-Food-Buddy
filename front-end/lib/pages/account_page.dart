import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/controllers/auth_controller.dart';
import 'package:food_buddy_frontend/models/user.dart';
import 'package:food_buddy_frontend/pages/auth/sign_in_page.dart';
import 'package:food_buddy_frontend/routes/route_helper.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/app_icon.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/icon_and_text_widget.dart';
import 'package:food_buddy_frontend/widgets/profile_detail.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        User user = authController.user;
        return !user.isSignedIn
            ? SignInPage()
            : Scaffold(
                appBar: AppBar(
                  title: Center(
                    child: BigText(
                      text: 'Profile',
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: AppColors.mainColor,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20 * Dimentions.hUnit),
                      //
                      // PROFILE ICON
                      Center(
                        child: AppIcon(
                            icon: Icons.person,
                            backgroundColor: AppColors.mainColor,
                            iconColor: Colors.white,
                            iconSize: 200 * Dimentions.hUnit),
                      ),
                      SizedBox(height: 20 * Dimentions.hUnit),
                      //
                      // USERNAME
                      ProfileDetail(
                        text: user.username!,
                        icon: Icons.person,
                        backgroundColor: AppColors.mainColor,
                        iconColor: Colors.white,
                      ),
                      SizedBox(height: 20 * Dimentions.hUnit),
                      //
                      // EMAIL
                      ProfileDetail(
                        text: user.email!,
                        icon: Icons.email_sharp,
                        backgroundColor: AppColors.iconColorPurple,
                        iconColor: Colors.white,
                      ),
                      SizedBox(height: 20 * Dimentions.hUnit),
                      //
                      // SIGN OUT BUTTON
                      ElevatedButton(
                        onPressed: () {
                          if (user.isSignedIn) {
                            authController.signOut();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightBlueColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 40 * Dimentions.hUnit,
                              vertical: 8 * Dimentions.hUnit,
                            ),
                            shadowColor: Colors.white),
                        child: BigText(
                          text: 'Sign out',
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          size: 20 * Dimentions.hUnit,
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}

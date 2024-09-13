import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/controllers/auth_controller.dart';
import 'package:food_buddy_frontend/models/api_response.dart';
import 'package:food_buddy_frontend/models/sign_in_body.dart';
import 'package:food_buddy_frontend/pages/auth/sign_up_page.dart';
import 'package:food_buddy_frontend/pages/nav_page.dart';
import 'package:food_buddy_frontend/routes/route_helper.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/app_text_field.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/custom_snackbar.dart';
import 'package:food_buddy_frontend/widgets/loading_indicator.dart';
import 'package:food_buddy_frontend/widgets/oath2_icon.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';
import 'package:get/get.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // VALIDATE INPUT
  bool _validateInputs(String username, String password) {
    if (username.isEmpty) {
      showCustomSnackBar('Type in your username',
          title: 'Username', isError: false);
      return false;
    } else if (password.isEmpty) {
      showCustomSnackBar('Type in your password',
          title: 'Password', isError: false);
      return false;
    } else {
      return true;
    }
  }

  // SIGN IN USER
  Future<void> _signIn() async {
    // hide the keyboard
    FocusScope.of(context).unfocus();

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    print('$username $password');

    // validate input
    if (_validateInputs(username, password)) {
      SignInBody signInBody = SignInBody(
        username: username,
        password: password,
      );
      ApiResponse apiResponse =
          await Get.find<AuthController>().signIn(signInBody);

      if (apiResponse.status == true) {
        showCustomSnackBar(apiResponse.message,
            isError: false, title: 'Success');
        Get.offNamed(RouteHelper.getInitial());
      } else {
        showCustomSnackBar(apiResponse.message, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20 * Dimentions.hUnit),
        child: GetBuilder<AuthController>(
          builder: (authController) {
            return authController.isLoading
                ? LoadingIndicator()
                : SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 60 * Dimentions.hUnit),
                        //
                        // APP LOGO
                        Center(
                          child: CircleAvatar(
                            backgroundImage: const AssetImage(
                                'assets/images/logo part 1.png'),
                            radius: 100 * Dimentions.hUnit,
                          ),
                        ),
                        SizedBox(height: 30 * Dimentions.hUnit),
                        //
                        // USERNAME
                        AppTextField(
                          controller: _usernameController,
                          iconColor: AppColors.mainColor,
                          hintText: 'Username',
                          icon: Icons.person,
                        ),
                        SizedBox(height: 20 * Dimentions.hUnit),
                        //
                        // PASSWORD
                        AppTextField(
                          isObscure: true,
                          controller: _passwordController,
                          iconColor: AppColors.mainColor,
                          hintText: 'Password',
                          icon: Icons.password_sharp,
                        ),
                        SizedBox(height: 40 * Dimentions.hUnit),
                        //
                        // SIGN IN BUTTON
                        ElevatedButton(
                          onPressed: () {
                            _signIn();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: 40 * Dimentions.hUnit,
                                vertical: 8 * Dimentions.hUnit,
                              ),
                              shadowColor: Colors.white),
                          child: BigText(
                            text: 'Sign in',
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            size: 25 * Dimentions.hUnit,
                          ),
                        ),
                        SizedBox(height: 50 * Dimentions.hUnit),
                        //
                        // DON'T HAVE AN ACCOUNT? -> CREATE ONE
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BigText(
                              text: 'Dont\'t have an account?',
                              color: AppColors.lightGreyColor,
                              size: 18 * Dimentions.hUnit,
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(() => SignUpPage());
                              },
                              child: BigText(
                                text: 'Create',
                                color: AppColors.darkGreyColor,
                                fontWeight: FontWeight.w500,
                                size: 18 * Dimentions.hUnit,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
          },
        ),
      )),
    );
  }
}

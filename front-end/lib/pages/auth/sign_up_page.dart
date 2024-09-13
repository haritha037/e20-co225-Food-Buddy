import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/controllers/auth_controller.dart';
import 'package:food_buddy_frontend/models/api_response.dart';
import 'package:food_buddy_frontend/models/sign_up_body.dart';
import 'package:food_buddy_frontend/pages/auth/sign_in_page.dart';
import 'package:food_buddy_frontend/pages/home_page.dart';
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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // VALIDATE INPUT
  bool _validateInputs(String email, String username, String password) {
    if (email.isEmpty) {
      showCustomSnackBar('Type in your email', title: 'Email', isError: false);
      return false;
    } else if (username.isEmpty) {
      showCustomSnackBar('Type in your username',
          title: 'Username', isError: false);
      return false;
    } else if (password.isEmpty) {
      showCustomSnackBar('Type in your password',
          title: 'Password', isError: false);
      return false;
    } else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('Invalid Email');
      return false;
    } else if (username.length < 3 || username.length > 20) {
      showCustomSnackBar('Username must be at least 3 characters.');
      return false;
    } else if (password.length < 6 || password.length > 20) {
      showCustomSnackBar('Password must be at least 6 characters.');
      return false;
    } else {
      return true;
    }
  }

  // REGISTER USER
  Future<void> _registration() async {
    // hide the keyboard
    FocusScope.of(context).unfocus();

    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    print('$email $username $password');

    // validate input
    if (_validateInputs(email, username, password)) {
      SignUpBody signUpBody = SignUpBody(
        email: email,
        username: username,
        password: password,
      );
      ApiResponse apiResponse =
          await Get.find<AuthController>().signUp(signUpBody);

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
    return Scaffold(
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
                          backgroundImage:
                              const AssetImage('assets/images/logo part 1.png'),
                          radius: 100 * Dimentions.hUnit,
                        ),
                      ),
                      SizedBox(height: 30 * Dimentions.hUnit),
                      //
                      // EMAIL
                      AppTextField(
                        controller: _emailController,
                        iconColor: AppColors.mainColor,
                        hintText: 'Email',
                        icon: Icons.email,
                      ),
                      SizedBox(height: 20 * Dimentions.hUnit),
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
                      // SIGN UP BUTTON
                      ElevatedButton(
                        onPressed: () {
                          _registration();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 40 * Dimentions.hUnit,
                              vertical: 8 * Dimentions.hUnit,
                            ),
                            shadowColor: Colors.white),
                        child: BigText(
                          text: 'Sign up',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          size: 25 * Dimentions.hUnit,
                        ),
                      ),
                      SizedBox(height: 10 * Dimentions.hUnit),
                      //
                      // HAVE AN ACCOUNT? -> SIGN IN
                      TextButton(
                        onPressed: () {
                          Get.to(() => SignInPage());
                        },
                        child: BigText(
                          text: 'Have an account?',
                          color: AppColors.lightGreyColor,
                        ),
                      ),

                      SizedBox(height: 40 * Dimentions.hUnit),
                      //
                      // OATH2
                      SmallText(
                        text: 'Sign up using one of the following methods',
                        size: 15 * Dimentions.hUnit,
                      ),
                      SizedBox(height: 20 * Dimentions.hUnit),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Oath2Icon(assetImagePath: 'assets/images/g.png'),
                          Oath2Icon(assetImagePath: 'assets/images/t.png'),
                          Oath2Icon(assetImagePath: 'assets/images/f.png'),
                        ],
                      )
                    ],
                  ),
                );
        },
      ),
    ));
  }
}

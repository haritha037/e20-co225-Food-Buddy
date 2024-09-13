import 'dart:async';

import 'package:food_buddy_frontend/data/repository/auth_repo.dart';
import 'package:food_buddy_frontend/models/api_response.dart';

import 'package:food_buddy_frontend/models/categories.dart';
import 'package:food_buddy_frontend/models/sign_in_body.dart';
import 'package:food_buddy_frontend/models/sign_up_body.dart';
import 'package:food_buddy_frontend/models/user.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User _user = User();
  User get user => _user;

  Future<ApiResponse> signUp(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.signUp(signUpBody);

    late ApiResponse apiResponse;

    if (response.statusCode == 201) {
      print('Registered successfully');
      authRepo.saveUserToken(response.body['jwtToken']);
      apiResponse =
          ApiResponse(status: true, message: 'Signed up successfully');
      _user = User.fromJson(response.body);
      _user.isSignedIn = true;
      _user.hasShop = response.body['roles'].length > 1;
    } else {
      print(response.statusCode);
      print('Registration failed');
      apiResponse =
          ApiResponse(status: false, message: response.body['message']);
    }

    _isLoading = false;
    update();
    return apiResponse;
  }

  Future<ApiResponse> signIn(SignInBody signInBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.signIn(signInBody);

    late ApiResponse apiResponse;

    if (response.statusCode == 200) {
      print('Signed in successfully');
      authRepo.saveUserToken(response.body['jwtToken']);
      apiResponse =
          ApiResponse(status: true, message: 'Signed in successfully');
      _user = User.fromJson(response.body);
      _user.isSignedIn = true;
      _user.hasShop = response.body['roles'].length > 1;
    } else {
      print(response.statusCode);
      print('Signing in failed');
      apiResponse =
          ApiResponse(status: false, message: response.body['message']);
    }

    _isLoading = false;
    update();
    return apiResponse;
  }

  Future<void> getSignedInUser() async {
    _isLoading = true;
    update();
    Response response = await authRepo.getSignedInUser();

    if (response.statusCode == 200) {
      print('************************Got signed in user');
      _user = User.fromJson(response.body);
      _user.isSignedIn = true;
      _user.hasShop = response.body['roles'].length > 1;
    } else {
      // default values do the work
    }
    _isLoading = false;
    update();
  }

  bool isUserSignedIn() {
    return authRepo.isUserSignedIn();
  }

  void getUserToken() {
    authRepo.getUserToken();
  }

  void clearSharedData() {
    authRepo.clearSharedData();
  }

  void signOut() {
    authRepo.clearSharedData();
    _user = User();
    update();
  }

  void promoteUserToAShopOwner() {
    _user.hasShop = true;
    _user.roles!.add('ROLE_SELLER');
    update();
  }
}

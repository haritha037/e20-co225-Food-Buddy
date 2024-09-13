import 'package:food_buddy_frontend/data/api/api_client.dart';
import 'package:food_buddy_frontend/models/sign_in_body.dart';
import 'package:food_buddy_frontend/models/sign_up_body.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> signUp(SignUpBody signUpBody) async {
    return await apiClient.postData(
        AppConstants.SIGN_UP_URI, signUpBody.toJson());
  }

  Future<Response> signIn(SignInBody signInBody) async {
    return await apiClient.postData(
        AppConstants.SIGN_IN_URI, signInBody.toJson());
  }

  saveUserToken(String token) {
    // save in memory
    apiClient.token = token;
    apiClient.updateHeader(token);
    // save in local storage
    sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  bool isUserSignedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  void getUserToken() {
    String token = sharedPreferences.getString(AppConstants.TOKEN) ?? 'None';
    // save in memory
    apiClient.token = token;
    apiClient.updateHeader(token);
  }

  void clearSharedData() {
    sharedPreferences.remove(AppConstants.TOKEN);
    apiClient.token = '';
    apiClient.updateHeader('');
  }

  Future<Response> getSignedInUser() async {
    return await apiClient.getData(AppConstants.SIGNED_IN_USER_URI);
  }
}

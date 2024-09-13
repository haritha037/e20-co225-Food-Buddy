import 'package:food_buddy_frontend/data/api/api_client.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:get/get.dart';

class CategoryRepo extends GetxService {
  final ApiClient apiClient;

  CategoryRepo({required this.apiClient});

  Future<Response> getAllCategories() async {
    return await apiClient.getData(AppConstants.ALL_CATEGORIES_URI);
  }
}

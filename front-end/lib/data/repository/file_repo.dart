import 'package:food_buddy_frontend/data/api/api_client.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:get/get.dart';

class FileRepo extends GetxService {
  final ApiClient apiClient;

  FileRepo({required this.apiClient});

  // UPLOAD IMAGE
  Future<Response> uploadImage(FormData image, String uri) async {
    return await apiClient.putFormData(
      uri,
      image,
    );
  }
}

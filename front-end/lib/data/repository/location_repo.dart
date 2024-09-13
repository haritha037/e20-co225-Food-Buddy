import 'package:food_buddy_frontend/data/api/api_client.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:get/get.dart';

class LocationRepo extends GetxService {
  final ApiClient apiClient;

  LocationRepo({required this.apiClient});

  // GET ALL PRODUCTS
  Future<Response> getRoutePoints({
    required double lon1,
    required double lat1,
    required double lon2,
    required double lat2,
  }) async {
    var url = AppConstants.getRoutePointsUri(
      lon1: lon1,
      lat1: lat1,
      lon2: lon2,
      lat2: lat2,
    );
    return await GetConnect().get(url);
  }
}

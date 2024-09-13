import 'package:food_buddy_frontend/data/api/api_client.dart';
import 'package:food_buddy_frontend/models/create_shop_body.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:get/get.dart';

class ShopRepo extends GetxService {
  final ApiClient apiClient;

  ShopRepo({required this.apiClient});

  // GET ALL SHOPS
  Future<Response> getAllShops() async {
    return await apiClient.getData(AppConstants.ALL_SHOPS_URI);
  }

  // GET SHOP BY ID
  Future<Response> getShopById(int shopId) async {
    return await apiClient.getData(AppConstants.getShopByIdUri(shopId));
  }

  // GET MY SHOP
  Future<Response> getMyShop() async {
    return await apiClient.getData(AppConstants.MY_SHOP_URI);
  }

  // GET ACTIVE SHOPS
  Future<Response> getActiveShops() async {
    return await apiClient.getData(AppConstants.ALL_ACTIVE_SHOPS_URI);
  }

  // CREATE SHOP
  Future<Response> createShop(CreateShopBody createShopBody) async {
    return await apiClient.postData(
        AppConstants.CREATE_SHOP_URI, createShopBody.toJson());
  }
}

import 'package:food_buddy_frontend/controllers/location_controller.dart';
import 'package:food_buddy_frontend/data/api/api_client.dart';
import 'package:food_buddy_frontend/models/create_product_body.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class ProductRepo extends GetxService {
  final ApiClient apiClient;

  ProductRepo({required this.apiClient});

  // GET ALL PRODUCTS
  Future<Response> getAllProducts() async {
    return await apiClient.getData(AppConstants.ALL_PRODUCTS_URI);
  }

  // GET PRODUCT BY ID
  Future<Response> getProductById(int productId) async {
    return await apiClient.getData(AppConstants.getProductByIdUri(productId));
  }

  // GET PRODUCTS BY CATEGORY
  Future<Response> getProductsByCategory(int categoryId) async {
    return await apiClient
        .getData(AppConstants.getProductsByCategoryUri(categoryId));
  }

  // GET PRODUCTS BY SHOP
  Future<Response> getProductsByShop(int shopId) async {
    return await apiClient.getData(AppConstants.getProductByShopUri(shopId));
  }

  // GET NEARBY PRODUCTS
  Future<Response> getNearbyProducts(
      {required double latitude,
      required double longitude,
      required double radius}) async {
    return await apiClient.getData(
      AppConstants.NEARBY_PRODUCT_URI,
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'radius': radius.toString(),
      },
    );
  }

  // CREATE PRODUCT
  Future<Response> addNewProduct(
      CreateProductBody createProductBody, int categoryId) async {
    return await apiClient.postData(
      AppConstants.addNewProductUri(categoryId),
      createProductBody.toJson(),
    );
  }

  // UPDATE PRODUCT
  Future<Response> updateProduct(
      CreateProductBody createProductBody, int productId) async {
    return await apiClient.putData(
      AppConstants.updateProductUri(productId),
      createProductBody.toJson(),
    );
  }

  // DELETE PRODUCT
  Future<Response> deleteProduct(int productId) async {
    return await apiClient.deleteData(AppConstants.deleteProductUri(productId));
  }
}

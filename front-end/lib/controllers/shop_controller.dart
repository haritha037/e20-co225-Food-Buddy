import 'dart:io';

import 'package:food_buddy_frontend/controllers/file_controller.dart';
import 'package:food_buddy_frontend/data/repository/product_repo.dart';
import 'package:food_buddy_frontend/data/repository/shop_repo.dart';
import 'package:food_buddy_frontend/models/api_response.dart';
import 'package:food_buddy_frontend/models/create_shop_body.dart';
import 'package:food_buddy_frontend/models/products.dart';
import 'package:food_buddy_frontend/models/shop.dart';
import 'package:food_buddy_frontend/models/sign_up_body.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ShopController extends GetxController {
  final ShopRepo shopRepo;
  final FileController fileController;

  ShopController({required this.shopRepo, required this.fileController});

  List<Shop> _allShopsList = [];
  List<Shop> get allShopsList => _allShopsList;

  List<Shop> _activeShopsList = [];
  List<Shop> get activeShopsList => _activeShopsList;

  late Shop _shopOnShopDetails;
  Shop get shopOnShopDetails => _shopOnShopDetails;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  int _myShopId = 0;
  int get myShopId => _myShopId;

  // GET ALL SHOPS
  Future<void> getAllShops() async {
    _isLoading = true;
    Response response = await shopRepo.getAllShops();

    if (response.statusCode == 200) {
      print('got shops');
      _allShopsList = [];

      _allShopsList.addAll(Shops.fromJson(response.body).shops);
      print(_allShopsList);
      update();
    } else {
      print(_allShopsList);
      print(response.statusCode);
      print('Fetching all shops failed');
    }

    _isLoading = false;
  }

  // GET ACTIVE SHOPS
  Future<void> getActiveShops() async {
    _isLoading = true;
    Response response = await shopRepo.getActiveShops();

    if (response.statusCode == 200) {
      print('got active shops');
      _activeShopsList = [];

      _activeShopsList.addAll(Shops.fromJson(response.body).shops);
      print(_allShopsList);
      update();
    } else {
      print(_activeShopsList);
      print(response.statusCode);
      print('Fetching active shops failed');
    }
    _isLoading = false;
  }

  // GET SHOP BY ID
  Future<void> getShopById(int shopId) async {
    _isLoading = true;
    update();
    Response response = await shopRepo.getShopById(shopId);

    if (response.statusCode == 200) {
      print('got shop with id $shopId');
      _shopOnShopDetails = Shop.fromJson(response.body);
      print(_shopOnShopDetails);
      update();
    } else {
      print(_shopOnShopDetails);
      print(response.statusCode);
      print('Fetching shop with shop id $shopId failed');
    }
    _isLoading = false;
    update();
  }

  // GET MY SHOP
  Future<void> getMyShop() async {
    _isLoading = true;
    update();
    Response response = await shopRepo.getMyShop();

    if (response.statusCode == 200) {
      print('*************************got my shop');
      _shopOnShopDetails = Shop.fromJson(response.body);
      print(_shopOnShopDetails);
    } else {
      print(_shopOnShopDetails);
      print(response.statusCode);
      print('Fetching my shop failed');
    }
    _isLoading = false;
    update();
    print('got my shop');
  }

  Future<ApiResponse> createShop(
      CreateShopBody createShopBody, XFile? imageFile) async {
    _isLoading = true;
    update();

    // create shop(POST)
    Response response = await shopRepo.createShop(createShopBody);

    late ApiResponse apiResponse;

    if (response.statusCode == 201) {
      // Shop created successfully
      print('Shop created successfully');

      // set the id of the created shop
      _myShopId = response.body['shopId'];

      // when an image is uploaded
      if (imageFile != null) {
        print('image file is not null(picker is used)');
        // upload image (PUT)
        String uri = AppConstants.uploadShopImageUri(_myShopId);
        ApiResponse imageResponse =
            await fileController.uploadImage(imageFile, uri);

        if (imageResponse.status == true) {
          // Image is uploaded successfully
          print('Shop created successfully');
          apiResponse =
              ApiResponse(status: true, message: 'Shop created successfully');
        } else {
          print('Shop created successfully but the image uploading failed');
          apiResponse = ApiResponse(
              status: false,
              message:
                  'Shop created successfully but the image uploading failed');
        }
        // when an image is not uploaded
      } else {
        apiResponse =
            ApiResponse(status: true, message: 'Shop created successfully');
      }
    } else {
      print(response.statusCode);
      print('Shop registration failed');
      apiResponse =
          ApiResponse(status: false, message: response.body['message']);
    }

    _isLoading = false;
    update();
    return apiResponse;
  }
}

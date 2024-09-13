import 'package:food_buddy_frontend/controllers/file_controller.dart';
import 'package:food_buddy_frontend/controllers/location_controller.dart';
import 'package:food_buddy_frontend/data/repository/product_repo.dart';
import 'package:food_buddy_frontend/models/api_response.dart';
import 'package:food_buddy_frontend/models/create_product_body.dart';
import 'package:food_buddy_frontend/models/products.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController {
  final ProductRepo productRepo;
  final FileController fileController;

  ProductController({required this.productRepo, required this.fileController});

  List<Product> _allProductsList = [];
  List<Product> get allProductsList => _allProductsList;

  List<Product> _nearbyProductsList = [];
  List<Product> get nearbyProductsList => _nearbyProductsList;

  late Product _productOnProductDetails;
  Product get productOnProductDetails => _productOnProductDetails;

  List<Product> _productsByCategory = [];
  List<Product> get productsByCategory => _productsByCategory;

  List<Product> _productsByShop = [];
  List<Product> get productsByShop => _productsByShop;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  int _newProductId = 0;
  int get newProductId => _newProductId;

  // ALL PRODUCTS
  Future<void> getAllProducts() async {
    Response response = await productRepo.getAllProducts();

    if (response.statusCode == 200) {
      print('got products');
      _allProductsList = [];

      _allProductsList.addAll(Products.fromJson(response.body).products);
      print(_allProductsList);
      update();
    } else {
      print(_allProductsList);
      print(response.statusCode);
      print('Fetching all products failed');
    }
  }

  // NEARBY PRODUCTS
  Future<void> getNearbyProducts(double radius) async {
    _isLoading = true;
    Position myLocation = Get.find<LocationController>().myLocation;

    print('my location - $myLocation');
    print('search radius in controller - $radius');

    Response response = await productRepo.getNearbyProducts(
      latitude: myLocation.latitude,
      longitude: myLocation.longitude,
      radius: radius,
    );

    if (response.statusCode == 200) {
      print('got nearby products');
      _nearbyProductsList = [];

      _nearbyProductsList.addAll(Products.fromJson(response.body).products);
      print(_nearbyProductsList);
      update();
    } else {
      print(_nearbyProductsList);
      print('***************status code-${response.statusCode}');
      print('Fetching all products failed');
    }
    _isLoading = false;
    update();
  }

  // PRODUCT BY ID
  Future<void> getProductById(int productId) async {
    _isLoading = true;
    Response response = await productRepo.getProductById(productId);

    if (response.statusCode == 200) {
      print('got product with id $productId');
      _productOnProductDetails = Product.fromJson(response.body);
      print(_productOnProductDetails);
      update();
    } else {
      print(_productOnProductDetails);
      print(response.statusCode);
      print('Fetching product with product id $productId failed');
    }

    _isLoading = false;
  }

  // PRODUCTS BY CATEGORY
  Future<void> getProductsByCategory(int categoryId) async {
    _isLoading = true;
    Response response = await productRepo.getProductsByCategory(categoryId);

    if (response.statusCode == 200) {
      print('got products from category id $categoryId');
      _productsByCategory = [];

      _productsByCategory.addAll(Products.fromJson(response.body).products);
      print(_productsByCategory);
      update();
    } else {
      print(_productsByCategory);
      print(response.statusCode);
      print('Fetching products from category id $categoryId failed');
    }

    if (response.statusCode == 400) {
      print('products not found for category');
      _productsByCategory = [];
      print(_productsByCategory);
      update();
    }

    _isLoading = false;
  }

  // PRODUCTS BY SHOP
  Future<void> getProductsByShop(int shopId) async {
    _isLoading = true;
    Response response = await productRepo.getProductsByShop(shopId);

    if (response.statusCode == 200) {
      print('got products from shop id $shopId');
      _productsByShop = [];

      _productsByShop.addAll(Products.fromJson(response.body).products);
      print(_productsByShop);
      update();
    } else {
      print(_productsByShop);
      print(response.statusCode);
      print('Fetching products from shop id $shopId failed');
    }

    // if (response.statusCode == 400) {
    //   print('products not found for category');
    //   _productsByCategory = [];
    //   print(_productsByCategory);
    //   update();
    // }

    _isLoading = false;
  }

  // ADD NEW PRODUCT
  Future<ApiResponse> addNewProduct(CreateProductBody createProductBody,
      int categoryId, XFile? imageFile) async {
    _isLoading = true;
    update();

    // create product(POST)
    Response response =
        await productRepo.addNewProduct(createProductBody, categoryId);

    late ApiResponse apiResponse;

    if (response.statusCode == 201) {
      // Product created successfully
      print('Product added successfully');

      // convert the response into a Product object
      Product newProduct;
      newProduct = Product.fromJson(response.body);
      // set the id of the added product
      _newProductId = response.body['productId'];

      // when an image is uploaded
      if (imageFile != null) {
        print('image file is not null(picker is used)');
        // upload image (PUT)
        String uri = AppConstants.uploadProductImageUri(_newProductId);
        ApiResponse imageResponse =
            await fileController.uploadImage(imageFile, uri);

        if (imageResponse.status == true) {
          // Image is uploaded successfully
          print('Product added successfully');
          newProduct.image = fileController.uploadedImageName;
          _productsByShop.addNonNull(newProduct);
          apiResponse =
              ApiResponse(status: true, message: 'Product added successfully');
        } else {
          print('Product added successfully but the image uploading failed');
          apiResponse = ApiResponse(
              status: false,
              message:
                  'Product added successfully but the image uploading failed');
        }
        // when an image is not uploaded
      } else {
        apiResponse =
            ApiResponse(status: true, message: 'Product added successfully');
      }
    } else {
      print(response.statusCode);
      print('Product adding failed');
      apiResponse =
          ApiResponse(status: false, message: response.body['message']);
    }

    _isLoading = false;
    update();
    return apiResponse;
  }

  // UPDATE PRODUCT
  Future<ApiResponse> updateProduct(CreateProductBody createProductBody,
      Product product, XFile? imageFile) async {
    _isLoading = true;
    update();

    // update product(PUT)
    Response response =
        await productRepo.updateProduct(createProductBody, product.productId);

    late ApiResponse apiResponse;

    if (response.statusCode == 200) {
      // Product created successfully
      print('Product updated successfully');

      // convert the response into a Product object
      Product updatedProduct;
      updatedProduct = Product.fromJson(response.body);
      // set the id of the added product
      _newProductId = response.body['productId'];

      // when an image is uploaded
      if (imageFile != null) {
        print('image file is not null(picker is used)');
        // upload image (PUT)
        String uri = AppConstants.uploadProductImageUri(_newProductId);
        ApiResponse imageResponse =
            await fileController.uploadImage(imageFile, uri);

        if (imageResponse.status == true) {
          // Image is uploaded successfully
          print('Image uploaded successfully');
          updatedProduct.image = fileController.uploadedImageName;
          _updateProductsList(product, updatedProduct);

          apiResponse = ApiResponse(
              status: true, message: 'Product updated successfully');
        } else {
          print('Product updated successfully but the image uploading failed');
          apiResponse = ApiResponse(
              status: false,
              message:
                  'Product updated successfully but the image uploading failed');
        }
        // when an image is not uploaded
      } else {
        apiResponse =
            ApiResponse(status: true, message: 'Product updated successfully');

        _updateProductsList(product, updatedProduct);
      }
    } else {
      print(response.statusCode);
      print('Product updating failed');
      apiResponse =
          ApiResponse(status: false, message: response.body['message']);
    }

    _isLoading = false;
    update();
    return apiResponse;
  }

  void _updateProductsList(Product product, Product updatedProduct) {
    int index = _productsByShop.indexOf(product);
    if (index == -1) {
      print('*****************Product not found in products list');
      return;
    }
    _productsByShop.removeAt(index);
    _productsByShop.insert(index, updatedProduct);
  }

  //
  // DELETE PRODUCT BY ID
  Future<ApiResponse> deleteProduct(Product product) async {
    _isLoading = true;
    update();

    // delete product(DELETE)
    Response response = await productRepo.deleteProduct(product.productId);

    late ApiResponse apiResponse;

    if (response.statusCode == 200) {
      // Product deleted successfully
      print('Product deleted successfully');

      _productsByShop.remove(product);

      apiResponse =
          ApiResponse(status: true, message: 'Product deleted successfully');
    } else {
      print(response.statusCode);
      print('Product deletion failed');
      apiResponse =
          ApiResponse(status: false, message: response.body['message']);
    }

    _isLoading = false;
    update();
    return apiResponse;
  }
}

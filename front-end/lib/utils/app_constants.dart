class AppConstants {
  static const String APP_NAME = "FoodBuddy";
  static const int APP_VERSION = 1;

  // static const String BASE_URL = "http://10.0.2.2:5000"; // emulator
  // static const String BASE_URL =
  //     "http://Food-buddy-env.eba-upp3xrai.ap-south-1.elasticbeanstalk.com";
  // static const String BASE_URL =
  //     "http://foodbuddy.ap-south-1.elasticbeanstalk.com";
  static const String BASE_URL = "http://192.168.1.5:5000";

  // shared preference keys
  static const String TOKEN = "token";

  // END POINTS0

  // PRODUCTS
  static const String ALL_PRODUCTS_URI = '/api/public/products';
  static const String PRODUCT_IMAGE_URI = '/api/public/products/images/';
  static const String NEARBY_PRODUCT_URI = '/api/public/products/nearby';

  static String getProductsByCategoryUri(int categoryId) =>
      '/api/public/categories/$categoryId/products';

  static String getProductByIdUri(int productId) =>
      '/api/public/products/$productId';

  static String getProductByShopUri(int shopId) =>
      '/api/public/products/shops/$shopId';

  static String addNewProductUri(int categoryId) =>
      '/api/products/categories/$categoryId';

  static String updateProductUri(int productId) => '/api/products/$productId';

  static String deleteProductUri(int productId) => '/api/products/$productId';

  static String uploadProductImageUri(int productId) =>
      '/api/products/$productId/image';

  // CATEGORIES
  static const String ALL_CATEGORIES_URI = '/api/public/categories';
  static const String CATEGORY_IMAGE_URI = '/api/public/categories/images/';

  // SHOPS
  static const String ALL_SHOPS_URI = '/api/public/shops';
  static const String ALL_ACTIVE_SHOPS_URI = '/api/public/shops/active';
  static const String SHOP_IMAGE_URI = '/api/public/shops/images/';
  static const String CREATE_SHOP_URI = '/api/shops';
  static const String MY_SHOP_URI = '/api/shops/myShop';

  static String getShopByIdUri(int shopId) => '/api/public/shops/$shopId';
  static String uploadShopImageUri(int shopId) => '/api/shops/$shopId/image';

  // MAP
  static String getRoutePointsUri({
    required double lon1,
    required double lat1,
    required double lon2,
    required double lat2,
  }) =>
      'http://router.project-osrm.org/route/v1/driving/$lon1,$lat1;$lon2,$lat2?steps=true&annotations=true&geometries=geojson&overview=full';

  // AUTH
  static const String SIGN_UP_URI = '/api/auth/signup';
  static const String SIGN_IN_URI = '/api/auth/signin';
  static const String SIGNED_IN_USER_URI = '/api/auth/user';
}

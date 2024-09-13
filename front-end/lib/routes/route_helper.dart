import 'package:food_buddy_frontend/helper/dependencies.dart';
import 'package:food_buddy_frontend/models/categories.dart';
import 'package:food_buddy_frontend/models/sign_up_body.dart';
import 'package:food_buddy_frontend/pages/account_page.dart';
import 'package:food_buddy_frontend/pages/auth/sign_in_page.dart';
import 'package:food_buddy_frontend/pages/auth/sign_up_page.dart';
import 'package:food_buddy_frontend/pages/splash_screen.dart';
import 'package:food_buddy_frontend/pages/category_products_page.dart';
import 'package:food_buddy_frontend/pages/home_page.dart';
import 'package:food_buddy_frontend/pages/nav_page.dart';
import 'package:food_buddy_frontend/pages/product_details_page.dart';
import 'package:food_buddy_frontend/pages/shop%20page/shop_details_page.dart';
import 'package:food_buddy_frontend/pages/shops_page.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String splashScreen = '/splash-screen';
  static const String initial = '/';
  static const String productDetails = '/product-details';
  static const String shops = '/shops';
  static const String categoryProducts = '/category-products';
  static const String shopDetails = '/shop-details';
  static const String accountPage = '/account-page';
  static const String signInPage = '/sign-in-page';
  static const String signUpPage = '/sign-up-page';

  static String getSplashScreen() => '$splashScreen';
  static String getInitial() => '$initial';
  static String getProductDetails() => '$productDetails';
  static String getShopDetails() => '$shopDetails';
  static String getShops() => '$shops';
  static String getAccountPage() => '$accountPage';
  static String getSignInPage() => '$signInPage';
  static String getSignUpPage() => '$signUpPage';
  static String getCategoryProducts(int categoryIndex) =>
      '$categoryProducts?categoryIndex=$categoryIndex';

  static List<GetPage> routes = [
    // SPLASH SCREEN
    GetPage(
      name: splashScreen,
      page: () => const Splashscreen(),
    ),
    //
    // HOME PAGE
    GetPage(
      name: initial,
      page: () => const NavPage(),
    ),

    // PRODUCT DETAILS PAGE
    GetPage(
      name: productDetails,
      page: () {
        return const ProductDetailsPage();
      },
      transition: Transition.fadeIn,
    ),

    // SHOPS PAGE
    GetPage(
      name: shops,
      page: () {
        return const ShopsPage();
      },
      transition: Transition.fadeIn,
    ),

    // CATEGORY PRODUCTS PAGE
    GetPage(
      name: categoryProducts,
      page: () {
        var categoryIndex = Get.parameters['categoryIndex'];
        print(categoryIndex);
        return CategoryProductsPage(categoryIndex: int.parse(categoryIndex!));
      },
      transition: Transition.fadeIn,
    ),

    // SHOP DETAILS PAGE
    GetPage(
      name: shopDetails,
      page: () {
        return const ShopDetailsPage();
      },
      transition: Transition.fadeIn,
    ),
    //
    // ACCOUNT PAGE
    GetPage(
      name: accountPage,
      page: () {
        return const AccountPage();
      },
      transition: Transition.fadeIn,
    ),
    //
    // SIGN IN PAGE
    GetPage(
      name: signInPage,
      page: () {
        return const SignInPage();
      },
      transition: Transition.fadeIn,
    ),
    //
    // SIGN UP PAGE
    GetPage(
      name: signUpPage,
      page: () {
        return const SignUpPage();
      },
      transition: Transition.fadeIn,
    ),
  ];
}

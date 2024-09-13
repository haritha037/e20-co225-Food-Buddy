// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/controllers/category_controller.dart';
import 'package:food_buddy_frontend/controllers/location_controller.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/models/categories.dart';
import 'package:food_buddy_frontend/models/products.dart';
import 'package:food_buddy_frontend/routes/route_helper.dart';
import 'package:food_buddy_frontend/utils/app_constants.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/utils/resources.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/category_image_and_text.dart';
import 'package:food_buddy_frontend/widgets/discount_details.dart';
import 'package:food_buddy_frontend/widgets/loading_indicator.dart';
import 'package:food_buddy_frontend/widgets/product%20card/product_card.dart';
import 'package:food_buddy_frontend/widgets/search_option_button.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _nearbyProducts = [];
  List<Product> _allProducts = [];
  List<Product> _productsOnPage = [];
  bool _isNearby = true;

  List<Product> _searchResults = [];
  //List<Product> _searchHistory = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_queryLisetner);
    Resources.loadResources();
  }

  @override
  void dispose() {
    _searchController.removeListener(_queryLisetner);
    _searchController.dispose();
    super.dispose();
  }

  void _toggleNearbyAndAll() {
    setState(() {
      _isNearby = !_isNearby;
    });
  }

  void _queryLisetner() {
    _search(_searchController.text.trim());
  }

  void _search(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults = _productsOnPage;
      } else {
        _searchResults = _productsOnPage
            .where(
              (product) => product.productName
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _unfocusSearchBar() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus(); // Unfocus when the background is tapped
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: _unfocusSearchBar,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10 * Dimentions.hUnit),
            child: Column(
              children: [
                //
                // TOP MARGIN
                SizedBox(height: 5 * Dimentions.hUnit),
                //
                // TOP BAR
                Row(
                  children: [
                    //
                    // LOCATION ICON
                    Container(
                      width: 60 * Dimentions.hUnit,
                      height: 60 * Dimentions.hUnit,
                      decoration: BoxDecoration(
                        color: Color(0xFFFAD8D8),
                        borderRadius:
                            BorderRadius.circular(30 * Dimentions.hUnit),
                      ),
                      child: Icon(
                        Icons.location_on_sharp,
                        size: 40 * Dimentions.hUnit,
                        color: AppColors.pinkColor,
                      ),
                    ),
                    SizedBox(width: 8 * Dimentions.hUnit),
                    //
                    // LOCATION DETAILS

                    GetBuilder<LocationController>(
                      builder: (locationController) {
                        return locationController.isLoading
                            ? LoadingIndicator()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BigText(
                                    text: (locationController.myLocationAddress[
                                                'locality'] !=
                                            ''
                                        // .toString().isNotEmpty
                                        )
                                        ? locationController.myLocationAddress[
                                                'locality'] ??
                                            ""
                                        : locationController.myLocationAddress[
                                                'subLocality'] ??
                                            "",
                                    size: 15 * Dimentions.hUnit,
                                  ),
                                  SmallText(
                                    text: locationController.myLocationAddress[
                                                'locality'] !=
                                            ''
                                        // .toString()
                                        // .isNotEmpty
                                        ? locationController.myLocationAddress[
                                                'subLocality'] ??
                                            ""
                                        : locationController.myLocationAddress[
                                                'subAdministrativeArea'] ??
                                            "",
                                  ),
                                ],
                              );
                      },
                    ),
                    //
                    Spacer(),
                    //
                    // SEARCH BUTTON
                    // Container(
                    //   width: 60 * Dimentions.hUnit,
                    //   height: 60 * Dimentions.hUnit,
                    //   decoration: BoxDecoration(
                    //     color: AppColors.pinkColor,
                    //     borderRadius:
                    //         BorderRadius.circular(20 * Dimentions.hUnit),
                    //   ),
                    //   child: Icon(
                    //     Icons.search,
                    //     size: 40 * Dimentions.hUnit,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 10 * Dimentions.hUnit),
                //
                // HORIZONTAL LINE
                Divider(
                  color: AppColors.lightGreyColor,
                  height: 0 *
                      Dimentions
                          .hUnit, // The space between the divider and the content above and below it
                  thickness: 0.5,
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: Resources.loadResources,
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        children: [
                          SizedBox(height: 10 * Dimentions.hUnit),
                          //
                          // CATEGORY BAR
                          GetBuilder<CategoryController>(
                            builder: (categoryController) {
                              List<Category> categories =
                                  categoryController.categoriesList;

                              return Container(
                                height: 130 * Dimentions.hUnit,
                                // color: Colors.black12,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () {
                                      int categoryId =
                                          categories[index].categoryId;
                                      Get.find<ProductController>()
                                          .getProductsByCategory(categoryId);
                                      Get.toNamed(
                                          RouteHelper.getCategoryProducts(
                                              index));

                                      print(
                                          'categoryId - ${categories[index].categoryId}');
                                    },
                                    child: CategoryImageAndText(
                                      image: categories[index].image,
                                      categoryName:
                                          categories[index].categoryName,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 15 * Dimentions.hUnit),

                          //
                          // SEARCH BAR
                          SearchBar(
                            elevation: WidgetStatePropertyAll(6),
                            focusNode: _focusNode,
                            controller: _searchController,
                            hintText: 'Search...',
                            trailing: [
                              IconButton(
                                onPressed: _unfocusSearchBar,
                                icon: Icon(Icons.search),
                              ),
                            ],
                          ),
                          SizedBox(height: 20 * Dimentions.hUnit),
                          //
                          // SEARCH OPTIONS BUTTONS SET
                          Row(
                            children: [
                              SmallText(
                                text: _isNearby ? 'Nearby you' : 'All ads',
                                size: 15 * Dimentions.hUnit,
                                color: AppColors.darkGreyColor,
                              ),
                              //SearchOptionButton(text: 'Nearby you'),
                              Spacer(),
                              GestureDetector(
                                onTap: _toggleNearbyAndAll,
                                child: SearchOptionButton(
                                    text: _isNearby ? 'See all' : 'see nearby'),
                              ),
                              SizedBox(width: 10 * Dimentions.wUnit),
                              GestureDetector(
                                onTap: () {
                                  Get.find<ShopController>().getAllShops();
                                  Get.toNamed(RouteHelper.getShops());
                                },
                                child: SearchOptionButton(text: 'Shops'),
                              ),
                            ],
                          ),
                          SizedBox(height: 5 * Dimentions.hUnit),
                          //
                          // MEALS LIST
                          GetBuilder<LocationController>(
                            builder: (locationController) {
                              if (locationController.isLoading) {
                                print('location controller is loading');
                                return Container(
                                  margin: EdgeInsets.only(
                                      top: 200 * Dimentions.hUnit),
                                  child: LoadingIndicator(),
                                );
                              } else {
                                // print('location loaded');
                                // double radius = locationController.searchRadius;
                                // Get.find<ProductController>()
                                //     .getNearbyProducts(radius);

                                // Position myLocation =
                                //     locationController.myLocation;
                                // locationController.getAddressFromLatLng(
                                //     myLocation.latitude, myLocation.longitude);

                                return GetBuilder<ProductController>(
                                  builder: (productController) {
                                    if (productController.isLoading) {
                                      print('product controller is loading');
                                      return Container(
                                        margin: EdgeInsets.only(
                                            top: 200 * Dimentions.hUnit),
                                        child: LoadingIndicator(),
                                      );
                                    }

                                    _nearbyProducts =
                                        productController.nearbyProductsList;
                                    _allProducts =
                                        productController.allProductsList;

                                    _productsOnPage = _isNearby
                                        ? _nearbyProducts
                                        : _allProducts;

                                    return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _focusNode.hasFocus ||
                                              _searchResults.isNotEmpty
                                          ? _searchResults.length
                                          : _productsOnPage.length,
                                      itemBuilder: (ctx, index) =>
                                          GestureDetector(
                                        onTap: () =>
                                            FocusScope.of(context).unfocus(),
                                        child: ProductCard(
                                          product: _focusNode.hasFocus ||
                                                  _searchResults.isNotEmpty
                                              ? _searchResults[index]
                                              : _productsOnPage[index],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

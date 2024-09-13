import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/controllers/category_controller.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/models/categories.dart';
import 'package:food_buddy_frontend/models/products.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/app_bar_widget.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/loading_indicator.dart';
import 'package:food_buddy_frontend/widgets/not_found.dart';
import 'package:food_buddy_frontend/widgets/product%20card/product_card.dart';
import 'package:get/get.dart';

class CategoryProductsPage extends StatelessWidget {
  final int categoryIndex;
  const CategoryProductsPage({super.key, required this.categoryIndex});

  @override
  Widget build(BuildContext context) {
    Category category =
        Get.find<CategoryController>().categoriesList[categoryIndex];
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBarWidget(title: category.categoryName),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10 * Dimentions.hUnit),
        child: GetBuilder<ProductController>(
          builder: (productController) {
            List<Product> productsByCategory =
                productController.productsByCategory;

            Widget content = productsByCategory.isEmpty
                ? const NotFound(message: 'No matching products')
                : ListView.builder(
                    itemCount: productsByCategory.length,
                    itemBuilder: (context, index) => ProductCard(
                      product: productsByCategory[index],
                    ),
                  );

            return productController.isLoading
                ? const LoadingIndicator()
                : content;
          },
        ),
      ),
    );
  }
}

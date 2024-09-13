import 'package:food_buddy_frontend/data/repository/category_repo.dart';
import 'package:food_buddy_frontend/data/repository/product_repo.dart';
import 'package:food_buddy_frontend/models/categories.dart';
import 'package:food_buddy_frontend/models/products.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final CategoryRepo categoryRepo;

  CategoryController({required this.categoryRepo});

  List<Category> _categoriesList = [];
  List<Category> get categoriesList => _categoriesList;

  // ALL CATEGORIES
  Future<void> getAllCategories() async {
    Response response = await categoryRepo.getAllCategories();

    if (response.statusCode == 200) {
      print('got categories');
      _categoriesList = [];

      _categoriesList.addAll(Categories.fromJson(response.body).categories);

      update();
    } else {
      print(response.statusCode);
      print('Fetching categories failed');
    }
  }
}

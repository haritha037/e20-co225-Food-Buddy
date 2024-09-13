import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/models/categories.dart';
import 'package:food_buddy_frontend/widgets/category_image_and_text.dart';

class CategoryPage extends StatelessWidget {
  final int categoryIndex;
  const CategoryPage({super.key, required this.categoryIndex});

  @override
  Widget build(BuildContext context) {
    // List<Category>
    // return Scaffold(
    //   appBar: AppBar(
    //     leading: GestureDetector(
    //       onTap: () {
    //         Navigator.pop(context);
    //       },
    //     ),
    //   ),
    //   body: Column(
    //     children: [
    //       CategoryImageAndText(image: 'category-rice-and-curry.jpg', categoryName: 'Rice & Curry',),

    //     ],
    //   ),
    // );
    return Container();
  }
}

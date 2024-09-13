class Categories {
  late List<Category> categories;

  Categories({required this.categories});

  Categories.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      categories = <Category>[];
      json['content'].forEach((v) {
        categories.add(Category.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.categories != null) {
  //     data['content'] = this.categories.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Category {
  late int categoryId;
  late String categoryName;
  late String image;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.image,
  });

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    image = json['image'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['categoryId'] = this.categoryId;
  //   data['categoryName'] = this.categoryName;
  //   data['image'] = this.image;
  //   return data;
  // }
}

class Products {
  late List<Product> _products;
  int? pageNumber;
  int? pageSize;
  int? totalElements;
  int? totalPages;
  bool? lastPage;

  // GETTERS
  List<Product> get products => _products;

  Products(
      {required products,
      this.pageNumber,
      this.pageSize,
      this.totalElements,
      this.totalPages,
      this.lastPage}) {
    _products = products;
  }

  Products.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      _products = <Product>[];
      json['content'].forEach((v) {
        _products.add(Product.fromJson(v));
      });
    }
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    lastPage = json['lastPage'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.content != null) {
  //     data['content'] = this.content!.map((v) => v.toJson()).toList();
  //   }
  //   data['pageNumber'] = this.pageNumber;
  //   data['pageSize'] = this.pageSize;
  //   data['totalElements'] = this.totalElements;
  //   data['totalPages'] = this.totalPages;
  //   data['lastPage'] = this.lastPage;
  //   return data;
  // }
}

class Product {
  late int productId;
  late String productName;
  late String image;
  late String description;
  late double originalPrice;
  late double discountedPrice;
  late int discountPercentage;
  int? quantity;
  late String validUntil;
  late int categoryId;
  late int shopId;
  late String shopName;
  late String shopPhoneNumber;

  Product(
      {required this.productId,
      required this.productName,
      required this.image,
      required this.description,
      required this.originalPrice,
      required this.discountedPrice,
      required this.discountPercentage,
      this.quantity,
      required this.validUntil,
      required this.categoryId,
      required this.shopId,
      required this.shopPhoneNumber,
      required this.shopName});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    image = json['image'];
    description = json['description'];
    originalPrice = json['originalPrice'];
    discountedPrice = json['discountedPrice'];
    discountPercentage = json['discountPercentage'];
    quantity = json['quantity'];
    validUntil = json['valid_until'];
    categoryId = json['categoryId'];
    shopId = json['shopId'];
    shopName = json['shopName'];
    shopPhoneNumber = json['shopPhoneNumber'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['productId'] = this.productId;
  //   data['productName'] = this.productName;
  //   data['image'] = this.image;
  //   data['description'] = this.description;
  //   data['originalPrice'] = this.originalPrice;
  //   data['discountedPrice'] = this.discountedPrice;
  //   data['discountPercentage'] = this.discountPercentage;
  //   data['quantity'] = this.quantity;
  //   data['valid_until'] = this.validUntil;
  //   data['categoryId'] = this.categoryId;
  //   data['shopId'] = this.shopId;
  //   data['shopName'] = this.shopName;
  //   return data;
  // }
}

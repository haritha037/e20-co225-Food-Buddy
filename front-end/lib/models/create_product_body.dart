import 'package:food_buddy_frontend/models/shop.dart';

class CreateProductBody {
  final String productName;
  final String description;
  final double originalPrice;
  final double discountedPrice;
  final int quantity;
  final String validUntil;
  final int? categoryId;

  CreateProductBody({
    required this.productName,
    this.categoryId,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.quantity,
    required this.validUntil,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['productName'] = productName;
    data['description'] = description;
    data['categoryId'] = categoryId;

    data['originalPrice'] = originalPrice;
    data['discountedPrice'] = discountedPrice;
    data['quantity'] = quantity;
    data['valid_until'] = validUntil;

    return data;
  }
}

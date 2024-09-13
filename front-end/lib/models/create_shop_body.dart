import 'package:food_buddy_frontend/models/shop.dart';

class CreateShopBody {
  final String shopName;
  final String phoneNumber;
  final String address1;
  final String address2;
  final String address3;
  final double latitude;
  final double longitude;

  CreateShopBody({
    required this.shopName,
    required this.phoneNumber,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['shopName'] = shopName;
    data['phoneNumber'] = phoneNumber;
    data['address'] = {
      'addressLine1': address1,
      'addressLine2': address2,
      'addressLine3': address3
    };
    data['latitude'] = latitude;
    data['longitude'] = longitude;

    return data;
  }
}

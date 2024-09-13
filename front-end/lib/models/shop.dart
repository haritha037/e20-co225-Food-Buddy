class Shops {
  late List<Shop> _shops;

  // GETTERS
  List<Shop> get shops => _shops;

  Shops({required shops}) {
    _shops = shops;
  }

  Shops.fromJson(List<dynamic> json) {
    _shops = <Shop>[];
    json.forEach((shopMap) {
      _shops.add(Shop.fromJson(shopMap));
    });
  }
}

class Shop {
  late int shopId;
  late double latitude;
  late double longitude;
  late String phoneNumber;
  late Address address;
  late int ownerId;
  late String shopName;
  late String image;

  Shop(
      {required this.shopId,
      required this.latitude,
      required this.longitude,
      required this.phoneNumber,
      required this.address,
      required this.image,
      required this.ownerId,
      required this.shopName});

  Shop.fromJson(Map<String, dynamic> json) {
    shopId = json['shopId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phoneNumber = json['phoneNumber'];
    address = Address.fromJson(json['address']);
    ownerId = json['ownerId'];
    shopName = json['shopName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shopId'] = shopId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address.toJson();
    data['ownerId'] = ownerId;
    data['shopName'] = shopName;
    data['image'] = image;
    return data;
  }
}

class Address {
  late int addressId;
  late String addressLine1;
  late String addressLine3;
  late String addressLine2;

  Address(
      {required this.addressId,
      required this.addressLine1,
      required this.addressLine3,
      required this.addressLine2});

  Address.fromJson(Map<String, dynamic> json) {
    addressId = json['addressId'];
    addressLine1 = json['addressLine1'];
    addressLine3 = json['addressLine3'];
    addressLine2 = json['addressLine2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addressId'] = addressId;
    data['addressLine1'] = addressLine1;
    data['addressLine3'] = addressLine3;
    data['addressLine2'] = addressLine2;
    return data;
  }
}

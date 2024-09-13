import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:food_buddy_frontend/controllers/auth_controller.dart';
import 'package:food_buddy_frontend/controllers/file_controller.dart';
import 'package:food_buddy_frontend/controllers/location_controller.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/models/api_response.dart';
import 'package:food_buddy_frontend/models/create_shop_body.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/app_icon.dart';
import 'package:food_buddy_frontend/widgets/app_text_field.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/custom_snackbar.dart';
import 'package:food_buddy_frontend/widgets/location_picker.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class ShopSignUpPage extends StatefulWidget {
  const ShopSignUpPage({super.key});

  @override
  State<ShopSignUpPage> createState() => _ShopSignUpPageState();
}

class _ShopSignUpPageState extends State<ShopSignUpPage> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final Position _myPosition = Get.find<LocationController>().myLocation;
  GeoPoint? _shopLocation;
  bool _isButtonDisabled = false;

  final _shopNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _address3Controller = TextEditingController();

  void _disableButton() {
    setState(() {
      _isButtonDisabled = true;
    });
  }

  void _takePhoto(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    setState(() {
      _imageFile = image;
    });
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _phoneNumberController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _address3Controller.dispose();
    super.dispose();
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  bool _validateInputs(String shopName, String phoneNumber, String address1,
      String address2, String address3, GeoPoint shopLocation) {
    if (shopName.isEmpty) {
      showCustomSnackBar(
        'Type in the shop name',
        title: 'Shop name',
        isError: false,
      );
      return false;
    } else if (phoneNumber.isEmpty) {
      showCustomSnackBar(
        'Type in the phone number',
        title: 'Phone number',
        isError: false,
      );
      return false;
    } else if (address1.isEmpty) {
      showCustomSnackBar(
        'Type in the address line 1',
        title: 'Adrress',
        isError: false,
      );
      return false;
    } else if (address2.isEmpty) {
      showCustomSnackBar(
        'Type in the address line 2',
        title: 'Adrress',
        isError: false,
      );
      return false;
    } else if (address3.isEmpty) {
      showCustomSnackBar(
        'Type in the address line 3',
        title: 'Adrress',
        isError: false,
      );
      return false;
    } else if (phoneNumber.length != 10 ||
        !GetUtils.isNumericOnly(phoneNumber)) {
      showCustomSnackBar(
        'Invalid phone number',
        title: 'Phone number',
        isError: false,
      );
      return false;
    } else if (shopLocation.latitude < -90 ||
        shopLocation.latitude > 90 ||
        shopLocation.longitude < -180 ||
        shopLocation.longitude > 180) {
      showCustomSnackBar(
        'Invalid location',
        title: 'Location',
        isError: true,
      );
      return false;
    } else if (_imageFile == null) {
      showCustomSnackBar(
        'Add an image',
        title: 'Image',
        isError: false,
      );
      return false;
    } else if (_shopLocation == null) {
      showCustomSnackBar(
        'Add a location',
        title: 'Location',
        isError: false,
      );
      return false;
    }
    return true;
  }

  // REGISTER SHOP
  Future<void> _registerShop() async {
    // hide the keyboard
    _hideKeyboard();

    String shopName = _shopNameController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();
    String address1 = _address1Controller.text.trim();
    String address2 = _address2Controller.text.trim();
    String address3 = _address3Controller.text.trim();
    GeoPoint shopLocation = _shopLocation ??
        GeoPoint(
            latitude: _myPosition.latitude, longitude: _myPosition.longitude);
    print(
        '$shopName $phoneNumber $address1 $address2 $address3 ${shopLocation.toString()}');

    // validate input
    if (_validateInputs(
      shopName,
      phoneNumber,
      address1,
      address2,
      address3,
      shopLocation,
    )) {
      _disableButton();

      CreateShopBody createShopBody = CreateShopBody(
        shopName: shopName,
        phoneNumber: phoneNumber,
        address1: address1,
        address2: address2,
        address3: address3,
        latitude: shopLocation.latitude,
        longitude: shopLocation.longitude,
      );
      print('******valid shop signup body');

      print(createShopBody.toString());

      ApiResponse shopResponse = await Get.find<ShopController>()
          .createShop(createShopBody, _imageFile);

      if (shopResponse.status == true) {
        showCustomSnackBar(shopResponse.message,
            isError: false, title: 'Success');
        Get.find<AuthController>().promoteUserToAShopOwner();
      } else {
        showCustomSnackBar(shopResponse.message, isError: true);
      }
    }
  }

  void _showBottomSheetForImage() {
    _hideKeyboard();
    Get.bottomSheet(
      Container(
        height: 200 * Dimentions.hUnit,
        width: Dimentions.screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: 40 * Dimentions.hUnit,
          vertical: 20 * Dimentions.hUnit,
        ),
        child: Column(
          children: [
            BigText(text: 'Choose shop image'),
            SizedBox(height: 20 * Dimentions.hUnit),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                // CAMERA
                InkWell(
                  onTap: () {
                    _takePhoto(ImageSource.camera);
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.camera,
                        size: 60 * Dimentions.hUnit,
                        color: AppColors.pinkColor,
                      ),
                      BigText(
                        text: 'camera',
                        color: AppColors.pinkColor,
                      ),
                    ],
                  ),
                ),
                //
                // GALLERY
                InkWell(
                  onTap: () {
                    _takePhoto(ImageSource.gallery);
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 60 * Dimentions.hUnit,
                        color: AppColors.lightBlueColor,
                      ),
                      BigText(
                        text: 'Gallery',
                        color: AppColors.lightBlueColor,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(8 * Dimentions.hUnit),
          child: Column(
            children: [
              SizedBox(height: 40 * Dimentions.hUnit),
              //
              // SHOP IMAGE
              Center(
                child: Stack(
                  children: [
                    //
                    // SHOP IMAGE + ICON
                    CircleAvatar(
                      backgroundImage: _imageFile != null
                          ? FileImage(File(_imageFile!.path))
                          : AssetImage('assets/images/default-shop.jpg'),
                      radius: 100 * Dimentions.hUnit,
                    ),
                    Positioned(
                      bottom: 10 * Dimentions.hUnit,
                      right: 10 * Dimentions.hUnit,
                      child: InkWell(
                        onTap: () {
                          _showBottomSheetForImage();
                        },
                        child: Icon(
                          Icons.camera_alt,
                          color: AppColors.mainColor,
                          size: 30 * Dimentions.hUnit,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30 * Dimentions.hUnit),
              //
              // SHOP NAME
              AppTextField(
                controller: _shopNameController,
                iconColor: AppColors.mainColor,
                hintText: 'Shop name',
                icon: Icons.storefront_rounded,
              ),
              SizedBox(height: 20 * Dimentions.hUnit),
              //
              // PHONE NUMBER
              AppTextField(
                controller: _phoneNumberController,
                iconColor: AppColors.mainColor,
                hintText: 'Phone number',
                icon: Icons.call,
              ),
              SizedBox(height: 50 * Dimentions.hUnit),

              //
              // ADDRESS LINE 1
              AppTextField(
                controller: _address1Controller,
                iconColor: AppColors.mainColor,
                hintText: 'Address line 1',
                icon: Icons.email,
              ),
              SizedBox(height: 20 * Dimentions.hUnit),
              //
              // ADDRESS LINE 2
              AppTextField(
                controller: _address2Controller,
                iconColor: AppColors.mainColor,
                hintText: 'Address line 2',
                icon: Icons.email,
              ),
              SizedBox(height: 20 * Dimentions.hUnit),
              //
              // ADDRESS LINE 3
              AppTextField(
                controller: _address3Controller,
                iconColor: AppColors.mainColor,
                hintText: 'Address line 3',
                icon: Icons.email,
              ),
              SizedBox(height: 20 * Dimentions.hUnit),
              //
              // LOCATION
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SmallText(
                    text: 'Set location on map - ',
                    size: 18 * Dimentions.hUnit,
                  ),
                  InkWell(
                    onTap: () async {
                      _hideKeyboard();
                      FocusScope.of(context).unfocus();

                      var geoPoint = await showSimplePickerLocation(
                        context: context,
                        isDismissible: true,
                        radius: 20 * Dimentions.hUnit,
                        title: 'Pick location',
                        textConfirmPicker: 'pick',
                        // initCurrentUserPosition:
                        //     UserTrackingOption(enableTracking: true),
                        initPosition: GeoPoint(
                            latitude: _myPosition.latitude,
                            longitude: _myPosition.longitude),
                        zoomOption: ZoomOption(initZoom: 16, minZoomLevel: 10),
                      );
                      _shopLocation = geoPoint;
                      print(_shopLocation.toString());
                    },
                    child: AppIcon(
                      icon: Icons.my_location_sharp,
                      backgroundColor: AppColors.iconColorRedLight,
                      iconColor: AppColors.iconColorRed,
                      iconSize: 50 * Dimentions.hUnit,
                    ),
                  ),
                  SizedBox(width: 20 * Dimentions.hUnit),
                ],
              ),
              SizedBox(height: 10 * Dimentions.hUnit),

              //
              // CREATE SHOP BUTTON
              ElevatedButton(
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                        print('*********************create shop pressed');
                        _registerShop();
                      },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 40 * Dimentions.hUnit,
                      vertical: 8 * Dimentions.hUnit,
                    ),
                    shadowColor: Colors.white),
                child: BigText(
                  text: 'Create shop',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  size: 25 * Dimentions.hUnit,
                ),
              ),
              SizedBox(height: 30 * Dimentions.hUnit),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget bottomSheet() {

//   return Container(
//     height: 100 * Dimentions.hUnit,
//     width: Dimentions.screenWidth,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(20 * Dimentions.hUnit),
//         topRight: Radius.circular(20 * Dimentions.hUnit),
//       ),
//     ),
//     margin: EdgeInsets.symmetric(
//         horizontal: 20 * Dimentions.hUnit, vertical: 20 * Dimentions.hUnit),
//     child: Column(
//       children: [
//         BigText(text: 'Choose shop image'),
//         SizedBox(height: 20 * Dimentions.hUnit),
//         Row(
//           children: [
//             TextButton(
//               onPressed: () {},
//               child: Column(
//                 children: [
//                   Icon(Icons.camera),
//                   Text('Camera'),
//                 ],
//               ),
//             ),
//             TextButton(
//               onPressed: () {},
//               child: Column(
//                 children: [
//                   Icon(Icons.camera),
//                   Text('Camera'),
//                 ],
//               ),
//             ),
//           ],
//         )
//       ],
//     ),
//   );
// }



import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/models/shop.dart';

import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/app_icon.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/icon_and_text_widget.dart';
import 'package:food_buddy_frontend/widgets/loading_indicator.dart';
import 'package:food_buddy_frontend/controllers/location_controller.dart';
import 'package:food_buddy_frontend/widgets/phone_number.dart';

import 'package:food_buddy_frontend/widgets/small_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MyShopInfo extends StatelessWidget {
  const MyShopInfo({super.key});

  @override
  Widget build(BuildContext context) {
    // THE SHOP IS AVAILABLE
    Shop shop = Get.find<ShopController>().shopOnShopDetails;
    // ACCESS THE CURRENT LOCATION
    Position myLocation = Get.find<LocationController>().myLocation;

    // GET THE ROUTE
    Get.find<LocationController>().getRoutePoints(
        lon1: shop.longitude,
        lat1: shop.latitude,
        lon2: myLocation.longitude,
        lat2: myLocation.latitude);

    return GetBuilder<LocationController>(
      builder: (locationController) {
        return locationController.isLoading
            ? const LoadingIndicator()
            : Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 30 * Dimentions.hUnit,
                  vertical: 20 * Dimentions.hUnit,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //
                    // SHOP NAME
                    BigText(
                      text: shop.shopName,
                      fontWeight: FontWeight.w500,
                      size: 28 * Dimentions.hUnit,
                    ),
                    //SizedBox(height: 20 * Dimentions.hUnit),
                    //
                    // PHONE NUMBER
                    Row(
                      children: [
                        AppIcon(
                            icon: Icons.call_outlined,
                            backgroundColor: AppColors.iconColorYellowLight,
                            iconColor: AppColors.iconColorYellow,
                            iconSize: 36 * Dimentions.hUnit),
                        SizedBox(width: 10 * Dimentions.hUnit),
                        PhoneNumber(phoneNumber: shop.phoneNumber, size: 18),
                      ],
                    ),

                    //SizedBox(height: 30 * Dimentions.hUnit),
                    //
                    // OPEN TIME
                    IconAndTextWidget(
                      icon: Icons.access_time,
                      text: '8.00 am - 7.00 pm',
                      backgroundColor: AppColors.iconColorPurpleLight,
                      iconColor: AppColors.iconColorPurple,
                      iconSize: 36 * Dimentions.hUnit,
                      textSize: 18 * Dimentions.hUnit,
                      textColor: AppColors.darkGreyColor,
                    ),
                    //SizedBox(height: 30 * Dimentions.hUnit),
                    //
                    // ADDRESS
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        // ICON
                        Container(
                          width: 36 * Dimentions.hUnit,
                          height: 36 * Dimentions.hUnit,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(18 * Dimentions.hUnit),
                            color: AppColors.iconColorGreenLight,
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 27 * Dimentions.hUnit,
                            color: AppColors.iconColorGreen,
                          ),
                        ),
                        SizedBox(width: 10 * Dimentions.hUnit),
                        //
                        // ADDRESS TEXT
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SmallText(
                              text: shop.address.addressLine1,
                              size: 18 * Dimentions.hUnit,
                              color: AppColors.darkGreyColor,
                            ),
                            SizedBox(height: 5 * Dimentions.hUnit),
                            SmallText(
                              text: shop.address.addressLine2,
                              size: 18 * Dimentions.hUnit,
                              color: AppColors.darkGreyColor,
                            ),
                            SizedBox(height: 5 * Dimentions.hUnit),
                            SmallText(
                              text: shop.address.addressLine3,
                              size: 18 * Dimentions.hUnit,
                              color: AppColors.darkGreyColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    //SizedBox(height: 40 * Dimentions.hUnit),

                    //
                    // DISTANCE
                    IconAndTextWidget(
                      icon: Icons.timeline,
                      text:
                          '${locationController.distance!.toStringAsFixed(2)} km',
                      backgroundColor: AppColors.iconColorRedLight,
                      iconColor: AppColors.iconColorRed,
                      iconSize: 36 * Dimentions.hUnit,
                      textSize: 18 * Dimentions.hUnit,
                      textColor: AppColors.darkGreyColor,
                    ),

                    //
                    // LOCATION ON MAP
                    Container(
                      width: double.maxFinite,
                      height: 350 * Dimentions.hUnit,
                      decoration: BoxDecoration(
                        color: AppColors.iconColorPurpleLight,
                        borderRadius:
                            BorderRadius.circular(20 * Dimentions.hUnit),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(20 * Dimentions.hUnit),
                        child: GetBuilder<LocationController>(
                          builder: (locationController) {
                            print(
                                'map is loading - ${locationController.isLoading}');
                            print(
                                'map is loading *********- ${Get.find<LocationController>().isLoading}');
                            return locationController.isLoading
                                ? LoadingIndicator()
                                : FlutterMap(
                                    options: MapOptions(
                                      initialCenter:
                                          LatLng(shop.latitude, shop.longitude),
                                      initialZoom: 14,
                                      interactionOptions:
                                          const InteractionOptions(
                                              flags: InteractiveFlag.all &
                                                  ~InteractiveFlag.rotate),
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.example.app',
                                      ),
                                      RichAttributionWidget(
                                        attributions: [
                                          TextSourceAttribution(
                                            'OpenStreetMap contributors',
                                            onTap: () => launchUrl(Uri.parse(
                                                'https://openstreetmap.org/copyright')),
                                          ),
                                        ],
                                      ),
                                      //
                                      // ROUTE
                                      PolylineLayer(
                                        polylines: [
                                          Polyline(
                                              points: locationController
                                                  .routePoints,
                                              color: Colors.blue,
                                              strokeWidth: 5),
                                        ],
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          //
                                          // SHOP MARKER
                                          Marker(
                                            height: 50 * Dimentions.hUnit,
                                            width: 50 * Dimentions.hUnit,
                                            alignment: Alignment.topCenter,
                                            point: LatLng(
                                                shop.latitude, shop.longitude),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(() => Scaffold());
                                              },
                                              child: Icon(
                                                Icons.location_on_sharp,
                                                color: AppColors.redColor,
                                                size: 50 * Dimentions.hUnit,
                                              ),
                                            ),
                                          ),
                                          //
                                          // USER MARKER
                                          Marker(
                                            alignment: Alignment.topCenter,
                                            point: LatLng(myLocation.latitude,
                                                myLocation.longitude),
                                            child: Icon(
                                              Icons.person,
                                              color: AppColors.lightBlueColor,
                                              size: 50 * Dimentions.hUnit,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}

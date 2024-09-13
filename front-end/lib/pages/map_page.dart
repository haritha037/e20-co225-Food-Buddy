import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_buddy_frontend/controllers/location_controller.dart';
import 'package:food_buddy_frontend/controllers/product_controller.dart';
import 'package:food_buddy_frontend/controllers/shop_controller.dart';
import 'package:food_buddy_frontend/models/shop.dart';
import 'package:food_buddy_frontend/routes/route_helper.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/big_text.dart';
import 'package:food_buddy_frontend/widgets/loading_indicator.dart';
import 'package:food_buddy_frontend/widgets/shop_on_map.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _searchRadiusController = TextEditingController();
  List<Shop> _activeShops = [];

  @override
  void dispose() {
    _searchRadiusController.dispose();
    super.dispose();
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _drawCircle() {
    _hideKeyboard();
    double r = double.parse(_searchRadiusController.text);
    Get.find<LocationController>().setSearchRadius(r);
  }

  // void _bringMarkerToFront(int index) {
  //   setState(() {
  //     print('Inside _bringMarkerToFront');
  //     final shop = _activeShops.removeAt(index);
  //     print('active shops before');
  //     _activeShops.map(
  //       (e) {
  //         print(e.shopName);
  //       },
  //     );
  //     _activeShops.add(shop); // Add the shop to the end of the list
  //     print('active shops after');
  //     _activeShops.map(
  //       (e) {
  //         print(e.shopName);
  //       },
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Get.find<ShopController>().getActiveShops();
    //Get.find<LocationController>().setSearchRadius(5);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10 * Dimentions.hUnit),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 20 * Dimentions.hUnit),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //
                    // RADIUS INPUT
                    Container(
                      width: 180 * Dimentions.hUnit,
                      child: TextField(
                        controller: _searchRadiusController,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        onSubmitted: (value) {
                          _drawCircle();
                        },
                        decoration: InputDecoration(
                          //label: Text('search radius(km)'),
                          hintText: 'search radius',
                          hintStyle:
                              const TextStyle(color: AppColors.lightGreyColor),
                          //alignLabelWithHint: true,
                          suffix: Text('km'),
                          counterText: '',

                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.lightBlueColor),
                            borderRadius: BorderRadius.circular(
                              30 * Dimentions.hUnit,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: AppColors.mainColor),
                            borderRadius: BorderRadius.circular(
                              30 * Dimentions.hUnit,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10 * Dimentions.hUnit),
                    //
                    // BUTTON
                    GestureDetector(
                      onTap: _drawCircle,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10 * Dimentions.hUnit,
                            vertical: 5 * Dimentions.hUnit),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius:
                              BorderRadius.circular(10 * Dimentions.hUnit),
                        ),
                        child: BigText(
                          text: 'draw a circle',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20 * Dimentions.hUnit),

              //
              // MAP
              Container(
                // margin: EdgeInsets.symmetric(
                //   horizontal: 0 * Dimentions.hUnit,
                //   vertical: 10 * Dimentions.hUnit,
                // ),
                width: double.maxFinite,
                height: Dimentions.screenHeight,
                decoration: BoxDecoration(
                  color: AppColors.iconColorPurpleLight,
                  borderRadius: BorderRadius.circular(20 * Dimentions.hUnit),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20 * Dimentions.hUnit),
                    child: GetBuilder<LocationController>(
                      builder: (locationController) {
                        return GetBuilder<ShopController>(
                          builder: (shopController) {
                            double searchRadius =
                                locationController.searchRadius;

                            if (locationController.isLoading) {
                              return const LoadingIndicator();
                            }

                            _activeShops = shopController.activeShopsList;

                            Position myPosition =
                                Get.find<LocationController>().myLocation;
                            LatLng myLocation = LatLng(
                                myPosition.latitude, myPosition.longitude);

                            return FlutterMap(
                              options: MapOptions(
                                onTap: (tapPosition, point) {
                                  _hideKeyboard();
                                },
                                initialCenter: myLocation,
                                initialZoom: 12.5,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.all &
                                      ~InteractiveFlag.rotate,
                                ),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.app',
                                ),

                                // RichAttributionWidget(
                                //   attributions: [
                                //     TextSourceAttribution(
                                //       'OpenStreetMap contributors',
                                //       onTap: () => launchUrl(Uri.parse(
                                //           'https://openstreetmap.org/copyright')),
                                //     ),
                                //   ],
                                // ),

                                // PolylineLayer(
                                //   polylines: [
                                //     Polyline(
                                //         points: locationController.routePoints,
                                //         color: Colors.blue,
                                //         strokeWidth: 5),
                                //   ],
                                // ),

                                CircleLayer(
                                  circles: [
                                    CircleMarker(
                                      point: myLocation,
                                      radius: searchRadius * 1000,
                                      useRadiusInMeter: true,
                                      borderColor: AppColors.darkGreyColor,
                                      color: AppColors.lightBlueColor
                                          .withOpacity(0.1),
                                      borderStrokeWidth: 1,
                                    ),
                                  ],
                                ),

                                MarkerLayer(
                                  markers: [
                                    //
                                    // SHOP MARKER
                                    ...List.generate(
                                      _activeShops.length,
                                      (index) {
                                        Shop shop = _activeShops[index];
                                        return Marker(
                                          width: 200 * Dimentions.hUnit,
                                          height: 200 * Dimentions.hUnit,
                                          alignment: Alignment.topCenter,
                                          point: LatLng(
                                              shop.latitude, shop.longitude),
                                          child: ShopOnMap(shop: shop),
                                        );
                                      },
                                    ),

                                    //
                                    // USER MARKER
                                    Marker(
                                      point: myLocation,
                                      alignment: Alignment.topCenter,
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
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

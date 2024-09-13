import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';

class Oath2Icon extends StatelessWidget {
  final String assetImagePath;
  const Oath2Icon({super.key, required this.assetImagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60 * Dimentions.hUnit,
      height: 60 * Dimentions.hUnit,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30 * Dimentions.hUnit),
        image: DecorationImage(
          image: AssetImage(
            assetImagePath,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

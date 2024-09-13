import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';

class NotFound extends StatelessWidget {
  final String message;
  const NotFound({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300 * Dimentions.hUnit,
            height: 300 * Dimentions.hUnit,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/not_found.png'),
              ),
            ),
          ),
          //SmallText(text: message, size: 18 * Dimentions.hUnit),
        ],
      ),
    );
  }
}

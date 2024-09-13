import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneNumber extends StatelessWidget {
  final String phoneNumber;
  final double size;
  const PhoneNumber({super.key, required this.phoneNumber, required this.size});

  Future<void> _makePhoneCall(String phoneNumber) async {
    print('tapped on phone number');
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print('failed to call');
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _makePhoneCall(phoneNumber),
      child: SmallText(
        text: phoneNumber,
        size: size,
        color: AppColors.lightBlueColor,
      ),
    );
  }
}

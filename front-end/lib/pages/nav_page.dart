import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/pages/account_page.dart';
import 'package:food_buddy_frontend/pages/auth/sign_in_page.dart';
import 'package:food_buddy_frontend/pages/auth/sign_up_page.dart';
import 'package:food_buddy_frontend/pages/home_page.dart';
import 'package:food_buddy_frontend/pages/map_page.dart';
import 'package:food_buddy_frontend/pages/shop%20page/shop_on_nav.dart';
import 'package:food_buddy_frontend/pages/shop%20page/shop_sign_up_page.dart';
import 'package:food_buddy_frontend/utils/colors.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  //
  // KEEP TRACK OF THE SELECTED PAGE
  int _selectedPage = 1;

  List<Widget> pages = [
    const ShopOnNav(),
    const HomePage(),
    MapPage(),
    const AccountPage(),
  ];

  void onTapNav(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      // CONTENT
      body: pages[_selectedPage],
      //
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: AppColors.lightGreyColor,
        currentIndex: _selectedPage,
        onTap: onTapNav,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_sharp),
            label: 'my shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'me',
          ),
        ],
      ),
    );
  }
}

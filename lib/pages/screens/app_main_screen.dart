import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/core/utils/consts.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/pages/screens/User_Activity/favorite_screen.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/pages/screens/food_app_home_screen.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/pages/screens/profile_screen.dart';
import 'package:iconsax/iconsax.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int currentIndex = 0;
  final List<Widget> _pages = [
    FoodAppHomeScreen(),
    FavoriteScreen(),
    ProfileScreen(),
    Scaffold(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 90,
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItems(Iconsax.home_15, "A", 0),
              SizedBox(width: 10),
              _buildNavItems(Iconsax.heart, "B", 1),
              SizedBox(width: 80),
              _buildNavItems(Icons.person_outline, "C", 2),
              SizedBox(width: 10),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildNavItems(Iconsax.shopping_cart, "D", 3),
                  Positioned(
                    right: -7,
                    top: 16,
                    child: CircleAvatar(
                      backgroundColor: red,
                      radius: 10,
                      child: Text("0", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  Positioned(
                    right: 153,
                    top: -17,
                    child: CircleAvatar(
                      backgroundColor: red,
                      radius: 35,
                      child: Icon(
                        CupertinoIcons.search,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItems(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: currentIndex == index ? Colors.red : Colors.grey,
          ),
          SizedBox(height: 3),
          CircleAvatar(
            radius: 3,
            backgroundColor: currentIndex == index ? red : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

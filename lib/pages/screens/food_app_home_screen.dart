import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/core/utils/consts.dart';

class FoodAppHomeScreen extends StatefulWidget {
  const FoodAppHomeScreen({super.key});

  @override
  State<FoodAppHomeScreen> createState() => _FoodAppHomeScreenState();
}

class _FoodAppHomeScreenState extends State<FoodAppHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarParts(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBanners(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container appBanners() {
    return Container(
                height: 160,
                padding: EdgeInsets.only(top: 25, right: 25, left: 25),
                decoration: BoxDecoration(
                  color: imageBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: "The Fastest In Delivery",
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: "Food",
                                  style: TextStyle(color: red),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: red,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "Order Now",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset("assets/food-delivery/courier.png"),
                  ],
                ),
              );
  }

  AppBar appbarParts() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      actions: [
        SizedBox(width: 25),
        Container(
          height: 45,
          width: 45,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: grey1,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset("assets/food-delivery/icon/dash.png"),
        ),
        Spacer(),
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 18, color: red),
            SizedBox(width: 5),
            Text(
              "Karur, TamilNadu",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 5),
            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: orange),
          ],
        ),
        Spacer(),
        Container(
          height: 45,
          width: 45,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: grey1,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset("assets/food-delivery/profile.png"),
        ),
        SizedBox(width: 25),
      ],
    );
  }
}

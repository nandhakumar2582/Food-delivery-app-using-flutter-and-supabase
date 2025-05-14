import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/core/models/categories_model.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/core/models/product_model.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/core/utils/consts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FoodAppHomeScreen extends StatefulWidget {
  const FoodAppHomeScreen({super.key});

  @override
  State<FoodAppHomeScreen> createState() => _FoodAppHomeScreenState();
}

class _FoodAppHomeScreenState extends State<FoodAppHomeScreen> {
  late Future<List<CategoryModel>> futureCategories = fetchCategories();
  late Future<List<FoodModel>> futureFoodProduct = Future.value([]);
  List<CategoryModel> categories = [];
  String? selectedCategory;
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    try {
      final categories = await futureCategories;
      if (categories.isNotEmpty) {
        log("categories $categories");
        setState(() {
          this.categories = categories;
          selectedCategory = categories.first.name;
          //fetch food product
          futureFoodProduct = fetchFoodProduct(selectedCategory!);
        });
      }
    } catch (error) {
      log("Initialization error: $error");
    }
  }

  // fetch product data
  Future<List<FoodModel>> fetchFoodProduct(String category) async {
    try {
      final response = await Supabase.instance.client
          .from("food_product")
          .select()
          .eq("category", category);
      log("response $response");
      return (response as List)
          .map((json) => FoodModel.fromJson(json))
          .toList();
    } catch (error) {
      log("Error fetching product: $error");
      return [];
    }
  }

  // fetch category data
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response =
          await Supabase.instance.client.from("category_items").select();
      log("response $response");
      return (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (error) {
      log("Error fetching categories: $error");
      return [];
    }
  }

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
                SizedBox(height: 25),
                Text(
                  "Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _buildCategoryList(),
          SizedBox(height: 30),
          viewAll(),
          SizedBox(height: 30),
          _buildProductSection(),
        ],
      ),
    );
  }

  Widget _buildProductSection() {
    return Expanded(
      child: FutureBuilder<List<FoodModel>>(
        future: futureFoodProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return Center(child: Text("N0 products found"));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 25 : 0,
                  right: index == products.length - 1 ? 25 : 0,
                ),
                //   child:
              );
            },
          );
        },
      ),
    );
  }

  Padding viewAll() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Popular Now",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            child: Row(
              children: [
                Text("View All", style: TextStyle(color: orange)),
                SizedBox(width: 5),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return FutureBuilder(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox.shrink();
        }
        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 15 : 0, right: 15),
                child: GestureDetector(
                  onTap: () => handleCategoryTap(category.name),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedCategory == category.name ? red : grey1,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                selectedCategory == category.name
                                    ? Colors.white
                                    : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            category.image,
                            width: 20,
                            height: 20,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    Icon(Icons.fastfood),
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          category.name,
                          style: TextStyle(
                            color:
                                selectedCategory == category.name
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void handleCategoryTap(String category) {
    if (selectedCategory == category) return;
    setState(() {
      selectedCategory = category;
      //fetch food products
      futureFoodProduct = fetchFoodProduct(category);
    });
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: "The Fastest In Delivery",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(text: "Food", style: TextStyle(color: red)),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
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

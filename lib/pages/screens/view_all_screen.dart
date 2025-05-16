import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/Widgets/products_items_display.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/core/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewAllProductsScreen extends StatefulWidget {
  const ViewAllProductsScreen({super.key});

  @override
  State<ViewAllProductsScreen> createState() => _ViewAllProductsScreenState();
}

class _ViewAllProductsScreenState extends State<ViewAllProductsScreen> {
  final supabase = Supabase.instance.client;
  List<FoodModel> products = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchFoodProduct();
  }

  // to fetch product data from supabase
  Future<void> fetchFoodProduct() async {
    try {
      final response =
          await Supabase.instance.client.from("food_product").select();
      final data = response as List;
      setState(() {
        products = data.map((json) => FoodModel.fromJson(json)).toList();
        isLoading = false;
      });

      log("response $response");
    } catch (error) {
      log("Error fetching product: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text("All Products"),
        backgroundColor: Colors.blue[50],
        forceMaterialTransparency: true,
        centerTitle: true,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                itemCount: products.length,
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.59,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return ProductsItemsDisplay(foodModel: products[index]);
                },
              ),
    );
  }
}

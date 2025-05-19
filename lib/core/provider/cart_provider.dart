import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/core/provider/Model/cart_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartProvider extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  //to calculate the total price

  double get totalPrice => _items.fold(
    0,
    (sum, item) => sum + (item.productData['price'] ?? 0) * item.quantity,
  );

  CartProvider() {
    loadCart();
  }

  // to load the cart items

  Future<void> loadCart() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;
    try {
      final response = await _supabaseClient
          .from("cart")
          .select()
          .eq("user_id", userId);
      _items =
          (response as List).map((item) => CartItem.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      log("Error loading cart: $e");
    }
  }

  Future<void> addCart(
    String productId,
    Map<String, dynamic> productData,
    int selectQuantity,
  ) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;
    try {
      final existing =
          await _supabaseClient
              .from("cart")
              .select()
              .eq("user_id", userId)
              .eq("product_id", productId)
              .maybeSingle();
      if (existing != null) {
        final newQuantity = (existing['quantity'] ?? 0) + selectQuantity;
        await _supabaseClient
            .from("cart")
            .update({'quantity': newQuantity})
            .eq("product_id", productId)
            .eq("user_id", userId);
        final index = _items.indexWhere(
          (item) => item.productId == productId && item.userId == userId,
        );
        if (index != -1) {
          _items[index].quantity = newQuantity;
        }
      } else {
        final response =
            await _supabaseClient.from('cart').insert({
              'product_id': productId,
              'product_data': productData,
              "quantity": selectQuantity,
              "user_id": userId,
            }).select();

        if (response.isNotEmpty) {
          _items.add(
            CartItem(
              id: response.first['id'],
              productId: productId,
              productData: productData,
              quantity: selectQuantity,
              userId: userId,
            ),
          );
        }
      }
      notifyListeners();
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }

  Future<void> removeItem(String itemId) async {
    try {
      await _supabaseClient.from('cart').delete().eq('id', itemId);
      _items.removeWhere((item) => item.id == itemId);
      notifyListeners();
    } catch (e) {
      log("Error removing item: $e");
    }
  }
}

final cartProvider = ChangeNotifierProvider<CartProvider>(
  (ref) => CartProvider(),
);

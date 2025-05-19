import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final favoriteProvider = ChangeNotifierProvider((ref) => FavoriteProvider());

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  List<String> get favorite => _favoriteIds;
  String? get userId => _supabaseClient.auth.currentUser?.id;

  FavoriteProvider() {
    // load the favourite provider
  }
  void reset() {
    _favoriteIds = [];
    notifyListeners();
  }

  //Toggle favourite state
  Future<void> toggleFavourite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      // remove favourite
      await _removeFavorite(productId);
    } else {
      _favoriteIds.add(productId);
      // add favorite
      await _addFavorite(productId);
    }
    notifyListeners();
  }

  // check if product is favorite
  bool isExist(String productId) {
    return _favoriteIds.contains(productId);
  }

  //add favorite to supabase
  Future<void> _addFavorite(String productId) async {
    try {
      await _supabaseClient.from("favorites").insert({
        "user_id": userId,
        "product_id": productId,
      });
    } catch (e) {
      log("Error adding favorite: $e");
    }
  }

  //remove favorite from supabase
  Future<void> _removeFavorite(String productId) async {
    try {
      await _supabaseClient.from("favorites").delete().match(({
        "user_id": userId!,
        "product_id": productId,
      }));
    } catch (e) {
      log("Error removing favorite: $e");
    }
  }

  //Load favorite from supabase
  Future<void> loadFavorites() async {
    if (userId == null) return;
    try {
      final data = await _supabaseClient
          .from("favorites")
          .select("product_id")
          .eq("user_id", userId!);
      _favoriteIds =
          data.map<String>((row) => row['product_id'] as String).toList();
    } catch (e) {
      log("Error loading favorite: $e");
    }
  }
}

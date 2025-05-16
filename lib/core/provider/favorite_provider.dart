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
    } else {
      _favoriteIds.add(productId);
      // add favorite
    }
    notifyListeners();
  }
  
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/core/provider/cart_provider.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/core/provider/favorite_provider.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/service/auth_service.dart';

final AuthService _authService = AuthService();

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _authService.logout(context);
              ref.invalidate(favoriteProvider);
              ref.invalidate(cartProvider);
            },
            child: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}

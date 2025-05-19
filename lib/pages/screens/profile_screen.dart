import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/core/provider/favorite_provider.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/service/auth_service.dart';

class ProfileScreen extends ConsumerWidget {
  ProfileScreen({super.key});

  final AuthService _authService = AuthService();

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
            },
            child: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}

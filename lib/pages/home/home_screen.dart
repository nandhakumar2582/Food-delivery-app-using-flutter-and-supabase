import 'package:flutter/material.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/service/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => _authService.logout(context),
            child: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}

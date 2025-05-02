import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/pages/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<String?> signup(String email, String password) async {
    try {
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return null;
      }
      return "An unknown error occurred";
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Error:$e";
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return null;
      }
      return "Invalid email or password";
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Error:$e";
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      if (!context.mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (e) {
      log("Logout error $e");
    }
  }
}

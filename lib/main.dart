import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/pages/auth/login_screen.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/pages/screens/app_main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://oqzefiuxreckmmgygxer.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9xemVmaXV4cmVja21tZ3lneGVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYxNjc2OTMsImV4cCI6MjA2MTc0MzY5M30.Qqf93wSt8_flqfYhqvYC3X35MFqMl4JQ-4hKF09ryVM",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(debugShowCheckedModeBanner: false, home: AuthCheck()),
    );
  }
}

class AuthCheck extends StatelessWidget {
  final supabase = Supabase.instance.client;
  AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = supabase.auth.currentSession;
        if (session != null) {
          return AppMainScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

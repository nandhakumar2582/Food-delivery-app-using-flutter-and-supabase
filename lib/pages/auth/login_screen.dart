import 'package:flutter/material.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/Widgets/my_button.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/Widgets/snack_bar.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/pages/auth/signup_screen.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/pages/screens/onboarding_screen.dart';
import 'package:food_delivery_app_using_flutter_and_supabase/service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;
  bool isPasswordHidden = true;

  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    final result = await _authService.login(email, password);
    if (result == null) {
      //success case
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Logged in successfully", Colors.green);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Signup Failed: $result", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Image.asset(
                "assets/login.jpg",
                width: double.maxFinite,
                height: 500,
                fit: BoxFit.cover,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: isPasswordHidden,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                    icon: Icon(
                      isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                    width: double.maxFinite,
                    child: MyButton(onTap: _login, buttonText: "Login"),
                  ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text(
                      "Signup here",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        // letterSpacing: -1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

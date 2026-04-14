import 'package:flutter/material.dart';
import 'package:smart_skincare_frontend/features/auth/signup_screen.dart';
import '../home/main_navigation.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPink = Color(0xFFF1ABB9);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign in to continue your journey",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),

              // Champ Email
              _buildTextField(
                hint: "Email Address",
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),

              // Champ Password
              _buildTextField(
                hint: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              // Mot de passe oublié
              // Dans LoginScreen
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: primaryPink),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainNavigation()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPink,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 2,
                  shadowColor: primaryPink.withOpacity(0.5),
                ),
                child: const Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),


              const SizedBox(height: 40),

              // Séparateur "Or continue with"
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Or continue with", style: TextStyle(color: Colors.grey[400])),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 30),

              // Boutons Sociaux
              Row(
                children: [
                  Expanded(child: _buildSocialButton("Google", "assets/google_logo.png", Colors.white)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildSocialButton("Apple", "assets/apple_logo.png", Colors.white, isApple: true)),
                ],
              ),

              const Spacer(),

              // Lien Sign Up
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: primaryPink, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, String assetPath, Color bgColor, {bool isApple = false}) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isApple ? Icons.apple : Icons.g_mobiledata, size: 28), // Utilisation d'icônes intégrées pour l'exemple
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
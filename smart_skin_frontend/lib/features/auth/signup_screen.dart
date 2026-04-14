import 'package:flutter/material.dart';
import '../home/main_navigation.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPink = Color(0xFFF1ABB9);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Start your skincare journey today",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 40),

                // Champ Full Name
                _buildTextField(
                  hint: "Full Name",
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),

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

                const SizedBox(height: 40),

                // Bouton Create Account
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
                  child: const Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),

                const SizedBox(height: 40),

                // Séparateur
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
                    Expanded(child: _buildSocialButton("Google", Icons.g_mobiledata)),
                    const SizedBox(width: 20),
                    Expanded(child: _buildSocialButton("Apple", Icons.apple)),
                  ],
                ),

                const SizedBox(height: 40),

                // Lien pour retourner vers Sign In
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Retourne à l'écran de Login
                        },
                        child: const Text(
                          "Sign In",
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
      ),
    );
  }

  // Widgets réutilisables (TextField et SocialButton)
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

  Widget _buildSocialButton(String label, IconData icon) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPink = Color(0xFFF1ABB9);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Forgot Password",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter your email address and we will send you a code to reset your password.",
              style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 40),

            // Champ Email
            _buildTextField(
              hint: "Email Address",
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 30),

            // Bouton Send Code
            ElevatedButton(
              onPressed: () {
                // Logique pour envoyer l'email
                _showSuccessDialog(context, primaryPink);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPink,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 2,
                shadowColor: primaryPink.withOpacity(0.5),
              ),
              child: const Text(
                  "Send Reset Link",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4)
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  // Petite boîte de dialogue pour confirmer l'envoi
  void _showSuccessDialog(BuildContext context, Color pink) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Email Sent", textAlign: TextAlign.center),
        content: const Text(
          "Check your inbox for the instructions to reset your password.",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK", style: TextStyle(color: pink, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
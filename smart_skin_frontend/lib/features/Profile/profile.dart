import 'package:flutter/material.dart';
// Remplace par le bon chemin vers ton écran de login
import '../auth/login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // La couleur rose principale de ton application
    const Color primaryPink = Color(0xFFF1ABB9);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
            "Profile",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              // Action pour les paramètres généraux
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. Header : Photo de profil, Nom et Type de peau
            _buildProfileHeader(primaryPink),

            const SizedBox(height: 30),

            // 2. Statistiques : Streak et Glow Points
            _buildStatsRow(primaryPink),

            const SizedBox(height: 35),

            // 3. Menu : Account Settings
            _buildMenuSection("Account Settings", [
              _buildMenuItem(Icons.person_outline, "Personal Information", () {
                // Action : Editer profil
              }),
              _buildMenuItem(Icons.notifications_none, "Notifications", () {
                // Action : Réglages notifications
              }),
              _buildMenuItem(Icons.lock_outline, "Privacy & Security", () {}),
            ]),

            const SizedBox(height: 25),

            // 4. Menu : Support & Logout
            _buildMenuSection("Support & More", [
              _buildMenuItem(Icons.help_outline, "Help Center", () {}),
              _buildMenuItem(Icons.info_outline, "About GlowSense", () {}),

              // Bouton Logout avec dialogue de confirmation
              _buildMenuItem(
                  Icons.logout,
                  "Logout",
                      () => _showLogoutDialog(context),
                  isLogout: true
              ),
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE COMPOSANTS ---

  Widget _buildProfileHeader(Color pink) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: pink, width: 3),
                image: const DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/150"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(Icons.edit, size: 20, color: pink),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Text("Sarah ✨", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text("Skin Type: Oily / Acne-prone", style: TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildStatsRow(Color pink) {
    return Row(
      children: [
        Expanded(child: _buildStatCard("24", "Day Streak", Icons.local_fire_department, Colors.orangeAccent)),
        const SizedBox(width: 15),
        Expanded(child: _buildStatCard("1,250", "Glow Points", Icons.stars, pink)),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLogout ? Colors.red[50] : const Color(0xFFFFFAFB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isLogout ? Colors.red : Colors.black54, size: 22),
      ),
      title: Text(
          title,
          style: TextStyle(
              color: isLogout ? Colors.red : Colors.black87,
              fontWeight: FontWeight.w500
          )
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  // --- LOGIQUE DE DIALOGUE ---

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Déconnexion et retour à l'écran de Login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
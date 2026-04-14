import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Définition des couleurs exactes basées sur l'image
    const Color primaryPink = Color(0xFFF1ABB9);
    const Color backgroundTop = Color(0xFFFFFAFB);
    const Color textBodyGrey = Color(0xFF8E8E93);

    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc pur en bas
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.4], // Le dégradé s'estompe rapidement vers le blanc
            colors: [backgroundTop, Colors.white],
          ),
        ),
        child: Column(
          children: [
            const Spacer(flex: 2), // Espace flexible pour centrer le haut

            // Logo GlowSense avec badge superposé
            Stack(
              alignment: Alignment.center,
              children: [
                _buildLogoCircle(),
                // Badge d'analyse superposé en bas à droite
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: _buildAnalysisBadge(primaryPink),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "GlowSense",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your AI-Powered Skincare Assistant",
              textAlign: TextAlign.center,
              style: TextStyle(color: textBodyGrey, fontSize: 16),
            ),

            const Spacer(flex: 1), // Espace avant les fonctionnalités

            // Liste des fonctionnalités
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  _buildFeatureItem(
                    iconData: Icons.crop_free, // Icône de scan/focus
                    iconColor: primaryPink,
                    title: "Smart Skin Analysis",
                    description:
                    "Advanced AI technology analyzes your skin condition in seconds",
                    bodyColor: textBodyGrey,
                  ),
                  const SizedBox(height: 25),
                  _buildFeatureItem(
                    iconData: Icons.auto_awesome, // Icône d'étincelles
                    iconColor: const Color(0xFF91C4EA), // Bleu clair
                    title: "Personalized Recommendations",
                    description:
                    "Get customized skincare routines tailored just for you",
                    bodyColor: textBodyGrey,
                  ),
                  const SizedBox(height: 25),
                  _buildFeatureItem(
                    iconData: Icons.trending_up, // Icône de graphique
                    iconColor: const Color(0xFFE5B98A), // Beige/Doré
                    title: "Track Your Progress",
                    description: "Monitor your skin's improvement over time",
                    bodyColor: textBodyGrey,
                  ),
                ],
              ),
            ),

            const Spacer(flex: 3), // Grand espace flexible avant le bouton

            // Bouton Get Started
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPink,
                  minimumSize: const Size(double.infinity, 58),
                  elevation: 0, // Pas d'ombre pour un look plat moderne
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100), // Bouton "pilule"
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Texte de pied de page
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Join thousands of users on their skincare journey",
                textAlign: TextAlign.center,
                style: TextStyle(color: textBodyGrey, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour le grand cercle de logo en dégradé
  Widget _buildLogoCircle() {
    return Container(
      height: 140,
      width: 140,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE5B3BC), // Rose haut-gauche
            Color(0xFFC7CCF1), // Bleu bas-droite
          ],
        ),
      ),
      child: const Icon(Icons.auto_awesome, size: 70, color: Colors.white),
    );
  }

  // Widget pour le petit badge d'analyse blanc superposé
  Widget _buildAnalysisBadge(Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(Icons.crop_free, size: 28, color: iconColor),
    );
  }

  // Widget réutilisable pour chaque ligne de fonctionnalité
  Widget _buildFeatureItem({
    required IconData iconData,
    required Color iconColor,
    required String title,
    required String description,
    required Color bodyColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Conteneur d'icône arrondi
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(iconData, color: iconColor, size: 24),
        ),
        const SizedBox(width: 18),
        // Textes
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: TextStyle(
                  color: bodyColor,
                  fontSize: 14,
                  height: 1.3, // Hauteur de ligne pour une meilleure lisibilité
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
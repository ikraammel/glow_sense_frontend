import 'package:flutter/material.dart';
import '../skin_analysis/skin_scan_page.dart';
import '../skin_analysis/product_scan_page.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 25),
              _buildHealthCard(),
              SizedBox(height: 25),
              Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SkinScanPage()),
                        );
                      },
                      child: _buildActionCard("Scan Skin", Icons.camera_alt, Color(0xFFFFEBF2)),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProductScanPage()),
                        );
                      },
                      child: _buildActionCard("Scan Product", Icons.qr_code_scanner, Color(0xFFEBF8FF)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              _buildRoutineSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good morning,", style: TextStyle(color: Colors.grey)),
            Text("Sarah ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        Icon(Icons.notifications_none_outlined, size: 30),
      ],
    );
  }

  Widget _buildHealthCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF8A4B4), // Rose du visuel
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Skin Health", style: TextStyle(color: Colors.white70)),
              Text("82%", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Great progress! Keep it up.", style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          // Icône circulaire de progression
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(value: 0.82, color: Colors.white, strokeWidth: 6),
              Icon(Icons.auto_awesome, color: Colors.white),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.black54),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildRoutineSection() {
    return Column(
      children: [
        // En-tête de la section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Routine",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {}, // Action pour voir tout
              child: Row(
                children: [
                  const Text("View All", style: TextStyle(color: Color(0xFFF8A4B4))),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFF8A4B4)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        // Carte de la routine
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Cercle avec icône Soleil (Morning)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFE8F5E9), // Vert très clair
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.wb_sunny_outlined, color: Colors.orangeAccent),
              ),
              SizedBox(width: 15),
              // Texte de la routine
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Morning Routine",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "4 steps",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              // Icône de validation (Check vert)
              Icon(Icons.check_circle, color: Colors.greenAccent[400]),
            ],
          ),
        ),
      ],
    );
  }
}

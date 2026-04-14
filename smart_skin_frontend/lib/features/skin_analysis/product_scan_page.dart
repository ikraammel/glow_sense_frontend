import 'package:flutter/material.dart';
import 'dart:ui';

class ProductScanPage extends StatefulWidget {
  const ProductScanPage({super.key});

  @override
  State<ProductScanPage> createState() => _ProductScanPageState();
}

class _ProductScanPageState extends State<ProductScanPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Animation infinie du laser de scan
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPink = Color(0xFFF1ABB9);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Flux caméra simulé
          Positioned.fill(
            child: Image.network(
              "https://via.placeholder.com/800x1600",
              fit: BoxFit.cover,
            ),
          ),

          // 2. Overlay sombre avec découpe centrale (Focus)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(decoration: const BoxDecoration(color: Colors.transparent)),
                Center(
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                const Spacer(),

                // 3. Cadre de scan interactif
                _buildScanArea(primaryPink),

                const SizedBox(height: 20),
                const Text(
                  "Align barcode within the frame",
                  style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                ),

                const Spacer(),

                // 4. Panneau de contrôle inférieur
                _buildBottomActionPanel(primaryPink),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            "PRODUCT SCANNER",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          IconButton(
            icon: const Icon(Icons.flashlight_on_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildScanArea(Color color) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        children: [
          // Coins du cadre
          _corner(top: true, left: true, color: color),
          _corner(top: true, left: false, color: color),
          _corner(top: false, left: true, color: color),
          _corner(top: false, left: false, color: color),

          // Laser de scan animé
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                top: 20 + (240 * _animationController.value),
                left: 30,
                right: 30,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: color,
                    boxShadow: [
                      BoxShadow(color: color.withOpacity(0.8), blurRadius: 15, spreadRadius: 2),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _corner({required bool top, required bool left, required Color color}) {
    return Positioned(
      top: top ? 0 : null,
      bottom: !top ? 0 : null,
      left: left ? 0 : null,
      right: !left ? 0 : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: top ? BorderSide(color: color, width: 5) : BorderSide.none,
            bottom: !top ? BorderSide(color: color, width: 5) : BorderSide.none,
            left: left ? BorderSide(color: color, width: 5) : BorderSide.none,
            right: !left ? BorderSide(color: color, width: 5) : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: top && left ? const Radius.circular(20) : Radius.zero,
            topRight: top && !left ? const Radius.circular(20) : Radius.zero,
            bottomLeft: !top && left ? const Radius.circular(20) : Radius.zero,
            bottomRight: !top && !left ? const Radius.circular(20) : Radius.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionPanel(Color pink) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Check your product safety",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Scan ingredients to see if they match your skin profile.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      icon: Icons.history_rounded,
                      label: "History",
                      color: Colors.black87,
                      isOutlined: true,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _actionButton(
                      icon: Icons.search_rounded,
                      label: "Search",
                      color: pink,
                      isOutlined: false,
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

  Widget _actionButton({required IconData icon, required String label, required Color color, required bool isOutlined}) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : color,
        borderRadius: BorderRadius.circular(15),
        border: isOutlined ? Border.all(color: Colors.grey.withOpacity(0.3)) : null,
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isOutlined ? Colors.black87 : Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isOutlined ? Colors.black87 : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
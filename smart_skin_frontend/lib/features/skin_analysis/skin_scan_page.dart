import 'package:flutter/material.dart';
import 'dart:ui'; // Nécessaire pour ImageFilter

class SkinScanPage extends StatefulWidget {
  const SkinScanPage({super.key});

  @override
  State<SkinScanPage> createState() => _SkinScanPageState();
}

class _SkinScanPageState extends State<SkinScanPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _scanProgress = 0.0;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  void _startScanning() {
    setState(() => _isScanning = true);
    _controller.forward().then((value) {
      // Action après la fin du scan (ex: navigation vers résultats)
      print("Scan terminé !");
    });

    _controller.addListener(() {
      setState(() => _scanProgress = _controller.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPink = Color(0xFFF1ABB9);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Feed (Simulé)
          Positioned.fill(
            child: Image.network(
              "https://via.placeholder.com/800x1600", // Image simulée de la caméra
              fit: BoxFit.cover,
            ),
          ),

          // 2. Filtre Sombre pour faire ressortir l'ovale
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(decoration: const BoxDecoration(color: Colors.transparent)),
                Center(
                  child: Container(
                    width: 280,
                    height: 380,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.elliptical(140, 190)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. UI Elements
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const Spacer(),

                // Guide Visuel et Instructions flottantes
                Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildScanFrame(primaryPink),
                    if (!_isScanning) _buildFloatingInstruction("Hold Still", Alignment.topCenter),
                    if (!_isScanning) _buildFloatingInstruction("Good Lighting", Alignment.centerRight),
                  ],
                ),

                const Spacer(),

                // Panneau Inférieur
                _buildBottomPanel(primaryPink),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            "AI SKIN SCAN",
            style: TextStyle(color: Colors.white, letterSpacing: 2, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.flash_off, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildScanFrame(Color color) {
    return Container(
      width: 300,
      height: 400,
      child: Stack(
        children: [
          // Coins du scanner
          Positioned(top: 0, left: 0, child: _corner(top: true, left: true, color: color)),
          Positioned(top: 0, right: 0, child: _corner(top: true, left: false, color: color)),
          Positioned(bottom: 0, left: 0, child: _corner(top: false, left: true, color: color)),
          Positioned(bottom: 0, right: 0, child: _corner(top: false, left: false, color: color)),

          // Ligne de scan laser (animée)
          if (_isScanning)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  top: 400 * _controller.value,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: color, blurRadius: 10, spreadRadius: 2)],
                      color: color,
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
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: top ? BorderSide(color: color, width: 4) : BorderSide.none,
          bottom: !top ? BorderSide(color: color, width: 4) : BorderSide.none,
          left: left ? BorderSide(color: color, width: 4) : BorderSide.none,
          right: !left ? BorderSide(color: color, width: 4) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFloatingInstruction(String text, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ),
    );
  }

  Widget _buildBottomPanel(Color pink) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isScanning ? "Analyzing your skin..." : "Ready for Analysis",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (_isScanning)
                LinearProgressIndicator(
                  value: _scanProgress,
                  backgroundColor: Colors.grey[200],
                  color: pink,
                )
              else
                const Text(
                  "Keep your face within the frame and stay still",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _isScanning ? null : _startScanning,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pink,
                  disabledBackgroundColor: Colors.grey,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                ),
                child: Text(
                  _isScanning ? "Scanning..." : "START ANALYSIS",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
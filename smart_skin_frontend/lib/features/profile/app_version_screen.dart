import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppVersionScreen extends StatefulWidget {
  const AppVersionScreen({super.key});
  @override
  State<AppVersionScreen> createState() => _AppVersionScreenState();
}

class _AppVersionScreenState extends State<AppVersionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  int _tapCount = 0;
  bool _devModeUnlocked = false;

  static const String appVersion    = '1.0.0';
  static const String buildNumber   = '42';
  static const String releaseDate   = 'January 2025';
  static const String minAndroid    = 'Android 8.0+';
  static const String minIos        = 'iOS 14.0+';
  static const String backendVersion = '1.0.0';
  static const String apiVersion    = 'v1';

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _onLogoBounce() async {
    _tapCount++;
    await _animCtrl.forward();
    await _animCtrl.reverse();
    if (_tapCount >= 7 && !_devModeUnlocked) {
      setState(() => _devModeUnlocked = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(children: [
            Icon(Icons.developer_mode, color: Colors.white),
            SizedBox(width: 8),
            Text('🎉 Developer mode unlocked!'),
          ]),
          backgroundColor: Color(0xFF333333),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ));
      }
    }
  }

  void _copyVersion() {
    Clipboard.setData(const ClipboardData(text: 'Smart Skin v$appVersion (Build $buildNumber)'));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Version copied to clipboard'),
      backgroundColor: Color(0xFF888888),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FB),
      appBar: AppBar(
        title: const Text('App Version',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF333333),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // App Logo + Version
          Column(
            children: [
              GestureDetector(
                onTap: _onLogoBounce,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 100, height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFE5B3BC), Color(0xFFC7CCF1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x30F1ABB9),
                          blurRadius: 24,
                          spreadRadius: 4,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Smart Skin',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333))),
              const SizedBox(height: 4),
              const Text('AI-Powered Skincare',
                  style: TextStyle(color: Color(0xFF888888), fontSize: 14)),
              const SizedBox(height: 12),
              GestureDetector(
                onLongPress: _copyVersion,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1ABB9).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF1ABB9).withOpacity(0.4)),
                  ),
                  child: Text('Version $appVersion (Build $buildNumber)',
                      style: const TextStyle(
                          color: Color(0xFFE08499),
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ),
              ),
              const SizedBox(height: 6),
              const Text('Long-press version to copy',
                  style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),

          const SizedBox(height: 28),
          // Version details
          _buildInfoCard('Release Info', [
            _infoRow(Icons.calendar_today_rounded, 'Release Date', releaseDate),
            _infoRow(Icons.tag_rounded, 'Build Number', buildNumber),
            _infoRow(Icons.api_rounded, 'API Version', apiVersion),
            _infoRow(Icons.dns_rounded, 'Backend Version', backendVersion),
          ]),

          const SizedBox(height: 16),
          _buildInfoCard('Compatibility', [
            _infoRow(Icons.android_rounded, 'Android', minAndroid),
            _infoRow(Icons.phone_iphone_rounded, 'iOS', minIos),
          ]),

          const SizedBox(height: 16),
          // What's New
          _buildWhatsNew(),

          if (_devModeUnlocked) ...[
            const SizedBox(height: 16),
            _buildDevInfo(),
          ],

          const SizedBox(height: 20),
          // Update check button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: const Row(children: [
                      Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50)),
                      SizedBox(width: 10),
                      Text('Up to Date'),
                    ]),
                    content: const Text(
                        'You are running the latest version of Smart Skin.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Great!', style: TextStyle(color: Color(0xFFE08499))),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.system_update_alt_rounded),
              label: const Text('Check for Updates',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1ABB9),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text('© 2025 Smart Skin Inc. All rights reserved.',
                style: TextStyle(color: Colors.grey, fontSize: 11)),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(title.toUpperCase(),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF888888),
                  letterSpacing: 0.6)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE08499), size: 20),
          const SizedBox(width: 14),
          Text(label,
              style: const TextStyle(color: Color(0xFF555555), fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: Color(0xFF888888), fontWeight: FontWeight.w500, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildWhatsNew() {
    final changes = [
      {'icon': '🚀', 'text': 'AI analysis engine v2 — 18% more accurate'},
      {'icon': '💬', 'text': 'New AI Skin Coach with memory'},
      {'icon': '🧪', 'text': 'Ingredient Scanner for product safety'},
      {'icon': '📊', 'text': 'Improved dashboard with score history'},
      {'icon': '🔔', 'text': 'Customizable notification preferences'},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE5B3BC), Color(0xFFC7CCF1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.new_releases_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text("What's New in v$appVersion",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ]),
          const SizedBox(height: 14),
          ...changes.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c['icon']!, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(c['text']!,
                          style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDevInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.developer_mode, color: Colors.greenAccent, size: 18),
            SizedBox(width: 8),
            Text('Developer Info',
                style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace')),
          ]),
          const SizedBox(height: 10),
          const Divider(color: Colors.white12),
          const SizedBox(height: 8),
          ...[
            'Flutter: 3.x',
            'Dart: 3.x',
            'BLoC: 8.1.5',
            'Dio: 5.4.x',
            'Environment: Production',
            'API: http://10.0.2.2:8080/api',
          ].map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('  > $line',
                    style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontFamily: 'monospace')),
              )),
        ],
      ),
    );
  }
}

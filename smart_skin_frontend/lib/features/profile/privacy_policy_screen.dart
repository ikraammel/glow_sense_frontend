import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FB),
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF333333),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSection(
            '1. Data We Collect',
            Icons.data_usage_rounded,
            'We collect information you provide directly to us, including your name, email address, profile photo, skin type, and skin concerns. We also collect data from your skin analyses (photos and results), product scan history, and app usage analytics.',
          ),
          _buildSection(
            '2. How We Use Your Data',
            Icons.psychology_rounded,
            'Your data is used to provide personalized skincare recommendations, improve our AI analysis engine, send you relevant notifications and tips, and generate your skin progress reports. We never sell your personal data to third parties.',
          ),
          _buildSection(
            '3. Photo & Image Data',
            Icons.photo_camera_rounded,
            'Photos taken for skin analysis are processed securely on our servers. Analysis images are stored temporarily and deleted after 30 days unless you choose to save them in your history. Raw images are never shared with third parties.',
          ),
          _buildSection(
            '4. Data Security',
            Icons.security_rounded,
            'We use industry-standard encryption (TLS 1.3) for all data in transit and AES-256 encryption for data at rest. Your account is protected by JWT authentication with automatic token refresh.',
          ),
          _buildSection(
            '5. Your Rights',
            Icons.verified_user_rounded,
            'You have the right to access, modify, or delete your personal data at any time. You can export your data or request account deletion by contacting our support team. We will process your request within 30 days.',
          ),
          _buildSection(
            '6. Cookies & Tracking',
            Icons.cookie_rounded,
            'We use minimal analytics to understand how users interact with our app. We do not use cross-site tracking or sell your behavioral data to advertising networks.',
          ),
          _buildSection(
            '7. Contact Us',
            Icons.email_rounded,
            'For privacy-related questions or requests, contact our Data Protection Officer at privacy@glowsense.app or write to: GlowSense Inc., Privacy Department.',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1ABB9).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF1ABB9).withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Color(0xFFE08499), size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Last updated: January 2025  •  Version 1.0',
                    style: TextStyle(
                      color: Color(0xFFE08499),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE5B3BC), Color(0xFFC7CCF1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_rounded, color: Colors.white, size: 36),
          SizedBox(height: 12),
          Text(
            'Your Privacy Matters',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'GlowSense is committed to protecting your personal data and being transparent about how we use it.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1ABB9).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFFE08499), size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

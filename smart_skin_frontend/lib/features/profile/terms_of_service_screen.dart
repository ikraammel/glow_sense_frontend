import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FB),
      appBar: AppBar(
        title: const Text(
          'Terms of Service',
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildTerm(
                  '1. Acceptance of Terms',
                  'By creating an account or using Smart Skin, you agree to these Terms of Service. If you do not agree, please do not use the app. We may update these terms from time to time and will notify you of significant changes.',
                ),
                _buildTerm(
                  '2. App Purpose & Medical Disclaimer',
                  'Smart Skin provides AI-powered skin analysis for informational and cosmetic guidance purposes ONLY. Our analysis is NOT a medical diagnosis. Always consult a qualified dermatologist or healthcare professional for medical skin conditions. We are not liable for decisions made based on our AI recommendations.',
                ),
                _buildTerm(
                  '3. Account Responsibilities',
                  'You are responsible for maintaining the confidentiality of your account credentials. You must be at least 16 years old to use this service. You agree not to share your account or use the app for any unlawful purpose.',
                ),
                _buildTerm(
                  '4. Intellectual Property',
                  'All content, AI models, algorithms, and interfaces within Smart Skin are the exclusive property of Smart Skin Inc. You may not copy, modify, distribute, or reverse-engineer any part of our service.',
                ),
                _buildTerm(
                  '5. User Content',
                  'By uploading photos or content, you grant Smart Skin a limited license to process that content to provide you with the service. You retain full ownership of your photos. We will never use your personal photos for advertising or sell them.',
                ),
                _buildTerm(
                  '6. Limitation of Liability',
                  'Smart Skin is provided "as is" without warranties of any kind. We are not liable for any indirect, incidental, or consequential damages arising from your use of the app, including reliance on AI-generated skin recommendations.',
                ),
                _buildTerm(
                  '7. Termination',
                  'We reserve the right to suspend or terminate accounts that violate these terms. You may delete your account at any time. Upon termination, your data will be deleted within 30 days.',
                ),
                _buildTerm(
                  '8. Governing Law',
                  'These Terms are governed by applicable law. Any disputes shall be resolved through binding arbitration, except where prohibited by law.',
                ),
                _buildTerm(
                  '9. Contact',
                  'Questions about these Terms? Contact us at legal@smartskin.app',
                ),
                const SizedBox(height: 20),
                _buildAcceptedBadge(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.gavel_rounded, color: Colors.white, size: 36),
          SizedBox(height: 12),
          Text(
            'Terms of Service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Please read these terms carefully. They govern your use of the Smart Skin application and services.',
            style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTerm(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF333333),
          ),
        ),
        iconColor: const Color(0xFFE08499),
        collapsedIconColor: Colors.grey,
        children: [
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

  Widget _buildAcceptedBadge() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50), size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms Accepted',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'You accepted these terms when you created your account.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});
  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  int? _expandedFaq;

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How does the skin analysis work?',
      'a': 'Our AI analyzes your selfie using deep learning trained on thousands of skin images. It detects skin type, hydration level, acne, pigmentation, wrinkles, and pore size — giving you a score from 0 to 100 for each category.',
    },
    {
      'q': 'How accurate is the AI analysis?',
      'a': 'Our AI achieves approximately 89% accuracy on skin type detection. For best results, take photos in natural light, facing the camera directly, without makeup or glasses.',
    },
    {
      'q': 'Are my photos stored permanently?',
      'a': 'No. Analysis images are processed securely and deleted from our servers after 30 days unless you explicitly save them to your history. You can delete your history at any time from the Analysis tab.',
    },
    {
      'q': 'How do I improve my skin score?',
      'a': 'Follow the personalized recommendations in your Analysis results and the AI Coach suggestions. Track your progress over time with regular analyses (we recommend once per week).',
    },
    {
      'q': 'What is the AI Skin Coach?',
      'a': 'The AI Coach is a conversational assistant powered by advanced AI that answers your skincare questions, explains ingredients, helps build routines, and gives personalized advice based on your skin profile.',
    },
    {
      'q': 'How does the Product Scanner work?',
      'a': 'Paste the ingredients list from any skincare product label. Our AI will analyze each ingredient for compatibility with your skin type and flag potentially harmful or highly beneficial components.',
    },
    {
      'q': 'Can I delete my account?',
      'a': 'Yes. Go to Profile > Settings > Delete Account. All your data including analyses, messages, and personal info will be permanently deleted within 30 days.',
    },
    {
      'q': 'I forgot my password. What do I do?',
      'a': 'On the login screen, tap "Forgot Password". Enter your email address and we will send you a reset link within a few minutes. Check your spam folder if you do not see it.',
    },
  ];

  List<Map<String, String>> get _filteredFaqs {
    if (_searchQuery.isEmpty) return _faqs;
    return _faqs
        .where((f) =>
            f['q']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            f['a']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FB),
      appBar: AppBar(
        title: const Text('Help & Support',
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
        padding: const EdgeInsets.all(20),
        children: [
          // Contact Cards
          Row(
            children: [
              Expanded(child: _contactCard(
                Icons.email_outlined,
                'Email Us',
                'support@smartskin.app',
                const Color(0xFF91C4EA),
                () => _showContactDialog(context, 'Email', 'support@smartskin.app'),
              )),
              const SizedBox(width: 12),
              Expanded(child: _contactCard(
                Icons.chat_bubble_outline_rounded,
                'Live Chat',
                'Mon–Fri 9am–6pm',
                const Color(0xFFC7CCF1),
                () => _showContactDialog(context, 'Chat', 'Opening live chat...'),
              )),
            ],
          ),
          const SizedBox(height: 24),

          // Search
          const Text('Frequently Asked Questions',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
            ),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: const InputDecoration(
                hintText: 'Search questions...',
                prefixIcon: Icon(Icons.search_rounded, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // FAQs
          if (_filteredFaqs.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Column(children: [
                  Icon(Icons.search_off_rounded, size: 40, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('No matching questions found.',
                      style: TextStyle(color: Colors.grey)),
                ]),
              ),
            )
          else
            ...List.generate(_filteredFaqs.length, (i) {
              final faq = _filteredFaqs[i];
              final isOpen = _expandedFaq == i;
              return GestureDetector(
                onTap: () => setState(() => _expandedFaq = isOpen ? null : i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isOpen ? const Color(0xFFF1ABB9).withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isOpen
                          ? const Color(0xFFF1ABB9).withOpacity(0.4)
                          : Colors.grey.shade100,
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              faq['q']!,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: isOpen
                                    ? const Color(0xFFE08499)
                                    : const Color(0xFF333333),
                              ),
                            ),
                          ),
                          Icon(
                            isOpen
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: isOpen ? const Color(0xFFE08499) : Colors.grey,
                          ),
                        ],
                      ),
                      if (isOpen) ...[
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        Text(
                          faq['a']!,
                          style: const TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 13,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),

          const SizedBox(height: 20),
          // Still need help
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE5B3BC), Color(0xFFC7CCF1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 32),
                const SizedBox(height: 8),
                const Text('Still need help?',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                const Text(
                  'Our support team typically responds within 2 business hours.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showContactDialog(context, 'Ticket',
                        'A ticket has been submitted. We will reply to your email within 2 hours.'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFE08499),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Submit a Support Ticket',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _contactCard(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 3),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context, String type, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('$type Support'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFFE08499))),
          ),
        ],
      ),
    );
  }
}

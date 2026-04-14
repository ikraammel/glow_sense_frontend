import 'package:flutter/material.dart';

class AICoachPage extends StatelessWidget {
  const AICoachPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPink = Color(0xFFF1ABB9);
    const Color aiBlue = Color(0xFF91C4EA);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFB),
      appBar: AppBar(
        title: const Text("AI Skin Coach", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCoachMessage(
                    "Hello Sarah! Based on your last scan, your skin hydration has improved by 15%. Keep using your hyaluronic acid serum!",
                    aiBlue,
                  ),
                  const SizedBox(height: 25),
                  const Text("Today's AI Tips", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  _buildTipCard(
                    "Stay Hydrated",
                    "Drink at least 2L of water today to maintain your skin's glow.",
                    Icons.local_drink,
                    Colors.blue[100]!,
                  ),
                  const SizedBox(height: 15),
                  _buildTipCard(
                    "UV Protection",
                    "UV index is high today (7). Don't forget your SPF 50!",
                    Icons.wb_sunny,
                    Colors.orange[100]!,
                  ),
                  const SizedBox(height: 25),
                  const Text("Ask me anything", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  _buildQuickQuestions(),
                ],
              ),
            ),
          ),
          _buildChatInput(primaryPink),
        ],
      ),
    );
  }

  Widget _buildCoachMessage(String message, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard(String title, String description, IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.black54),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickQuestions() {
    final questions = [
      "How to treat acne?",
      "Best routine for dry skin?",
      "What is retinol?",
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: questions.map((q) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1ABB9).withOpacity(0.3)),
        ),
        child: Text(q, style: const TextStyle(fontSize: 13, color: Colors.black87)),
      )).toList(),
    );
  }

  Widget _buildChatInput(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: color,
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

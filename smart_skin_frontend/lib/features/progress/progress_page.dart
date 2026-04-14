import 'package:flutter/material.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPink = Color(0xFFF1ABB9);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFB),
      appBar: AppBar(
        title: const Text("My Progress", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeeklySummary(primaryPink),
            const SizedBox(height: 30),
            const Text("Skin Score History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildChartPlaceholder(primaryPink),
            const SizedBox(height: 30),
            const Text("Before & After", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _buildComparisonCard("Week 1", "Day 1", primaryPink)),
                const SizedBox(width: 15),
                Expanded(child: _buildComparisonCard("Week 4", "Today", primaryPink)),
              ],
            ),
            const SizedBox(height: 30),
            _buildMetricList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummary(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem("Current Score", "82", color),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          _buildSummaryItem("Improvement", "+5%", Colors.green),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          _buildSummaryItem("Days Streak", "12", Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildChartPlaceholder(Color color) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(40, color),
                _buildBar(55, color),
                _buildBar(50, color),
                _buildBar(70, color),
                _buildBar(65, color),
                _buildBar(82, color),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Mon", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Tue", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Wed", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Thu", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Fri", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Sat", style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBar(double heightFactor, Color color) {
    return Container(
      width: 30,
      height: heightFactor * 1.5,
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.bottomCenter,
        heightFactor: 0.7,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonCard(String title, String subtitle, Color color) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage("https://via.placeholder.com/150"), // Placeholder image
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 12,
            left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricList() {
    return Column(
      children: [
        _buildMetricTile("Hydration", "High", Icons.water_drop, Colors.blue),
        _buildMetricTile("Texture", "Improving", Icons.face, Colors.purple),
        _buildMetricTile("Dark Spots", "Reduced", Icons.blur_on, Colors.orange),
      ],
    );
  }

  Widget _buildMetricTile(String title, String status, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SeasonalPollutionTrendsScreen extends StatelessWidget {
  const SeasonalPollutionTrendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00B074),
        title: const Text('Seasonal Pollution Trends'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _summaryCard(),
          const SizedBox(height: 16),
          _sectionTitle('Season-wise Overview'),
          const SizedBox(height: 10),
          _seasonCard(
            season: 'Winter (Nov-Feb)',
            avgAqi: 238,
            level: 'Very Unhealthy',
            color: const Color(0xFF9333EA),
            reason:
                'Temperature inversion, biomass burning, and stagnant winds.',
          ),
          const SizedBox(height: 10),
          _seasonCard(
            season: 'Summer (Mar-Jun)',
            avgAqi: 154,
            level: 'Unhealthy',
            color: const Color(0xFFEF4444),
            reason: 'Dust storms and higher ozone formation in hot afternoons.',
          ),
          const SizedBox(height: 10),
          _seasonCard(
            season: 'Monsoon (Jul-Sep)',
            avgAqi: 86,
            level: 'Moderate',
            color: const Color(0xFFF59E0B),
            reason:
                'Frequent rains reduce particulate concentration significantly.',
          ),
          const SizedBox(height: 10),
          _seasonCard(
            season: 'Post-Monsoon (Oct)',
            avgAqi: 196,
            level: 'Unhealthy',
            color: const Color(0xFFEA580C),
            reason:
                'Crop residue burning and lower wind speed increase pollution.',
          ),
          const SizedBox(height: 18),
          _sectionTitle('Monthly Snapshot (Typical Delhi Pattern)'),
          const SizedBox(height: 10),
          _monthRow('Jan', 252),
          _monthRow('Feb', 198),
          _monthRow('Mar', 165),
          _monthRow('Apr', 149),
          _monthRow('May', 141),
          _monthRow('Jun', 162),
          _monthRow('Jul', 92),
          _monthRow('Aug', 74),
          _monthRow('Sep', 93),
          _monthRow('Oct', 206),
          _monthRow('Nov', 289),
          _monthRow('Dec', 268),
          const SizedBox(height: 18),
          _sectionTitle('Actionable Insights'),
          const SizedBox(height: 10),
          _insight(
            'Winter needs strict emergency controls on transport and industry.',
          ),
          _insight(
            'Monsoon is the best period for outdoor activities and community events.',
          ),
          _insight(
            'Dust-control measures are most effective before summer peaks.',
          ),
          _insight(
            'Pre-emptive anti-smog actions should begin before October.',
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yearly Trend Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Air quality generally worsens from October to February and improves during monsoon due to rainfall and better dispersion.',
            style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _seasonCard({
    required String season,
    required int avgAqi,
    required String level,
    required Color color,
    required String reason,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
              Expanded(
                child: Text(
                  season,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  level,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Average AQI: $avgAqi',
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            reason,
            style: const TextStyle(
              fontSize: 12.5,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _monthRow(String month, int aqi) {
    final color = aqi <= 100
        ? const Color(0xFF10B981)
        : aqi <= 150
        ? const Color(0xFFF59E0B)
        : aqi <= 200
        ? const Color(0xFFEA580C)
        : const Color(0xFFDC2626);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              month,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: (aqi / 350).clamp(0, 1),
              backgroundColor: const Color(0xFFE5E7EB),
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 36,
            child: Text(
              '$aqi',
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _insight(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(Icons.circle, size: 7, color: Color(0xFF00B074)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

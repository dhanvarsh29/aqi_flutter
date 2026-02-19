import 'package:flutter/material.dart';

class HealthTipsScreen extends StatelessWidget {
  final int aqi;
  final String dominantPollutant;
  final String tip;

  const HealthTipsScreen({
    super.key,
    required this.aqi,
    required this.dominantPollutant,
    required this.tip,
  });

  String _labelForPollutant(String key) {
    switch (key) {
      case 'pm25':
        return 'PM2.5';
      case 'pm10':
        return 'PM10';
      case 'no2':
        return 'NO2';
      case 'so2':
        return 'SO2';
      case 'o3':
        return 'O3';
      default:
        return key.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pollutantLabel = _labelForPollutant(dominantPollutant);

    return Scaffold(
      backgroundColor: const Color(0xFFF6FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00B074),
        title: const Text('Health Tips'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE8F9F1),
                    child: Icon(
                      Icons.favorite_border,
                      color: Color(0xFF00B074),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AQI $aqi',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dominant pollutant: $pollutantLabel',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                tip,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF065F46),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

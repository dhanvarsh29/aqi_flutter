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

  String _aqiBandLabel(int value) {
    if (value <= 50) return 'Good';
    if (value <= 100) return 'Moderate';
    if (value <= 150) return 'Unhealthy for Sensitive Groups';
    if (value <= 200) return 'Unhealthy';
    if (value <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  List<String> _immediateActions(int value, String dominant) {
    final list = <String>[];

    if (value > 200) {
      list.add('Avoid outdoor workouts and long walks.');
      list.add('Use an N95 mask while commuting.');
      list.add('Keep windows closed during peak traffic hours.');
    } else if (value > 100) {
      list.add('Limit prolonged outdoor exposure.');
      list.add('Prefer indoor exercise today.');
      list.add('Stay hydrated and monitor breathing discomfort.');
    } else {
      list.add('Outdoor activity is generally safe.');
      list.add('Keep checking AQI updates during the day.');
      list.add('Carry a mask if commuting in dense traffic.');
    }

    if (dominant == 'pm25' || dominant == 'pm10') {
      list.add(
        'Dust/particle levels are elevated, clean indoor surfaces regularly.',
      );
    } else if (dominant == 'no2') {
      list.add('Traffic emissions are high, choose low-traffic routes.');
    } else if (dominant == 'o3') {
      list.add('Avoid outdoor activity in the afternoon when ozone peaks.');
    }

    return list.take(4).toList();
  }

  List<String> _sensitiveGroupTips(int value) {
    if (value > 150) {
      return const [
        'Children and elderly should avoid outdoor exertion.',
        'People with asthma/COPD should keep inhalers accessible.',
        'Pregnant women should minimize exposure during peak AQI hours.',
      ];
    }

    return const [
      'Sensitive groups should monitor symptoms during outdoor activity.',
      'Use masks when AQI rises near busy roads.',
      'Schedule walks in cleaner hours (early morning or late evening).',
    ];
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
      body: SingleChildScrollView(
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
                          'Status: ${_aqiBandLabel(aqi)} • Dominant: $pollutantLabel',
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
            const SizedBox(height: 16),
            _tipsBlock(
              title: 'Immediate Actions',
              icon: Icons.local_hospital_outlined,
              items: _immediateActions(aqi, dominantPollutant),
            ),
            const SizedBox(height: 12),
            _tipsBlock(
              title: 'For Sensitive Groups',
              icon: Icons.family_restroom,
              items: _sensitiveGroupTips(aqi),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.schedule, color: Color(0xFF00B074), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Best time for outdoor activity: early morning (6–9 AM) or after sunset, when traffic and ozone are usually lower.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tipsBlock({
    required String title,
    required IconData icon,
    required List<String> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF00B074), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.circle, size: 6, color: Colors.black54),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

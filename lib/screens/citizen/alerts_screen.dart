import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00B074),
        title: const Text('Air Quality Alerts'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAlertCard(
            icon: Icons.warning_amber_rounded,
            iconColor: const Color(0xFFDC2626),
            iconBg: const Color(0xFFFEE2E2),
            title: 'Severe Air Quality Alert',
            subtitle: 'AQI has reached 301 - Hazardous level',
            time: '2 hours ago',
            location: 'Connaught Place, Delhi',
            description:
                'Health alert: Everyone may experience serious health effects. Avoid outdoor activities.',
            type: 'CRITICAL',
          ),
          const SizedBox(height: 12),
          _buildAlertCard(
            icon: Icons.notifications_active,
            iconColor: const Color(0xFFEA580C),
            iconBg: const Color(0xFFFFEDD5),
            title: 'PM2.5 Threshold Exceeded',
            subtitle: 'PM2.5 level: 187 µg/m³',
            time: '5 hours ago',
            location: 'Anand Vihar, Delhi',
            description:
                'Fine particulate matter has exceeded safe limits. Sensitive groups should reduce outdoor exposure.',
            type: 'WARNING',
          ),
          const SizedBox(height: 12),
          _buildAlertCard(
            icon: Icons.air,
            iconColor: const Color(0xFFD97706),
            iconBg: const Color(0xFFFEF3C7),
            title: 'Moderate Air Quality',
            subtitle: 'AQI improved to 156',
            time: 'Yesterday, 6:30 PM',
            location: 'Major Dhyan Chand Stadium',
            description:
                'Air quality has improved from unhealthy to moderate. Sensitive individuals should still limit prolonged outdoor activities.',
            type: 'INFO',
          ),
          const SizedBox(height: 12),
          _buildAlertCard(
            icon: Icons.trending_up,
            iconColor: const Color(0xFFCA8A04),
            iconBg: const Color(0xFFFEF9C3),
            title: 'AQI Rising Trend Detected',
            subtitle: 'Expected to reach 200+ by evening',
            time: 'Yesterday, 2:15 PM',
            location: 'Delhi NCR Region',
            description:
                'Air quality is deteriorating. Consider rescheduling outdoor activities for tomorrow morning.',
            type: 'FORECAST',
          ),
          const SizedBox(height: 12),
          _buildAlertCard(
            icon: Icons.check_circle_outline,
            iconColor: const Color(0xFF059669),
            iconBg: const Color(0xFFD1FAE5),
            title: 'Good Air Quality',
            subtitle: 'AQI dropped to 78',
            time: '2 days ago, 8:00 AM',
            location: 'Lodhi Garden, Delhi',
            description:
                'Air quality is satisfactory. Ideal time for outdoor activities and exercise.',
            type: 'GOOD_NEWS',
          ),
          const SizedBox(height: 12),
          _buildAlertCard(
            icon: Icons.science_outlined,
            iconColor: const Color(0xFF7C3AED),
            iconBg: const Color(0xFFEDE9FE),
            title: 'Stubble Burning Activity',
            subtitle: 'Increased pollution from neighboring states',
            time: '3 days ago, 10:30 AM',
            location: 'North Delhi Region',
            description:
                'Satellite data shows increased stubble burning in Punjab and Haryana, affecting air quality.',
            type: 'ADVISORY',
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String time,
    required String location,
    required String description,
    required String type,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: iconBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            type,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: iconColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                location,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 12),
              Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

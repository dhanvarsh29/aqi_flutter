import 'package:flutter/material.dart';
import 'map_screen.dart'; // ✅ Import Map Screen

class CitizenHomeScreen extends StatefulWidget {
  const CitizenHomeScreen({super.key});

  @override
  State<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen> {
  int _currentIndex = 0; // ✅ Needed for navigation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBFF),

      // ✅ Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF00B074),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        // ✅ ONLY MAP NAVIGATION ADDED
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MapScreen(),
              ),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: "Map"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none), label: "Alerts"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined), label: "Reports"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),

      // ✅ FULL OLD UI BODY (UNCHANGED)
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontFamily: "Poppins"),
                      children: [
                        TextSpan(
                          text: "Good Morning,\n",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        TextSpan(
                          text: "Stay Safe Today",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00B074),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Notification Icon
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: const Icon(Icons.notifications_none),
                  )
                ],
              ),

              const SizedBox(height: 6),

              const Text(
                "Tuesday, Feb 10 • 07:18 PM",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 18),

              // Location Dropdown Pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.location_on_outlined,
                        color: Color(0xFF00B074)),
                    SizedBox(width: 6),
                    Text(
                      "Lower Manhattan, NY",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // AQI Big Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C98D), Color(0xFF00A86B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "CURRENT AIR QUALITY",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Text(
                            "Good",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 16),

                    // AQI Number
                    const Text(
                      "42",
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Safety Info Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.verified_user,
                              color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Safe for outdoor activities today.",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Pollutant Grid
                    Row(
                      children: const [
                        Expanded(
                          child: _PollutantCard(
                              title: "PM2.5", value: "12.4 µg/m³"),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: _PollutantCard(
                              title: "PM10", value: "20.1 µg/m³"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: const [
                        Expanded(
                          child: _PollutantCard(title: "NO₂", value: "8.5 ppb"),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: _PollutantCard(title: "SO₂", value: "2.3 ppb"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Scrollable Cards Section
              _InfoCard(
                color: const Color(0xFFFFE5EA),
                icon: Icons.error_outline,
                title: "High Ozone Alert",
                subtitle: "Ozone levels are rising in your area.",
                buttonText: "View",
              ),

              const SizedBox(height: 16),

              _SimpleFeatureCard(
                icon: Icons.favorite_border,
                title: "Health Tips Near You",
                subtitle: "Advice based on your current AQI",
              ),

              const SizedBox(height: 16),

              _SimpleFeatureCard(
                icon: Icons.auto_graph,
                title: "AI AQI Forecast",
                subtitle: "Next 72 hours prediction",
              ),

              const SizedBox(height: 16),

              _SimpleFeatureCard(
                icon: Icons.calendar_month_outlined,
                title: "Seasonal Pollution Trends",
                subtitle: "Compare air quality across months",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// Pollutant Small Card Widget
//
class _PollutantCard extends StatelessWidget {
  final String title;
  final String value;

  const _PollutantCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          )
        ],
      ),
    );
  }
}

//
// Alert Card Widget
//
class _InfoCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;

  const _InfoCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.redAccent,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {},
            child: Text(buttonText),
          )
        ],
      ),
    );
  }
}

//
// Feature Card Widget
//
class _SimpleFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SimpleFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: Icon(icon, color: Colors.black87),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16)
        ],
      ),
    );
  }
}

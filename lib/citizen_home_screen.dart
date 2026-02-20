import 'package:flutter/material.dart';
import 'services/aqi_service.dart'; // ✅ AQI fetching service
import 'screens/citizen/ai_aqi_forecast_screen.dart';
import 'screens/citizen/health_tips_screen.dart';
import 'screens/citizen/seasonal_pollution_trends_screen.dart';

class CitizenHomeScreen extends StatefulWidget {
  const CitizenHomeScreen({super.key});

  @override
  State<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen> {
  AQIData? currentAQIData;
  bool isLoadingAQI = false;

  String get aqiStatus {
    if (currentAQIData == null) return "--";
    final aqi = currentAQIData!.aqi;
    if (aqi <= 50) return "Good";
    if (aqi <= 100) return "Moderate";
    if (aqi <= 150) return "Unhealthy";
    return "Hazardous";
  }

  String getHealthTip(int aqi, String dominant) {
    // Severe AQI first (global advice)
    if (aqi > 300) {
      return "Air quality is hazardous. Stay indoors, use an air purifier, and avoid outdoor travel.";
    }

    if (aqi > 200) {
      return "Air quality is very unhealthy. Reduce outdoor activity and wear an N95 mask.";
    }

    if (aqi > 100) {
      // Pollutant specific tips
      if (dominant == "pm25") {
        return "High PM2.5 detected. Wear an N95 mask and avoid outdoor exercise.";
      }
      if (dominant == "o3") {
        return "Ozone levels elevated. Avoid outdoor activity during afternoon hours.";
      }
      if (dominant == "no2") {
        return "Traffic pollution is high. Prefer low-traffic routes and indoor ventilation.";
      }
      if (dominant == "pm10") {
        return "Dust levels are high. Keep windows closed and avoid construction areas.";
      }

      return "Air quality is poor. Limit prolonged outdoor exposure.";
    }

    if (aqi > 50) {
      return "Air quality is moderate. Sensitive individuals should reduce prolonged outdoor activity.";
    }

    return "Air quality is good. Outdoor activities are safe.";
  }

  String _dominantPollutant(AQIData data) {
    final values = <String, double>{
      "pm25": data.pm25.toDouble(),
      "pm10": data.pm10.toDouble(),
      "no2": data.no2,
      "so2": data.so2,
    };

    var maxKey = "pm25";
    var maxValue = values[maxKey] ?? 0.0;
    values.forEach((key, value) {
      if (value > maxValue) {
        maxValue = value;
        maxKey = key;
      }
    });

    return maxKey;
  }

  @override
  void initState() {
    super.initState();
    // ensure selectedLocation is valid
    if (stations.isNotEmpty) {
      selectedLocation = stations.first;
    }
    // load initial AQI for the selected station
    loadAQI(selectedLocation);
  }

  /// Public helper used throughout the class (and callable externally)
  Future<void> loadAQI(String station) async {
    print('loadAQI called for $station');
    setState(() {
      isLoadingAQI = true;
    });
    try {
      final data = await AQIService.fetchCurrentAQIData(station);
      print('AQIService returned $data');
      setState(() {
        currentAQIData = data;
      });
    } catch (e, st) {
      print('Error fetching AQI: $e\n$st');
      setState(() {
        currentAQIData = null;
      });
    } finally {
      setState(() {
        isLoadingAQI = false;
      });
    }
  }

  // ✅ Delhi Stations List (44 Locations)
  final List<String> stations = [
    "Indirapuram, Ghaziabad, India",
    "R.K. Puram, Delhi, Delhi, India",
    "Major Dhyan Chand National Stadium, Delhi, Delhi, India",
    "Burari Crossing, Delhi, Delhi, India",
    "Punjabi Bagh, Delhi, Delhi, India",
    "DTU, Delhi, Delhi, India",
    "Sector - 62, Noida, India",
    "NISE Gwal Pahari, Gurugram, India",
    "Sector-1, Noida, India",
    "Anand Vihar, Delhi, Delhi, India",
    "Vikas Sadan Gurgaon, Gurgaon, India",
    "Sri Auribindo Marg, Delhi, Delhi, India",
    "PGDAV College, Sriniwaspuri, Delhi, Delhi, India",
    "Mandir Marg, Delhi, Delhi, India",
    "ITO, Delhi, Delhi, India",
    "Pusa, Delhi, Delhi, India",
    "Shadipur, Delhi, Delhi, India",
    "National Institute of Malaria Research, Dwarka, Delhi, India",
    "ITI Jahangirpuri, Delhi, India",
    "ITI Shahdra, Jhilmil Industrial Area, Delhi, India",
    "Shaheed Sukhdev College, Rohini, Delhi, India",
    "Lodhi Road, Delhi, India",
    "Aya Nagar, Delhi, India",
    "Delhi Institute of Tool Engineering, Wazirpur, Delhi, India",
    "Pooth Khurd, Bawana, Delhi, India",
    "Sector 30, Faridabad, India",
    "Mother Dairy Plant, Parparganj, Delhi, India",
    "Jawaharlal Nehru Stadium, Delhi, India",
    "Satyawati College, Delhi, India",
    "Mundka, Delhi, India",
    "Narela, Delhi, India",
    "Bramprakash Ayurvedic Hospital, Najafgarh, Delhi, India",
    "Arya Nagar, Bahadurgarh, India",
    "Teri Gram, Gurugram, India",
    "Dr. Karni Singh Shooting Range, Delhi, India",
    "CRRI Mathura Road, Delhi, India",
    "Loni, Ghaziabad, India",
    "Alipur, Delhi, India",
    "Vasundhara, Ghaziabad, India",
    "Sector-116, Noida, India",
    "Sector-51, Gurugram, India",
    "DITE Okhla, Delhi, India",
    "Sector - 125, Noida, India",
    "Sonia Vihar Water Treatment Plant, Delhi, India",
  ];

  // ✅ Selected Location
  // start empty; will be set in initState
  String selectedLocation = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBFF),
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
                        ),
                      ],
                    ),
                    child: const Icon(Icons.notifications_none),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              const Text(
                "Tuesday, Feb 10 • 07:18 PM",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 18),

              // ✅ Location Dropdown Toggle Pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLocation,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isExpanded: false,

                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),

                    items: stations.map((station) {
                      return DropdownMenuItem(
                        value: station,
                        child: SizedBox(
                          width: 220,
                          child: Text(station, overflow: TextOverflow.ellipsis),
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedLocation = value!;
                      });
                      // fetch updated data for newly selected station
                      loadAQI(selectedLocation);
                    },

                    selectedItemBuilder: (context) {
                      return stations.map((station) {
                        return Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF00B074),
                            ),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 160,
                              child: Text(
                                selectedLocation,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
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
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            aqiStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // AQI Number
                    isLoadingAQI
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                        : Text(
                            currentAQIData != null
                                ? currentAQIData!.aqi.toString()
                                : "N/A",
                            style: const TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                    const SizedBox(height: 12),

                    // pollutant details removed – values shown in the grid below

                    // Safety Info Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.verified_user,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Safe for outdoor activities today.",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Pollutant Grid
                    Row(
                      children: [
                        Expanded(
                          child: _PollutantCard(
                            title: "PM2.5",
                            value: isLoadingAQI
                                ? "--"
                                : currentAQIData != null
                                ? "${currentAQIData!.pm25} µg/m³"
                                : "--",
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _PollutantCard(
                            title: "PM10",
                            value: isLoadingAQI
                                ? "--"
                                : currentAQIData != null
                                ? "${currentAQIData!.pm10} µg/m³"
                                : "--",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _PollutantCard(
                            title: "NO₂",
                            value: isLoadingAQI
                                ? "--"
                                : currentAQIData != null
                                ? "${currentAQIData!.no2} ppb"
                                : "--",
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _PollutantCard(
                            title: "SO₂",
                            value: isLoadingAQI
                                ? "--"
                                : currentAQIData != null
                                ? "${currentAQIData!.so2} ppb"
                                : "--",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Scrollable Cards Section
              _SimpleFeatureCard(
                icon: Icons.favorite_border,
                title: "Health Tips Near You",
                subtitle: isLoadingAQI || currentAQIData == null
                    ? "Health tips will appear once data loads."
                    : getHealthTip(
                        currentAQIData!.aqi,
                        _dominantPollutant(currentAQIData!),
                      ),
                onTap: isLoadingAQI || currentAQIData == null
                    ? null
                    : () {
                        final dominant = _dominantPollutant(currentAQIData!);
                        final tip = getHealthTip(currentAQIData!.aqi, dominant);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HealthTipsScreen(
                              aqi: currentAQIData!.aqi,
                              dominantPollutant: dominant,
                              tip: tip,
                            ),
                          ),
                        );
                      },
              ),

              const SizedBox(height: 16),

              _SimpleFeatureCard(
                icon: Icons.auto_graph,
                title: "AI AQI Forecast",
                subtitle: "Next 72 hours prediction",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AiAqiForecastScreen(station: selectedLocation),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _SimpleFeatureCard(
                icon: Icons.calendar_month_outlined,
                title: "Seasonal Pollution Trends",
                subtitle: "Compare air quality across months",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SeasonalPollutionTrendsScreen(),
                  ),
                ),
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

  const _PollutantCard({required this.title, required this.value});

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
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

//
// Alert Card Widget
//

//
// Feature Card Widget
//
class _SimpleFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SimpleFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12),
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

// MapScreen widget used by the main application. It encapsulates the
// previous SafeRoutePage logic.

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
    "National Institute of Malaria Research, Sector 8, Dwarka, Delhi, Delhi, India",
    "ITI Jahangirpuri, Delhi, Delhi, India",
    "ITI Shahdra, Jhilmil Industrial Area, Delhi, Delhi, India",
    "Shaheed Sukhdev College of Business Studies, Rohini, Delhi, Delhi, India",
    "Lodhi Road, Delhi, Delhi, India",
    "Aya Nagar, Delhi, Delhi, India",
    "Delhi Institute of Tool Engineering, Wazirpur, Delhi, Delhi, India",
    "Pooth Khurd, Bawana, Delhi, Delhi, India",
    "Sector 30, Faridabad, India",
    "Mother Dairy Plant, Parparganj, Delhi, Delhi, India",
    "Jawaharlal Nehru Stadium, Delhi, Delhi, India",
    "Satyawati College, Delhi, Delhi, India",
    "Mundka, Delhi, Delhi, India",
    "Narela, Delhi, Delhi, India",
    "Bramprakash Ayurvedic Hospital, Najafgarh, Delhi, Delhi, India",
    "Arya Nagar, Bahadurgarh, India",
    "Teri Gram, Gurugram, India",
    "Dr. Karni Singh Shooting Range, Delhi, Delhi, India",
    "CRRI Mathura Road, Delhi, Delhi, India",
    "Loni, Ghaziabad, India",
    "Alipur, Delhi, Delhi, India",
    "Vasundhara, Ghaziabad, India",
    "Sector-116, Noida, India",
    "Sector-51, Gurugram, India",
    "DITE Okhla, Delhi, Delhi, India",
    "Sector - 125, Noida, India",
    "Sonia Vihar Water Treatment Plant DJB, Delhi, Delhi, India",
  ];

  String? source;
  String? destination;

  List<List<LatLng>> routes = [];
  List<List<dynamic>> routePlaces = [];
  int? bestIndex;
  List<dynamic> scores = [];
  double? reductionPercent;

  String _passThroughLabel(int index) {
    if (routePlaces.length <= index) return "Not available";
    final raw = routePlaces[index];
    final names = raw
        .map((p) => p.toString().split(',').first.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (names.isEmpty) return "Not available";
    return names.take(4).join(", ");
  }

  Future<void> fetchRoute() async {
    if (source == null || destination == null) return;

    final url =
        "https://safe-route-delhi.onrender.com/safe-route?source=${Uri.encodeComponent(source!)}&destination=${Uri.encodeComponent(destination!)}";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    final result = data["result"];

    List<List<LatLng>> parsedRoutes = [];

    for (var route in result["routes"]) {
      List<LatLng> points = [];
      for (var point in route) {
        points.add(LatLng(point[0], point[1]));
      }
      parsedRoutes.add(points);
    }

    // Debug logging
    print("Backend response keys: ${result.keys}");
    if (result.containsKey("route_places")) {
      print("route_places raw: ${result["route_places"]}");
      print("route_places length: ${result["route_places"].length}");
    } else {
      print("⚠️ route_places NOT found in backend response!");
    }

    setState(() {
      routes = parsedRoutes;
      bestIndex = result["best_route_index"];
      scores = result["scores"];
      reductionPercent = result["pollution_reduction_percent"] * 1.0;
      routePlaces = result.containsKey("route_places")
          ? List<List<dynamic>>.from(result["route_places"])
          : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delhi Safe Route Navigator 🌫️")),
      body: Column(
        children: [
          /// Dropdowns
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text("Select Source"),
                    value: source,
                    isExpanded: true,
                    items: stations.map((station) {
                      return DropdownMenuItem(
                        value: station,
                        child: Text(station),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        source = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text("Select Destination"),
                    value: destination,
                    isExpanded: true,
                    items: stations.map((station) {
                      return DropdownMenuItem(
                        value: station,
                        child: Text(station),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        destination = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: fetchRoute,
            child: const Text("Find Safe Route"),
          ),

          const SizedBox(height: 10),

          /// Map
          Expanded(
            child: FlutterMap(
              options: MapOptions(center: LatLng(28.61, 77.23), zoom: 11),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.aqi',
                ),

                for (int i = 0; i < routes.length; i++)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routes[i],
                        color: i == bestIndex ? Colors.green : Colors.red,
                        strokeWidth: 4,
                      ),
                    ],
                  ),
              ],
            ),
          ),

          /// Route Summary
          if (routes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  for (int i = 0; i < routes.length; i++)
                    Card(
                      color: i == bestIndex
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Route ${i + 1} ${i == bestIndex ? "(Recommended)" : ""}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Average AQI: ${scores[i]}"),
                            Text("Passes through: ${_passThroughLabel(i)}"),
                          ],
                        ),
                      ),
                    ),
                  Text("Pollution Reduction: $reductionPercent%"),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

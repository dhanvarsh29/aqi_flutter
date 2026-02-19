import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple container for the response returned by the backend API.  
///
/// The server currently returns `aqi` plus a few pollutant metrics which are
/// exposed here so the UI can render them.
class AQIData {
  final int aqi;
  final int pm25;
  final int pm10;
  final double no2;
  final double so2;

  AQIData({
    required this.aqi,
    required this.pm25,
    required this.pm10,
    required this.no2,
    required this.so2,
  });

  factory AQIData.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    return AQIData(
      aqi: current['aqi'] as int,
      pm25: current['pm25'] as int,
      pm10: current['pm10'] as int,
      no2: (current['no2'] as num).toDouble(),
      so2: (current['so2'] as num).toDouble(),
    );
  }
}

class AQIService {
  static const String baseUrl =
      "https://forecast-model-kiex.onrender.com";

  /// Returns the full set of current measurements for the given station
  /// or `null` if something went wrong.
  static Future<AQIData?> fetchCurrentAQIData(String station) async {
    final url = Uri.parse(
      "$baseUrl/forecast?station=${Uri.encodeComponent(station)}",
    );
    print('AQIService: fetching $url');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return AQIData.fromJson(data);
    } else {
      return null;
    }
  }
}

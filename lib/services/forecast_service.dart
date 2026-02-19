import 'dart:convert';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────────────────────────────────────
//  Forecast Service
//  Tries the real API first; falls back to built-in mock data on any error.
//  API endpoint: GET http://10.0.2.2:8001/forecast?station=<name>
//  Expected response shape:
//    { "current_aqi": 42,
//      "forecast_24h": [38, 45, ...],   // 24 values (hourly)
//      "forecast_72h": [38, 33, ...] }  // 24 values (every 3 h)
// ─────────────────────────────────────────────────────────────────────────────

class ForecastData {
  final int currentAqi;
  final List<double> forecast24h;
  final List<double> forecast72h;

  const ForecastData({
    required this.currentAqi,
    required this.forecast24h,
    required this.forecast72h,
  });

  double get peak24h => forecast24h.reduce((a, b) => a > b ? a : b);
  double get lowest24h => forecast24h.reduce((a, b) => a < b ? a : b);
  double get avg24h => forecast24h.reduce((a, b) => a + b) / forecast24h.length;

  double get peak72h => forecast72h.reduce((a, b) => a > b ? a : b);
  double get lowest72h => forecast72h.reduce((a, b) => a < b ? a : b);
  double get avg72h => forecast72h.reduce((a, b) => a + b) / forecast72h.length;
}

Future<ForecastData> fetchForecast(String station) async {
  final uri = Uri.parse(
    "https://forecast-model-kiex.onrender.com/forecast?station=${Uri.encodeComponent(station)}",
  );

  final response = await http.get(uri).timeout(const Duration(seconds: 8));
  if (response.statusCode != 200) {
    throw Exception("Forecast API failed with status ${response.statusCode}");
  }

  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final forecast24h = _parseForecastList(data["forecast_24h"]);
  final forecast72h = _parseForecastList(data["forecast_72h"]);

  final currentAqi = _toDouble(data["current_aqi"]);
  final safeCurrentAqi = currentAqi != null
      ? currentAqi.toInt()
      : (forecast24h.isNotEmpty ? forecast24h.first.toInt() : 0);

  return ForecastData(
    currentAqi: safeCurrentAqi,
    forecast24h: forecast24h,
    forecast72h: forecast72h,
  );
}

List<double> _parseForecastList(dynamic rawList) {
  if (rawList is! List) {
    return const [0.0];
  }

  final parsed = rawList
      .map(_toDouble)
      .map((value) => value ?? 0.0)
      .toList(growable: false);

  if (parsed.isEmpty) {
    return const [0.0];
  }

  return parsed;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

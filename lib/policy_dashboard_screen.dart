import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InterventionChartScreen extends StatefulWidget {
  const InterventionChartScreen({super.key});

  @override
  State<InterventionChartScreen> createState() =>
      _InterventionChartScreenState();
}

class _InterventionChartScreenState extends State<InterventionChartScreen> {
  double currentAQI = 0;
  Map<String, double> sourceData = {};
  bool loading = true;

  // 🔴 PUT TOKEN HERE
  final String WAQI_TOKEN = "5d884a451880e821b8e4c7ed3a8727ce0eb30650";

  // 🔴 SOURCE API
  final String SOURCE_API =
      "https://cirealkiller-source-identification-waqi.hf.space/live";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // -------- LOAD DATA --------
  Future<void> loadData() async {
    try {
      // ===== WAQI =====
      final waqiUrl = "https://api.waqi.info/feed/delhi/?token=$WAQI_TOKEN";

      final aqiRes = await http.get(Uri.parse(waqiUrl));
      final aqiJson = jsonDecode(aqiRes.body);

      currentAQI = (aqiJson["data"]["aqi"] as num).toDouble();

      // ===== SOURCE API =====
      final srcUrl = "$SOURCE_API?aqi=${currentAQI.toInt()}";
      final srcRes = await http.get(Uri.parse(srcUrl));

      final srcJson = jsonDecode(srcRes.body);

      sourceData = parseSourceData(srcJson);

      setState(() => loading = false);
    } catch (e) {
      print("Error loading policy data: $e");
      setState(() => loading = false);
    }
  }

  Map<String, double> parseSourceData(dynamic srcJson) {
    final Map<String, double> parsed = {};

    // HF Space returns {"probabilities": {...}}
    if (srcJson is Map && srcJson["probabilities"] is Map) {
      final probs = srcJson["probabilities"] as Map;
      probs.forEach((k, v) {
        if (v is num) parsed[k.toString()] = v.toDouble();
      });
      return parsed;
    }

    if (srcJson is Map && srcJson["data"] is List) {
      final dataList = srcJson["data"] as List;
      if (dataList.isNotEmpty) {
        final first = dataList.first;
        if (first is Map) {
          first.forEach((k, v) {
            if (v is num) parsed[k.toString()] = v.toDouble();
          });
        } else if (first is List) {
          // Handle list output without labels; keep index labels
          for (var i = 0; i < first.length; i++) {
            final v = first[i];
            if (v is num) parsed["source_${i + 1}"] = v.toDouble();
          }
        }
      }
    }

    if (parsed.isEmpty && srcJson is Map) {
      // Some spaces return {"prediction": {...}}
      final pred = srcJson["prediction"];
      if (pred is Map) {
        pred.forEach((k, v) {
          if (v is num) parsed[k.toString()] = v.toDouble();
        });
      }
    }

    if (parsed.isEmpty && srcJson is Map) {
      // Fallback: treat top-level numeric fields as sources
      srcJson.forEach((k, v) {
        if (v is num) parsed[k.toString()] = v.toDouble();
      });
    }

    return parsed;
  }

  // -------- DONUT CHART --------
  Widget buildDonutChart() {
    if (sourceData.isEmpty) {
      return const SizedBox(
        height: 240,
        child: Center(child: Text("No source data available")),
      );
    }

    final sorted = sourceData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final colors = <Color>[
      const Color(0xff2563eb),
      const Color(0xff16a34a),
      const Color(0xfff97316),
      const Color(0xffef4444),
      const Color(0xffa855f7),
      const Color(0xff14b8a6),
    ];

    final sections = List.generate(sorted.length, (i) {
      final item = sorted[i];
      return PieChartSectionData(
        value: item.value,
        color: colors[i % colors.length],
        radius: 70,
        title: "${item.value.toStringAsFixed(1)}%",
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    });

    return SizedBox(
      height: 260,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 50,
          sectionsSpace: 3,
        ),
      ),
    );
  }

  Widget buildLegend() {
    if (sourceData.isEmpty) return const SizedBox.shrink();

    final sorted = sourceData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final colors = <Color>[
      const Color(0xff2563eb),
      const Color(0xff16a34a),
      const Color(0xfff97316),
      const Color(0xffef4444),
      const Color(0xffa855f7),
      const Color(0xff14b8a6),
    ];

    return Column(
      children: List.generate(sorted.length, (i) {
        final item = sorted[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[i % colors.length],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${item.key} (${item.value.toStringAsFixed(1)}%)",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // -------- UI --------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Policy Intervention Impact")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Current AQI: ${currentAQI.toInt()}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Source Prediction",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  buildDonutChart(),
                  const SizedBox(height: 16),
                  buildLegend(),
                ],
              ),
            ),
    );
  }
}

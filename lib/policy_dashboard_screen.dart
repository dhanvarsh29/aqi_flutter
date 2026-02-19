import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InterventionChartScreen extends StatefulWidget {
  const InterventionChartScreen({super.key});

  @override
  State<InterventionChartScreen> createState() =>
      _InterventionChartScreenState();
}

class _InterventionChartScreenState extends State<InterventionChartScreen> {
  double currentAQI = 420;

  // -------- MOCK SOURCE PREDICTION --------
  Map<String, double> mockSource = {
    "mixed": 55.7,
    "road_dust": 14.8,
    "construction": 14.5,
    "industry": 11.3,
    "traffic": 2.0,
    "stubble": 1.4,
  };

  late List<Map<String, dynamic>> impactData;

  @override
  void initState() {
    super.initState();
    impactData = buildPolicyImpact(mockSource, currentAQI);
  }

  // -------- BUILD POLICY IMPACT --------
  List<Map<String, dynamic>> buildPolicyImpact(
      Map<String, double> source, double currentAQI) {
    Map<String, String> policyMap = {
      "traffic": "Odd-Even",
      "construction": "Const Halt",
      "road_dust": "Dust Control",
      "industry": "Industry Control",
      "stubble": "Stubble Ban",
      "mixed": "Multi Policy",
    };

    List<Map<String, dynamic>> list = [];

    source.forEach((key, pct) {
      final after = currentAQI - (currentAQI * pct / 100);

      list.add({
        "name": policyMap[key] ?? key,
        "before": currentAQI,
        "after": after,
        "confidence": pct,
      });
    });

    list.sort(
        (a, b) => (b["confidence"] as double).compareTo(a["confidence"]));

    return list.take(3).toList();
  }

  // -------- CHART --------
  Widget buildChart() {
    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          barGroups: List.generate(impactData.length, (i) {
            final d = impactData[i];

            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: d["before"],
                  width: 14,
                  color: const Color(0xffcbd5e1),
                ),
                BarChartRodData(
                  toY: d["after"],
                  width: 14,
                  color: const Color(0xff10b981),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(impactData[value.toInt()]["name"]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------- UI --------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Policy Intervention Impact")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Current AQI: ${currentAQI.toInt()}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            const Text(
              "Before vs After Policies",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            buildChart(),
          ],
        ),
      ),
    );
  }
}
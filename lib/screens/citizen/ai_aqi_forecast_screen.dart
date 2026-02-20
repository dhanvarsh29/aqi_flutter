import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/forecast_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  AQI colour helpers
// ─────────────────────────────────────────────────────────────────────────────
Color _aqiColor(double aqi) {
  if (aqi <= 50) return const Color(0xFF00B87C);
  if (aqi <= 100) return const Color(0xFFFFA500);
  if (aqi <= 150) return const Color(0xFFFF7043);
  if (aqi <= 200) return const Color(0xFFE53935);
  return const Color(0xFF9C27B0);
}

// ─────────────────────────────────────────────────────────────────────────────
//  Insight model
// ─────────────────────────────────────────────────────────────────────────────
class _InsightData {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String body;

  const _InsightData({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.body,
  });
}

const _insights24h = [
  _InsightData(
    icon: Icons.warning_amber_rounded,
    iconColor: Color(0xFFF59E0B),
    bgColor: Color(0xFFFFFBEB),
    title: "Expected Rise This Evening",
    body:
        "AQI likely to reach 95 around this evening due to low wind conditions and traffic patterns.",
  ),
  _InsightData(
    icon: Icons.trending_down_rounded,
    iconColor: Color(0xFF00B87C),
    bgColor: Color(0xFFECFDF5),
    title: "Improvement Expected",
    body:
        "Air quality will improve to 42 by tomorrow morning with increased wind speeds.",
  ),
  _InsightData(
    icon: Icons.masks_outlined,
    iconColor: Color(0xFF6366F1),
    bgColor: Color(0xFFEEF2FF),
    title: "Health Tip",
    body:
        "Sensitive groups should avoid outdoor activities between 10 AM and 6 PM today.",
  ),
];

const _insights72h = [
  _InsightData(
    icon: Icons.warning_amber_rounded,
    iconColor: Color(0xFFF59E0B),
    bgColor: Color(0xFFFFFBEB),
    title: "Expected Rise This Evening",
    body:
        "AQI likely to reach 95 around tomorrow evening due to low wind conditions and traffic patterns.",
  ),
  _InsightData(
    icon: Icons.trending_down_rounded,
    iconColor: Color(0xFF00B87C),
    bgColor: Color(0xFFECFDF5),
    title: "Improvement Expected",
    body:
        "Air quality will improve to 42 by Thursday with increased wind speeds.",
  ),
  _InsightData(
    icon: Icons.wb_sunny_outlined,
    iconColor: Color(0xFFF97316),
    bgColor: Color(0xFFFFF7ED),
    title: "Day 2 — Stay Cautious",
    body:
        "Temperature-driven ozone buildup will push AQI to ~95 on Day 2 afternoon. Plan indoor activities.",
  ),
  _InsightData(
    icon: Icons.eco_outlined,
    iconColor: Color(0xFF6366F1),
    bgColor: Color(0xFFEEF2FF),
    title: "Best Window — Day 3 Morning",
    body:
        "Day 3 before 9 AM offers the cleanest air across the 72 h period (AQI ≈ 42).",
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
//  X-axis labels
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
//  Main Screen
// ─────────────────────────────────────────────────────────────────────────────
class AiAqiForecastScreen extends StatefulWidget {
  final String station;

  const AiAqiForecastScreen({this.station = "Delhi", super.key});

  @override
  State<AiAqiForecastScreen> createState() => _AiAqiForecastScreenState();
}

class _AiAqiForecastScreenState extends State<AiAqiForecastScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ForecastData? _data;
  bool _loading = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  Future<void> _load() async {
    try {
      final result = await fetchForecast(widget.station);
      if (!mounted) return;
      setState(() {
        _data = result;
        _loading = false;
        _errorText = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorText = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── Purple gradient header ─────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B4FCF), Color(0xFF7C73E6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "AI AQI Forecast",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Tab switcher pill
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: const Color(0xFF5B4FCF),
                        unselectedLabelColor: Colors.white70,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: const TextStyle(fontSize: 14),
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(text: "Next 24 Hours"),
                          Tab(text: "Next 3 Days"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),

          // ── Scrollable body ───────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF5B4FCF)),
                  )
                : _errorText != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        _errorText!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _TabBody(
                        spots: _spots(
                          _data!.forecast24h,
                          hourStep: 1,
                          startAtOne: true,
                        ),
                        peak: _data!.peak24h,
                        lowest: _data!.lowest24h,
                        avg: _data!.avg24h,
                        xMax: 24,
                        insights: _insights24h,
                        xInterval: 1,
                      ),
                      _TabBody(
                        spots: _spots(
                          _data!.forecast72h,
                          hourStep: 6,
                          startAtOne: false,
                        ),
                        peak: _data!.peak72h,
                        lowest: _data!.lowest72h,
                        avg: _data!.avg72h,
                        xMax: 72,
                        insights: _insights72h,
                        xInterval: 6,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _spots(
    List<double> v, {
    required double hourStep,
    required bool startAtOne,
  }) {
    final spots = List.generate(v.length, (i) {
      final x = startAtOne ? (i + 1) * hourStep : i * hourStep;
      return FlSpot(x, v[i]);
    });

    // For 72-hour forecast with 6-hour steps (12 points: 0,6,12...66)
    // Add an extra point at 72hr with the last value to complete the range
    if (!startAtOne && hourStep == 6 && spots.isNotEmpty) {
      final lastSpot = spots.last;
      if (lastSpot.x < 72) {
        spots.add(FlSpot(72, lastSpot.y));
      }
    }

    return spots;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tab body
// ─────────────────────────────────────────────────────────────────────────────
class _TabBody extends StatelessWidget {
  final List<FlSpot> spots;
  final double peak;
  final double lowest;
  final double avg;
  final double xMax;
  final List<_InsightData> insights;
  final double xInterval;

  const _TabBody({
    required this.spots,
    required this.peak,
    required this.lowest,
    required this.avg,
    required this.xMax,
    required this.insights,
    required this.xInterval,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: "Peak",
                  value: peak.toInt().toString(),
                  icon: Icons.arrow_upward_rounded,
                  color: _aqiColor(peak),
                  bgColor: _aqiColor(peak).withOpacity(0.09),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  label: "Lowest",
                  value: lowest.toInt().toString(),
                  icon: Icons.arrow_downward_rounded,
                  color: _aqiColor(lowest),
                  bgColor: _aqiColor(lowest).withOpacity(0.09),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  label: "Average",
                  value: avg.toInt().toString(),
                  icon: Icons.drag_handle_rounded,
                  color: const Color(0xFF3B82F6),
                  bgColor: const Color(0xFFEFF6FF),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Chart
          Container(
            padding: const EdgeInsets.fromLTRB(8, 20, 12, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SizedBox(
              height: 220,
              child: _AqiChart(spots: spots, xMax: xMax, xInterval: xInterval),
            ),
          ),

          const SizedBox(height: 24),

          // Insights heading
          const Text(
            "AI INSIGHTS",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF5B4FCF),
              letterSpacing: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          // Insight cards
          ...insights.map(
            (ins) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _InsightCard(insight: ins),
            ),
          ),

          const SizedBox(height: 6),
          const Center(
            child: Text(
              "Predictions based on weather patterns, historical data,\nand machine learning models",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black38,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Stat card
// ─────────────────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.75),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Line chart
// ─────────────────────────────────────────────────────────────────────────────
class _AqiChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double xMax;
  final double xInterval;

  const _AqiChart({
    required this.spots,
    required this.xMax,
    required this.xInterval,
  });

  @override
  Widget build(BuildContext context) {
    const maxY = 500.0;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: xMax,
        minY: 0,
        maxY: maxY,
        clipData: const FlClipData.all(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 50,
          getDrawingHorizontalLine: (_) => FlLine(
            color: const Color(0xFFE2E8F0),
            strokeWidth: 1,
            dashArray: [5, 4],
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 50,
              getTitlesWidget: (value, _) {
                if (value < 0 || value > maxY || value % 50 != 0)
                  return const SizedBox.shrink();
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8)),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              interval: xInterval,
              getTitlesWidget: (value, _) {
                final hour = value.round();
                if ((value - hour).abs() > 0.01) return const SizedBox.shrink();
                if (hour < 0 || hour > xMax.toInt()) {
                  return const SizedBox.shrink();
                }
                if (xMax == 24 && hour % 2 != 0) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: SizedBox(
                    width: 26,
                    child: Text(
                      '${hour}hr',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchSpotThreshold: 20,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF1E293B),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            tooltipRoundedRadius: 8,
            getTooltipItems: (spots) {
              // Only show tooltip if the spot is at a grid intersection
              return spots.map((s) {
                final xInt = s.x.round();
                final yInt = s.y.round();
                final isXGrid =
                    (xMax == 24 && xInt % 2 == 0) ||
                    (xMax == 72 && xInt % 6 == 0);
                // Only show if near grid intersection
                if (isXGrid && (s.y - yInt).abs() < 8) {
                  return LineTooltipItem(
                    "AQI ${s.y.toInt()}",
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return null;
              }).toList();
            },
          ),
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((spotIndex) {
              final spot = barData.spots[spotIndex];
              final xInt = spot.x.round();
              final isXGrid =
                  (xMax == 24 && xInt % 2 == 0) ||
                  (xMax == 72 && xInt % 6 == 0);

              // Only show indicator at grid x positions
              if (!isXGrid) {
                return TouchedSpotIndicatorData(
                  FlLine(color: Colors.transparent, strokeWidth: 0),
                  FlDotData(show: false),
                );
              }

              return TouchedSpotIndicatorData(
                FlLine(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  strokeWidth: 1.5,
                ),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 6,
                      color: Colors.white,
                      strokeWidth: 2.5,
                      strokeColor: const Color(0xFF6366F1),
                    );
                  },
                ),
              );
            }).toList();
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.5,
            color: const Color(0xFF6366F1),
            barWidth: 2.5,
            isStrokeCapRound: true,
            preventCurveOverShooting: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1).withOpacity(0.2),
                  const Color(0xFF6366F1).withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 950),
      curve: Curves.easeInOutCubic,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Insight card
// ─────────────────────────────────────────────────────────────────────────────
class _InsightCard extends StatelessWidget {
  final _InsightData insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: insight.bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: insight.iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(insight.icon, color: insight.iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  insight.body,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

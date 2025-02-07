import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/mood_entry.dart';

class MoodChart extends StatelessWidget {
  final List<MoodEntry> moodEntries;

  const MoodChart({required this.moodEntries, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 5,
        lineBarsData: [
          LineChartBarData(
            spots: _generateChartPoints(),
            isCurved: true,
            color: Colors.purple,  // Fixed 'colors' issue
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateChartPoints() {
    final weekAgo = DateTime.now().subtract(Duration(days: 7));
    final dailyAverages = List.generate(7, (index) {
      final day = weekAgo.add(Duration(days: index));
      final entries = moodEntries.where((e) => _isSameDay(e.date, day)).toList();

      if (entries.isEmpty) return 3.0;  // Default value when no entries

      final total = entries.map((e) => e.rating).reduce((a, b) => a + b);
      return total / entries.length; // Manually compute the average
    });

    return dailyAverages
        .asMap()
        .map((index, value) => MapEntry(index, FlSpot(index.toDouble(), value)))
        .values
        .toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

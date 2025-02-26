import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/mood_entry.dart';

class MoodChart extends StatelessWidget {
  final List<MoodEntry> moodEntries;
  final Color backgroundColor;// New color parameter

  const MoodChart({
    required this.moodEntries,
    required this.backgroundColor,
    // Default color
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.0),  // Use color with opacity
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: LineChart(
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
              color: backgroundColor,  // Use the same color for the line
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  // Keep the rest of the code unchanged
  List<FlSpot> _generateChartPoints() {
    final weekAgo = DateTime.now().subtract(Duration(days: 7));
    final dailyAverages = List.generate(7, (index) {
      final day = weekAgo.add(Duration(days: index));
      final entries = moodEntries.where((e) => _isSameDay(e.date, day)).toList();

      if (entries.isEmpty) return 3.0;

      final total = entries.map((e) => e.rating).reduce((a, b) => a + b);
      return total / entries.length;
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
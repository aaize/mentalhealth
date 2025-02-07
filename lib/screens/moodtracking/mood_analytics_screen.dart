import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/mood_entry.dart';
import 'package:mentalhealth/widgets/mood_chart.dart';
class MoodAnalyticsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mood Analytics')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(_user?.uid)
            .collection('moodEntries')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final moodEntries = snapshot.data!.docs
              .map((doc) => MoodEntry.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildWeeklySummary(moodEntries),
                SizedBox(height: 20),
                Expanded(child: MoodChart(moodEntries: moodEntries)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeeklySummary(List<MoodEntry> entries) {
    final weeklyAverage = entries
        .where((e) => e.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .map((e) => e.rating)
        .average;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('7-Day Mood Average', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(weeklyAverage.toStringAsFixed(1),
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

extension on Iterable<int> {
  double get average => isEmpty ? 0 : reduce((a, b) => a + b) / length;
}
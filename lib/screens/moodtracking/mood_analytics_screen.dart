import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/mood_entry.dart';
import 'package:mentalhealth/widgets/mood_chart.dart';

class MoodAnalyticsScreen extends StatelessWidget {
  final String email;
  final Color backgroundColor;

  MoodAnalyticsScreen({Key? key, required this.email, required this.backgroundColor}) : super(key: key);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text(
          'Mood Analytics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.5,
          ),
        ),
        elevation: 4, // Subtle shadow for depth
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('moods')
            .doc(email)
            .collection('entries')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final moodEntries = snapshot.data!.docs
              .map((doc) => MoodEntry.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
      color: Colors.blueGrey[50],
      elevation: 5, // Added elevation for a more dynamic effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners for a soft feel
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '7-Day Mood Average',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey[700],
              ),
            ),
            SizedBox(height: 10),
            Text(
              weeklyAverage.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Last updated: ${DateTime.now().toLocal()}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blueGrey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Iterable<int> {
  double get average => isEmpty ? 0 : reduce((a, b) => a + b) / length;
}

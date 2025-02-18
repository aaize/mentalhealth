import 'package:flutter/material.dart';
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
            fontSize: 20,
          ),
        ),
        elevation: 4,
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
                Expanded(
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MoodChart(moodEntries: moodEntries),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_calculateWeeklyAverage(moodEntries) < 3.3)
                  _buildProfessionalContacts(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeeklySummary(List<MoodEntry> entries) {
    final weeklyAverage = _calculateWeeklyAverage(entries);

    return Card(
      color: Colors.blueGrey[50],
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
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

  double _calculateWeeklyAverage(List<MoodEntry> entries) {
    final recentEntries = entries
        .where((e) => e.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();

    if (recentEntries.isEmpty) return 0.0;

    final total = recentEntries.map((e) => e.rating).reduce((a, b) => a + b);
    return total / recentEntries.length;
  }

  Widget _buildProfessionalContacts() {
    final List<Map<String, String>> professionals = [
      {
        'name': 'Dr. Krishen Ranganath',
        'experience': '25 years',
        'rating': '99%',
        'location': 'Seshadripuram',
        'fee': '₹1800',
      },
      {
        'name': 'Dr. Sushruth',
        'experience': '13 years',
        'rating': '98%',
        'location': 'Indiranagar',
        'fee': '₹750',
      },
      {
        'name': 'Dr. Venkatesh Babu G M',
        'experience': '19 years',
        'rating': '85%',
        'location': 'HSR Layout',
        'fee': '₹1200',
      },
      // Add more professionals as needed
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Consider reaching out to a mental health professional:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
        SizedBox(height: 10),
        ...professionals.map((professional) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(Icons.local_hospital, color: Colors.deepPurple),
              title: Text(
                professional['name']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${professional['experience']} experience\n'
                    'Rating: ${professional['rating']}\n'
                    'Location: ${professional['location']}\n'
                    'Consultation Fee: ${professional['fee']}',
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

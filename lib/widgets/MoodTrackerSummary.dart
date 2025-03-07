import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodTrackerSummary extends StatelessWidget {
  final String email;
  final Color backgroundColor;

  const MoodTrackerSummary({required this.email,
  required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('moods')
          .doc(email)
          .collection('entries')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildNoDataCard();
        }

        // Convert document IDs (dates) to DateTime and sort
        final entries = snapshot.data!.docs
            .map((doc) => MoodEntry.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date)); // Sort descending

        // Get only the last 7 days of data
        final recentEntries = entries.take(7).toList();

        return _buildMoodSummaryCard(recentEntries);
      },
    );
  }

  Widget _buildNoDataCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No mood entries yet. Track your mood to see a summary!',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildMoodSummaryCard(List<MoodEntry> entries) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood Tracker Summary',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: backgroundColor, // Replace with your theme color
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your mood over the past 7 days                             \n ${entries.map((e) => e.emoji).join(' ')}',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodEntry {
  final DateTime date;
  final String emoji;

  MoodEntry({required this.date, required this.emoji});

  factory MoodEntry.fromFirestore(String docId, Map<String, dynamic> data) {
    return MoodEntry(
      date: DateTime.parse(docId), // Convert doc ID (String) to DateTime
      emoji: data['emoji'] ?? '😐', // Default mood if missing
    );
  }
}

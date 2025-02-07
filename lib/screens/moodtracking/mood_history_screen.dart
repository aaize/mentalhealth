import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/mood_entry.dart';
import 'package:mentalhealth/widgets/mood_calendar.dart';
import 'package:mentalhealth/screens/moodtracking/mood_analytics_screen.dart';
class MoodHistoryScreen extends StatefulWidget {
  @override
  _MoodHistoryScreenState createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  late Stream<QuerySnapshot> _moodEntriesStream;

  @override
  void initState() {
    super.initState();
    _moodEntriesStream = _firestore
        .collection('users')
        .doc(_user?.uid)
        .collection('moodEntries')
        .snapshots();
  }

  Future<void> _saveMoodEntry(DateTime date, String emoji) async {
    await _firestore
        .collection('users')
        .doc(_user?.uid)
        .collection('moodEntries')
        .doc(date.toString())
        .set({
      'date': date,
      'emoji': emoji,
      'rating': _getRatingFromEmoji(emoji),
    });
  }

  int _getRatingFromEmoji(String emoji) {
    const emojiRatings = {
      '😢': 1,
      '😞': 2,
      '😐': 3,
      '😊': 4,
      '😁': 5,
    };
    return emojiRatings[emoji] ?? 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood History'),
        actions: [
          IconButton(
            icon: Icon(Icons.analytics),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MoodAnalyticsScreen()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _moodEntriesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final moodEntries = snapshot.data!.docs
              .map((doc) => MoodEntry.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return MoodCalendar(
            moodEntries: moodEntries,
            onDayPressed: (date) => _showEmojiPicker(context, date),
          );
        },
      ),
    );
  }

  void _showEmojiPicker(BuildContext context, DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Mood'),
        content: Wrap(
          spacing: 10,
          children: ['😢', '😞', '😐', '😊', '😁'].map((emoji) {
            return IconButton(
              icon: Text(emoji, style: TextStyle(fontSize: 32)),
              onPressed: () {
                _saveMoodEntry(date, emoji);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
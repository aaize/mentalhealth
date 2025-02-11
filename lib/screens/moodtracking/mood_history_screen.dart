import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/mood_entry.dart';
import 'package:mentalhealth/widgets/mood_calendar.dart';
import 'package:mentalhealth/screens/moodtracking/mood_analytics_screen.dart';

class MoodHistoryScreen extends StatefulWidget {
  final String email;
  final Color backgroundColor; // Receive the backgroundColor


  const MoodHistoryScreen({Key? key, required this.email, required this.backgroundColor}) : super(key: key);

  @override
  _MoodHistoryScreenState createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _moodEntriesStream;

  @override
  void initState() {
    super.initState();
    _moodEntriesStream = _firestore
        .collection('moods')
        .doc(widget.email)
        .collection('entries')
        .snapshots();
  }

  Future<void> _saveMoodEntry(DateTime date, String emoji) async {
    await _firestore
        .collection('moods')
        .doc(widget.email)
        .collection('entries')
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
        centerTitle: true,
        title: Text('Mood History',
        style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: widget.backgroundColor, // Use backgroundColor here
        actions: [
          IconButton(
            icon: Icon(Icons.analytics),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MoodAnalyticsScreen(email: widget.email,backgroundColor: widget.backgroundColor,)),
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

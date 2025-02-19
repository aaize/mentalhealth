import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/mood_entry.dart';
import 'package:mentalhealth/widgets/mood_calendar.dart';
import 'package:mentalhealth/screens/moodtracking/mood_analytics_screen.dart';

class MoodHistoryScreen extends StatefulWidget {
  final String email;
  final Color backgroundColor;

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
        title: Text(
          'Mood History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: widget.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.analytics),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MoodAnalyticsScreen(
                  email: widget.email,
                  backgroundColor: widget.backgroundColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Mood Calendar Section
            StreamBuilder<QuerySnapshot>(
              stream: _moodEntriesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final moodEntries = snapshot.data!.docs
                    .map((doc) => MoodEntry.fromMap(doc.data() as Map<String, dynamic>))
                    .toList();

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MoodCalendar(
                    moodEntries: moodEntries,
                    onDayPressed: (date) => _showEmojiPicker(context, date),
                  ),
                );
              },
            ),
            // Divider
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            // Tips Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mental Health Tips',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.backgroundColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildTipCard(
                    'Stay Active',
                    'Regular physical activity can help reduce stress and improve your mood.',
                  ),
                  _buildTipCard(
                    'Eat Healthy',
                    'A balanced diet nourishes your body and mind, contributing to better mental health.',
                  ),
                  _buildTipCard(
                    'Get Enough Sleep',
                    'Adequate sleep is essential for emotional and psychological well-being.',
                  ),
                  _buildTipCard(
                    'Practice Mindfulness',
                    'Mindfulness techniques can help you stay grounded and manage stress effectively.',
                  ),
                  _buildTipCard(
                    'Connect with Others',
                    'Building strong relationships can provide emotional support and improve your mood.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
//For tips
  Widget _buildTipCard(String title, String description) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(Icons.lightbulb_outline, color: widget.backgroundColor),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
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

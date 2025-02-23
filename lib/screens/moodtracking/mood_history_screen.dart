import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/mood_entry.dart';
import '../../widgets/mood_calendar.dart';
import 'package:mentalhealth/screens/moodtracking/mood_analytics_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodHistoryScreen extends StatefulWidget {
  final String email;
  final Color backgroundColor;

  const MoodHistoryScreen({
    Key? key,
    required this.email,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _moodEntriesStream;
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _moodEntriesStream = _firestore
        .collection('moods')
        .doc(widget.email)
        .collection('entries')
        .snapshots();
  }

  void _handleMonthChange(int delta) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + delta);
    });
  }

  Future<void> _saveMoodEntry(DateTime date, String emoji) async {
    await _firestore
        .collection('moods')
        .doc(widget.email)
        .collection('entries')
        .doc(DateFormat('yyyy-MM-dd').format(date))
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
      '🚫': 0,
    };
    return emojiRatings[emoji] ?? 3;
  }

  Future<void> _clearAllMoodEntries() async {
    final batch = _firestore.batch();
    final collectionRef = _firestore
        .collection('moods')
        .doc(widget.email)
        .collection('entries');

    final snapshot = await collectionRef.get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  void _showClearConfirmationDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Clear All Entries'),
        content: Text('Are you sure you want to delete all mood entries? This action cannot be undone.'),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: Text('Delete', style: TextStyle(color: CupertinoColors.destructiveRed)),
            onPressed: () async {
              await _clearAllMoodEntries();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEmojiPicker(BuildContext context, DateTime date) {
    if (date.isAfter(DateTime.now())) {
      return;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Select Your Mood'),
        actions: ['😢', '😞', '😐', '😊', '😁', '🚫'].map((emoji) {
          return CupertinoActionSheetAction(
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
            onPressed: () {
              _saveMoodEntry(date, emoji);
              Navigator.pop(context);
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel', style: TextStyle(color: CupertinoColors.destructiveRed)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Mood History',
          style: GoogleFonts.poppins(
            color: CupertinoColors.white,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: widget.backgroundColor,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.chart_bar_alt_fill, color: CupertinoColors.white),
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => MoodAnalyticsScreen(
                    email: widget.email,
                    backgroundColor: widget.backgroundColor,
                  ),
                ),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.delete, color: CupertinoColors.white),
              onPressed: _showClearConfirmationDialog,
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Mood Calendar Section
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.extraLightBackgroundGray,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemGrey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _moodEntriesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: CupertinoActivityIndicator(),
                        );
                      }

                      final entries = snapshot.data!.docs
                          .map((doc) => MoodEntry.fromMap(doc.data() as Map<String, dynamic>))
                          .toList();

                      return MoodCalendar(
                        currentMonth: _currentMonth,
                        moodEntries: entries,
                        onMonthChanged: _handleMonthChange,
                        onDayPressed: (date) {
                          if (!date.isAfter(DateTime.now())) {
                            _showEmojiPicker(context, date);
                          }
                        },
                        primaryColor: widget.backgroundColor,
                      );
                    },
                  ),
                ),
              ),
            ),

            // Divider
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  color: CupertinoColors.systemGrey2,
                  thickness: 1,
                ),
              ),
            ),

            // Mental Health Tips Section
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final tip = _mentalHealthTips[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildTipCard(tip['title']!, tip['description']!),
                    );
                  },
                  childCount: _mentalHealthTips.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List of Mental Health Tips
  final List<Map<String, String>> _mentalHealthTips = [
    {
      'title': 'Practice Mindfulness',
      'description': 'Take deep breaths and focus on the present moment to reduce stress.',
    },
    {
      'title': 'Stay Active',
      'description': 'Engage in regular physical activity to boost your mood and energy levels.',
    },
    {
      'title': 'Get Enough Sleep',
      'description': 'Prioritize a healthy sleep routine to improve mental clarity and emotional stability.',
    },
    {
      'title': 'Stay Connected',
      'description': 'Reach out to friends and family for support and companionship.',
    },
    {
      'title': 'Limit Screen Time',
      'description': 'Reduce screen time before bed to enhance sleep quality and mental well-being.',
    },
  ];

  // Build a Tip Card
  Widget _buildTipCard(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.darkBackgroundGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.poppins(fontSize: 14,
                decoration: TextDecoration.none,
                color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
}
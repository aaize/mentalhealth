import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/mood_entry.dart';
import '../../widgets/mood_calendar.dart';
import 'package:mentalhealth/screens/moodtracking/mood_analytics_screen.dart';

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
    };
    return emojiRatings[emoji] ?? 3;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Mood History',
            style: TextStyle(color: CupertinoColors.white)),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back,
              color: CupertinoColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: widget.backgroundColor,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.chart_bar_alt_fill,
              color: CupertinoColors.white),
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
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
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
                          .map((doc) => MoodEntry.fromMap(
                          doc.data() as Map<String, dynamic>))
                          .toList();

                      return MoodCalendar(
                        currentMonth: _currentMonth,
                        moodEntries: entries,
                        onMonthChanged: _handleMonthChange,
                        onDayPressed: (date) => _showEmojiPicker(context, date),
                        primaryColor: widget.backgroundColor,
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Divider(
                  height: 1,
                  color: CupertinoColors.systemGrey4,
                  indent: 24,
                  endIndent: 24,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildTipCard(
                      _mentalHealthTips[index]['title']!,
                      _mentalHealthTips[index]['description']!,
                    ),
                  ),
                  childCount: _mentalHealthTips.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> _mentalHealthTips = [
    {
      'title': 'Stay Active',
      'description': 'Regular physical activity helps reduce stress and improve mood.',
    },
    {
      'title': 'Balanced Diet',
      'description': 'Nourish your body and mind with healthy meals.',
    },
    {
      'title': 'Quality Sleep',
      'description': 'Adequate rest is crucial for emotional well-being.',
    },
    {
      'title': 'Mindfulness',
      'description': 'Practice meditation to stay grounded.',
    },
    {
      'title': 'Social Connection',
      'description': 'Maintain strong relationships for emotional support.',
    },
  ];

  // Update the _buildTipCard widget
  Widget _buildTipCard(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        // Remove boxShadow and use border instead
        border: Border.all(
          color: CupertinoColors.systemGrey4,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.backgroundColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(CupertinoIcons.heart_fill,
                  size: 20,
                  color: widget.backgroundColor
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.2 // Add line height
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(description,
                    style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 14,
                        height: 1.3 // Add line height
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmojiPicker(BuildContext context, DateTime date) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Select Your Mood'),
        actions: ['😢', '😞', '😐', '😊', '😁'].map((emoji) {
          return CupertinoActionSheetAction(
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
            onPressed: () {
              _saveMoodEntry(date, emoji);
              Navigator.pop(context);
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel',
              style: TextStyle(color: CupertinoColors.destructiveRed)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
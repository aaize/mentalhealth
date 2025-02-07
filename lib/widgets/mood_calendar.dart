import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/mood_entry.dart';

class MoodCalendar extends StatelessWidget {
  final List<MoodEntry> moodEntries;
  final Function(DateTime) onDayPressed;

  const MoodCalendar({
    required this.moodEntries,
    required this.onDayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.now().add(Duration(days: 365)),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          final entry = moodEntries.firstWhere(
                (e) => _isSameDay(e.date, date),
            orElse: () => MoodEntry(date: date, emoji: '', rating: 0),
          );
          return entry.emoji.isNotEmpty
              ? Positioned(
            bottom: 1,
            child: Text(entry.emoji, style: TextStyle(fontSize: 20)),
          )
              : SizedBox.shrink();
        },
      ),
      onDaySelected: (day, _) => onDayPressed(day),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
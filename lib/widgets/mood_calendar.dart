import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/mood_entry.dart';

class MoodCalendar extends StatelessWidget {
  final DateTime currentMonth;
  final List<MoodEntry> moodEntries;
  final Function(int) onMonthChanged;
  final Function(DateTime) onDayPressed;
  final Color primaryColor;

  const MoodCalendar({
    Key? key,
    required this.currentMonth,
    required this.moodEntries,
    required this.onMonthChanged,
    required this.onDayPressed,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);
    final firstWeekday = DateTime(currentMonth.year, currentMonth.month, 1).weekday;
    final entriesMap = {
      for (var entry in moodEntries)
        DateFormat('yyyy-MM-dd').format(entry.date): entry.emoji
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMonthHeader(),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.8,
            ),
            itemCount: daysInMonth + firstWeekday - 1,
            itemBuilder: (context, index) {
              if (index < firstWeekday - 1) return Container();

              final day = index - firstWeekday + 2;
              final date = DateTime(currentMonth.year, currentMonth.month, day);
              final emoji = entriesMap[DateFormat('yyyy-MM-dd').format(date)];

              return CupertinoButton(
                padding: EdgeInsets.all(0), // Ensure no extra padding
                onPressed: () => onDayPressed(date),
                child: Container(
                  margin: const EdgeInsets.all(5), // Increased margin for better spacing
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), // Add padding to increase highlight area
                  decoration: BoxDecoration(
                    color: _isToday(date) ? primaryColor.withOpacity(0.4) : null, // Make highlight broader
                    borderRadius: BorderRadius.circular(12), // Increase for rounded effect
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.toString(),
                        style: TextStyle(
                          fontSize: 16, // Increase font size for better visibility
                          fontWeight: FontWeight.bold,
                          color: _isToday(date) ? primaryColor : CupertinoColors.label,
                        ),
                      ),
                      if (emoji != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4), // Adjust spacing
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 20), // Increase emoji size
                          ),
                        ),
                    ],
                  ),
                ),
              );

            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM yyyy').format(currentMonth),
            style:  TextStyle(
              decoration: TextDecoration.none,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.chevron_left, size: 24),
                onPressed: () => onMonthChanged(-1),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.chevron_right, size: 24),
                onPressed: () => onMonthChanged(1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
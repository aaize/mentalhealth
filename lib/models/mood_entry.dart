class MoodEntry {
  final DateTime date;
  final String emoji;
  final int rating; // 1-5 scale (optional for analytics)

  MoodEntry({
    required this.date,
    required this.emoji,
    this.rating = 3,
  });

  factory MoodEntry.fromMap(Map<String, dynamic> data) {
    return MoodEntry(
      date: data['date'].toDate(),
      emoji: data['emoji'],
      rating: data['rating'] ?? 3,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'emoji': emoji,
      'rating': rating,
    };
  }
}
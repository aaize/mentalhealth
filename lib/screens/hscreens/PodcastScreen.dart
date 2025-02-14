import 'package:flutter/material.dart';

class PodcastScreen extends StatelessWidget {
  final List<Map<String, String>> podcasts = [
    {
      "title": "Overcoming Anxiety",
      "host": "Dr. Smith",
      "duration": "20 min",
      "audioUrl": "https://example.com/audio1.mp3"
    },
    {
      "title": "The Power of Positive Thinking",
      "host": "Mental Wellness Podcast",
      "duration": "30 min",
      "audioUrl": "https://example.com/audio2.mp3"
    },
    {
      "title": "The Power of Mind",
      "host": "Mental Wellness Podcast",
      "duration": "30 min",
      "audioUrl": "https://example.com/audio3.mp3"
    },
    {
      "title": "Mindfulness Meditation",
      "host": "Calm Minds",
      "duration": "25 min",
      "audioUrl": "https://example.com/audio4.mp3"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mental Health Podcasts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: podcasts.length,
        itemBuilder: (context, index) {
          return Card(
            key: Key('podcast_$index'), // Assigning a unique key
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                podcasts[index]["title"]!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Host: ${podcasts[index]["host"]!} • ${podcasts[index]["duration"]!}",
              ),
              trailing: Icon(Icons.play_circle_fill, color: Colors.green),
              onTap: () {
                // Play audio using audio plugin
              },
            ),
          );
        },
      ),
    );
  }
}

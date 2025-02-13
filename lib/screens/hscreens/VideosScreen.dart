import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class VideosScreen extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {
      'title': 'Mental Health Explainer: What is OCD?',
      'source': 'APA',
      'url': 'https://www.youtube.com/watch?v=d_snmHhA5N0',
      'image': 'lib/assets/hscreen/video1.png',
    },
    {
      'title': 'How Climate Change Impacts Your Mental Health',
      'source': 'APA',
      'url': 'https://www.youtube.com/watch?v=YdMCL9_UTE4',
      'image': 'lib/assets/hscreen/video2.png',
    },
    {
      'title': 'What is Addiction?',
      'source': 'APA',
      'url': 'https://www.youtube.com/watch?v=H7eC5R9OJV8',
      'image': 'lib/assets/hscreen/video3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mental Health Videos',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF6A5ACD),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: Image.asset(
                video['image']!,
                width: 100,
                fit: BoxFit.cover,
              ),
              title: Text(
                video['title']!,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                video['source']!,
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                // Implement navigation to a video player or external link
              },
            ),
          );
        },
      ),
    );
  }
}

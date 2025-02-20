import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:mentalhealth/screens/HomeScreen.dart';

class VideosScreen extends StatelessWidget {
  final Color backgroundColor;

  VideosScreen({Key? key, required this.backgroundColor}) : super(key: key);

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
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);

            // Handle back action
          },
        ),
        title: Text(
          'Videos',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        actions: [
          /*IconButton(
            icon: Icon(CupertinoIcons.search, color: Colors.white),
            onPressed: () {
              // Handle search action
            },
          ),*/
        ],
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      video['image']!,
                      width: 150,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video['title']!,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          video['source']!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

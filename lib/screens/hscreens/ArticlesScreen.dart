import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticlesScreen extends StatelessWidget {
  final List<Map<String, String>> articles = [
    {
      'title': 'Children Still Being Sent Far from Home for Mental Health Care in England',
      'source': 'The Guardian',
      'date': 'February 8, 2025',
      'url': 'https://www.theguardian.com/society/2025/feb/08/children-sent-far-from-home-mental-health-care-nhs-england',
      'image': 'lib/assets/hscreen/article1.webp',
    },
    {
      'title': 'Reversing Memory Loss in Early Alzheimer\'s',
      'source': 'ScienceDaily',
      'date': 'February 10, 2025',
      'url': 'https://www.sciencedaily.com/releases/2025/02/250210101010.htm',
      'image': 'lib/assets/hscreen/article2.jpeg',
    },
    {
      'title': 'Anxiety and Stress Weighing Heavily at Night? A New Blanket Might Help',
      'source': 'Harvard Health',
      'date': 'February 7, 2025',
      'url': 'https://www.health.harvard.edu/blog/anxiety-and-stress-weighing-heavily-at-night-a-new-blanket-might-help-2025020720107',
      'image': 'lib/assets/hscreen/article3.webp',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Articles on Mental Health',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF6A5ACD),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: Image.asset(
                article['image']!,
                width: 100,
                fit: BoxFit.cover,
              ),
              title: Text(
                article['title']!,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${article['source']} - ${article['date']}',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                // Implement navigation to a detailed view or external link
              },
            ),
          );
        },
      ),
    );
  }
}

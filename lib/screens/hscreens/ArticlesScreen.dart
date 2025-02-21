import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticlesScreen extends StatelessWidget {
  final Color backgroundColor;
  ArticlesScreen({
    Key? key,
    required this.backgroundColor,
  }) : super(key: key);
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
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Articles',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () {
                // Implement navigation to a detailed view or external link
              },
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Container with fixed height
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        article['image']!,
                        width: 150,
                        height: 120, // Ensure height is set
                        fit: BoxFit.cover, // Fills the box while maintaining aspect ratio
                      ),
                    ),
                    SizedBox(width: 10), // Spacing between image and text
                    // Text Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article['title']!,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${article['source']} - ${article['date']}',
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
            ),
          );
        },
      ),
    );
  }
}

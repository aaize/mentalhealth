import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalhealth/screens/hscreens/VideoPlayerScreen.dart';

class VideosScreen extends StatelessWidget {
  final Color backgroundColor;

  VideosScreen({Key? key, required this.backgroundColor}) : super(key: key);

  final List<Map<String, String>> videos = [
    {
      'title': 'Meditation for Stress',
      'source': 'Psych Hub',
      'url': 'https://www.youtube.com/watch?v=Ix73CLI0Mo0',
    },
    {
      'title': 'How Does Food Impact Mental Health?',
      'source': 'Psych Hub',
      'url': 'https://www.youtube.com/watch?v=rtABcNUIQwQ',
    },
    {
      'title': '10-Minute Meditation For Stress',
      'source': 'Goodful',
      'url': 'https://www.youtube.com/watch?v=z6X5oEIg6Ak',
    },
    {
      'title': 'Work-Life Balance and Mental Health',
      'source': 'Laura',
      'url': 'https://www.youtube.com/watch?v=T66oY4tL2co',
    },
    {
      'title': '20 Minute Guided Meditation for Reducing Anxiety and Stress',
      'source': 'Mindful Peace Journey',
      'url': 'https://www.youtube.com/watch?v=MIr3RsUWrdo',
    },
    {
      'title': 'Virtual Wellness Series: How does Nutrition Impact Your Mental Health',
      'source': 'Wellness Series',
      'url': 'https://www.youtube.com/watch?v=eH414ixcIHI',
    },
    {
      'title': '15 Minute Guided Imagery Meditation Exercise',
      'source': 'City of Hope',
      'url': 'https://www.youtube.com/watch?v=qcdbCphVa1g',
    },
    {
      'title': 'How Food Influences Your Mental Health',
      'source': 'Deepak Chopra',
      'url': 'https://www.facebook.com/DeepakChopra/videos/how-food-influences-your-mental-health/3856601054601401/',
    },
    {
      'title': 'Stillness For Stress Relief | 15-Minute Meditation',
      'source': 'Yoga With Adriene',
      'url': 'https://www.youtube.com/watch?v=CscxGprl1yw',
    },
    {
      'title': 'How Food Affects Our Mental Health | ENDEVR Documentary',
      'source': 'ENDEVR',
      'url': 'https://www.youtube.com/watch?v=Wth5CSX7_hQ',
    },
    {
      'title': 'Food and Mood: Diet and Depression (Part 1)',
      'source': 'Mental Health Foundation',
      'url': 'https://www.youtube.com/watch?v=e9emXL4VKmc',
    },
    {
      'title': 'Headspace | Mini Meditation | Let Go of Stress',
      'source': 'Headspace',
      'url': 'https://www.youtube.com/watch?v=c1Ndym-IsQg',
    },
    {
      'title': 'Supporting a Healthy Mind Through Diet & Exercise',
      'source': 'McLean Hospital',
      'url': 'https://www.mcleanhospital.org/video/supporting-healthy-mind-through-diet-exercise',
    },
    {
      'title': 'A 10-Minute Meditation for Stress from Headspace',
      'source': 'Headspace',
      'url': 'https://www.youtube.com/watch?v=lS0kcSNlULw',
    },
    {
      'title': 'Feed Your Mental Health | Drew Ramsey | TEDxCharlottesville',
      'source': 'TEDx Talks',
      'url': 'https://www.youtube.com/watch?v=BbLFsQubdtw',
    },
  ];


  String? getYouTubeThumbnail(String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.host.contains('youtube.com')) return null;
    final videoId = uri.queryParameters['v'];
    if (videoId == null) return null;
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: backgroundColor,
        border: null,
        brightness: Brightness.dark,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.back, color: Colors.white),
        ),
        middle: Text(
          'Videos',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final thumbnailUrl = getYouTubeThumbnail(video['url']!);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => VideoPlayerScreen(videoUrl: video['url']!),
                ),
              );
            },
            child: Card(
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
                      child: thumbnailUrl != null
                          ? Image.network(
                        thumbnailUrl,
                        width: 150,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        width: 150,
                        height: 100,
                        color: Colors.grey,
                        child: Icon(Icons.videocam, color: Colors.white),
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
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AgeAdviceScreen extends StatelessWidget {
  final String ageRange;
  final String content;
  final Color backgroundColor;

  const AgeAdviceScreen({
    Key? key,
    required this.ageRange,
    required this.content,
    required this.backgroundColor
  }) : super(key: key);

  // Function to launch URLs
  Future<void> _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: backgroundColor,
        middle: Text('Age-Specific Advice ($ageRange)',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w400,
          color: CupertinoColors.white
        ),),
        leading: IconButton(icon: Icon(CupertinoIcons.back,
            size: 23), onPressed: () {
          Navigator.pop(context);
        },
        ),

      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionHeader('Advice for $ageRange'),
            _buildAdviceSection(content),
            _buildSectionHeader('Tips for $ageRange'),
            _buildTipsSection(),
            _buildSectionHeader('Recommended Articles'),
            _buildArticlesSection(context),
            _buildSectionHeader('Exercises for $ageRange'),
            _buildExercisesSection(context),
            _buildSectionHeader('Videos for $ageRange'),
            _buildVideosSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.label,
        ),
      ),
    );
  }

  Widget _buildAdviceSection(String content) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        content,
        style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
      ),
    );
  }

  Widget _buildTipsSection() {
    final tips = [
      '• Maintain a consistent sleep schedule.',
      '• Engage in regular physical activity.',
      '• Practice mindfulness and meditation.',
      '• Stay socially connected with friends and family.',
    ];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tips.map((tip) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            tip,
            style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildArticlesSection(BuildContext context) {
    final articles = [
      {"title": "Longevity To-Do List for Your 30s", "url": "https://www.verywellhealth.com/longevity-to-dos-for-your-30s-2223717"},
      {"title": "Good Sleep for Good Health", "url": "https://newsinhealth.nih.gov/2021/04/good-sleep-good-health"},
      {"title": "Mindfulness for Beginners: Reclaiming the Present Moment and Your Life", "url": "https://www.amazon.com/Mindfulness-Beginners-Reclaiming-Present-Moment/dp/1622036670"}
    ];

    return Column(
      children: articles.map((article) => CupertinoListTile(
        title: Text(
          article['title']!,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        trailing: const Icon(CupertinoIcons.chevron_forward),
        onTap: () {
          _launchURL(context, article['url']!); // Launch the article URL
        },
      )).toList(),
    );
  }

  Widget _buildExercisesSection(BuildContext context) {
    final exercises = [
      {
        'name': 'Morning Stretch Routine',
        'url': 'https://www.bupa.co.uk/newsroom/ourviews/waking-up-stretching'
      },
      {
        'name': 'Cardio Exercises at Home',
        'url': 'https://www.medicalnewstoday.com/articles/cardio-exercises-at-home'
      },
      {
        'name': 'Yoga for Relaxation',
        'url': 'https://www.healthline.com/health/fitness-exercise/morning-stretches'
      },];

    return Column(
      children: exercises.map((exercise) => CupertinoListTile(
        title: Text(
          exercise['name']!,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        trailing: const Icon(CupertinoIcons.chevron_forward),
        onTap: () {
          _launchURL(context, exercise['url']!); // Launch the exercise URL
        },
      )).toList(),
    );
  }

  Widget _buildVideosSection(BuildContext context) {
    final videos = [
      {
        'title': 'Quick Morning Stretching Routine For Flexibility, Mobility',
        'url': 'https://www.youtube.com/watch?v=t2jel6q1GRk'
      },
      {
        'title': '10 Minute Morning Stretch for Every Day',
        'url': 'https://www.youtube.com/watch?v=ihba9Lw0tv4'
      },];

    return Column(
      children: videos.map((video) => CupertinoListTile(
        title: Text(
          video['title']!,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        trailing: const Icon(CupertinoIcons.chevron_forward),
        onTap: () {
          _launchURL(context, video['url']!); // Launch the video URL
        },
      )).toList(),
    );
  }
}

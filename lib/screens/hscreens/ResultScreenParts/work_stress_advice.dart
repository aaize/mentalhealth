import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkStressAdviceScreen extends StatelessWidget {
  final String content;

  const WorkStressAdviceScreen({
    Key? key,
    required this.content,
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
        middle: Text('Work Stress Management'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionHeader('Work Stress Management Advice'),
            _buildAdviceSection(content),
            _buildSectionHeader('Recommended Articles'),
            _buildArticlesSection(context),
            _buildSectionHeader('Informative Videos'),
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

  Widget _buildArticlesSection(BuildContext context) {
    final articles = [
      {
        'title': 'Stress Management: Enhance Your Well-Being',
        'url': 'https://www.mayoclinic.org/healthy-lifestyle/stress-management/in-depth/stress-relief/art-20044456',
      },
      {
        'title': 'Work, Stress, and Health & Socioeconomic Status',
        'url': 'https://www.apa.org/pi/ses/resources/publications/work-stress-health',
      },
      {
        'title': 'Coping with Stress at Work',
        'url': 'https://www.cdc.gov/niosh/topics/stress/default.html',
      },
    ];

    return Column(
      children: articles.map((article) => CupertinoListTile(
        title: Text(
          article['title']!,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        trailing: const Icon(CupertinoIcons.chevron_forward),
        onTap: () {
          _launchURL(context, article['url']!);
        },
      )).toList(),
    );
  }

  Widget _buildVideosSection(BuildContext context) {
    final videos = [
      {
        'title': 'How to Manage Stress at Work',
        'url': 'https://www.youtube.com/watch?v=WvYEZk6xjD8',
      },
      {
        'title': '5 Tips to Reduce Work Stress',
        'url': 'https://www.youtube.com/watch?v=8jrxpT_zBYE',
      },

    ];

    return Column(
      children: videos.map((video) => CupertinoListTile(
        title: Text(
          video['title']!,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        trailing: const Icon(CupertinoIcons.chevron_forward),
        onTap: () {
          _launchURL(context, video['url']!);
        },
      )).toList(),
    );
  }
}

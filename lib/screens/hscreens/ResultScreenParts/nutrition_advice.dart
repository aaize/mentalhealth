import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NutritionAdviceScreen extends StatelessWidget {
  final String content;
  final Color backgroundColor;

  const NutritionAdviceScreen({
    Key? key,
    required this.content,
    required this.backgroundColor,
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
        middle: Text('Nutrition Advice',
        style: (GoogleFonts.roboto(color: CupertinoColors.white,
        fontWeight: FontWeight.w400)),),
        border: null,
        backgroundColor: backgroundColor,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(CupertinoIcons.back,size: 23,)),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionHeader('General Nutrition Advice'),
            _buildAdviceSection(content),
            SizedBox(height: 20,),
            Divider(),
            _buildSectionHeader('Recommended Articles'),
            _buildArticlesSection(context),
            SizedBox(height: 20,),
            Divider(),
            _buildSectionHeader('Informative Videos'),
            _buildVideosSection(context),
            SizedBox(height: 20,),
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
        style: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: backgroundColor,
          decoration: TextDecoration.none
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
        style: GoogleFonts.poppins(fontSize: 16, height: 1.5,
        color: Colors.green),
      ),
    );
  }

  Widget _buildArticlesSection(BuildContext context) {
    final articles = [
      {
        'title': '27 Natural Health and Nutrition Tips That Are Evidence-Based',
        'url': 'https://www.healthline.com/nutrition/27-health-and-nutrition-tips',
      },
      {
        'title': 'Choosing Healthy Foods for a Balanced Diet',
        'url': 'https://www.helpguide.org/articles/healthy-eating/healthy-eating.htm',
      },
      {
        'title': 'Healthy Eating Plate',
        'url': 'https://www.hsph.harvard.edu/nutritionsource/healthy-eating-plate/',
      },
    ];

    return Column(
      children: articles.map((article) => CupertinoListTile(
        title: Text(
          article['title']!,
          style: GoogleFonts.poppins(fontSize: 16,
          color: CupertinoColors.inactiveGray),
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
        'title': 'Nutrition Tips for Eating Out in a Healthy Way',
        'url': 'https://www.youtube.com/watch?v=FyxrX1loUjE',
      },
      {
        'title': 'HOW TO SIMPLIFY HEALTHY EATING | Start with 3 simple steps!',
        'url': 'https://www.youtube.com/watch?v=TjtNpxLllP0',
      },
    ];

    return Column(
      children: videos.map((video) => CupertinoListTile(
        title: Text(
          video['title']!,
          style: GoogleFonts.poppins(fontSize: 16,
          color: CupertinoColors.inactiveGray),
        ),
        trailing: const Icon(CupertinoIcons.chevron_forward),
        onTap: () {
          _launchURL(context, video['url']!);
        },
      )).toList(),
    );
  }
}

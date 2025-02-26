import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalhealth/screens/hscreens/ResultScreenParts/age_advice.dart';
import 'package:mentalhealth/screens/hscreens/ResultScreenParts/nutrition_advice.dart';
import 'package:mentalhealth/screens/hscreens/ResultScreenParts/work_stress_advice.dart';

class ResultScreen extends StatefulWidget {
  final int totalScore;
  final Color backgroundColor;
  final List<int> responses;
  final String ageRange;
  final String meals;
  final String workPressure;

  const ResultScreen({
    super.key,
    required this.totalScore,
    required this.responses,
    required this.backgroundColor,
    required this.ageRange,
    required this.meals,
    required this.workPressure,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _calculateMentalHealthScore() {
    return (widget.responses.reduce((a, b) => a + b) ~/ 4);
  }

  int _ageScore(String range) {
    const scores = {'18-25': 0, '26-35': 1, '36-45': 2, '46-55': 3, '56+': 4};
    return scores[range] ?? 0;
  }

  int _mealScore(String meals) {
    const scores = {'1': 3, '2': 2, '3': 1, '4+': 0};
    return scores[meals] ?? 0;
  }

  int _workScore(String pressure) {
    const scores = {'Low': 0, 'Moderate': 2, 'High': 4};
    return scores[pressure] ?? 0;
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white60,
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(String title, String content, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => screen),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: CupertinoListTile(
          leading: Icon(icon, color: widget.backgroundColor, size: 29),
          title: Text(
            title,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: widget.backgroundColor),
          ),
          subtitle: Text(
            content,
            style: GoogleFonts.poppins(fontSize: 14, height: 1.4, color: Colors.grey),
          ),
          trailing: const Icon(CupertinoIcons.chevron_forward, size: 18),
        ),
      ),
    );
  }

  Widget _buildAgeRecommendations() {
    final recommendations = <String, String>{
      '18-25': '• Establish healthy sleep patterns\n• Regular physical activity 4-5x/week\n• Mindfulness practices\n• Social connection maintenance',
      '26-35': '• Stress management techniques\n• Balanced work-life routine\n• Annual health checkups\n• Strength training 3x/week',
      '36-45': '• Cardiovascular exercises\n• Regular health screenings\n• Mental health awareness\n• Nutritional supplements if needed',
      '46-55': '• Low-impact exercises\n• Bone density monitoring\n• Cognitive activities\n• Regular social engagement',
      '56+': '• Gentle daily movement\n• Fall prevention measures\n• Regular medical checkups\n• Community participation',
    };

    return _buildRecommendationCard(
      'Age-Specific Advice (${widget.ageRange})',
      recommendations[widget.ageRange] ?? '• Maintain regular health checkups\n• Stay physically active\n• Balanced nutrition\n• Social engagement',
      CupertinoIcons.heart_circle,
      AgeAdviceScreen(ageRange: widget.ageRange, content: recommendations[widget.ageRange] ?? ''),
    );
  }

  Widget _buildNutritionAdvice() {
    String content;
    switch (widget.meals) {
      case '1':
        content = '⚠️ Consider increasing meal frequency:\n• Add nutrient-dense snacks\n• Focus on protein intake\n• Stay hydrated throughout the day';
        break;
      case '2':
        content = '➡️ Ideal: 3-4 balanced meals\n• Include healthy fats\n• Complex carbohydrates\n• Fiber-rich vegetables';
        break;
      case '3':
        content = '✓ Good balance\n• Maintain consistent timing\n• Watch portion sizes\n• Include varied food groups';
        break;
      default:
        content = '✓ Adequate frequency\n• Mindful eating practices\n• Avoid over-snacking\n• Balance macros';
    }
    return _buildRecommendationCard(
      'Nutrition Guidance (${widget.meals} meals)',
      content,
      CupertinoIcons.leaf_arrow_circlepath,
      NutritionAdviceScreen(content: content),
    );
  }

  Widget _buildWorkStressAdvice() {
    final advice = {
      'Low': '• Maintain work-life balance\n• Skill development\n• Proactive stress management',
      'Moderate': '• Regular breaks\n• Time management\n• Relaxation techniques',
      'High': '⚠️ Priority Stress Reduction:\n• Daily decompression routine\n• Set clear boundaries\n• Professional support if needed',
    };

    return _buildRecommendationCard(
      'Work Pressure Management (${widget.workPressure})',
      advice[widget.workPressure] ?? '• Regular stress assessments\n• Healthy coping mechanisms\n• Workload prioritization',
      CupertinoIcons.briefcase,
      WorkStressAdviceScreen(content: advice[widget.workPressure] ?? ''),
    );
  }

  Widget _buildProfessionalCard(Professional professional) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      ),
      child: CupertinoListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: widget.backgroundColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(CupertinoIcons.person_fill, color: widget.backgroundColor),
        ),
        title: Text(
          professional.name,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: CupertinoColors.opaqueSeparator),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${professional.experience} years experience'),
            Text('${professional.location} • ₹${professional.consultationFee}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(CupertinoIcons.star_fill, size: 16, color: CupertinoColors.systemYellow),
                const SizedBox(width: 4),
                Text('${professional.rating}%', style: GoogleFonts.poppins(fontSize: 14)),
              ],
            ),
          ],
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Book', style: TextStyle(color: CupertinoColors.systemBlue)),
          onPressed: () {/* Add booking logic */},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final professionals = [
      Professional(
        name: 'Dr. Anika Rao',
        experience: 8,
        rating: 97,
        location: 'Indiranagar',
        consultationFee: 1500,
      ),
      Professional(
        name: 'Dr. Rajesh Menon',
        experience: 15,
        rating: 98,
        location: 'Koramangala',
        consultationFee: 2000,
      ),
    ];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: widget.backgroundColor,
        middle: Text(
          'Health Summary',
          style: GoogleFonts.poppins(
              color: CupertinoColors.white,
              fontWeight: FontWeight.w500),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 16),
          children: [
            CupertinoListSection.insetGrouped(
              decoration: BoxDecoration(
                color: CupertinoTheme.of(context).scaffoldBackgroundColor,
              ),
              children: [
                CupertinoListTile(
                  title: Text('Overall Score', style: GoogleFonts.poppins(color: Colors.blueGrey)),
                  additionalInfo: Text(
                    widget.totalScore.toString(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.opaqueSeparator,
                      fontSize: 24,
                    ),
                  ),
                ),
                CupertinoListTile(
                  title: Text('Age Group', style: GoogleFonts.poppins(color: Colors.blueGrey)),
                  additionalInfo: Text(widget.ageRange),
                ),
                CupertinoListTile(
                  title: Text('Daily Meals', style: GoogleFonts.poppins(color: Colors.blueGrey)),
                  additionalInfo: Text(widget.meals),
                ),
                CupertinoListTile(
                  title: Text('Work Stress', style: GoogleFonts.poppins(color: Colors.blueGrey)),
                  additionalInfo: Text(widget.workPressure),
                ),
              ],
            ),

            _buildSectionHeader('Key Areas of Concern'),

            Container(
              height: 220,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelRotation: -45,
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                  labelStyle: GoogleFonts.poppins(fontSize: 12),
                ),
                primaryYAxis: const NumericAxis(isVisible: false),
                series: <BarSeries<MapEntry<String, int>, String>>[
                  BarSeries(
                    dataSource: [
                      MapEntry('Mental\nHealth', _calculateMentalHealthScore()),
                      MapEntry('Nutrition', _mealScore(widget.meals)),
                      MapEntry('Work\nStress', _workScore(widget.workPressure)),
                    ],
                    xValueMapper: (entry, _) => entry.key,
                    yValueMapper: (entry, _) => entry.value,
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),

            _buildAgeRecommendations(),
            _buildNutritionAdvice(),
            _buildWorkStressAdvice(),

            _buildSectionHeader('Recommended Professionals'),

            ...professionals.map((professional) => _buildProfessionalCard(professional)).toList(),
          ],
        ),
      ),
    );
  }
}

class Professional {
  final String name;
  final int experience;
  final int rating;
  final String location;
  final int consultationFee;

  const Professional({
    required this.name,
    required this.experience,
    required this.rating,
    required this.location,
    required this.consultationFee,
  });
}
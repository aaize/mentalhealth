import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatelessWidget {
  final int totalScore;
  final Color backgroundColor;
  final List<int> responses;
  final String ageRange;
  final String meals;
  final String workPressure;

  ResultScreen({
    required this.totalScore,
    required this.responses,
    required this.backgroundColor,
    required this.ageRange,
    required this.meals,
    required this.workPressure,
  });

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        subtitle: Text(value, style: GoogleFonts.poppins(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Professional> professionals = [
      Professional(
        name: 'Dr. Krishen Ranganath',
        experience: 25,
        rating: 99,
        location: 'Seshadripuram',
        consultationFee: 1800,
      ),
      // Add other professionals...
    ];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Assessment Results',
            style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: backgroundColor,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildInfoCard('Total Score', totalScore.toString()),
                  _buildInfoCard('Age Range', ageRange),
                  _buildInfoCard('Daily Meals', meals),
                  _buildInfoCard('Work Pressure', workPressure),

                  SizedBox(height: 20),
                  Text('Response Summary:',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Container(
                    height: 300,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(labelRotation: -45),
                      series: <CartesianSeries>[
                        BarSeries<MapEntry<String, int>, String>(
                          dataSource: [
                            MapEntry('Mental Health', responses.reduce((a, b) => a + b)),
                            MapEntry('Age Factor', _ageScore(ageRange)),
                            MapEntry('Nutrition', _mealScore(meals)),
                            MapEntry('Work Stress', _workScore(workPressure)),
                          ],
                          xValueMapper: (entry, _) => entry.key,
                          yValueMapper: (entry, _) => entry.value,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          color: backgroundColor,
                        )
                      ],
                    ),
                  ),

                  if (totalScore > 15) ...[
                    SizedBox(height: 20),
                    Text('Recommended Professionals:',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                    ...professionals.map((p) => _professionalCard(p)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _ageScore(String range) {
    const scores = {'18-25':0, '26-35':1, '36-45':2, '46-55':3, '56+':4};
    return scores[range] ?? 0;
  }

  int _mealScore(String meals) {
    const scores = {'1':3, '2':2, '3':1, '4+':0};
    return scores[meals] ?? 0;
  }

  int _workScore(String pressure) {
    const scores = {'Low':0, 'Moderate':2, 'High':4};
    return scores[pressure] ?? 0;
  }

  Widget _professionalCard(Professional p) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(CupertinoIcons.person_crop_circle_fill, size: 40),
        title: Text(p.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${p.experience} years experience'),
            Text('${p.rating}% satisfaction'),
            Text('Fee: ₹${p.consultationFee}'),
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
  final int consultationFee;

  Professional({
    required this.name,
    required this.experience,
    required this.rating,
    required this.consultationFee, required String location,
  });
}
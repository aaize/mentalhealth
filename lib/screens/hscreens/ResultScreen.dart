import 'package:flutter/material.dart';
import 'package:charts_flutter_updated/charts_flutter_updated.dart' as charts;
import 'package:google_fonts/google_fonts.dart';

class QuestionScore {
  final String question;
  final int score;
  final charts.Color color;

  QuestionScore(this.question, this.score, Color color)
      : this.color = charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class Professional {
  final String name;
  final int experience; // in years
  final int rating; // as a percentage
  final String location;
  final int consultationFee; // in INR

  Professional({
    required this.name,
    required this.experience,
    required this.rating,
    required this.location,
    required this.consultationFee,
  });
}

class ResultScreen extends StatelessWidget {
  final int totalScore;
  final Color backgroundColor;
  final List<int> responses;

  ResultScreen({
    required this.totalScore,
    required this.responses,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Data for the stacked bar chart
    final List<QuestionScore> data = List.generate(
      responses.length,
          (index) => QuestionScore(
        'Q${index + 1}',
        responses[index],
        backgroundColor,
      ),
    );

    List<charts.Series<QuestionScore, String>> _createSampleData() {
      return [
        charts.Series<QuestionScore, String>(
          id: 'Scores',
          domainFn: (QuestionScore qs, _) => qs.question,
          measureFn: (QuestionScore qs, _) => qs.score,
          colorFn: (QuestionScore qs, _) => qs.color,
          data: data,
        )
      ];
    }

    // List of mental health professionals in Bengaluru
    final List<Professional> professionals = [
      Professional(
        name: 'Dr. Krishen Ranganath',
        experience: 25,
        rating: 99,
        location: 'Seshadripuram',
        consultationFee: 1800,
      ),
      Professional(
        name: 'Dr. Sushruth',
        experience: 13,
        rating: 98,
        location: 'Indiranagar',
        consultationFee: 750,
      ),
      Professional(
        name: 'Dr. Venkatesh Babu G M',
        experience: 19,
        rating: 85,
        location: 'HSR Layout',
        consultationFee: 1200,
      ),
      // Add more professionals as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assessment Results',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Total Score
            Center(
              child: Text(
                'Your Total Score: $totalScore',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Stacked Bar Chart
            Text(
              'Your Responses Overview:',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 300,
              child: charts.BarChart(
                _createSampleData(),
                animate: true,
                barGroupingType: charts.BarGroupingType.stacked,
                vertical: true,
              ),
            ),
            SizedBox(height: 30),

            // Conditional Display of Contact Cards
            if (totalScore < 10) ...[
              Text(
                'We recommend consulting with a mental health professional:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: professionals.map((professional) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        Icons.local_hospital,
                        color: backgroundColor,
                        size: 50,
                      ),
                      title: Text(
                        professional.name,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${professional.experience} years experience\n'
                            'Rating: ${professional.rating}%\n'
                            'Location: ${professional.location}\n'
                            'Consultation Fee: ₹${professional.consultationFee}',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

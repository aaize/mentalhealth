import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionScore {
  final String question;
  final int score;

  QuestionScore(this.question, this.score);
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
  final List<int> responses;

  ResultScreen({required this.totalScore, required this.responses});

  @override
  Widget build(BuildContext context) {
    // Data for the bar chart
    final List<QuestionScore> data = List.generate(
      responses.length,
          (index) => QuestionScore('Q${index + 1}', responses[index]),
    );

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
        title: Text('Assessment Results', style: GoogleFonts.poppins()),
        backgroundColor: Colors.deepPurple,
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

            // Bar Chart
            Text(
              'Your Responses Overview:',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<QuestionScore, String>(
                    dataSource: data,
                    xValueMapper: (QuestionScore qs, _) => qs.question,
                    yValueMapper: (QuestionScore qs, _) => qs.score,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Conditional Content Based on Total Score
            if (totalScore > 10) ...[
              Center(
                child: Text(
                  'Great job! Your assessment indicates a positive mental health status. Keep up the good work!',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ] else ...[
              Text(
                'Based on your assessment, you might find it helpful to consult with a mental health professional. Here are some options in Bengaluru:',
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
                      leading: Icon(Icons.local_hospital, color: Colors.deepPurple),
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

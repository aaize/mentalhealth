import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ResultScreen.dart'; // Import the result screen file

class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  // Define a list of questions
  final List<String> questions = [
    'How often do you feel overwhelmed?',
    'How often do you feel hopeless?',
    'How often do you feel anxious?',
    'How often do you have trouble sleeping?',
    'How often do you feel isolated?'
  ];

  // Default rating of 3 for each question (range 1-5)
  List<double> ratings = [3, 3, 3, 3, 3];

  // Define a threshold (e.g., if total score is less than 15, consider that needing help)
  final double threshold = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mental Health Questionnaire", style: GoogleFonts.poppins()),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questions[index],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Slider(
                            value: ratings[index],
                            min: 1,
                            max: 5,
                            divisions: 4,
                            label: ratings[index].round().toString(),
                            onChanged: (value) {
                              setState(() {
                                ratings[index] = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Calculate total score
                double totalScore = ratings.reduce((a, b) => a + b);
                bool needsHelp = totalScore < threshold;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(
                      totalScore: totalScore,
                      needsHelp: needsHelp,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: Text(
                'Submit Questionnaire',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

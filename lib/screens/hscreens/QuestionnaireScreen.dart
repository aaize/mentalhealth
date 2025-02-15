import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalhealth/screens/hscreens/ResultScreen.dart';

class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final List<String> questions = [
    'How often do you feel depressed?',
    'How often do you feel anxious?',
    'How often do you feel overwhelmed?',
    'How often do you experience panic attacks?',
    'How often do you have difficulty sleeping?',
    'How often do you feel hopeless?',
    'How often do you feel isolated?',
    'How often do you have difficulty concentrating?',
    'How often do you feel irritable?',
    'How often do you withdraw from social activities?',
  ];

  List<int> responses = List.filled(10, 3);

  int mapResponseToScore(int response) {
    switch (response) {
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 0;
      case 4:
        return -1;
      case 5:
        return -2;
      default:
        return 0;
    }
  }

  void handleSubmit() {
    int totalScore = responses.map(mapResponseToScore).reduce((a, b) => a + b);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(totalScore: totalScore, responses: responses),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Health Questionnaire', style: GoogleFonts.poppins()),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                            value: responses[index].toDouble(),
                            min: 1,
                            max: 5,
                            divisions: 4,
                            label: responses[index].toString(),
                            onChanged: (value) {
                              setState(() {
                                responses[index] = value.toInt();
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
              onPressed: handleSubmit,
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentalhealth/screens/hscreens/ResultScreen.dart';

class QuestionnaireScreen extends StatefulWidget {
  final Color backgroundColor;

  const QuestionnaireScreen({
    Key? key,
    required this.backgroundColor,
  }) : super(key: key);

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
      CupertinoPageRoute(
        builder: (context) => ResultScreen(
          totalScore: totalScore,
          responses: responses,
          backgroundColor: widget.backgroundColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Questionnaire',
          style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 23)),
        backgroundColor: widget.backgroundColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.back),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: CupertinoFormSection(
                      header: Text(
                        questions[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        CupertinoSlider(
                          value: responses[index].toDouble(),
                          min: 1,
                          max: 5,
                          divisions: 4,
                          onChanged: (value) {
                            setState(() {
                              responses[index] = value.toInt();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(17.0),
              child: CupertinoButton(
                color: CupertinoColors.systemIndigo,
                onPressed: handleSubmit,
                child: Text('Submit Questionnaire',
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}

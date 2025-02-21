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
  String selectedAgeRange = '18-25';
  String selectedMeals = '3';
  String selectedWorkPressure = 'Low';

  final Map<String, int> ageScores = {
    '18-25': 0,
    '26-35': 1,
    '36-45': 2,
    '46-55': 3,
    '56+': 4
  };

  final Map<String, int> mealScores = {
    '1': 3,
    '2': 2,
    '3': 1,
    '4+': 0
  };

  final Map<String, int> workPressureScores = {
    'Low': 0,
    'Moderate': 2,
    'High': 4
  };

  int mapResponseToScore(int response) {
    switch (response) {
      case 1: return 1;
      case 2: return 2;
      case 3: return 0;
      case 4: return -1;
      case 5: return -2;
      default: return 0;
    }
  }

  void handleSubmit() {
    int totalScore = responses.map(mapResponseToScore).reduce((a, b) => a + b);
    totalScore += ageScores[selectedAgeRange]!;
    totalScore += mealScores[selectedMeals]!;
    totalScore += workPressureScores[selectedWorkPressure]!;

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ResultScreen(
          totalScore: totalScore,
          responses: responses,
          backgroundColor: widget.backgroundColor,
          ageRange: selectedAgeRange,      // Add this
          meals: selectedMeals,            // Add this
          workPressure: selectedWorkPressure, // Add this
        ),
      ),
    );
  }

  Widget _buildDropdownQuestion(String title, String value, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                spreadRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ), // <-- Closing BoxDecoration properly
          child: CupertinoFormSection(
            header: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: widget.backgroundColor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSlidingSegmentedControl<String>(
                  groupValue: value,
                  children: {
                    for (var item in items)
                      item: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(item),
                      )
                  },
                  onValueChanged: onChanged,
                ),
              ),
            ],
          ),
        ), // <-- Closing Container properly

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Questionnaire',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 20,
            decoration: TextDecoration.none,
          ),
        ),
        backgroundColor: widget.backgroundColor,
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
                children: [
                  _buildDropdownQuestion(
                    'Select your age range:',
                    selectedAgeRange,
                    ['18-25', '26-35', '36-45', '46-55', '56+'],
                        (value) => setState(() => selectedAgeRange = value!),
                  ),
                  _buildDropdownQuestion(
                    'How many meals do you have daily?',
                    selectedMeals,
                    ['1', '2', '3', '4+'],
                        (value) => setState(() => selectedMeals = value!),
                  ),
                  _buildDropdownQuestion(
                    'How would you rate your work pressure?',
                    selectedWorkPressure,
                    ['Low', 'Moderate', 'High'],
                        (value) => setState(() => selectedWorkPressure = value!),
                  ),
                  ...List.generate(questions.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBackground.resolveFrom(context),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CupertinoFormSection(
                            header: Text(
                              questions[index],
                              style: TextStyle(
                                fontSize: 18,
                                color: widget.backgroundColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CupertinoSlider(
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(17.0),
              child: CupertinoButton(
                color: CupertinoColors.systemIndigo,
                onPressed: handleSubmit,
                child: Text('Submit Questionnaire'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
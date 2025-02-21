import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentalhealth/screens/hscreens/ResultScreen.dart';

class QuestionnaireScreen extends StatefulWidget {
  final Color backgroundColor;

  const QuestionnaireScreen({
    super.key,
    required this.backgroundColor,
  });

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
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
    final totalScore = responses.map(mapResponseToScore).reduce((a, b) => a + b) +
        ageScores[selectedAgeRange]! +
        mealScores[selectedMeals]! +
        workPressureScores[selectedWorkPressure]!;

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ResultScreen(
          totalScore: totalScore,
          responses: responses,
          backgroundColor: widget.backgroundColor,
          ageRange: selectedAgeRange,
          meals: selectedMeals,
          workPressure: selectedWorkPressure,
        ),
      ),
    );
  }

  Widget _buildDropdownQuestion(String title, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CupertinoFormSection(
            header: Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: widget.backgroundColor,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none
                ),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSlidingSegmentedControl<String>(
                  groupValue: value,
                  thumbColor: widget.backgroundColor,
                  backgroundColor: CupertinoColors.tertiarySystemFill,
                  children: {
                    for (var item in items)
                      item: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          item,
                          style: const TextStyle(color: CupertinoColors.opaqueSeparator,
                              decoration: TextDecoration.none

                          ),
                        ),
                      )
                  },
                  onValueChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionSlider(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CupertinoFormSection(
            header: Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 8.0),
              child: Text(
                questions[index],
                style: TextStyle(
                  fontSize: 18,
                  color: widget.backgroundColor,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none
                ),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    CupertinoSlider(
                      value: responses[index].toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      activeColor: widget.backgroundColor,
                      thumbColor: widget.backgroundColor,
                      onChanged: (value) {
                        setState(() {
                          responses[index] = value.toInt();
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Never', style: TextStyle(fontSize: 12,
                          decoration: TextDecoration.none)),
                          Text('Always', style: TextStyle(fontSize: 12,
                              decoration: TextDecoration.none)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
            decoration: TextDecoration.none,
            color: CupertinoColors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        backgroundColor: widget.backgroundColor,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(

                physics: const BouncingScrollPhysics(),
                children: [
                  _buildDropdownQuestion(
                    'Select your age range:',
                    selectedAgeRange,
                    ['18-25', '26-35', '36-45', '46-55', '56+'],
                        (value) => setState(() => selectedAgeRange = value!),
                  ),
                  _buildDropdownQuestion(
                    'Daily meals:',
                    selectedMeals,
                    ['1', '2', '3', '4+'],
                        (value) => setState(() => selectedMeals = value!),
                  ),
                  _buildDropdownQuestion(
                    'Work pressure level:',
                    selectedWorkPressure,
                    ['Low', 'Moderate', 'High'],
                        (value) => setState(() => selectedWorkPressure = value!),
                  ),
                  ...List.generate(questions.length, (index) => _buildQuestionSlider(index)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton.filled(
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: handleSubmit,
                child: const Text(
                  'Submit Questionnaire',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none
                  ),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
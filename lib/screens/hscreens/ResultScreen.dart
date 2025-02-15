import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatelessWidget {
  final double totalScore;
  final bool needsHelp;

  const ResultScreen({
    Key? key,
    required this.totalScore,
    required this.needsHelp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message;
    if (needsHelp) {
      message =
      "Based on your responses, it seems you might benefit from professional support. Please consider contacting a mental health professional.";
    } else {
      message =
      "Your responses indicate that you're coping well. However, remember that seeking help is always a positive step if needed.";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Questionnaire Results", style: GoogleFonts.poppins()),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Total Score: ${totalScore.toStringAsFixed(1)}",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.poppins(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            if (needsHelp)
              Column(
                children: [
                  Text(
                    "Contact Details for Professional Help:",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Dr. Jane Doe\nPhone: (123) 456-7890\nEmail: help@mentalhealth.org",
                    style: GoogleFonts.poppins(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

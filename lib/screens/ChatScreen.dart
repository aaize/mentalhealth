import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      textTheme: GoogleFonts.robotoTextTheme(),
    ),
    home: EmergencyScreen(),
  ));
}

class EmergencyScreen extends StatelessWidget {
  final List<Map<String, dynamic>> emergencyOptions = [
    {"text": "Send Help to My Location", "action": () => _sendHelp()},
    {"text": "Call Emergency Services", "action": () => _callNumber("112")},
    {"text": "Alert My Emergency Contacts", "action": () => _alertContacts()},
    {"text": "Find Nearest Hospital", "action": () => _openMaps("hospital near me")},
    {"text": "Safety Tips", "action": () => _showSafetyTips()},
  ];

  static void _sendHelp() {
    print("Sending help to your location...");
    // Implement GPS location sending logic
  }

  static void _callNumber(String number) async {
    final Uri url = Uri.parse("tel:$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Could not launch $number");
    }
  }

  static void _alertContacts() {
    print("Alerting emergency contacts...");
    // Implement alert logic
  }

  static void _openMaps(String query) async {
    final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Could not open maps");
    }
  }

  static void _showSafetyTips() {
    print("Displaying safety tips...");
    // Show a dialog or navigate to a safety tips screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Assistance'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: emergencyOptions.map((option) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: option['action'],
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  option['text'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

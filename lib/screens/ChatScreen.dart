import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  String _currentMessage = "Select an option to get help";
  bool _showMapButton = false;
  String _mapQuery = "";

  void _updateMessage(String text) {
    setState(() {
      _currentMessage = _autoResponses[text.toLowerCase()] ?? "Processing your request...";
      _showMapButton = text.toLowerCase() == "hospital" || text.toLowerCase() == "pharmacy";
      _mapQuery = text.toLowerCase();
    });
  }

  Future<void> _callNumber(String number) async {
    final Uri url = Uri.parse("tel:$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _sendHelp() {
    // Implement location sharing logic
  }

  void _alertContacts() {
    // Implement contact alert logic
  }

  Future<void> _openMaps(String query) async {
    final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _showSafetyTips() {
    // Implement safety tips display
  }

  final Map<String, String> _autoResponses = {
    "hospital": "Opening hospitals near you...",
    "pharmacy": "Finding nearby pharmacies...",
    "112": "Connecting to emergency services...",
  };

  List<Map<String, dynamic>> get _emergencyOptions => [
    {
      "text": "🚨 Emergency Call",
      "action": () => _callNumber("112"),
      "color": Colors.red
    },
    {
      "text": "🏥 Nearest Hospital",
      "action": () => _openMaps("hospital"),
      "color": Colors.blue
    },
    {
      "text": "💊 Pharmacy",
      "action": () => _openMaps("pharmacy"),
      "color": Colors.green
    },
    {
      "text": "🆘 Send My Location",
      "action": _sendHelp,
      "color": Colors.orange
    },
    {
      "text": "📞 Emergency Contacts",
      "action": _alertContacts,
      "color": Colors.purple
    },
    {
      "text": "📚 Safety Guide",
      "action": _showSafetyTips,
      "color": Colors.teal
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Assistance'),
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 30),
                  if (_showMapButton)
                    ElevatedButton.icon(
                      icon: Icon(Icons.map),
                      label: Text("Open in Maps"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      onPressed: () => _openMaps(_mapQuery),
                    ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            padding: EdgeInsets.all(20),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 15,
              runSpacing: 15,
              children: _emergencyOptions.map((option) {
                return GestureDetector(
                  onTap: () {
                    option['action']();
                    _updateMessage(option['text']);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: option['color'],
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Text(
                      option['text'],
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

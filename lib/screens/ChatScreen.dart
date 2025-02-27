import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:location/location.dart';

class EmergencyScreen extends StatefulWidget {
  final Color backgroundColor;

  const EmergencyScreen({Key? key, required this.backgroundColor})
      : super(key: key);

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  String _currentMessage = "Select an option to get help";
  bool _showMapButton = false;
  String _mapQuery = "";

  void _updateMessage(String text) {
    setState(() {
      _currentMessage = _autoResponses[text.toLowerCase()] ??
          "Processing your request...";
      _showMapButton =
          text.toLowerCase() == "hospital" || text.toLowerCase() == "pharmacy";
      _mapQuery = text.toLowerCase();
    });
  }

  Future<void> _callNumber(String number) async {
    final Uri url = Uri.parse("tel:$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openMaps(String query) async {
    final Uri url =
    Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _sendHelp() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _locationData = await location.getLocation();
    final Uri locationUrl = Uri.parse(
        "https://maps.google.com/?q=${_locationData.latitude},${_locationData.longitude}");
    if (await canLaunchUrl(locationUrl)) {
      await launchUrl(locationUrl);
    }
  }

  Future<void> _alertContacts() async {
    if (!await FlutterContacts.requestPermission()) return;
    List<Contact> contacts = await FlutterContacts.getContacts();
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("Emergency Contacts"),
        actions: contacts
            .take(5)
            .map(
              (contact) => CupertinoActionSheetAction(
            onPressed: () => _callNumber(contact.phones.isNotEmpty
                ? contact.phones.first.number
                : ""),
            child: Text(contact.displayName),
          ),
        )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
      ),
    );
  }

  void _showSafetyTips() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("Safety Guide"),
        message: Text("1️⃣ Stay calm\n"
            "2️⃣ Find a safe space\n"
            "3️⃣ Call emergency services\n"
            "4️⃣ Share your location\n"
            "5️⃣ Reach out to your emergency contacts"),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text("OK"),
        ),
      ),
    );
  }

  final Map<String, String> _autoResponses = {
    "hospital": "Opening hospitals near you...",
    "pharmacy": "Finding nearby pharmacies...",
    "112": "Connecting to emergency services...",
  };

  List<Map<String, dynamic>> get _emergencyOptions => [
    {
      "text": "🚨 Call Emergency",
      "action": () => _callNumber("112"),
      "color": CupertinoColors.systemRed,
    },
    {
      "text": "🏥 Nearest Hospital",
      "action": () => _openMaps("hospital"),
      "color": CupertinoColors.systemBlue,
    },
    {
      "text": "💊 Pharmacy",
      "action": () => _openMaps("pharmacy"),
      "color": CupertinoColors.systemGreen,
    },
    {
      "text": "📍 Share My Location",
      "action": _sendHelp,
      "color": CupertinoColors.systemOrange,
    },
    {
      "text": "📞 Emergency Contacts",
      "action": _alertContacts,
      "color": CupertinoColors.systemPurple,
    },
    {
      "text": "📚 Safety Guide",
      "action": _showSafetyTips,
      "color": CupertinoColors.systemTeal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: widget.backgroundColor,
        middle: Text(
          'Emergency',
          style: GoogleFonts.roboto(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.back, size: 23, color: Colors.white),
        ),
      ),
      child: SafeArea(
        child: Column(
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
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    SizedBox(height: 30),
                    if (_showMapButton)
                      CupertinoButton.filled(
                        onPressed: () => _openMaps(_mapQuery),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.map, color: Colors.white),
                            SizedBox(width: 8),
                            Text("Open in Maps"),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGroupedBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: _emergencyOptions.map((option) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    child: CupertinoButton(
                      color: option['color'],
                      borderRadius: BorderRadius.circular(15),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      onPressed: () {
                        option['action']();
                        _updateMessage(option['text']);
                      },
                      child: Text(
                        option['text'],
                        style: GoogleFonts.roboto(
                          fontSize: 18,
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
      ),
    );
  }
}

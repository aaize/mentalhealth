import 'package:flutter/material.dart';

class WorkshopScreen extends StatelessWidget {
  final List<Map<String, String>> workshops = [
    {
      "title": "Mindfulness Meditation",
      "date": "March 10, 2025",
      "time": "5:00 PM - 6:30 PM",
      "location": "Online (Zoom)"
    },
    {
      "title": "Stress Management Strategies",
      "date": "March 15, 2025",
      "time": "4:00 PM - 5:30 PM",
      "location": "Community Center"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wellness Workshops")),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: workshops.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(workshops[index]["title"]!, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("📅 ${workshops[index]["date"]!} • 🕒 ${workshops[index]["time"]!}\n📍 ${workshops[index]["location"]!}"),
              trailing: ElevatedButton(
                child: Text("Register"),
                onPressed: () {
                  // Open registration form
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

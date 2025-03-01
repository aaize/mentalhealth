import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkshopScreen extends StatelessWidget {
  final Color backgroundColor;

  WorkshopScreen({Key? key, required this.backgroundColor}) : super(key: key);

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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: backgroundColor,
        middle: Text(
          "Wellness Workshops",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.back),
        ),
      ),
      child: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: workshops.length,
          itemBuilder: (context, index) {
            final workshop = workshops[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text(
                  workshop["title"]!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "📅 ${workshop["date"]!} • 🕒 ${workshop["time"]!}\n📍 ${workshop["location"]!}",
                ),
                trailing: CupertinoButton(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: CupertinoColors.activeBlue,
                  child: Text(
                    "Register",
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => WorkshopRegistrationScreen(
                          workshop: workshop,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class WorkshopRegistrationScreen extends StatefulWidget {
  final Map<String, String> workshop;

  WorkshopRegistrationScreen({Key? key, required this.workshop})
      : super(key: key);

  @override
  _WorkshopRegistrationScreenState createState() =>
      _WorkshopRegistrationScreenState();
}

class _WorkshopRegistrationScreenState
    extends State<WorkshopRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _email = "";
  String _phone = "";

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Register for Workshop"),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.back),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.workshop["title"]!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text("Date: ${widget.workshop["date"]!}",
                  style: TextStyle(fontSize: 16)),
              Text("Time: ${widget.workshop["time"]!}",
                  style: TextStyle(fontSize: 16)),
              Text("Location: ${widget.workshop["location"]!}",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CupertinoTextFormFieldRow(
                      placeholder: "Name",
                      onSaved: (value) => _name = value ?? "",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      placeholder: "Email",
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => _email = value ?? "",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      placeholder: "Phone",
                      keyboardType: TextInputType.phone,
                      onSaved: (value) => _phone = value ?? "",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your phone number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CupertinoButton.filled(
                      child: Text("Submit Registration"),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // You can implement actual registration logic here.
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: Text("Registration Successful"),
                              content: Text(
                                  "Thank you, $_name, for registering for ${widget.workshop["title"]!}."),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context); // close dialog
                                    Navigator.pop(context); // go back
                                  },
                                )
                              ],
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

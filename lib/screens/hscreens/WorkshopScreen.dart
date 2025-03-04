import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkshopScreen extends StatefulWidget {
  final Color backgroundColor;

  WorkshopScreen({Key? key, required this.backgroundColor}) : super(key: key);

  @override
  _WorkshopScreenState createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {
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
    {
      "title": "Yoga for Beginners",
      "date": "March 20, 2025",
      "time": "6:00 PM - 7:30 PM",
      "location": "Online (Zoom)"
    },
    {
      "title": "Healthy Eating Habits",
      "date": "March 25, 2025",
      "time": "5:30 PM - 7:00 PM",
      "location": "Online (Zoom)"
    },
  ];

  // Set to keep track of registered workshops
  final Set<String> registeredWorkshops = {};

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.systemBlue,
      ),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: widget.backgroundColor,
          middle: Text(
            "Wellness Workshops",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
            ),
          ),

          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context),
            child: Icon(CupertinoIcons.back),
          ),
        ),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(

            ),
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: workshops.length,
              itemBuilder: (context, index) {
                final workshop = workshops[index];
                final isRegistered =
                registeredWorkshops.contains(workshop["title"]);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Material(
                    color: Colors.grey[900],
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        title: Text(
                          workshop["title"]!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(CupertinoIcons.calendar,
                                      size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(workshop["date"]!,
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.clock,
                                      size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(workshop["time"]!,
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.location,
                                      size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(workshop["location"]!,
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: CupertinoButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          color: isRegistered
                              ? CupertinoColors.inactiveGray
                              : CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(8),
                          child: Text(
                            isRegistered ? "Registered" : "Register",
                            style: TextStyle(
                              color: CupertinoColors.white,
                            ),
                          ),
                          onPressed: isRegistered
                              ? null
                              : () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    WorkshopRegistrationScreen(
                                      workshop: workshop,
                                      backgroundColor: widget.backgroundColor,
                                      onRegister: () {
                                        setState(() {
                                          registeredWorkshops
                                              .add(workshop["title"]!);
                                        });
                                      },
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class WorkshopRegistrationScreen extends StatefulWidget {
  final Map<String, String> workshop;
  final VoidCallback onRegister;
  final Color backgroundColor;

  WorkshopRegistrationScreen(
      {Key? key, required this.workshop, required this.onRegister,required this.backgroundColor})
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
  bool _isSubmitting = false;

  void _submitRegistration() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Simulate a network call / registration process
      setState(() {
        _isSubmitting = true;
      });
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _isSubmitting = false;
      });

      widget.onRegister();

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
          Navigator.pop(context); // Close dialog
          Navigator.pop(context); // Go back to workshop screen
        },
      ),
    ],
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Register for Workshop"),
        border: null,
        backgroundColor: widget.backgroundColor,
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
              Text("📅 Date: ${widget.workshop["date"]!}",

                  style: TextStyle(fontSize: 16)),
              Text("🕒 Time: ${widget.workshop["time"]!}",
                  style: TextStyle(fontSize: 16)),
              Text("📍 Location: ${widget.workshop["location"]!}",
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
                      child: _isSubmitting
                          ? CupertinoActivityIndicator()
                          : Text("Submit Registration"),
                      onPressed: _isSubmitting ? null : _submitRegistration,
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
}


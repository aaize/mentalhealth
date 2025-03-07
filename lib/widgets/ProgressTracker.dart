import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
class ProgressTracker extends StatefulWidget {
  @override
  _ProgressTrackerState createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userEmail;
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userEmail = _auth.currentUser?.email ?? "unknown_user";
  }

  // Update task completion status in Firebase
  void _updateTaskStatus(String taskId, bool isCompleted) {
    FirebaseFirestore.instance.collection('progress').doc(userEmail).update({
      taskId: isCompleted,
    });
  }

  // Add new task to Firebase
  void _addNewTask() {
    if (_taskController.text.isEmpty) return;
    FirebaseFirestore.instance.collection('progress').doc(userEmail).set({
      _taskController.text: false, // New task, initially incomplete
    }, SetOptions(merge: true));
    _taskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTaskDialog(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Progress',
                style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(height: 10),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('progress').doc(
                    userEmail).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('No progress data available.');
                  }
                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  int completed = data.values
                      .where((val) => val == true)
                      .length;
                  int total = data.length;
                  return Column(
                    children: [
                      CupertinoTheme(
                        data: CupertinoThemeData(
                          primaryColor: CupertinoColors.activeBlue,
                        ),
                        child: LinearProgressIndicator(
                          value: total == 0 ? 0 : completed / total,
                          backgroundColor: CupertinoColors.systemGrey5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              CupertinoColors.activeBlue),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('$completed of $total tasks completed'),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Your Tasks",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 17,

          ),),
          content: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('progress').doc(
                userEmail).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text("No tasks found"),
                );
              }
              var data = snapshot.data!.data() as Map<String, dynamic>;

              // Convert to a sorted list: false (incomplete) tasks first, then true (completed) tasks
              var sortedTasks = data.keys.toList()
                ..sort((a, b) => (data[a] ? 1 : 0).compareTo(data[b] ? 1 : 0));

              return Column(
                children: sortedTasks.map((taskId) {
                  return CupertinoListTile(
                    title: Text(taskId,
                    style: GoogleFonts.roboto(
                      color: CupertinoColors.link,
                      fontWeight: FontWeight.bold
                    ),),
                    trailing: CupertinoSwitch(
                      value: data[taskId] == true,
                      onChanged: (bool value) {
                        _updateTaskStatus(taskId, value);
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalhealth/widgets/screens/MeditationScreen.dart';
class QuickAccessButtons extends StatelessWidget {
  final Color backgroundColor;
  final String userEmail; // Add this parameter

  const QuickAccessButtons({required this.backgroundColor, required this.userEmail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton('Journal', CupertinoIcons.pencil, () {
          Navigator.push(context, CupertinoPageRoute(builder: (_) => JournalScreen(userEmail: userEmail,backgroundColor: backgroundColor,)));
        }),
        _buildButton('Meditate', CupertinoIcons.moon, () {
          Navigator.push(context, CupertinoPageRoute(builder: (_) => MeditationScreen(backgroundColor: backgroundColor,)));
        }),
        _buildButton('Chat', CupertinoIcons.chat_bubble, () {
          Navigator.push(context, CupertinoPageRoute(builder: (_) => ChatScreen()));
        }),
      ],
    );
  }

  Widget _buildButton(String label, IconData icon, VoidCallback onPressed) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Icon(icon, size: 36, color: backgroundColor),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}




class JournalScreen extends StatefulWidget {
  final String userEmail; // Add this parameter
  final Color backgroundColor;

  const JournalScreen({required this.userEmail,
  required this.backgroundColor}); // Update constructor

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _journalController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedMood = '😊';
  String _searchQuery = '';

  final List<String> _moodOptions = ['😊', '😢', '😡', '😴', '😍', '🤔'];
  final List<Color> _moodColors = [
    CupertinoColors.systemYellow,
    CupertinoColors.systemBlue,
    CupertinoColors.systemRed,
    CupertinoColors.systemGrey,
    CupertinoColors.systemPink,
    CupertinoColors.systemTeal,
  ];

  void _addJournalEntry() async {
    final entry = _journalController.text.trim();
    if (entry.isEmpty) return;

    try {
      await _firestore
          .collection('journals')
          .doc(widget.userEmail) // Use the passed userEmail
          .collection('entries')
          .add({
        'content': entry,
        'mood': _selectedMood,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _journalController.clear();
      _showToast('Entry saved successfully!!!', CupertinoColors.activeGreen);
    } catch (e) {
      _showToast('Failed to save entry', CupertinoColors.destructiveRed);
    }
  }

  void _deleteEntry(String entryId) async {
    try {
      await _firestore
          .collection('journals')
          .doc(widget.userEmail) // Use the passed userEmail
          .collection('entries')
          .doc(entryId)
          .delete();

      _showToast('Entry deleted', CupertinoColors.systemGrey);
    } catch (e) {
      _showToast('Failed to delete entry', CupertinoColors.destructiveRed);
    }
  }

  void _showToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      textColor: CupertinoColors.white,
    );
  }

  void _showMoodPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) =>
          CupertinoActionSheet(
            title: const Text('Select Mood'),
            actions: _moodOptions.map((mood) =>
                CupertinoActionSheetAction(
                  child: Text(mood, style: TextStyle(fontSize: 32)),
                  onPressed: () {
                    setState(() => _selectedMood = mood);
                    Navigator.pop(context);
                  },
                )).toList(),
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ),
    );
  }

  Widget _buildJournalEntry(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    // Ensure data is not null
    if (data == null) {
      return SizedBox.shrink(); // Return an empty widget if data is null
    }

    // Handle null timestamp safely
    Timestamp? timestamp = data['timestamp'] as Timestamp?;
    String formattedDate = timestamp != null
        ? DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate())
        : 'Unknown Date'; // ✅ Provides a fallback value

    return Dismissible(
      key: Key(doc.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: CupertinoColors.destructiveRed,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(CupertinoIcons.delete, color: CupertinoColors.white),
      ),
      onDismissed: (direction) => _deleteEntry(doc.id),
      child: CupertinoButton(
        onPressed: () => _showEntryDialog(data['content'] ?? '', doc.id),
        padding: EdgeInsets.zero,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: CupertinoTheme
                .of(context)
                .brightness == Brightness.dark
                ? CupertinoColors.darkBackgroundGray
                : CupertinoColors.extraLightBackgroundGray,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _moodOptions.contains(data['mood']) ? data['mood'] : '😊',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(width: 10),
                    Text(
                      formattedDate, // ✅ Uses safe date formatting
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  data['content'] ?? 'No content available.',
                  // ✅ Prevents null errors
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _showEntryDialog(String content, String entryId) {
    final editController = TextEditingController(text: content);
    showCupertinoDialog(
      context: context,
      builder: (context) =>
          CupertinoAlertDialog(
            title: Text('Edit Entry'),
            content: CupertinoTextField(
              controller: editController,
              style: TextStyle(color: CupertinoColors.systemGrey),
              maxLines: 5,
              placeholder: 'Edit your entry...',
            ),
            actions: [
              CupertinoDialogAction(
                child: Text('Cancel',
                  style: TextStyle(color: CupertinoColors.white),),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                child: Text('Save'),
                onPressed: () async {
                  if (editController.text
                      .trim()
                      .isNotEmpty) {
                    await _firestore
                        .collection('journals')
                        .doc(widget.userEmail) // Use the passed userEmail
                        .collection('entries')
                        .doc(entryId)
                        .update({'content': editController.text.trim()});
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Journal",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            color: CupertinoColors.white,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back, size: 23),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: widget.backgroundColor,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.search),
          onPressed: () =>
              showCupertinoDialog(
                context: context,
                builder: (context) =>
                    CupertinoAlertDialog(
                      title: Text('Search Entries'),
                      content: CupertinoTextField(
                        placeholder: 'Search journal entries...',
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: Text('Close'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
              ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Journal Entries Section
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('journals')
                    .doc(widget.userEmail)
                    .collection('entries')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CupertinoActivityIndicator());
                  }

                  final entries = snapshot.data!.docs.where((doc) {
                    final content =
                    (doc.data() as Map<String, dynamic>)['content']
                        .toString()
                        .toLowerCase();
                    return content.contains(_searchQuery.toLowerCase());
                  }).toList();

                  if (entries.isEmpty) {
                    return Center(child: Text('No entries found'));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: entries.length,
                    itemBuilder: (context, index) =>
                        _buildJournalEntry(entries[index]),
                  );
                },
              ),
            ),
            // Input & Save Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoTextField(
                          controller: _journalController,
                          placeholder: "Write your thoughts...",
                          padding: EdgeInsets.all(16),
                          maxLines: 4,
                          decoration: BoxDecoration(
                            color: CupertinoColors.extraLightBackgroundGray,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                            _selectedMood, style: TextStyle(fontSize: 36)),
                        onPressed: _showMoodPicker,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 14, horizontal: 32),
                      onPressed: _addJournalEntry,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.book_circle_fill,
                            size: 25,
                            color: CupertinoColors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Save Entry",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Chat")),
      child: Center(
        child: Text("Chat feature coming soon!"),
      ),
    );
  }
}

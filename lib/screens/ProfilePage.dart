import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealth/screens/UploadProfilePic.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String displayName = "Loading...";
  late String email = "";
  late String imageUrl = "";
  late String lastUpdated = "";
  bool isLoading = true; // To manage loading state

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load user profile data from Firebase
  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;

    if (user != null) {
      final profileDoc = await FirebaseFirestore.instance
          .collection('ProfileDetails')
          .doc(user.uid)
          .get();

      setState(() {
        displayName = profileDoc['displayName'] ?? 'No name';
        email = user.email ?? 'No email';
        imageUrl = profileDoc['imageUrl'] ?? '';
        lastUpdated = profileDoc['lastUpdated'] != null
            ? DateFormat.yMMMd().format(profileDoc['lastUpdated'].toDate())
            : 'Not updated';
        isLoading = false; // Update loading state
      });
    }
  }

  // Function to show edit popup
  void _showEditPopup() {
    TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Display Name"),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Enter new display name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String newName = _nameController.text.trim();
                if (newName.isNotEmpty) {
                  User? user = _auth.currentUser;

                  if (user != null) {
                    String uid = user.uid;

                    await FirebaseFirestore.instance
                        .collection('ProfileDetails')
                        .doc(uid)
                        .update({'displayName': newName});

                    setState(() {
                      displayName = newName; // Update the UI
                    });

                    Navigator.pop(context); // Close popup
                  }
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Profile",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: _showEditPopup, // Open the popup when edit button is clicked
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 80,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : AssetImage('assets/default_profile_pic.png') as ImageProvider,
                child: imageUrl.isEmpty
                    ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                    : null,
              ),
              SizedBox(height: 20),

              // Profile Information
              Text(
                displayName,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                email,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Last updated: $lastUpdated',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
              ),

              SizedBox(height: 40),

              // Button to navigate to Upload Profile Pic Screen
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                child: Text(
                  'Upload Profile Picture',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

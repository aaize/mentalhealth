import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealth/screens/UploadProfilePic.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String displayName;
  late String email;
  late String imageUrl;
  late String lastUpdated;

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
        displayName = user.displayName ?? 'No name';
        email = user.email ?? 'No email';
        imageUrl = profileDoc['imageUrl'] ?? '';
        lastUpdated = profileDoc['lastUpdated'] != null
            ? DateFormat.yMMMd().format(profileDoc['lastUpdated'].toDate())
            : 'Not updated';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(email, style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 10),
            Text('Last updated: $lastUpdated', style: TextStyle(fontSize: 14, color: Colors.grey)),

            SizedBox(height: 40),

            // Button to navigate to Upload Profile Pic Screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: Text('Upload Profile Picture'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40), backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

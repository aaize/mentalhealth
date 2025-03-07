import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../moodtracking/mood_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Color backgroundColor;
  final String userEmail;


  const ProfileScreen({
    Key? key,
    required this.backgroundColor,
    required this.userEmail,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String displayName = "Loading...";
  late String imageUrl = "";
  late String lastUpdated = "Not updated";
  bool isLoading = true;
  File? _image;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final DocumentSnapshot profileDoc = await FirebaseFirestore.instance
          .collection('ProfileDetails')
          .doc(widget.userEmail)
          .get();

      if (profileDoc.exists) {
        final data = profileDoc.data() as Map<String, dynamic>;
        setState(() {
          displayName = data['displayName'] ?? 'No name';
          imageUrl = data['imageUrl'] ?? '';
          lastUpdated = data['lastUpdated'] != null
              ? DateFormat.yMMMd().format((data['lastUpdated'] as Timestamp).toDate())
              : 'Not updated';
          isLoading = false;
        });
      } else {
        setState(() {
          displayName = 'Profile not found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        displayName = 'Error loading profile';
        isLoading = false;
      });
      print("Error loading profile: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isUploading = true; // Show loading state while uploading
      });

      try {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${_image!.path.split('/').last}';

        // Upload the file to Supabase Storage
        final fileKey = await Supabase.instance.client.storage
            .from('mentalhealth')
            .upload(fileName, _image!);

        final publicUrl = Supabase.instance.client.storage
            .from('mentalhealth')
            .getPublicUrl(fileName);

        setState(() {
          imageUrl = publicUrl;  // Update the imageUrl immediately
        });

        // Update Firestore with the new image URL
        await FirebaseFirestore.instance
            .collection('ProfileDetails')
            .doc(widget.userEmail)
            .update({
          'imageUrl': imageUrl,
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile image uploaded successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      } finally {
        setState(() {
          _isUploading = false;  // Hide loading state after upload
        });
      }
    }
  }

  void _showEditPopup() {
    TextEditingController _nameController = TextEditingController();
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Edit Display Name"),
          content: CupertinoTextField(
            controller: _nameController,
            placeholder: "Enter new display name",
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                String newName = _nameController.text.trim();
                if (newName.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('ProfileDetails')
                      .doc(widget.userEmail)
                      .update({'displayName': newName});
                  setState(() {
                    displayName = newName;
                  });
                  Navigator.pop(context);
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: widget.backgroundColor,
        middle: Text("Profile", style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: Icon(CupertinoIcons.back,size: 23,), onPressed: () {
          Navigator.pop(context);
        },),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              _buildProfileHeader(),
              _buildStatsSection(),
              _buildActionButtons(),
              _buildProfileDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 90,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : (_image != null ? FileImage(_image!) : null),
                child: imageUrl.isEmpty && _image == null
                    ? Icon(CupertinoIcons.person_fill, size: 60, color: CupertinoColors.systemGrey)
                    : null,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.camera_fill,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          displayName,
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold,              decoration: TextDecoration.none,
          ),
        ),
        Text(
          widget.userEmail,
          style: GoogleFonts.poppins(fontSize: 16, color: CupertinoColors.systemGrey,              decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem("126", "Streak Days"),
          _buildStatItem("A+", "Mood Grade"),
          _buildStatItem("92%", "Progress"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold,              decoration: TextDecoration.none,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16, color: CupertinoColors.systemGrey,              decoration: TextDecoration.none,

          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        children: [
          _buildButton(CupertinoIcons.pencil_circle, "Edit Name", _showEditPopup),
          SizedBox(height: 10),

          _buildButton(
            CupertinoIcons.graph_circle,
            "Mood Tracker",
                () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => MoodHistoryScreen(
                    backgroundColor: widget.backgroundColor,
                    email: widget.userEmail
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          _buildButton(CupertinoIcons.settings_solid, "Settings", _showEditPopup),
          SizedBox(height: 10),
          _buildButton(CupertinoIcons.lock_open, "Log Out", _logout),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String text, VoidCallback onPressed) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: CupertinoColors.systemGrey.withOpacity(0.3), blurRadius: 5)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color:CupertinoColors.white),
            SizedBox(width: 10),
            Text(text, style: GoogleFonts.poppins(fontSize: 18,
              fontWeight: FontWeight.w400,
              color: CupertinoColors.white,
              decoration: TextDecoration.none,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile Details",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.backgroundColor,
              decoration: TextDecoration.none,

            ),
          ),
          SizedBox(height: 10),
          _buildDetailItem("Last Updated", lastUpdated),
          _buildDetailItem("Account Created", "Jan 1, 2023"), // Replace with actual data
          _buildDetailItem("Streak Started", "Mar 15, 2023"), // Replace with actual data
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: CupertinoColors.systemGrey,
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,

            ),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
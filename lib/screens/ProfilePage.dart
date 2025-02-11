import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  final String email; // Passed from the login (or home) screen
  const ProfilePage({Key? key, required this.email}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String displayName = "Loading...";
  late String imageUrl = "";
  late String lastUpdated = "";
  bool isLoading = true; // To manage loading state
  File? _image;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Loads the user's profile details from Firestore using the email (document ID)
  Future<void> _loadUserProfile() async {
    try {
      final DocumentSnapshot profileDoc = await FirebaseFirestore.instance
          .collection('ProfileDetails')
          .doc(widget.email) // Using the email as the document ID
          .get();

      if (profileDoc.exists) {
        final data = profileDoc.data() as Map<String, dynamic>;
        setState(() {
          displayName = data['displayName'] ?? 'No name';
          imageUrl = data['imageUrl'] ?? '';
          lastUpdated = data['lastUpdated'] != null
              ? DateFormat.yMMMd().format(
            (data['lastUpdated'] as Timestamp).toDate(),
          )
              : 'Not updated';
          isLoading = false;
        });
      } else {
        // Document not found
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

  // Method to pick an image from the gallery and upload it
  Future<void> _pickAndUploadImage() async {
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
            .doc(widget.email)
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

  // Function to show an edit popup for updating the display name
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
                  await FirebaseFirestore.instance
                      .collection('ProfileDetails')
                      .doc(widget.email)
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
            onPressed: _showEditPopup,
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
            children: [
              // Profile Picture
              GestureDetector(
                onTap: _pickAndUploadImage,  // Trigger image pick and upload
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : AssetImage('assets/default_profile_pic.png')
                  as ImageProvider,
                  child: imageUrl.isEmpty
                      ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                      : null,
                ),
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
              SizedBox(height: 10),
              Text(
                widget.email,
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
              // Button to upload the profile image
              ElevatedButton(
                onPressed: _isUploading ? null : _pickAndUploadImage,  // Bind to the new function
                child: _isUploading
                    ? CircularProgressIndicator()
                    : Text(
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

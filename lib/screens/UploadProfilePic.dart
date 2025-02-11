import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isLoading = false;
  String? _uploadedImageUrl;

  // Method to pick an image from the gallery.
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Method to upload the image to Supabase Storage.
  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Create a unique file name.
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${_image!.path.split('/').last}';

      // Upload the file to the 'mentalhealth' bucket.
      // The upload method returns a String, which is the key of the stored file.
      final fileKey = await Supabase.instance.client.storage
          .from('mentalhealth')
          .upload(fileName, _image!);

      // Retrieve the public URL for the uploaded file.
      final publicUrl = Supabase.instance.client.storage
          .from('mentalhealth')
          .getPublicUrl(fileName);

      setState(() {
        _uploadedImageUrl = publicUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile image uploaded successfully!')),
      );

      // Update Firestore with the new image URL
      _updateProfileImageUrl(publicUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to update Firestore with the image URL
  Future<void> _updateProfileImageUrl(String imageUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Reference to the ProfileDetails document in Firestore
        final profileRef = FirebaseFirestore.instance.collection('ProfileDetails').doc(user.uid);

        // Update or create the 'imageUrl' field
        await profileRef.set({
          'imageUrl': imageUrl,
          'displayName': user.displayName,
          'email': user.email,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));  // Merge to prevent overwriting existing data

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile image URL saved to Firestore!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving URL to Firestore: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Explicitly declare displayImage as ImageProvider<Object>? to avoid type issues.
    final ImageProvider<Object>? displayImage = _uploadedImageUrl != null
        ? NetworkImage(_uploadedImageUrl!)
        : (_image != null ? FileImage(_image!) : null);

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,

        title: Text('Update Profile Picture',
        style: TextStyle(fontWeight: FontWeight.bold,
        ),),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 90,
                backgroundImage: displayImage,
                child: displayImage == null
                    ? Icon(Icons.camera_alt, size: 40)
                    : null,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(34)
                )
              ),
              onPressed: _isLoading ? null : _uploadImage,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('      Upload      ',
                      style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 20),),
            ),
            if (_uploadedImageUrl != null) ...[
              SizedBox(height: 20),
              Text('Uploaded Image URL:'),
              SelectableText(_uploadedImageUrl!),
            ],
          ],
        ),
      ),
    );
  }
}

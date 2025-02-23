import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  final String email;
  final Color backgroundColor;

  const ProfilePage({Key? key, required this.email, required this.backgroundColor}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String displayName = "Loading...";
  late String imageUrl = "";
  late String lastUpdated = "";
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
          .doc(widget.email)
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

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isUploading = true;
      });

      try {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${_image!.path.split('/').last}';
        final fileKey = await Supabase.instance.client.storage.from('mentalhealth').upload(fileName, _image!);
        final publicUrl = Supabase.instance.client.storage.from('mentalhealth').getPublicUrl(fileName);

        setState(() {
          imageUrl = publicUrl;
        });

        await FirebaseFirestore.instance.collection('ProfileDetails').doc(widget.email).update({
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
          _isUploading = false;
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
          content: Column(
            children: [
              CupertinoTextField(
                controller: _nameController,
                placeholder: "Enter new display name",
                padding: EdgeInsets.all(12),
              ),
            ],
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
                  await FirebaseFirestore.instance.collection('ProfileDetails').doc(widget.email).update({'displayName': newName});
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

  void _showImagePickerActionSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text("Select Image"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickAndUploadImage();
              },
              child: Text("Choose from Gallery"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Your Profile",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.pencil),
          onPressed: _showEditPopup,
        ),
      ),
      child: Center(
        child: isLoading
            ? CupertinoActivityIndicator(radius: 15)
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _showImagePickerActionSheet,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover)
                      : Icon(CupertinoIcons.camera, size: 100, color: CupertinoColors.systemGrey),
                ),
              ),
              SizedBox(height: 20),
              Text(
                displayName,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.email,
                style: GoogleFonts.poppins(fontSize: 18, color: CupertinoColors.systemGrey),
              ),
              SizedBox(height: 10),
              Text(
                'Last updated: $lastUpdated',
                style: GoogleFonts.poppins(fontSize: 16, color: CupertinoColors.systemGrey2),
              ),
              SizedBox(height: 40),
              CupertinoButton.filled(
                onPressed: _isUploading ? null : _pickAndUploadImage,
                child: _isUploading
                    ? CupertinoActivityIndicator()
                    : Text(
                  'Upload Profile Picture',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

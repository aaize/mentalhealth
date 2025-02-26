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
            placeholderStyle: TextStyle(color: CupertinoColors.systemGrey2), // White-grey placeholder
            style: TextStyle(color: CupertinoColors.systemGrey6), // White-grey text
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey.withOpacity(0.2), // Slight background tint
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


  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: widget.backgroundColor,
        middle: Text("Profile", style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w400, color: CupertinoColors.white)),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(
          CupertinoIcons.back,
          size: 23,
        )),
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 200),
            _buildProfileHeader(),
            _buildStatsSection(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: CircleAvatar(
            radius: 60,
            backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            child: imageUrl.isEmpty ? Icon(CupertinoIcons.person_fill, size: 60, color: CupertinoColors.systemGrey) : null,
          ),
        ),
        SizedBox(height: 10),
        Text(displayName, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(widget.email, style: GoogleFonts.poppins(fontSize: 16, color: CupertinoColors.systemGrey)),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem("", ""),
          _buildStatItem("", ""),
          _buildStatItem("", ""),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(count, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: GoogleFonts.poppins(fontSize: 16, color: CupertinoColors.systemGrey)),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        children: [
          _buildButton(CupertinoIcons.pencil, "Edit Name", _showEditPopup),
          SizedBox(height: 10),
          _buildButton(CupertinoIcons.power, "Log Out", _logout),
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
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: CupertinoColors.systemGrey.withOpacity(0.3), blurRadius: 5)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: widget.backgroundColor),
            SizedBox(width: 10),
            Text(text, style: GoogleFonts.poppins(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

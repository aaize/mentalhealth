import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class JoinEventScreen extends StatefulWidget {
  final String eventName;
  final String eventTime;
  final String eventDescription;
  final String eventImage;
  final Color backgroundColor;

  const JoinEventScreen({
    Key? key,
    required this.eventName,
    required this.eventTime,
    required this.eventDescription,
    required this.eventImage,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _JoinEventScreenState createState() => _JoinEventScreenState();
}

class _JoinEventScreenState extends State<JoinEventScreen> {
  bool hasJoined = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Modern dark theme
      appBar: CupertinoNavigationBar(
        middle: Text(
          "Events",
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back, size: 23, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: widget.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10), // Half of the previous
              child: Image.asset(
                widget.eventImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
            SizedBox(height: 20),

            // Event Name
            Text(
              widget.eventName,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),

            // Event Time
            Text(
              widget.eventTime,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 20),

            // Event Description
            Text(
              "About the Event",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purpleAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.eventDescription,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),

            // Event Links
            _buildLink("More details", "www.mhpsupportcircle.com/details", Icons.info),
            _buildLink("Join via Web", "www.mhpsupportcircle.com/join", Icons.link),
            _buildLink("Zoom Meeting", "www.zoom.com/mhp-circle", Icons.video_call),
            _buildLink("Resources & Articles", "www.mhpsupportcircle.com/resources", Icons.book),
            SizedBox(height: 30),

            // Join Event Button
            Center(
              child: ElevatedButton(
                onPressed: hasJoined ? null : _joinEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasJoined ? Colors.grey : Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  hasJoined ? "Joined" : "Join Event",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle event joining
  void _joinEvent() {
    setState(() {
      hasJoined = true;
    });

    Fluttertoast.showToast(
      msg: "You have successfully joined the event!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.deepPurpleAccent,
      textColor: Colors.white,
    );
  }

  // Function to build event links
  Widget _buildLink(String title, String fullUrl, IconData icon) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: fullUrl));
        Fluttertoast.showToast(
          msg: "Copied: $fullUrl",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "$title: ${_truncateUrl(fullUrl)}",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to truncate long URLs
  String _truncateUrl(String url, {int maxLength = 30}) {
    return url.length > maxLength ? "${url.substring(0, maxLength)}..." : url;
  }
}

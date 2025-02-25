import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JoinEventScreen extends StatelessWidget {
  final String eventName;
  final String eventTime;
  final String eventDescription;
  final Color backgroundColor;

  const JoinEventScreen({
    Key? key,
    required this.eventName,
    required this.eventTime,
    required this.eventDescription,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CupertinoNavigationBar(
        middle: Text('Events',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400

          ),
        ),
        border: null,
        backgroundColor: backgroundColor,

      ),
      /*AppBar(
        centerTitle: true,
        title: Text(
          eventName,

          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold
          ),

        ),
        backgroundColor: backgroundColor,
      ),*/
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              eventName,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),

            ),
            SizedBox(height: 8),
            Text(
              eventTime,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[300],
              ),
            ),
        Center(
          child: Container(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Rounded corners
              border: Border.all(color: CupertinoColors.systemGrey, width: 1), // Border color and width
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemGrey.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Ensures the image follows the rounded shape
              child: Image.asset(
                'lib/assets/harmony.png',
                fit: BoxFit.cover, // Ensures proper scaling
              ),
            ),
          ),
        ),


            

            SizedBox(height: 16),
            Text(
              eventDescription,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement join event functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  padding: EdgeInsets.symmetric(
                      vertical: 12, horizontal: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Join Event',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          eventName,

          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold
          ),

        ),
        backgroundColor: backgroundColor,
      ),
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

              child: Image.asset('lib/assets/harmony.png'),
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

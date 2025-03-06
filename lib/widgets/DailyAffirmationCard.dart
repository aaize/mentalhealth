import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyAffirmationCard extends StatelessWidget {
  final Color backgroundColor;

  const DailyAffirmationCard({required this.backgroundColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('affirmations')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)))
          .where('date', isLessThan: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1)))
// Querying by date
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildNoAffirmationCard();
        }

        final document = snapshot.data!.docs.first;
        final affirmationText = document['text'] ?? 'Stay positive!';

        return _buildAffirmationCard(affirmationText);
      },
    );
  }

  Widget _buildNoAffirmationCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No affirmation for today. Check back tomorrow!',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildAffirmationCard(String text) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Affirmation                                ',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

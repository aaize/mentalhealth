import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalhealth/screens/ChatScreen.dart';
import 'package:mentalhealth/screens/JoinEventScreen.dart';
import 'package:mentalhealth/screens/LoginScreen.dart';
import 'package:mentalhealth/screens/hscreens/Prof.dart';
import 'package:mentalhealth/screens/moodtracking/mood_history_screen.dart';
import 'package:mentalhealth/screens/ProfilePage.dart';
import '../widgets/DailyAffirmationCard.dart';
import '../widgets/MoodTrackerSummary.dart';
import '../widgets/ProgressTracker.dart';
import '../widgets/QuickAccessButtons.dart';
import 'hscreens/ArticlesScreen.dart';
import 'hscreens/PodcastScreen.dart';
import 'hscreens/VideosScreen.dart';
import 'hscreens/WorkshopScreen.dart';
import 'package:mentalhealth/screens/hscreens/QuestionnaireScreen.dart';
import 'package:mentalhealth/screens/hscreens/Prof.dart';
class HomeScreen extends StatefulWidget {
  final String userEmail; // The email of the logged-in user
  const HomeScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedEmoji = '😊'; // Default emoji
  Color backgroundColor = Color(0xFF6A5ACD);
  final PageController _pageController = PageController(viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    // Show toast message when the screen is loaded
    Fluttertoast.showToast(
      msg: "Welcome to Your Peer Support Network!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Color(0xFF6A5ACD), // Slate Blue
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _emojiButtonColor(String emoji) {
    setState(() {
      selectedEmoji = emoji;
      backgroundColor = _getColorForEmoji(emoji);
    });
  }

  Color _getColorForEmoji(String emoji) {
    switch (emoji) {
      case '😊': return CupertinoColors.systemYellow;
      case '😢': return CupertinoColors.systemBlue;
      case '😡': return CupertinoColors.systemRed;
      case '😎': return CupertinoColors.systemGreen;
      case '😍': return CupertinoColors.systemPink;
      default: return CupertinoColors.systemPurple;
    }
  }

  void openEmojiSelection() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Select Your Emoji',
            style: TextStyle(fontWeight: FontWeight.w500)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 20,
              runSpacing: 15,
              children: ['😊','😢','😡','😎','😍','🤔','😴','☂️']
                  .map((e) => CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(e, style: const TextStyle(fontSize: 36)),
                onPressed: () {
                  _emojiButtonColor(e);
                  Navigator.pop(context);
                },
              )).toList(),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showProfileMenu() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoTheme(
        data: CupertinoThemeData(
          brightness: Brightness.dark, // Dark background for visibility
        ),
        child: CupertinoActionSheet(
          actions: [
            _buildActionSheetItem('Mood Tracker',
                CupertinoIcons.heart, () {
                  _navigateTo(MoodHistoryScreen(
                    email: widget.userEmail,
                    backgroundColor: backgroundColor,
                  ));
                }),
            _buildActionSheetItem('Profile', CupertinoIcons.person, () {
              _navigateTo(ProfilePage(
                email: widget.userEmail,
                backgroundColor: backgroundColor,
              ));
            }),
            _buildActionSheetItem('Settings', CupertinoIcons.gear, () {}),
            CupertinoActionSheetAction(
              onPressed: () => _logout(),
              isDestructiveAction: true,
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 20, color: Colors.white), // White text
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel', style: TextStyle(color: Colors.white)), // White text
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  Widget _buildActionSheetItem(String title, IconData icon, VoidCallback onTap) {
    return CupertinoActionSheetAction(
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24), // White icon
          SizedBox(width: 10),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 18)), // White text
        ],
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(context, CupertinoPageRoute(builder: (_) => screen));
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: backgroundColor,
        border: null, // Remove bottom border
        brightness: Brightness.dark, // For light status bar icons
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ProfileScreen(backgroundColor: backgroundColor, userEmail: widget.userEmail,), // Replace with your screen widget
              ),
            );
          },
          child: Icon(CupertinoIcons.bars, color: Colors.white),
        ),

        middle: RichText(
          text: TextSpan(
            style: GoogleFonts.gabarito(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: "M",
                style: TextStyle(color: Colors.purple),
              ),
              TextSpan(text: "inCo"),
            ],
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: openEmojiSelection,
          sizeStyle: CupertinoButtonSize.small,
          child: Text(
            selectedEmoji,
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Welcome to Your Peer Support Network!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Here to support you through your journey. Take a deep breath, you are not alone.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => QuestionnaireScreen(backgroundColor: backgroundColor,)),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),

                child: Text(
                  'Take Questionnaire',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Explore Resources',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),
            ),
            SizedBox(height: 30),

            Container(
              height: 205,
              child: PageView(
                controller: _pageController,
                physics: BouncingScrollPhysics(), // iOS-style smooth scrolling
                children: [
                  _imageCard(
                      'lib/assets/aomh.png',
                      'Articles on Mental Health',
                      ArticlesScreen(backgroundColor: backgroundColor,)
                  ),
                  _imageCard(
                      'lib/assets/htimh.jpg',
                      'Mental Health Videos',
                      VideosScreen(backgroundColor: backgroundColor)
                  ),
                  _imageCard(
                      'lib/assets/mhp.jpg',
                      'Mental Health Podcasts',
                      PodcastScreen(backgroundColor: backgroundColor,)
                  ),
                  _imageCard(
                      'lib/assets/wellnessworkshop.png',
                      'Wellness Workshops',
                      WorkshopScreen(backgroundColor: backgroundColor,)
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Daily Affirmation Section

            DailyAffirmationCard(backgroundColor: backgroundColor),
            SizedBox(height: 30),
            _communityHighlights(),

            SizedBox(height: 30),
            // Mood Tracker Summary
            MoodTrackerSummary(email: widget.userEmail),

            SizedBox(height: 30),
            // Progress Tracker
            ProgressTracker(),
            // Quick Access Buttons
            SizedBox(height: 30),
            // Community Highlights
            //CommunityHighlights(),

            SizedBox(height: 30),
            // Explore Resources Section
            QuickAccessButtons(backgroundColor: backgroundColor,userEmail: widget.userEmail,),
            SizedBox(height: 10),

            SizedBox(height: 30),

            // Upcoming Events or Support Groups
            Text(
              'Upcoming Peer Support Groups',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),
            ),
            SizedBox(height: 10),
            _eventCard('Harmony Helpers', 'Thursday October 10 at 10AM - 2PM', '''A supportive community gathering to discuss mental health topics.
                \n Shared Experiences: Engaging with others facing similar challenges fosters a sense of belonging and reduces feelings of isolation.
                \n Emotional Support: Regular interactions in a supportive environment can alleviate stress and promote emotional well-being.''',
                  "lib/assets/harmony.png"
                  ),
            SizedBox(height: 20),
            _eventCard(
                'Anxiety Support Circle',
                'Every Friday at 3 PM',
                'Join a compassionate and understanding community where you can openly share your thoughts and feelings. Guided by mental health professionals, this support circle offers practical coping techniques, mindfulness exercises, and a safe space to connect with others who truly understand your journey.\n\n📌 More details: [www.mhpsupportcircle.com](#)\n🌐 Join via Web: [www.mhpsupportcircle.com/join](#)\n🎥 Zoom Meeting: [www.zoom.com/mhp-circle](#)\n🔗 Resources & Articles: [www.mhpsupportcircle.com/resources](#)',
                "lib/assets/mhp.jpg"
            ),

            SizedBox(height: 30),
            // Emergency Contacts Section
            Text(
              'Emergency Contacts',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),
            ),
            SizedBox(height: 10),
            _contactCard('Suicide Prevention', '1-800-273-TALK'),
            SizedBox(height: 20),
            _contactCard('Emergency', 'Assist you at any time..'),
          ],
        ),
      ),
    );
  }

  // Daily Affirmation Card


  // Mood Tracker Summary
  Widget _moodTrackerSummary() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood Tracker Summary',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your mood over the past 7 days:                       s \n😊 😢 😊 😎 😊 😢 😊',
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

  // Quick Access Buttons
  Widget _quickAccessButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _quickAccessButton('Journal', CupertinoIcons.pencil, () {
          // Navigate to Journal Screen
        }),
        _quickAccessButton('Meditate', CupertinoIcons.moon, () {
          // Navigate to Meditation Screen
        }),
        _quickAccessButton('Chat', CupertinoIcons.chat_bubble, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EmergencyScreen(backgroundColor: backgroundColor,)),
          );
        }),
      ],
    );
  }

  Widget _quickAccessButton(String label, IconData icon, VoidCallback onPressed) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Icon(icon, size: 36, color: backgroundColor),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: backgroundColor,
            ),
          ),
        ],
      ),
    );
  }

  // Community Highlights
  Widget _communityHighlights() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Community Highlights',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '"This community has been a lifesaver for me. Thank you all for your support!" - User123',
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

  // Image Card Widget with Navigation
  Widget _imageCard(String imagePath, String title, Widget destinationScreen) {
    return CupertinoButton(
      padding: EdgeInsets.zero, // Removes default button padding
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => destinationScreen), // iOS-style transition
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [ // Adds iOS-style soft shadow
              BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
              )],
          image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
    ),
    );
  }

  // Event Card Widget
  Widget _eventCard(String eventName, String eventTime, String eventDescription, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JoinEventScreen(
              eventName: eventName,
              eventTime: eventTime,
              eventDescription: eventDescription,
              backgroundColor: backgroundColor,
              eventImage: imagePath),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventName,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: backgroundColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                eventTime,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[100],
                ),
              ),
              SizedBox(height: 8),
              Text(
                eventDescription,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Contact Card Widget
  Widget _contactCard(String name, String number) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: backgroundColor,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  number,
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
              ],
            ),
            Spacer(),
            if (name == 'Suicide Prevention')
              IconButton(
                icon: Icon(CupertinoIcons.phone_solid, color: Color(0xFF87CEFA)),
                onPressed: () {
                  // Handle call action for Suicide Prevention
                },
              ),
            if (name == 'Emergency')
              IconButton(
                icon: Icon(CupertinoIcons.chat_bubble_fill, color: Color(0xFF87CEFA)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmergencyScreen(backgroundColor: backgroundColor,)),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalhealth/screens/ChatScreen.dart';
import 'package:mentalhealth/screens/JoinEventScreen.dart';
import 'package:mentalhealth/screens/LoginScreen.dart';
import 'package:mentalhealth/screens/moodtracking/mood_history_screen.dart';
import 'package:mentalhealth/screens/JoinEventScreen.dart';

import 'ProfilePage.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedEmoji = '😊'; // Default emoji
  Color backgroundColor = Color(0xFF6A5ACD);  // Default color
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

      // Change background color based on the emoji selected
      if (emoji == '😊') {
        backgroundColor = Colors.yellow;  // Example color for happy emoji
      } else if (emoji == '😢') {
        backgroundColor = Colors.blueAccent;  // Example color for sad emoji
      } else if (emoji == '😡') {
        backgroundColor = Colors.red;  // Example color for angry emoji
      } else if (emoji == '😎') {
        backgroundColor = Colors.green;  // Example color for cool emoji
      }else if (emoji == '😍') {
        backgroundColor = Colors.pink;  // Example color for cool emoji
      }
      else if (emoji == '🚫') {
        backgroundColor = Colors.deepPurple;  // Example color for cool emoji
      }
      // Add more conditions for other emojis if needed
    });
  }
  Widget _emojiButton(String emoji) {
    return GestureDetector(
      onTap: () {
        _emojiButtonColor(emoji); // Call method to update emoji and color
        Navigator.of(context).pop(); // Close the dialog
      },
      child: Text(
        emoji,
        style: TextStyle(fontSize: 32),
      ),
    );
  }



  void openEmojiSelection() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Select Your Emoji',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 10,
                  children: [
                    _emojiButton('😊'),
                    _emojiButton('😢'),
                    _emojiButton('😡'),
                    _emojiButton('😱'),
                    _emojiButton('😎'),
                    _emojiButton('😍'),
                    _emojiButton('🤔'),
                    _emojiButton('😴'),
                    _emojiButton('🚫'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Color(0xFF6A5ACD)),
              ),
            ),
          ],
        );
      },
    );
  }



  // Function to show the bottom sheet with profile/menu options
  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                title: Text('Mood Tracker',
                  style: TextStyle(fontSize: 18),
                ),
                leading: Icon(Icons.emoji_emotions, color: backgroundColor,),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MoodHistoryScreen()),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.person, color: backgroundColor),
                title: Text('Profile', style: GoogleFonts.poppins(fontSize: 18)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );


                  // Add further functionality here if needed
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings, color: backgroundColor),
                title: Text('Settings', style: GoogleFonts.poppins(fontSize: 18)),
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: "Settings selected",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  // Add settings functionality here
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: backgroundColor),
                title: Text('Logout', style: GoogleFonts.poppins(fontSize: 18)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );

                  Fluttertoast.showToast(
                    msg: "Logout selected",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  // Add logout functionality here
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white), // Hamburger menu icon
          onPressed: _showProfileMenu,
        ),
        title: Center(
          child: RichText(
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
                TextSpan(
                  text: "inCo",
                ),
              ],
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        //backgroundColor: Color(0xFF6A5ACD),
        elevation: 0,
        actions: [
          // Add the selected emoji to the AppBar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                selectedEmoji,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
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

            // Emotional Check-In Section
            Text(
              'How are you feeling today?',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: openEmojiSelection,
                style: ButtonStyle(
                  alignment: Alignment.centerLeft,
                  backgroundColor: WidgetStateProperty.all(Color(0xFF87CEFA)), // Light Sky Blue
                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 50)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                child: Text(
                  'Select..',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Image Gallery Section
            Text(
              'Explore Resources',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: PageView(
                children: [
                  _imageCard('lib/assets/articlesonmental.png', 'Articles on Mental Health'),
                  _imageCard('lib/assets/mentalhealthvideos.jpg', 'Mental Health Videos'),
                  _imageCard('lib/assets/mentalhealthpodcast.jpeg', 'Mental Health Podcasts'),
                  _imageCard('lib/assets/wellnessworkshop.png', 'Wellness Workshops'),
                ],
              ),
            ),
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
            _eventCard('Harmony Helpers', 'Every Wednesday at 6 PM','A supportive community gathering to discuss mental health topics.'),
            SizedBox(height: 20),
            _eventCard('Anxiety Support Circle', 'Every Friday at 3 PM','A supportive community gathering to discuss mental health topics.'),
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

  // Image Card Widget
  Widget _imageCard(String imagePath, String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
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
    );
  }

  // Event Card Widget
  Widget _eventCard(String eventName, String eventTime, String eventDescription) {
    return GestureDetector(
      onTap: () {
        // Navigate to the event details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JoinEventScreen(
              eventName: eventName,
              eventTime: eventTime,
              eventDescription: eventDescription,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              'lib/assets/event_image.jpg', // Replace with your image path
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),*/
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:backgroundColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    eventTime,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    eventDescription,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
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
            CircleAvatar(
              radius: 25,
              backgroundColor:
              backgroundColor,
              child: Icon(Icons.person, color: Colors.white),
            ),
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
            // Different icons based on name
            if (name == 'Suicide Prevention')
              IconButton(
                icon: Icon(Icons.call, color: Color(0xFF87CEFA)),
                onPressed: () {
                  // Handle call action for Suicide Prevention
                },
              ),
            if (name == 'Emergency')
              IconButton(
                icon: Icon(Icons.chat, color: Color(0xFF87CEFA)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen()),
                  );
                  // Handle chat action for Chat with a Person
                },
              ),
          ],
        ),
      ),
    );
  }
}

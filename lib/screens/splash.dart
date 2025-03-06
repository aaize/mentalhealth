import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'HomeScreen.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _jiggleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..forward();

    _jiggleAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _colorAnimation = ColorTween(begin: Colors.black, end: Colors.deepPurple).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Check login status after the animation ends
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        final userEmail = await SessionManager.getUserEmail();
        if (userEmail != null) {
          // User is logged in, navigate to HomeScreen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomeScreen(userEmail: userEmail)),
          );
        } else {
          // User is not logged in, navigate to LoginScreen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorAnimation.value,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _jiggleAnimation.value),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.gabarito(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2, 2),
                      ),
                    ],
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
            );
          },
        ),
      ),
    );
  }
}

class SessionManager {
  static const String _userEmailKey = 'userEmail';

  // Save user email after login
  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  // Get saved user email for auto-login
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Clear user email on logout
  static Future<void> clearUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userEmailKey);
  }
}
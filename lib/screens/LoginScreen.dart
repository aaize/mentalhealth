import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'HomeScreen.dart';
import 'SignUpScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check for saved user email on app startup
  final userEmail = await SessionManager.getUserEmail();
  runApp(MaterialApp(
    title: 'Custom Login Demo',
    theme: ThemeData.dark(),
    home: userEmail != null ? HomeScreen(userEmail: userEmail) : LoginScreen(),
  ));
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginUser() async {
    setState(() => _isLoading = true);

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // Basic email format validation
    if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      showToast("Please enter a valid email");
      setState(() => _isLoading = false);
      return;
    }

    if (password.isEmpty || password.length < 6) {
      showToast("Password must be at least 6 characters");
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Query the ProfileDetails collection for a document with the given email
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('ProfileDetails')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        showToast("No user found with this email");
      } else {
        // Get the first (and only) document
        var userDoc = query.docs.first;
        // Compare stored password with provided password
        // (In production, compare hashed passwords)
        if (userDoc['password'] == password) {
          showToast("Login successful!");

          // Save user email for auto-login
          await SessionManager.saveUserEmail(email);

          // Navigate to the HomeScreen (pass user data if needed)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen(userEmail: email)),
          );
        } else {
          showToast("Incorrect password");
        }
      }
    } catch (e) {
      showToast("Error: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 40, vertical: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'lib/assets/Logo.png',
                  height: 220,
                  width: 180,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "LOGIN",
                style: GoogleFonts.waitingForTheSunrise(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 0.24,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "EMAIL",
                  hintStyle:
                  GoogleFonts.roboto(fontSize: 13, color: Colors.grey),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 0.24,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "PASSWORD",
                  hintStyle:
                  GoogleFonts.roboto(fontSize: 13, color: Colors.grey),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text(
                    "LOG IN",
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 0.168,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ),
                ),
                child: Text(
                  "CREATE NEW ACCOUNT",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.deepPurple,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'LoginScreen.dart'; // Ensure this import is correct

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _signUpUser() async {
    setState(() => _isLoading = true);

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
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

    if (password != confirmPassword) {
      showToast("Passwords do not match");
      setState(() => _isLoading = false);
      return;
    }

    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();
      showToast("Verification email sent! Please check your inbox.");
      Navigator.pop(context); // Return to the login screen after successful signup

    } on FirebaseAuthException catch (e) {
      handleFirebaseError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void handleFirebaseError(FirebaseAuthException e) {
    String message = 'An error occurred';
    switch (e.code) {
      case 'email-already-in-use':
        message = 'Email already registered';
        break;
      case 'weak-password':
        message = 'Password is too weak';
        break;
      case 'invalid-email':
        message = 'Invalid email address';
        break;
      default:
        message = e.message ?? 'An error occurred';
    }
    showToast(message);
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
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 120),
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
                "SIGN UP",
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
                  hintStyle: GoogleFonts.roboto(fontSize: 13, color: Colors.grey),
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
                  hintStyle: GoogleFonts.roboto(fontSize: 13, color: Colors.grey),
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
                controller: _confirmPasswordController,
                obscureText: true,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 0.24,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "CONFIRM PASSWORD",
                  hintStyle: GoogleFonts.roboto(fontSize: 13, color: Colors.grey),
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
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUpUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text(
                    "SIGN UP",
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 0.168,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "ALREADY HAVE AN ACCOUNT? LOGIN",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.deepPurple,
                    decoration: TextDecoration.underline,
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
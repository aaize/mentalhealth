import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mentalhealth/screens/LoginScreen.dart';
import 'package:mentalhealth/screens/splash.dart';
import 'package:mentalhealth/screens/HomeScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gopaalmaytgpwfwhihkj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdvcGFhbG1heXRncHdmd2hpaGtqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkxMjMzNDMsImV4cCI6MjA1NDY5OTM0M30.lGrRHotrEDOpe7w6-B9jaWDpJR9u-p3kYW711xXB0N8',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindfulConnect',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey.shade900,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => LoginScreen(), // Placeholder for the Home screen

      },
    );
  }
}
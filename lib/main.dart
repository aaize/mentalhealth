import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mentalhealth/screens/LoginScreen.dart';
import 'package:mentalhealth/screens/splash.dart';
import 'package:mentalhealth/screens/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
/* =======================================================
   MAIN ENTRY POINT
   ======================================================= */

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'welcome/splash_screen.dart';

/* ============= Main Function ============= */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

/* ============= Root App Widget ============= */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6055D8),
          primary: const Color(0xFF6055D8),
        ),
        useMaterial3: true,
        fontFamily: null,
      ),
      home: const SplashScreen(),
    );
  }
}

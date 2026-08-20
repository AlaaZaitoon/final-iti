/* =======================================================
   WELCOME MODULE: Splash Screen
   ======================================================= */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../signIn/login_screen.dart';
import '../home_nav/main_nav_screen.dart';

/* ============= Splash Screen Widget ============= */
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /* ============= Navigation Logic ============= */
  void _handleNavigation() {
    _timer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;
      // Only enter app if user is signed in and has verified their email
      if (user != null && user.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6C6C8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text(
              'Loading • • •',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

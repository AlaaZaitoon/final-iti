/* =======================================================
   HOME NAV MODULE: Profile Screen
   ======================================================= */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../signIn/login_screen.dart';

/* ============= Profile Screen Widget ============= */
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSigningOut = false;

  /* ============= Get Dynamic User Name ============= */
  String _getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        return user.displayName!;
      }
      if (user.email != null && user.email!.isNotEmpty) {
        final prefix = user.email!.split('@')[0];
        return prefix.isNotEmpty
            ? '${prefix[0].toUpperCase()}${prefix.substring(1)}'
            : 'User';
      }
    }
    return 'Rana Mohy';
  }

  /* ============= Sign Out Action ============= */
  Future<void> _handleSignOut() async {
    setState(() {
      _isSigningOut = true;
    });

    try {
      // 1. Sign out of Google
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
      } catch (_) {}

      // 2. Sign out of Firebase
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      // 3. Clear navigation stack and go to Login Screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign out error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSigningOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // 1. User Avatar Placeholder
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE5E7EB),
                ),
                child: Center(
                  child: user?.photoURL != null && user!.photoURL!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(48),
                          child: Image.network(
                            user.photoURL!,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.person_rounded,
                              size: 56,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.person_rounded,
                          size: 56,
                          color: Color(0xFF9CA3AF),
                        ),
                ),
              ),

              const SizedBox(height: 14),

              // User Name
              Text(
                _getUserName(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              if (user?.email != null) ...[
                const SizedBox(height: 4),
                Text(
                  user!.email!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // 2. Menu Options
              _buildMenuItem(
                icon: Icons.person_outline_rounded,
                title: 'Profile',
                onTap: () {},
              ),
              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'Setting',
                onTap: () {},
              ),
              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.mail_outline_rounded,
                title: 'Contact',
                onTap: () {},
              ),
              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.share_outlined,
                title: 'Share App',
                onTap: () {},
              ),
              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                title: 'Help',
                onTap: () {},
              ),

              const SizedBox(height: 48),

              // 3. Sign Out Button
              _isSigningOut
                  ? const CircularProgressIndicator(
                      color: Color(0xFFFF4B4B),
                      strokeWidth: 2.5,
                    )
                  : GestureDetector(
                      onTap: _handleSignOut,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF4B4B),
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /* ============= Menu Option Item Helper Widget ============= */
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7F7),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF111827),
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF9CA3AF),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

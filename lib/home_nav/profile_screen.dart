/* =======================================================
   HOME NAV MODULE: Profile Screen (with Interactive Actions)
   ======================================================= */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../signIn/login_screen.dart';
import 'favorites_screen.dart';
import 'orders_screen.dart';

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
    return 'Customer';
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

  /* ============= Show Account Details Modal ============= */
  void _showAccountDetailsModal(User? user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Account Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 18),
            _buildInfoRow('Name', _getUserName()),
            const SizedBox(height: 12),
            _buildInfoRow('Email', user?.email ?? 'Not provided'),
            const SizedBox(height: 12),
            _buildInfoRow(
              'User ID',
              user?.uid != null
                  ? '${user!.uid.substring(0, 10)}...'
                  : 'Anonymous',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Status',
              user?.emailVerified == true ? 'Verified' : 'Active',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  /* ============= Show Contact Dialog ============= */
  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.support_agent_rounded, color: Color(0xFF6055D8)),
            SizedBox(width: 10),
            Text(
              'Contact Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Need assistance with your orders or account? Reach out to us directly:',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email_outlined, size: 18, color: Color(0xFF6055D8)),
                SizedBox(width: 8),
                Text(
                  'support@swiftshop.com',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 18, color: Color(0xFF6055D8)),
                SizedBox(width: 8),
                Text(
                  '+20 100 000 0000',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Color(0xFF6055D8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* ============= Share App Action ============= */
  void _handleShareApp() {
    const String shareUrl = 'https://ecommerce-app-gules-theta.vercel.app';
    Clipboard.setData(const ClipboardData(text: shareUrl));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('App link copied to clipboard! Share it with friends.'),
        backgroundColor: Color(0xFF6055D8),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /* ============= Show Help / FAQs Modal ============= */
  void _showHelpModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24.0),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Frequently Asked Questions (FAQ)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 16),
            _buildFaqItem(
              'How long does shipping take?',
              'Standard delivery takes between 2 to 4 business days.',
            ),
            _buildFaqItem(
              'What payment methods are supported?',
              'We support Credit Cards, Debit Cards, Cash on Delivery, and Digital Wallets.',
            ),
            _buildFaqItem(
              'What is your return policy?',
              'You can return any unused item within 14 days of receipt for a full refund.',
            ),
            _buildFaqItem(
              'How can I track my order?',
              'Go to Profile > My Orders to view live status updates for all your orders.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          const Divider(height: 20, color: Color(0xFFF3F4F6)),
        ],
      ),
    );
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

              // 1. User Avatar
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

              const SizedBox(height: 28),

              // 2. Menu Options
              _buildMenuItem(
                icon: Icons.receipt_long_rounded,
                title: 'My Orders',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdersScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.favorite_border_rounded,
                title: 'My Wishlist',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.person_outline_rounded,
                title: 'Account Information',
                onTap: () => _showAccountDetailsModal(user),
              ),
              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.mail_outline_rounded,
                title: 'Contact Support',
                onTap: _showContactDialog,
              ),
              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.share_outlined,
                title: 'Share App',
                onTap: _handleShareApp,
              ),
              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                title: 'Help & FAQs',
                onTap: _showHelpModal,
              ),

              const SizedBox(height: 36),

              // 3. Sign Out Button
              GestureDetector(
                onTap: _isSigningOut ? null : _handleSignOut,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFEE2E2), width: 1.2),
                  ),
                  child: Center(
                    child: _isSigningOut
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Color(0xFFFF4B4B),
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.logout_rounded,
                                color: Color(0xFFFF4B4B),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Sign Out',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF4B4B),
                                ),
                              ),
                            ],
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

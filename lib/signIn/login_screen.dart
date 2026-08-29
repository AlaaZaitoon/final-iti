/* =======================================================
   SIGN IN MODULE: Login Screen
   ======================================================= */

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/discount_banner.dart';
import '../register/signup_screen.dart';
import 'forgot_password_screen.dart';
import '../home_nav/main_nav_screen.dart';

/* ============= Login Screen Widget ============= */
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /* ============= Login Execution ============= */
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Strict Check: Block sign in if email is not verified
        if (!user.emailVerified) {
          await FirebaseAuth.instance.signOut();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Please verify your email before logging in. Check inbox/spam.',
              ),
              backgroundColor: const Color(0xFFE65100),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Resend',
                textColor: Colors.white,
                onPressed: () async {
                  try {
                    await user.sendEmailVerification();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Verification email resent!'),
                          backgroundColor: Color(0xFF6055D8),
                        ),
                      );
                    }
                  } catch (_) {}
                },
              ),
            ),
          );
          return;
        }

        // Check and sync user document in Firestore if not exists
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          final derivedName = email.split('@')[0];
          final formattedName = derivedName.isNotEmpty
              ? '${derivedName[0].toUpperCase()}${derivedName.substring(1)}'
              : 'User';

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'name': user.displayName ?? formattedName,
            'email': email,
            'lastLogin': FieldValue.serverTimestamp(),
          });
        }
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String errorMessage = 'Login failed. Please check your credentials.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Invalid email or password.';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /* ============= Google Sign-In Execution ============= */
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      UserCredential userCredential;

      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          if (mounted) setState(() => _isGoogleLoading = false);
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
      }

      final user = userCredential.user;

      if (user != null) {
        String displayName = user.displayName ?? '';
        if (displayName.isEmpty && user.email != null) {
          final derived = user.email!.split('@')[0];
          displayName = derived.isNotEmpty
              ? '${derived[0].toUpperCase()}${derived.substring(1)}'
              : 'User';
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': displayName,
          'email': user.email ?? '',
          'photoUrl': user.photoURL ?? '',
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Top Discount Banner
                const DiscountBanner(),

                const SizedBox(height: 28),

                // Email / Username Field
                CustomTextField(
                  label: 'Enter your name',
                  hintText: 'User Name / Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Password Field
                CustomTextField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Remember Me & Forgot Password Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Remember Me Checkbox
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: const Color(0xFF6055D8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: const BorderSide(
                              color: Color(0xFF9CA3AF),
                              width: 1.5,
                            ),
                            onChanged: (val) {
                              setState(() {
                                _rememberMe = val ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Remember me',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF111827),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Forgot Password Link
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forget password?',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Login Button
                CustomButton(
                  text: 'Login',
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),

                const SizedBox(height: 16),

                // OR Divider
                Row(
                  children: const [
                    Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                  ],
                ),

                const SizedBox(height: 16),

                // Google Sign In Button
                _buildGoogleButton(),

                const SizedBox(height: 20),

                // Sign Up Footer Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* ============= Google Sign In Button Widget ============= */
  Widget _buildGoogleButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.white,
        ),
        child: _isGoogleLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF6055D8),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google.png',
                    width: 22,
                    height: 22,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.g_mobiledata,
                      size: 28,
                      color: Color(0xFF6055D8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/colors.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final user = FirebaseAuth.instance.currentUser;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => user != null ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delivery_dining, size: 90, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'QuickBite',
              style: GoogleFonts.poppins(
                fontSize: 36, fontWeight: FontWeight.bold,
                color: Colors.white, letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Order. Eat. Enjoy.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

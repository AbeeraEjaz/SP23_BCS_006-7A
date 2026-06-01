import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, size: 80, color: AppColors.success),
              ),
              const SizedBox(height: 30),
              Text('Order Placed!', style: GoogleFonts.poppins(
                fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 12),
              Text(
                'Your order has been placed successfully.\nWe will deliver it to you in 30 minutes.',
                style: AppStyles.greyText.copyWith(height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              CustomButton(
                text: 'Back to Home',
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

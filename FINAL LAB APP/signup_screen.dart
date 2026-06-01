import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void _signup() async {
    setState(() => isLoading = true);
    final error = await AuthService().signUp(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    setState(() => isLoading = false);
    if (!mounted) return;
    if (error == null) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text('QuickBite', style: GoogleFonts.poppins(
                  fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ),
              const SizedBox(height: 30),
              Text('Create Account', style: AppStyles.heading1),
              Text('Sign up to get started', style: AppStyles.greyText),
              const SizedBox(height: 30),
              CustomTextField(
                hint: 'Full Name', icon: Icons.person_outline,
                controller: nameController),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'Email', icon: Icons.email_outlined,
                controller: emailController),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'Password', icon: Icons.lock_outline,
                controller: passwordController, isPassword: true),
              const SizedBox(height: 30),
              CustomButton(text: 'Sign Up', onPressed: _signup, isLoading: isLoading),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: AppStyles.greyText,
                      children: [
                        TextSpan(text: 'Login',
                          style: AppStyles.bodyText.copyWith(
                            color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void _login() async {
    setState(() => isLoading = true);
    final error = await AuthService().login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    setState(() => isLoading = false);
    if (!mounted) return;
    if (error == null) {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()));
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
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.delivery_dining, size: 70, color: AppColors.primary),
                    const SizedBox(height: 10),
                    Text('QuickBite', style: GoogleFonts.poppins(
                      fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text('Welcome Back!', style: AppStyles.heading1),
              Text('Login to continue', style: AppStyles.greyText),
              const SizedBox(height: 30),
              CustomTextField(
                hint: 'Email', icon: Icons.email_outlined,
                controller: emailController),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'Password', icon: Icons.lock_outline,
                controller: passwordController, isPassword: true),
              const SizedBox(height: 30),
              CustomButton(text: 'Login', onPressed: _login, isLoading: isLoading),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SignupScreen())),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: AppStyles.greyText,
                      children: [
                        TextSpan(text: 'Sign Up',
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

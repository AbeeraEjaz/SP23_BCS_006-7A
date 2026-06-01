import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';
import 'order_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withOpacity(0.15),
              child: const Icon(Icons.person, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(user?.displayName ?? 'QuickBite User', style: AppStyles.heading2),
            const SizedBox(height: 4),
            Text(user?.email ?? 'user@email.com', style: AppStyles.greyText),
            const SizedBox(height: 40),
            _profileTile(Icons.shopping_bag_outlined, 'My Orders', () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const OrderScreen()));
            }),
            _profileTile(Icons.location_on_outlined, 'Delivery Address', () {}),
            _profileTile(Icons.payment_outlined, 'Payment Methods', () {}),
            _profileTile(Icons.help_outline, 'Help & Support', () {}),
            const Spacer(),
            CustomButton(
              text: 'Logout',
              color: Colors.red,
              onPressed: () async {
                await AuthService().logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppStyles.bodyText),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textGrey),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}

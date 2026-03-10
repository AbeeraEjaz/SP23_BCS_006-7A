import 'package:flutter/material.dart';

void main() {
  runApp(const ProfileCardApp());
}

class ProfileCardApp extends StatelessWidget {
  const ProfileCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Card',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ProfileCardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileCardScreen extends StatelessWidget {
  const ProfileCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main Profile Card
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header with gradient (feminine colors)
                    Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFD7E8C), // Soft pink
                            Color(0xFFB881FF), // Lavender
                            Color(0xFF6C9BE5), // Light blue
                          ],
                        ),
                      ),
                    ),
                    
                    // Profile Image (overlapping)
                    Transform.translate(
                      offset: const Offset(0, -60),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://cdn-icons-png.flaticon.com/512/3135/3135715.png', // Female avatar icon
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    
                    // Name and Degree
                    Transform.translate(
                      offset: const Offset(0, -40),
                      child: Column(
                        children: [
                          const Text(
                            'Abeera Ejaz', // Your name
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB881FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'BSCS Student', // Your degree
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFB881FF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Contact Information
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                      child: Column(
                        children: [
                          // Email
                          _buildContactItem(
                            icon: Icons.email_outlined,
                            label: 'abeera.ejaz@example.com', // Your email
                            color: const Color(0xFFFD7E8C),
                          ),
                          const SizedBox(height: 15),
                          
                          // Phone
                          _buildContactItem(
                            icon: Icons.phone_outlined,
                            label: '+92 300 1234567', // Pakistan format
                            color: const Color(0xFFB881FF),
                          ),
                          const SizedBox(height: 15),
                          
                          // University/Location
                          _buildContactItem(
                            icon: Icons.school_outlined,
                            label: 'BSCS, 6th Semester', // Your semester
                            color: const Color(0xFF6C9BE5),
                          ),
                        ],
                      ),
                    ),
                    
                    // Social Media Icons
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialIcon(
                            icon: Icons.facebook,
                            color: const Color(0xFF1877F2),
                          ),
                          const SizedBox(width: 20),
                          _buildSocialIcon(
                            icon: Icons.message,
                            color: const Color(0xFFFD7E8C),
                          ),
                          const SizedBox(width: 20),
                          _buildSocialIcon(
                            icon: Icons.link,
                            color: const Color(0xFF6C9BE5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Footer Text
              Text(
                'Profile Card • Flutter Assignment',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF636E72),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}
import 'package:flutter/material.dart';

class GenderSelector extends StatelessWidget {
  final String selectedGender;
  final Function(String) onGenderChanged;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E3A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GENDER',
            style: TextStyle(
              color: Color(0xFF8B8BAA),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _genderButton('Male', Icons.male, 'Male'),
              const SizedBox(width: 10),
              _genderButton('Female', Icons.female, 'Female'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _genderButton(String gender, IconData icon, String label) {
    final isActive = selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => onGenderChanged(gender),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF6C63FF).withOpacity(0.15)
                : const Color(0xFF2A2A4A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? const Color(0xFF6C63FF)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: isActive ? const Color(0xFFA89FFF) : Colors.white54,
                  size: 28),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? const Color(0xFFA89FFF) : Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

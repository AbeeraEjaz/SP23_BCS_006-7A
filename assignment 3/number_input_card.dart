import 'package:flutter/material.dart';

class NumberInputCard extends StatelessWidget {
  final String label;
  final int value;
  final String unit;
  final String? errorText;
  final Function(int) onChanged;

  const NumberInputCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E3A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: errorText != null
              ? const Color(0xFFEF4444).withOpacity(0.5)
              : const Color(0xFF6C63FF).withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF8B8BAA),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(color: Color(0xFF8B8BAA), fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _stepButton(Icons.remove, () {
                if (value > 0) onChanged(value - 1);
              }),
              const SizedBox(width: 16),
              _stepButton(Icons.add, () {
                onChanged(value + 1);
              }),
            ],
          ),
          if (errorText != null) ...[
            const SizedBox(height: 6),
            Text(
              '⚠ $errorText',
              style: const TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _stepButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFF6C63FF).withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF6C63FF).withOpacity(0.4),
          ),
        ),
        child: Icon(icon, color: const Color(0xFFA89FFF), size: 18),
      ),
    );
  }
}

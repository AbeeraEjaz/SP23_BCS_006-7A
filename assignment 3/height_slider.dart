import 'package:flutter/material.dart';

class HeightSlider extends StatelessWidget {
  final double height;
  final String? errorText;
  final Function(double) onHeightChanged;

  const HeightSlider({
    super.key,
    required this.height,
    required this.onHeightChanged,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HEIGHT',
            style: TextStyle(
              color: Color(0xFF8B8BAA),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                height.toStringAsFixed(0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'cm',
                style: TextStyle(color: Color(0xFF8B8BAA), fontSize: 16),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF6C63FF),
              inactiveTrackColor: const Color(0xFF2A2A4A),
              thumbColor: Colors.white,
              overlayColor: const Color(0xFF6C63FF).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              trackHeight: 5,
            ),
            child: Slider(
              min: 100,
              max: 250,
              value: height,
              onChanged: onHeightChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('100 cm', style: TextStyle(color: Color(0xFF444466), fontSize: 10)),
              Text('250 cm', style: TextStyle(color: Color(0xFF444466), fontSize: 10)),
            ],
          ),
          if (errorText != null) ...[
            const SizedBox(height: 6),
            Text(
              '⚠ $errorText',
              style: const TextStyle(color: Color(0xFFEF4444), fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}

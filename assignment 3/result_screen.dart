import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final double bmi;
  final double height;
  final int weight;
  final int age;
  final String gender;

  const ResultScreen({
    super.key,
    required this.bmi,
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
  });

  String get category {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal Weight';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  Color get categoryColor {
    if (bmi < 18.5) return const Color(0xFF38BDF8);
    if (bmi < 25.0) return const Color(0xFF4ADE80);
    if (bmi < 30.0) return const Color(0xFFFACC15);
    return const Color(0xFFEF4444);
  }

  double get _needlePercent {
    if (bmi <= 15) return 0.0;
    if (bmi >= 40) return 1.0;
    return (bmi - 15) / 25.0;
  }

  double _idealWeightMin() => 18.5 * (height / 100) * (height / 100);
  double _idealWeightMax() => 24.9 * (height / 100) * (height / 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildResultCard(),
                    const SizedBox(height: 16),
                    _buildStatsRow(),
                    const SizedBox(height: 16),
                    _buildCategoryTable(),
                    const SizedBox(height: 24),
                    _buildRecalcButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFFA855F7)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white70, size: 16),
                Text('Back', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your BMI Result',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E3A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const Text(
            'YOUR BMI',
            style: TextStyle(
              color: Color(0xFF8B8BAA),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFFA855F7)],
            ).createShader(bounds),
            child: Text(
              bmi.toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 72,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            '✓  $category',
            style: TextStyle(
              color: categoryColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Height: ${height.toStringAsFixed(0)} cm · Weight: $weight kg · Age: $age',
            style: const TextStyle(color: Color(0xFF8B8BAA), fontSize: 12),
          ),
          const SizedBox(height: 20),
          _buildGauge(),
        ],
      ),
    );
  }

  Widget _buildGauge() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF38BDF8),
                    Color(0xFF4ADE80),
                    Color(0xFFFACC15),
                    Color(0xFFF97316),
                    Color(0xFFEF4444),
                  ],
                ),
              ),
            ),
            Positioned(
              left: (_needlePercent * 100).clamp(2.0, 96.0).toString() == '50.0'
                  ? null
                  : null,
              child: FractionallySizedBox(
                widthFactor: _needlePercent.clamp(0.02, 0.96),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 3,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 6,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Under', style: TextStyle(color: Color(0xFF555577), fontSize: 10)),
            Text('Normal', style: TextStyle(color: Color(0xFF555577), fontSize: 10)),
            Text('Over', style: TextStyle(color: Color(0xFF555577), fontSize: 10)),
            Text('Obese', style: TextStyle(color: Color(0xFF555577), fontSize: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    final minIdeal = _idealWeightMin();
    final maxIdeal = _idealWeightMax();
    final diff = maxIdeal - weight;

    return Row(
      children: [
        _statBox('$weight kg', 'Current Weight'),
        const SizedBox(width: 12),
        _statBox(
          '${minIdeal.toStringAsFixed(0)}–${maxIdeal.toStringAsFixed(0)} kg',
          'Ideal Range',
        ),
        const SizedBox(width: 12),
        _statBox(
          '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(1)} kg',
          diff > 0 ? 'To Overweight' : 'Above Ideal',
        ),
      ],
    );
  }

  Widget _statBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E3A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(color: Color(0xFF8B8BAA), fontSize: 11),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTable() {
    final rows = [
      ('Underweight', 'Below 18.5', const Color(0xFF38BDF8), 'Low'),
      ('Normal Weight', '18.5 – 24.9', const Color(0xFF4ADE80), 'Normal'),
      ('Overweight', '25.0 – 29.9', const Color(0xFFFACC15), 'Medium'),
      ('Obese', '30.0 & above', const Color(0xFFEF4444), 'High'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E3A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BMI Categories',
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...rows.map((row) {
            final isActive = row.$1 == category;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(row.$1,
                        style: TextStyle(
                          color: isActive ? Colors.white : const Color(0xFFCCCCCC),
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 13,
                        )),
                  ),
                  Text(row.$2,
                      style: const TextStyle(color: Color(0xFF8B8BAA), fontSize: 13)),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: row.$3.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isActive ? '✓ You' : row.$4,
                      style: TextStyle(
                          color: row.$3, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecalcButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF6C63FF), width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh, color: Color(0xFFA89FFF), size: 20),
            SizedBox(width: 8),
            Text('Recalculate',
                style: TextStyle(
                    color: Color(0xFFA89FFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

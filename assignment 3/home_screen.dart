import 'package:flutter/material.dart';
import '../widgets/gender_selector.dart';
import '../widgets/height_slider.dart';
import '../widgets/number_input_card.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedGender = 'Male';
  double _height = 175.0;
  int _weight = 70;
  int _age = 25;

  String? _heightError;
  String? _weightError;
  String? _ageError;

  bool _validate() {
    bool valid = true;
    setState(() {
      _heightError = null;
      _weightError = null;
      _ageError = null;

      if (_height < 100 || _height > 250) {
        _heightError = 'Height must be between 100 and 250 cm';
        valid = false;
      }
      if (_weight < 10 || _weight > 500) {
        _weightError = 'Weight must be between 10 and 500 kg';
        valid = false;
      }
      if (_age < 2 || _age > 120) {
        _ageError = 'Age must be between 2 and 120 years';
        valid = false;
      }
    });
    return valid;
  }

  void _calculateBMI() {
    if (!_validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Please fix the errors before calculating.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    double heightInMeters = _height / 100;
    double bmi = _weight / (heightInMeters * heightInMeters);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          bmi: bmi,
          height: _height,
          weight: _weight,
          age: _age,
          gender: _selectedGender,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    GenderSelector(
                      selectedGender: _selectedGender,
                      onGenderChanged: (g) => setState(() => _selectedGender = g),
                    ),
                    const SizedBox(height: 16),
                    HeightSlider(
                      height: _height,
                      errorText: _heightError,
                      onHeightChanged: (h) => setState(() => _height = h),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: NumberInputCard(
                            label: 'Weight',
                            value: _weight,
                            unit: 'kg',
                            errorText: _weightError,
                            onChanged: (v) => setState(() => _weight = v),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: NumberInputCard(
                            label: 'Age',
                            value: _age,
                            unit: 'yrs',
                            errorText: _ageError,
                            onChanged: (v) => setState(() => _age = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildCalculateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFFA855F7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BMI Calculator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Body Mass Index',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.monitor_weight_outlined,
                color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: ElevatedButton(
        onPressed: _calculateBMI,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: const Color(0xFF6C63FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          shadowColor: const Color(0xFF6C63FF).withOpacity(0.5),
        ),
        child: const Text(
          'CALCULATE BMI',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
      ),
    );
  }
}

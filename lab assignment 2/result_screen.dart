// lib/screens/result_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import 'history_screen.dart';

class ResultScreen extends StatefulWidget {
  final int guessedNumber;
  final int targetNumber;
  final String status;
  final VoidCallback onPlayAgain;

  const ResultScreen({
    super.key,
    required this.guessedNumber,
    required this.targetNumber,
    required this.status,
    required this.onPlayAgain,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Auto-save to SQLite
    _saveResult();
  }

  Future<void> _saveResult() async {
    final now = DateFormat('dd MMM yyyy – hh:mm a').format(DateTime.now());
    final result = GameResult(
      guessedNumber: widget.guessedNumber,
      targetNumber: widget.targetNumber,
      status: widget.status,
      timestamp: now,
    );
    await DatabaseHelper.instance.insertResult(result);
    if (mounted) setState(() => _saved = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _statusColor {
    switch (widget.status) {
      case 'Correct':
        return const Color(0xFF00E676);
      case 'Too High':
        return const Color(0xFFFF5252);
      case 'Too Low':
        return const Color(0xFFFFD740);
      default:
        return Colors.white;
    }
  }

  String get _statusEmoji {
    switch (widget.status) {
      case 'Correct':
        return '🎉';
      case 'Too High':
        return '📈';
      case 'Too Low':
        return '📉';
      default:
        return '❓';
    }
  }

  String get _statusMessage {
    switch (widget.status) {
      case 'Correct':
        return 'Congratulations!\nYou got it right!';
      case 'Too High':
        return 'Too High!\nGuess a smaller number.';
      case 'Too Low':
        return 'Too Low!\nGuess a bigger number.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Result',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Result card
              FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: _statusColor.withOpacity(0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _statusColor.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Emoji
                          Text(
                            _statusEmoji,
                            style: const TextStyle(fontSize: 70),
                          ),
                          const SizedBox(height: 16),

                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: _statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: _statusColor.withOpacity(0.5)),
                            ),
                            child: Text(
                              widget.status.toUpperCase(),
                              style: TextStyle(
                                color: _statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            _statusMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Number info
                          Row(
                            children: [
                              _infoBox('Your Guess', '${widget.guessedNumber}', const Color(0xFF6C63FF)),
                              const SizedBox(width: 12),
                              _infoBox(
                                widget.status == 'Correct' ? 'Correct!' : 'Answer',
                                widget.status == 'Correct' ? '✓' : '${widget.targetNumber}',
                                _statusColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Save status
                          if (_saved)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle, color: Color(0xFF00E676), size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  'Result saved to history',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onPlayAgain();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text(
                          'PLAY AGAIN',
                          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const HistoryScreen()),
                          );
                        },
                        icon: const Icon(Icons.history),
                        label: const Text(
                          'VIEW HISTORY',
                          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white70,
                          side: BorderSide(color: Colors.white.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

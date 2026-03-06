import 'package:flutter/material.dart';
import 'dart:math'; // For random number generation

void main() {
  runApp(const DiceApp());
}

class DiceApp extends StatelessWidget {
  const DiceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Dice App',
      theme: ThemeData(
        fontFamily: 'Roboto', // Clean font
        primarySwatch: Colors.indigo,
      ),
      home: const DiceHomePage(),
    );
  }
}

class DiceHomePage extends StatefulWidget {
  const DiceHomePage({Key? key}) : super(key: key);

  @override
  State<DiceHomePage> createState() => _DiceHomePageState();
}

class _DiceHomePageState extends State<DiceHomePage> {

  int diceNumber = 1; // Default dice value

  // Function to roll dice
  void rollDice() {
    setState(() {
      diceNumber = Random().nextInt(6) + 1; // Random number 1–6
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text("Simple Dice App"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Dice Image (Tap to roll)
            GestureDetector(
              onTap: rollDice,
              child: Image.asset(
                'assets/images/$diceNumber.png',
                width: 150,
              ),
            ),

            const SizedBox(height: 30),

            // Roll Button
            ElevatedButton(
              onPressed: rollDice,
              child: const Text("Roll Dice"),
            ),
          ],
        ),
      ),
    );
  }
}
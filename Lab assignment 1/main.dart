
import 'package:flutter/material.dart';
import 'screens/patient_list_screen.dart';

void main() {
  runApp(DoctorApp());
}

class DoctorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: PatientListScreen(),
    );
  }
}

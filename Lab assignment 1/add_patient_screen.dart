
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/patient.dart';

class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final diseaseController = TextEditingController();

  DBHelper dbHelper = DBHelper();

  void savePatient() async {
    Patient p = Patient(
      name: nameController.text,
      age: ageController.text,
      disease: diseaseController.text,
    );

    await dbHelper.insertPatient(p);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Patient")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: ageController, decoration: InputDecoration(labelText: "Age")),
            TextField(controller: diseaseController, decoration: InputDecoration(labelText: "Disease")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: savePatient,
              child: Text("Save"),
            )
          ],
        ),
      ),
    );
  }

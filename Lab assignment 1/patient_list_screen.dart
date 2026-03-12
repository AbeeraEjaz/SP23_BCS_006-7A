
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/patient.dart';
import 'add_patient_screen.dart';

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {

  DBHelper dbHelper = DBHelper();
  List<Patient> patients = [];

  void loadPatients() async {
    patients = await dbHelper.getPatients();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Patients")),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final p = patients[index];
          return ListTile(
            title: Text(p.name),
            subtitle: Text("Age: ${p.age} | Disease: ${p.disease}"),
            trailing: IconButton(
              icon: Icon(Icons.delete,color: Colors.red),
              onPressed: () async {
                await dbHelper.deletePatient(p.id!);
                loadPatients();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddPatientScreen()),
          );
          loadPatients();
        },
      ),
    );
  }
}


import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/patient.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'doctor_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE patients(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          age TEXT,
          disease TEXT
        )
        ''');
      },
    );
  }

  Future<int> insertPatient(Patient patient) async {
    final db = await database;
    return db.insert('patients', patient.toMap());
  }

  Future<List<Patient>> getPatients() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('patients');
    return maps.map((e) => Patient.fromMap(e)).toList();
  }

  Future<int> updatePatient(Patient patient) async {
    final db = await database;
    return db.update('patients', patient.toMap(),
        where: 'id=?', whereArgs: [patient.id]);
  }

  Future<int> deletePatient(int id) async {
    final db = await database;
    return db.delete('patients', where: 'id=?', whereArgs: [id]);
  }
}

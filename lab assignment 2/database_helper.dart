// lib/db/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GameResult {
  final int? id;
  final int guessedNumber;
  final int targetNumber;
  final String status; // 'Correct', 'Too High', 'Too Low'
  final String timestamp;

  GameResult({
    this.id,
    required this.guessedNumber,
    required this.targetNumber,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'guessedNumber': guessedNumber,
      'targetNumber': targetNumber,
      'status': status,
      'timestamp': timestamp,
    };
  }

  factory GameResult.fromMap(Map<String, dynamic> map) {
    return GameResult(
      id: map['id'],
      guessedNumber: map['guessedNumber'],
      targetNumber: map['targetNumber'],
      status: map['status'],
      timestamp: map['timestamp'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('game_results.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE game_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        guessedNumber INTEGER NOT NULL,
        targetNumber INTEGER NOT NULL,
        status TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertResult(GameResult result) async {
    final db = await instance.database;
    return await db.insert('game_results', result.toMap());
  }

  Future<List<GameResult>> getAllResults() async {
    final db = await instance.database;
    final maps = await db.query(
      'game_results',
      orderBy: 'id DESC',
    );
    return maps.map((map) => GameResult.fromMap(map)).toList();
  }

  Future<int> deleteAllResults() async {
    final db = await instance.database;
    return await db.delete('game_results');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

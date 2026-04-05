import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        dueDate TEXT NOT NULL,
        isCompleted INTEGER DEFAULT 0,
        isRepeated INTEGER DEFAULT 0,
        repeatInterval TEXT DEFAULT 'none',
        notificationId INTEGER,
        reminderTime TEXT
      )
    ''');
    
    print("✅ Database created successfully!");
  }

  // CREATE - Add new task
  Future<int> createTask(Task task) async {
    final db = await database;
    try {
      int id = await db.insert('tasks', task.toMap());
      print("✅ Task added with ID: $id");
      return id;
    } catch (e) {
      print("❌ Error adding task: $e");
      return -1;
    }
  }

  // READ - Get all tasks
  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final result = await db.query('tasks', orderBy: 'dueDate ASC');
    return result.map((json) => Task.fromMap(json)).toList();
  }

  // READ - Get tasks by completion status
  Future<List<Task>> getTasksByStatus(bool isCompleted) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [isCompleted ? 1 : 0],
      orderBy: 'dueDate ASC',
    );
    print("📋 Found ${result.length} tasks (completed: $isCompleted)");
    return result.map((json) => Task.fromMap(json)).toList();
  }

  // READ - Get today's tasks
  Future<List<Task>> getTodayTasks() async {
    final db = await database;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await db.query(
      'tasks',
      where: 'dueDate BETWEEN ? AND ? AND isCompleted = 0',
      whereArgs: [startOfDay.toIso8601String(), endOfDay.toIso8601String()],
      orderBy: 'dueDate ASC',
    );
    print("📋 Today's tasks: ${result.length}");
    return result.map((json) => Task.fromMap(json)).toList();
  }

  // READ - Get repeated tasks
  Future<List<Task>> getRepeatedTasks() async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'isRepeated = 1 AND isCompleted = 0',
      orderBy: 'dueDate ASC',
    );
    print("🔄 Repeated tasks: ${result.length}");
    return result.map((json) => Task.fromMap(json)).toList();
  }

  // UPDATE - Update task
  Future<int> updateTask(Task task) async {
    final db = await database;
    try {
      int result = await db.update(
        'tasks',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      print("✏️ Task updated: ${task.title}");
      return result;
    } catch (e) {
      print("❌ Error updating task: $e");
      return 0;
    }
  }

  // UPDATE - Mark as completed
  Future<int> markAsCompleted(int id) async {
    final db = await database;
    try {
      int result = await db.update(
        'tasks',
        {'isCompleted': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
      print("✅ Task marked as completed: ID $id");
      return result;
    } catch (e) {
      print("❌ Error marking task: $e");
      return 0;
    }
  }

  // DELETE - Delete task
  Future<int> deleteTask(int id) async {
    final db = await database;
    try {
      int result = await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
      print("🗑️ Task deleted: ID $id");
      return result;
    } catch (e) {
      print("❌ Error deleting task: $e");
      return 0;
    }
  }
}
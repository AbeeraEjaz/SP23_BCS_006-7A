import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/task.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Task> _todayTasks = [];
  List<Task> _completedTasks = [];
  List<Task> _repeatedTasks = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAllTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ✅ UPDATED METHOD (DEBUG + SAFE)
  Future<void> _loadAllTasks() async {
    setState(() => _isLoading = true);

    try {
      final db = DatabaseHelper.instance;

      // 🔍 Debug print
      print("🔄 Loading tasks...");

      _todayTasks = await db.getTodayTasks();
      _completedTasks = await db.getTasksByStatus(true);
      _repeatedTasks = await db.getRepeatedTasks();

      print(
          "📊 Loaded: ${_todayTasks.length} today, ${_completedTasks.length} completed, ${_repeatedTasks.length} repeated");
    } catch (e) {
      print("❌ Error loading tasks: $e");
    }

    setState(() => _isLoading = false);
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    final db = DatabaseHelper.instance;

    if (task.isCompleted) {
      task.isCompleted = false;
      await db.updateTask(task);
    } else {
      await db.markAsCompleted(task.id!);
    }

    await _loadAllTasks();
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = DatabaseHelper.instance;
      await db.deleteTask(task.id!);
      await _loadAllTasks();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${task.title}" deleted')),
        );
      }
    }
  }

  void _navigateToAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const AddTaskScreen()),
    );

    if (result == true) {
      await _loadAllTasks();
    }
  }

  Widget _buildTaskList(List<Task> tasks, {bool showCheckbox = true}) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + button to add a task',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tasks.length,
      itemBuilder: (ctx, index) {
        final task = tasks[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: showCheckbox
                ? Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => _toggleTaskCompletion(task),
                    activeColor: Colors.green,
                  )
                : null,
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? Colors.grey : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style:
                        TextStyle(fontSize: 13, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM dd, yyyy • hh:mm a')
                          .format(task.dueDate),
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                    if (task.isRepeated) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.repeat,
                          size: 12, color: Colors.blue[400]),
                      const SizedBox(width: 4),
                      Text(
                        'Repeats: ${task.repeatInterval}',
                        style: TextStyle(
                            fontSize: 11, color: Colors.blue[400]),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => AddTaskScreen(task: task),
                      ),
                    );
                    if (result == true) {
                      await _loadAllTasks();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(task),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today\'s Tasks'),
            Tab(text: 'Completed'),
            Tab(text: 'Repeated'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(_todayTasks),
                _buildTaskList(_completedTasks, showCheckbox: false),
                _buildTaskList(_repeatedTasks),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
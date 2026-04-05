import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import '../database/database_helper.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = value;
    });
    await prefs.setBool('isDarkMode', value);
    
    // Rebuild the whole app to apply theme
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = value;
    });
    await prefs.setBool('notificationsEnabled', value);
  }

  Future<void> _exportTasksToCSV() async {
    setState(() => _isExporting = true);
    
    try {
      final db = DatabaseHelper.instance;
      final tasks = await db.getAllTasks();
      
      if (tasks.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No tasks to export!')),
        );
        setState(() => _isExporting = false);
        return;
      }
      
      // Prepare CSV data
      List<List<String>> csvData = [
        ['ID', 'Title', 'Description', 'Due Date', 'Completed', 'Repeated', 'Repeat Interval']
      ];
      
      for (var task in tasks) {
        csvData.add([
          task.id.toString(),
          task.title,
          task.description,
          task.dueDate.toIso8601String(),
          task.isCompleted.toString(),
          task.isRepeated.toString(),
          task.repeatInterval,
        ]);
      };
      
      // Convert to CSV string
      String csv = const ListToCsvConverter().convert(csvData);
      
      // Save to file
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Tasks Export',
        fileName: 'tasks_export_${DateTime.now().millisecondsSinceEpoch}.csv',
      );
      
      if (outputFile != null) {
        File file = File(outputFile);
        await file.writeAsString(csv);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Exported ${tasks.length} tasks to $outputFile')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
    
    setState(() => _isExporting = false);
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('Are you sure? This will delete ALL tasks permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final db = DatabaseHelper.instance;
      final tasks = await db.getAllTasks();
      for (var task in tasks) {
        await db.deleteTask(task.id!);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All tasks cleared!')),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          
          // Appearance Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Appearance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch between light and dark theme'),
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
              secondary: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Notifications Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Get reminders for upcoming tasks'),
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
              secondary: const Icon(Icons.notifications),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Data Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Data Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_file, color: Colors.green),
                  title: const Text('Export Tasks to CSV'),
                  subtitle: const Text('Save all tasks as CSV file'),
                  trailing: _isExporting 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.arrow_forward),
                  onTap: _exportTasksToCSV,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Clear All Data'),
                  subtitle: const Text('Delete all tasks permanently'),
                  trailing: const Icon(Icons.warning, color: Colors.red),
                  onTap: _clearAllData,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Info Section
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.info_outline, size: 32, color: Colors.blue),
                  const SizedBox(height: 8),
                  const Text(
                    'Task Manager App',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Manage your tasks efficiently',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
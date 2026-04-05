import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isRepeated = false;
  String _repeatInterval = 'daily';

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    if (widget.task != null) {
      _isEditing = true;
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
      _selectedTime = TimeOfDay.fromDateTime(widget.task!.dueDate);
      _isRepeated = widget.task!.isRepeated;
      _repeatInterval = widget.task!.repeatInterval;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  // ✅ UPDATED METHOD (FINAL)
  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    final dueDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // 🔍 Debug logs
    print("📝 Creating task:");
    print("   Title: ${_titleController.text.trim()}");
    print("   Due Date: $dueDateTime");
    print("   Repeated: $_isRepeated");

    final task = Task(
      id: widget.task?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: dueDateTime,
      isCompleted: widget.task?.isCompleted ?? false,
      isRepeated: _isRepeated,
      repeatInterval: _repeatInterval,
    );

    final db = DatabaseHelper.instance;

    if (_isEditing) {
      await db.updateTask(task);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task updated successfully!')),
        );
      }
    } else {
      int result = await db.createTask(task);

      print("📝 Database insert result: $result");

      if (result != -1 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully!')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error adding task!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Task' : 'Add New Task'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title *',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date *',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: _selectTime,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Time *',
                    prefixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(_selectedTime.format(context)),
                ),
              ),
              const SizedBox(height: 24),

              SwitchListTile(
                title: const Text('Repeat Task'),
                value: _isRepeated,
                onChanged: (val) => setState(() => _isRepeated = val),
              ),

              if (_isRepeated)
                DropdownButtonFormField<String>(
                  value: _repeatInterval,
                  items: ['daily', 'weekly', 'monthly']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _repeatInterval = val!),
                  decoration: const InputDecoration(
                    labelText: 'Repeat Interval',
                    border: OutlineInputBorder(),
                  ),
                ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  child: Text(
                    _isEditing ? 'UPDATE TASK' : 'ADD TASK',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Task {
  int? id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  bool isRepeated;
  String repeatInterval;
  int? notificationId;
  DateTime? reminderTime;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.isRepeated = false,
    this.repeatInterval = 'none',
    this.notificationId,
    this.reminderTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'isRepeated': isRepeated ? 1 : 0,
      'repeatInterval': repeatInterval,
      'notificationId': notificationId,
      'reminderTime': reminderTime?.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
      isRepeated: map['isRepeated'] == 1,
      repeatInterval: map['repeatInterval'],
      notificationId: map['notificationId'],
      reminderTime: map['reminderTime'] != null 
          ? DateTime.parse(map['reminderTime']) 
          : null,
    );
  }
}
class User {
  int? id;
  String name;
  String email;
  int age;
  String? imagePath; // Optional: for storing image path

  User({
    this.id,
    required this.name,
    required this.email,
    required this.age,
    this.imagePath,
  });

  // Convert User object to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'imagePath': imagePath,
    };
  }

  // Create User object from Map (database query result)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      age: map['age'],
      imagePath: map['imagePath'],
    );
  }
}
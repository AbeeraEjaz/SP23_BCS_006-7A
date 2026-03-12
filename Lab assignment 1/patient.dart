
class Patient {
  int? id;
  String name;
  String age;
  String disease;

  Patient({this.id, required this.name, required this.age, required this.disease});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'disease': disease,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      disease: map['disease'],
    );
  }
}

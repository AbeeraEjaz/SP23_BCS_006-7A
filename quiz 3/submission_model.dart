// lib/models/submission_model.dart

class SubmissionModel {
  final String? id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String gender;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubmissionModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
    this.createdAt,
    this.updatedAt,
  });

  // Convert from Supabase JSON response
  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'] as String?,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      gender: json['gender'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  // Convert to JSON for Supabase insert/update
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'gender': gender,
    };
  }

  // Copy with method for editing
  SubmissionModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? gender,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubmissionModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'SubmissionModel(id: $id, fullName: $fullName, email: $email)';
  }
}

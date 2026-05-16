// lib/screens/form_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/submission_model.dart';
import '../services/supabase_service.dart';

class FormScreen extends StatefulWidget {
  final SubmissionModel? existingSubmission; // null = Create, non-null = Update

  const FormScreen({super.key, this.existingSubmission});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedGender = 'Male';
  bool _isLoading = false;

  bool get _isEditing => widget.existingSubmission != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final s = widget.existingSubmission!;
      _nameController.text = s.fullName;
      _emailController.text = s.email;
      _phoneController.text = s.phone;
      _addressController.text = s.address;
      _selectedGender = s.gender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // ── Validators ─────────────────────────────────────────────────
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[a-z]{2,}$').hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 13) {
      return 'Enter a valid phone number (10–13 digits)';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if (value.trim().length < 10) {
      return 'Please enter a complete address (min 10 chars)';
    }
    return null;
  }

  // ── Submit / Update ─────────────────────────────────────────────
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final submission = SubmissionModel(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim().toLowerCase(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      gender: _selectedGender,
    );

    try {
      if (_isEditing) {
        await SupabaseService.updateSubmission(
            widget.existingSubmission!.id!, submission);
        if (mounted) {
          _showSnack('Record updated successfully!', Colors.green);
          Navigator.pop(context, true);
        }
      } else {
        await SupabaseService.createSubmission(submission);
        if (mounted) {
          _showSnack('Submission created successfully!', Colors.green);
          _clearForm();
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnack('Error: ${e.toString()}', Colors.red);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    setState(() => _selectedGender = 'Male');
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check_circle : Icons.error,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: Text(_isEditing ? 'Update Submission' : 'New Submission'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isEditing)
            TextButton(
              onPressed: _clearForm,
              child: const Text('Clear',
                  style: TextStyle(color: Colors.white70)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isEditing
                      ? const Color(0xFFFFF8E1)
                      : const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isEditing
                        ? const Color(0xFFFFCC02)
                        : const Color(0xFF81C784),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isEditing
                          ? Icons.edit_note_rounded
                          : Icons.note_add_rounded,
                      color: _isEditing
                          ? const Color(0xFFF57C00)
                          : const Color(0xFF388E3C),
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isEditing
                          ? 'Edit the fields you want to update'
                          : 'All fields are required. Please fill in your details.',
                      style: TextStyle(
                        fontSize: 13,
                        color: _isEditing
                            ? const Color(0xFF5D4037)
                            : const Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Full Name ─────────────────────────────────────
              _SectionLabel(label: 'Full Name', icon: Icons.person_outline),
              TextFormField(
                controller: _nameController,
                validator: _validateName,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Mehreen Yonus',
                  prefixIcon: Icon(Icons.person_outline, size: 20),
                ),
              ),
              const SizedBox(height: 20),

              // ── Email ─────────────────────────────────────────
              _SectionLabel(label: 'Email Address', icon: Icons.email_outlined),
              TextFormField(
                controller: _emailController,
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'e.g. student@comsats.edu.pk',
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 20),

              // ── Phone ─────────────────────────────────────────
              _SectionLabel(
                  label: 'Phone Number', icon: Icons.phone_outlined),
              TextFormField(
                controller: _phoneController,
                validator: _validatePhone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s]')),
                ],
                decoration: const InputDecoration(
                  hintText: 'e.g. 0300-1234567',
                  prefixIcon: Icon(Icons.phone_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 20),

              // ── Address ───────────────────────────────────────
              _SectionLabel(label: 'Address', icon: Icons.home_outlined),
              TextFormField(
                controller: _addressController,
                validator: _validateAddress,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText:
                      'e.g. House 12, Street 5, F-8 Markaz, Islamabad',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.home_outlined, size: 20),
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),

              // ── Gender ────────────────────────────────────────
              _SectionLabel(
                  label: 'Gender', icon: Icons.wc_rounded),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select your gender:',
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Male', 'Female', 'Other'].map((gender) {
                        final isSelected = _selectedGender == gender;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedGender = gender),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: EdgeInsets.only(
                                  right: gender != 'Other' ? 8 : 0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF3F51B5)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF3F51B5)
                                      : Colors.grey.shade300,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF3F51B5)
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    gender == 'Male'
                                        ? Icons.male_rounded
                                        : gender == 'Female'
                                            ? Icons.female_rounded
                                            : Icons.transgender_rounded,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    gender,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Submit Button ─────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEditing
                        ? const Color(0xFFF57C00)
                        : const Color(0xFF3F51B5),
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_isEditing
                                ? Icons.save_rounded
                                : Icons.cloud_upload_rounded),
                            const SizedBox(width: 8),
                            Text(_isEditing
                                ? 'Save Changes'
                                : 'Submit to Supabase'),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF3F51B5)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const Text(' *', style: TextStyle(color: Colors.red, fontSize: 14)),
        ],
      ),
    );
  }
}

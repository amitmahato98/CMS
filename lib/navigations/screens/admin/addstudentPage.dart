import 'dart:math';
import 'package:flutter/material.dart';

class addstudentPage extends StatefulWidget {
  const addstudentPage({Key? key}) : super(key: key);

  @override
  State<addstudentPage> createState() => _addstudentPageState();
}

class _addstudentPageState extends State<addstudentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedGender = 'Male';
  DateTime _selectedDOB = DateTime.now().subtract(
    const Duration(days: 365 * 18),
  ); // Default 18 years old
  String _selectedProgram = 'BSc.CSIT';

  final List<String> _programs = [
    'BSc.CSIT',
    'BIT',
    'BTECH',
    'Physics',
    'Nutrition',
  ];

  bool _isLoading = false;

  String get _generatedStudentId =>
      'STU${DateTime.now().year}${1000 + Random().nextInt(9000)}';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      final studentData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'gender': _selectedGender,
        'dateOfBirth': _selectedDOB.toIso8601String(),
        'program': _selectedProgram,
        'studentId': _generatedStudentId,
      };

      await Future.delayed(const Duration(seconds: 2)); // Simulate delay

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(studentData);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add student. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Student'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration('Full Name', Icons.person),
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Please enter student name'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      // Gender
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: _inputDecoration('Gender', Icons.people),
                        items:
                            ['Male', 'Female', 'Other'].map((gender) {
                              return DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null)
                            setState(() => _selectedGender = value);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date of Birth
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDOB,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null)
                            setState(() => _selectedDOB = picked);
                        },
                        child: InputDecorator(
                          decoration: _inputDecoration(
                            'Date of Birth',
                            Icons.calendar_today,
                          ),
                          child: Text(
                            '${_selectedDOB.day}/${_selectedDOB.month}/${_selectedDOB.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration(
                          'Email Address',
                          Icons.email,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter email address';
                          } else if (!RegExp(
                            r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone
                      TextFormField(
                        controller: _phoneController,
                        decoration: _inputDecoration(
                          'Phone Number',
                          Icons.phone,
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter phone number';
                          } else if (!RegExp(r'^\d{7,15}$').hasMatch(value)) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Address
                      TextFormField(
                        controller: _addressController,
                        decoration: _inputDecoration(
                          'Full Address',
                          Icons.home,
                        ),
                        maxLines: 2,
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Please enter address'
                                    : null,
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Academic Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Program
                      DropdownButtonFormField<String>(
                        value: _selectedProgram,
                        decoration: _inputDecoration('Program', Icons.school),
                        items:
                            _programs.map((program) {
                              return DropdownMenuItem(
                                value: program,
                                child: Text(program),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null)
                            setState(() => _selectedProgram = value);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Student ID (auto-generated, disabled)
                      TextFormField(
                        decoration: _inputDecoration(
                          'Student ID (Auto-generated)',
                          Icons.badge,
                        ),
                        enabled: false,
                        initialValue: _generatedStudentId,
                      ),
                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _submitForm,
                          child: const Text(
                            'Add Student',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

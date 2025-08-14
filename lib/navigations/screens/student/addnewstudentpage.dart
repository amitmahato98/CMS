import 'dart:math';
import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/material.dart';

class AddNewStudentPage extends StatefulWidget {
  final Map<String, dynamic>? studentData;

  const AddNewStudentPage({Key? key, this.studentData}) : super(key: key);

  @override
  State<AddNewStudentPage> createState() => _AddNewStudentPageState();
}

class _AddNewStudentPageState extends State<AddNewStudentPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedGender = 'Male';
  DateTime _selectedDOB = DateTime.now().subtract(
    const Duration(days: 365 * 18),
  );
  String _selectedProgram = 'BSc.CSIT';
  String _studentId = '';

  final List<String> _programs = ['BSc.CSIT', 'BIT'];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.studentData != null) {
      final data = widget.studentData!;
      _nameController.text = data['name'];
      _emailController.text = data['email'];
      _phoneController.text = data['phone'];
      _addressController.text = data['address'];
      _selectedGender = data['gender'];
      _selectedProgram = data['program'];
      _selectedDOB = DateTime.tryParse(data['dateOfBirth']) ?? _selectedDOB;
      _studentId = data['studentId'];
    } else {
      _studentId = 'STU${DateTime.now().year}${1000 + Random().nextInt(9000)}';
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
        'studentId': _studentId,
      };

      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Navigator.of(context).pop(studentData);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    String? prefixText,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: blueColor),
      prefixIcon: Icon(icon, color: blueColor),
      prefixText: prefixText,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: blueColor, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: blueColor, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.studentData == null ? 'Add Student' : 'Edit Student',
        ),
        backgroundColor: blueColor,
        foregroundColor: whiteColor,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: blueColor,
                        controller: _nameController,
                        decoration: _inputDecoration('Full Name', Icons.person),
                        validator:
                            (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Enter name'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: _inputDecoration('Gender', Icons.people),
                        items:
                            ['Male', 'Female', 'Other']
                                .map(
                                  (g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(() => _selectedGender = v!),
                      ),
                      const SizedBox(height: 16),

                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDOB,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _selectedDOB = picked);
                          }
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

                      TextFormField(
                        controller: _emailController,
                        cursorColor: blueColor,
                        decoration: _inputDecoration(
                          'Email Address',
                          Icons.email,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter email';
                          }
                          final regex = RegExp(
                            r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          return regex.hasMatch(value) ? null : 'Invalid email';
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _phoneController,
                        cursorColor: blueColor,
                        decoration: _inputDecoration(
                          'Phone Number',
                          Icons.phone,
                          prefixText: '+977 ',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter phone number';
                          }
                          final phone = value.trim();
                          if (!RegExp(r'^(97|98)\d{8}$').hasMatch(phone)) {
                            return 'Must start with 97 or 98 and be 10 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _addressController,
                        cursorColor: blueColor,
                        decoration: _inputDecoration('Address', Icons.home),
                        maxLines: 2,
                        validator:
                            (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Enter address'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _selectedProgram,
                        decoration: _inputDecoration('Program', Icons.school),
                        items:
                            _programs
                                .map(
                                  (p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(p),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(() => _selectedProgram = v!),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        decoration: _inputDecoration('Student ID', Icons.badge),
                        enabled: false,
                        initialValue: _studentId,
                      ),
                      const SizedBox(height: 32),

                      Center(
                        child: ElevatedButton.icon(
                          icon: Icon(
                            widget.studentData == null ? Icons.add : Icons.save,
                            color: whiteColor,
                          ),
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blueColor,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          label: Text(
                            widget.studentData == null
                                ? 'Add Student'
                                : 'Save Changes',
                            style: const TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                            ),
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

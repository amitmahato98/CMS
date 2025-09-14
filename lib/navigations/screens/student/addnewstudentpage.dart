import 'dart:math';
import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as nepali_picker;
import 'package:nepali_utils/nepali_utils.dart';

class AddNewStudentPage extends StatefulWidget {
  final Map<String, dynamic>? studentData;

  const AddNewStudentPage({Key? key, this.studentData}) : super(key: key);

  @override
  State<AddNewStudentPage> createState() => _AddNewStudentPageState();
}

class _AddNewStudentPageState extends State<AddNewStudentPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _fatherController = TextEditingController();
  final _regNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _rollController = TextEditingController();
  final _batchController = TextEditingController();

  String _selectedGender = 'Male';
  NepaliDateTime _selectedDOB = NepaliDateTime.now().subtract(
    const Duration(days: 365 * 20),
  );
  String _selectedProgram = 'BSc.CSIT';
  String _studentId = '';

  final List<String> _programs = ['BSc.CSIT', 'BIT'];

  bool _isLoading = false;
  String? _rollError;

  @override
  void initState() {
    super.initState();
    if (widget.studentData != null) {
      final data = widget.studentData!;
      _nameController.text = data['name'];
      _fatherController.text = data['fatherFullName'] ?? '';
      _regNoController.text = data['registrationNumber'] ?? '';
      _emailController.text = data['email'];
      _phoneController.text = data['phone'];
      _addressController.text = data['address'];
      _rollController.text = data['rollNumber'] ?? '';
      _batchController.text = data['batch'] ?? '';
      _selectedGender = data['gender'];
      _selectedProgram = data['program'];
      try {
        if (data['dateOfBirth'] != null &&
            data['dateOfBirth'].toString().isNotEmpty) {
          _selectedDOB = NepaliDateTime.parse(data['dateOfBirth']);
        }
      } catch (_) {}
      _studentId = data['studentId'];
    } else {
      _studentId = 'STU${DateTime.now().year}${1000 + Random().nextInt(9000)}';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherController.dispose();
    _regNoController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _rollController.dispose();
    _batchController.dispose();
    super.dispose();
  }

  // Title Case
  String _toTitleCase(String input) {
    return input
        .split(' ')
        .where((e) => e.trim().isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  // Address formatting
  String _formatAddress(String input) => _toTitleCase(input);

  // Father's name validation
  String? _validateFatherName(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Enter father\'s full name';
    final parts = value.trim().split(' ');
    if (parts.length < 2) return 'Enter first and last name';
    return null;
  }

  // Registration number validation
  String? _validateRegNo(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Enter registration number';
    final regExp = RegExp(r'^(?!-)(?!.*--)(?!.*-$)[0-9-]+$');
    if (!regExp.hasMatch(value.trim())) {
      return 'Invalid format (e.g. 59-56-564-454)';
    }
    return null;
  }

  // Roll validation
  String? _validateRoll(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter roll number';
    final roll = value.trim();

    if (!RegExp(r'^\d+$').hasMatch(roll)) return 'Roll must be digits only';
    if (roll.length < 7) return 'Invalid roll format';

    final prefix = int.tryParse(roll.substring(0, 2));
    if (prefix == null || prefix < 60 || prefix > 99) {
      return 'Roll must start with 60–99';
    }

    final batchYear = int.tryParse(_batchController.text.trim());
    if (batchYear == null) return 'Enter valid batch year first';

    // Check if first 2 digits match last 2 digits of batch
    final batchPrefix = batchYear % 100;
    if (prefix != batchPrefix) {
      return 'Roll prefix does not match batch year';
    }

    // CSIT: XX011XXX
    if (_selectedProgram == 'BSc.CSIT') {
      if (!RegExp(r'^(?:6[0-9]|[7-9][0-9])011\d{3}$').hasMatch(roll)) {
        return 'Invalid CSIT roll (format: XX011XXX)';
      }
    }

    // BIT: XX022XXX
    if (_selectedProgram == 'BIT') {
      if (!RegExp(r'^(?:6[0-9]|[7-9][0-9])022\d{3}$').hasMatch(roll)) {
        return 'Invalid BIT roll (format: XX022XXX)';
      }
    }

    return null;
  }

  // Batch validation
  String? _validateBatch(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter batch year';
    if (!RegExp(r'^\d{4}$').hasMatch(value.trim()))
      return 'Batch must be exactly 4 digits';
    final year = int.tryParse(value.trim());
    if (year == null || year < 2070 || year > 2099)
      return 'Batch must be between 2070–2099';
    return null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isLoading = true;
        _rollError = null;
      });

      final roll = _rollController.text.trim();
      final existing =
          await FirebaseFirestore.instance
              .collection('students')
              .where('rollNumber', isEqualTo: roll)
              .get();

      if (existing.docs.isNotEmpty &&
          (widget.studentData == null ||
              widget.studentData!['rollNumber'] != roll)) {
        setState(() {
          _rollError = 'Roll number already exists';
          _isLoading = false;
        });
        return;
      }

      final studentData = {
        'name': _toTitleCase(_nameController.text.trim()),
        'fatherFullName': _toTitleCase(_fatherController.text.trim()),
        'registrationNumber': _regNoController.text.trim(),
        'email': _emailController.text.trim().toLowerCase(),
        'phone': _phoneController.text.trim(),
        'address': _formatAddress(_addressController.text.trim()),
        'gender': _selectedGender,
        'dateOfBirth': NepaliDateFormat("yyyy-MM-dd").format(_selectedDOB),
        'program': _selectedProgram,
        'studentId': _studentId,
        'rollNumber': roll,
        'batch': _batchController.text.trim(),
      };

      await FirebaseFirestore.instance
          .collection('students')
          .doc(_studentId)
          .set(studentData);

      if (!mounted) return;
      Navigator.of(context).pop(studentData);
    } catch (e, st) {
      debugPrint('Firestore set error: $e\n$st');
      String message =
          e.toString().contains('permission-denied')
              ? 'Permission denied: check Firestore rules.'
              : 'Something went wrong.';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
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

                      TextFormField(
                        cursorColor: blueColor,
                        controller: _fatherController,
                        decoration: _inputDecoration(
                          'Father\'s Full Name',
                          Icons.person,
                        ),
                        validator: _validateFatherName,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        cursorColor: blueColor,
                        controller: _regNoController,
                        decoration: _inputDecoration(
                          'Registration Number',
                          Icons.confirmation_number,
                        ),
                        validator: _validateRegNo,
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
                          final picked = await nepali_picker
                              .showAdaptiveDatePicker(
                                context: context,
                                initialDate: _selectedDOB,
                                firstDate: NepaliDateTime(2000),
                                lastDate: NepaliDateTime.now(),
                              );
                          if (picked != null)
                            setState(() => _selectedDOB = picked);
                        },
                        child: InputDecorator(
                          decoration: _inputDecoration(
                            'Date of Birth (Nepali)',
                            Icons.calendar_today,
                          ),
                          child: Text(
                            NepaliDateFormat('yyyy-MM-dd').format(_selectedDOB),
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
                          if (value == null || value.trim().isEmpty)
                            return 'Enter email';
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
                          if (value == null || value.trim().isEmpty)
                            return 'Enter phone number';
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
                        controller: _batchController,
                        cursorColor: blueColor,
                        decoration: _inputDecoration(
                          'Batch Year',
                          Icons.date_range,
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validateBatch,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _rollController,
                        cursorColor: blueColor,
                        decoration: _inputDecoration(
                          'Roll Number',
                          Icons.confirmation_number,
                        ),
                        validator: _validateRoll,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        decoration: _inputDecoration('Student ID', Icons.badge),
                        enabled: false,
                        initialValue: _studentId,
                      ),
                      const SizedBox(height: 32),

                      Center(
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(
                                widget.studentData == null
                                    ? Icons.add
                                    : Icons.save,
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
                            if (_rollError != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _rollError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

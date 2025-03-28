import 'dart:math';
import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/material.dart';

class AddNewTeacherPage extends StatefulWidget {
  const AddNewTeacherPage({Key? key}) : super(key: key);

  @override
  _AddNewTeacherPageState createState() => _AddNewTeacherPageState();
}

class _AddNewTeacherPageState extends State<AddNewTeacherPage> {
  final _formKey = GlobalKey<FormState>();

  // Personal Information Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  // Professional Information Controllers
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _joiningDateController = TextEditingController();

  // Dropdown and Selection Variables
  String _selectedGender = 'Male';
  String _selectedDepartment = 'Computer Science';
  String _selectedDesignation = 'Assistant Professor';
  DateTime _selectedDOB = DateTime.now().subtract(
    const Duration(days: 365 * 30),
  );
  DateTime _selectedJoiningDate = DateTime.now();

  // Dropdown Lists
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _departments = [
    'Computer Science',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
  ];
  final List<String> _designations = [
    'Assistant Professor',
    'Associate Professor',
    'Professor',
    'Senior Lecturer',
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose all controllers
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _aadharController.dispose();
    _dobController.dispose();
    _qualificationController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _joiningDateController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() {
          _isLoading = true;
        });

        // Create teacher data to return
        final teacherData = {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'aadharNumber': _aadharController.text,
          'gender': _selectedGender,
          'dateOfBirth': _selectedDOB,
          'department': _selectedDepartment,
          'designation': _selectedDesignation,
          'qualification': _qualificationController.text,
          'specialization': _specializationController.text,
          'experience': _experienceController.text,
          'joiningDate': _selectedJoiningDate,
          'teacherId':
              'TCH${DateTime.now().year}${1000 + Random().nextInt(9000)}',
        };

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Teacher added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Return data to previous screen
        Navigator.of(context).pop(teacherData);
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add teacher. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Teacher'),
        backgroundColor: blueColor,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Teacher Photo Upload Section
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[200],
                              child: const Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.grey,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 20,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    // Photo upload functionality
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Personal Information Section
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Full Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter teacher name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Gender Selection
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: const Icon(Icons.people),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items:
                            _genders.map((gender) {
                              return DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedGender = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date of Birth
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDOB,
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null && picked != _selectedDOB) {
                            setState(() {
                              _selectedDOB = picked;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            '${_selectedDOB.day}/${_selectedDOB.month}/${_selectedDOB.year}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Aadhar Number
                      TextFormField(
                        controller: _aadharController,
                        decoration: InputDecoration(
                          labelText: 'Aadhar Number',
                          prefixIcon: const Icon(Icons.credit_card),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Aadhar number';
                          }
                          if (value.length != 12) {
                            return 'Aadhar number must be 12 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email address';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (value.length != 10) {
                            return 'Phone number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Address
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          prefixIcon: const Icon(Icons.home),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Professional Information Section
                      const Text(
                        'Professional Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Department Selection
                      DropdownButtonFormField<String>(
                        value: _selectedDepartment,
                        decoration: InputDecoration(
                          labelText: 'Department',
                          prefixIcon: const Icon(Icons.account_balance),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items:
                            _departments.map((department) {
                              return DropdownMenuItem(
                                value: department,
                                child: Text(department),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedDepartment = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Designation Selection
                      DropdownButtonFormField<String>(
                        value: _selectedDesignation,
                        decoration: InputDecoration(
                          labelText: 'Designation',
                          prefixIcon: const Icon(Icons.work),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items:
                            _designations.map((designation) {
                              return DropdownMenuItem(
                                value: designation,
                                child: Text(designation),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedDesignation = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Qualification
                      TextFormField(
                        controller: _qualificationController,
                        decoration: InputDecoration(
                          labelText: 'Highest Qualification',
                          prefixIcon: const Icon(Icons.school),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter highest qualification';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Specialization
                      TextFormField(
                        controller: _specializationController,
                        decoration: InputDecoration(
                          labelText: 'Specialization',
                          prefixIcon: const Icon(Icons.bookmark),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Years of Experience
                      TextFormField(
                        controller: _experienceController,
                        decoration: InputDecoration(
                          labelText: 'Years of Experience',
                          prefixIcon: const Icon(Icons.timer),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter years of experience';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Joining Date
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedJoiningDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null &&
                              picked != _selectedJoiningDate) {
                            setState(() {
                              _selectedJoiningDate = picked;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Joining Date',
                            prefixIcon: const Icon(Icons.calendar_month),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            '${_selectedJoiningDate.day}/${_selectedJoiningDate.month}/${_selectedJoiningDate.year}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Teacher ID (Auto generated)
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Teacher ID (Auto-generated)',
                          prefixIcon: const Icon(Icons.badge),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        enabled: false,
                        initialValue:
                            'TCH${DateTime.now().year}${1000 + Random().nextInt(9000)}',
                      ),
                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _submitForm,
                          child: const Text(
                            'Add Teacher',
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
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:cms/theme/theme_provider.dart';

class FormFillUp extends StatefulWidget {
  const FormFillUp({Key? key}) : super(key: key);

  @override
  _FormFillUpState createState() => _FormFillUpState();
}

class _FormFillUpState extends State<FormFillUp> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _institutionController = TextEditingController();
  final _gpaController = TextEditingController();
  final _experienceController = TextEditingController();
  final _specialityController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();

  // Form Data
  String? _selectedRole;
  DateTime? _dateOfBirth;
  String? _selectedGender;
  String? _selectedBloodGroup;
  String? _selectedNationality;
  String? _selectedCountry;
  String? _selectedProgram;
  String? _selectedCourseType;
  String? _selectedCourse;
  int? _selectedDuration;
  int? _selectedYear;
  int? _selectedSemester;
  bool _hasScholarship = false;
  bool _hasAccommodation = false;
  bool _hasMedicalCondition = false;
  String? _selectedPaymentMethod;
  File? _profileImage;
  File? _idProof;
  File? _transcripts;
  File? _certificates;

  // Lists for dropdown menus
  final List<String> _roles = ['Student', 'Teacher'];
  final List<String> _genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  final List<String> _countries = [
    'USA',
    'Nepal',
    'India',
    'UK',
    'Canada',
    'Australia',
    'India',
    'China',
    'Japan',
    'Germany',
    'France',
    'Other',
  ];
  final List<String> _nationalities = [
    'American',
    'Nepalese',
    'British',
    'Canadian',
    'Australian',
    'Indian',
    'Chinese',
    'Japanese',
    'German',
    'French',
    'Other',
  ];
  final List<String> _programs = [
    'Undergraduate',
    'Postgraduate',
    'Doctorate',
    'Certificate',
    'Diploma',
  ];
  final List<String> _courseTypes = ['Year-wise', 'Semester-wise'];
  final Map<String, List<String>> _yearWiseCourses = {
    'Undergraduate': [
      'B.Tech',
      'B.Arch',
      'B.Physics',
      'B.Chemistry',
      'B.Mathematics',
    ],
    'Postgraduate': [
      'M.Tech',
      'M.Arch',
      'M.Physics',
      'M.Chemistry',
      'M.Mathematics',
    ],
    'Doctorate': ['Ph.D Engineering', 'Ph.D Sciences', 'Ph.D Arts'],
    'Certificate': [
      'Engineering Certificate',
      'Science Certificate',
      'Arts Certificate',
    ],
    'Diploma': ['Engineering Diploma', 'Science Diploma', 'Arts Diploma'],
  };
  final Map<String, List<String>> _semesterWiseCourses = {
    'Undergraduate': ['BSc.CSIT', 'BIT', 'BCA', 'Nutrition', 'BBA'],
    'Postgraduate': ['MSc.CSIT', 'MIT', 'MCA', 'Nutrition Sciences', 'MBA'],
    'Doctorate': [
      'Ph.D Computer Science',
      'Ph.D Information Technology',
      'Ph.D Business',
    ],
    'Certificate': [
      'IT Certificate',
      'Business Certificate',
      'Health Sciences Certificate',
    ],
    'Diploma': ['IT Diploma', 'Business Diploma', 'Health Sciences Diploma'],
  };
  final List<int> _yearOptions = [1, 2, 3, 4];
  final List<int> _semesterOptions = [1, 2, 3, 4, 5, 6, 7, 8];
  final List<String> _paymentMethods = [
    'Credit/Debit Card',
    'Bank Transfer',
    'PayPal',
    'Scholarship',
    'Cash',
  ];

  bool _isSubmitting = false;
  bool _showTeacherFields = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _qualificationController.dispose();
    _institutionController.dispose();
    _gpaController.dispose();
    _experienceController.dispose();
    _specialityController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _dateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(data: Theme.of(context), child: child!);
      },
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _profileImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickDocument(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        switch (type) {
          case 'id':
            _idProof = File(result.files.single.path!);
            break;
          case 'transcripts':
            _transcripts = File(result.files.single.path!);
            break;
          case 'certificates':
            _certificates = File(result.files.single.path!);
            break;
        }
      });
    }
  }

  void _updateCourseType(String? value) {
    setState(() {
      _selectedCourseType = value;
      _selectedCourse = null;
      _selectedYear = null;
      _selectedSemester = null;
    });
  }

  void _updateProgram(String? value) {
    setState(() {
      _selectedProgram = value;
      _selectedCourse = null;
    });
  }

  void _updateRole(String? value) {
    setState(() {
      _selectedRole = value;
      _showTeacherFields = value == 'Teacher';
    });
  }

  List<String> _getCurrentCourseList() {
    if (_selectedProgram == null || _selectedCourseType == null) return [];

    if (_selectedCourseType == 'Year-wise') {
      return _yearWiseCourses[_selectedProgram] ?? [];
    } else {
      return _semesterWiseCourses[_selectedProgram] ?? [];
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isSubmitting = false;
      });

      // Show success dialog
      if (mounted) {
        _showSuccessDialog();
      }
    } else {
      // Scroll to the first error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Application Submitted!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Your application has been submitted successfully. You will receive a confirmation email at ${_emailController.text}.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Application ID: APP-${DateTime.now().millisecondsSinceEpoch.toString().substring(4, 12)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetForm();
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _addressController.clear();
      _cityController.clear();
      _stateController.clear();
      _zipController.clear();
      _qualificationController.clear();
      _institutionController.clear();
      _gpaController.clear();
      _experienceController.clear();
      _specialityController.clear();
      _emergencyContactNameController.clear();
      _emergencyContactPhoneController.clear();

      _selectedRole = null;
      _dateOfBirth = null;
      _selectedGender = null;
      _selectedBloodGroup = null;
      _selectedNationality = null;
      _selectedCountry = null;
      _selectedProgram = null;
      _selectedCourseType = null;
      _selectedCourse = null;
      _selectedDuration = null;
      _selectedYear = null;
      _selectedSemester = null;
      _hasScholarship = false;
      _hasAccommodation = false;
      _hasMedicalCondition = false;
      _selectedPaymentMethod = null;
      _profileImage = null;
      _idProof = null;
      _transcripts = null;
      _certificates = null;
      _showTeacherFields = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
        centerTitle: true,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            radius: const Radius.circular(10),
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.school_rounded,
                            size: 48,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'College Application',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Fill in the form below to apply',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Role selection
                    SectionHeader(title: 'Select Role'),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'I am applying as a:',
                              style: theme.textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children:
                                  _roles.map((role) {
                                    return Expanded(
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () => _updateRole(role),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                _selectedRole == role
                                                    ? theme.colorScheme.primary
                                                    : theme.colorScheme.surface,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color:
                                                  _selectedRole == role
                                                      ? theme
                                                          .colorScheme
                                                          .primary
                                                      : theme.dividerColor,
                                              width: 1,
                                            ),
                                            boxShadow:
                                                _selectedRole == role
                                                    ? [
                                                      BoxShadow(
                                                        color: theme
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(0.3),
                                                        spreadRadius: 1,
                                                        blurRadius: 5,
                                                        offset: const Offset(
                                                          0,
                                                          2,
                                                        ),
                                                      ),
                                                    ]
                                                    : null,
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                role == 'Student'
                                                    ? Icons.person
                                                    : Icons.person_2,
                                                size: 32,
                                                color:
                                                    _selectedRole == role
                                                        ? theme
                                                            .colorScheme
                                                            .onPrimary
                                                        : theme
                                                            .colorScheme
                                                            .primary,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                role,
                                                style: theme
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      color:
                                                          _selectedRole == role
                                                              ? theme
                                                                  .colorScheme
                                                                  .onPrimary
                                                              : theme
                                                                  .colorScheme
                                                                  .onSurface,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                            if (_selectedRole == null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Please select a role',
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Personal Information
                    SectionHeader(title: 'Personal Information'),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Image Picker
                            Center(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: _pickImage,
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surface,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: theme.colorScheme.primary,
                                          width: 2,
                                        ),
                                        image:
                                            _profileImage != null
                                                ? DecorationImage(
                                                  image: FileImage(
                                                    _profileImage!,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )
                                                : null,
                                      ),
                                      child:
                                          _profileImage == null
                                              ? Icon(
                                                Icons.add_a_photo,
                                                size: 40,
                                                color:
                                                    theme.colorScheme.primary,
                                              )
                                              : null,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Profile Photo',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  Text(
                                    '(Required)',
                                    style: TextStyle(
                                      color: theme.colorScheme.error,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Full Name
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Date of Birth
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Date of Birth',
                                    prefixIcon: const Icon(
                                      Icons.calendar_today,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  controller: TextEditingController(
                                    text:
                                        _dateOfBirth != null
                                            ? DateFormat(
                                              'dd MMM yyyy',
                                            ).format(_dateOfBirth!)
                                            : '',
                                  ),
                                  validator: (value) {
                                    if (_dateOfBirth == null) {
                                      return 'Please select your date of birth';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Gender
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                prefixIcon: const Icon(Icons.people_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your gender';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Blood Group
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Blood Group',
                                prefixIcon: const Icon(
                                  Icons.bloodtype_outlined,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items:
                                  _bloodGroups.map((bloodGroup) {
                                    return DropdownMenuItem(
                                      value: bloodGroup,
                                      child: Text(bloodGroup),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedBloodGroup = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your blood group';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Nationality
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Nationality',
                                prefixIcon: const Icon(Icons.flag_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items:
                                  _nationalities.map((nationality) {
                                    return DropdownMenuItem(
                                      value: nationality,
                                      child: Text(nationality),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedNationality = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your nationality';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Contact Information
                    SectionHeader(title: 'Contact Information'),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address';
                                } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Phone Number
                            TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                prefixIcon: const Icon(Icons.phone_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                  return 'Enter Correct Number';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Address
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                labelText: 'Address Line',
                                prefixIcon: const Icon(Icons.home_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your address';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // City & State
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _cityController,
                                    decoration: InputDecoration(
                                      labelText: 'City',
                                      prefixIcon: const Icon(
                                        Icons.location_city_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _stateController,
                                    decoration: InputDecoration(
                                      labelText: 'State/Province',
                                      prefixIcon: const Icon(
                                        Icons.map_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Postal Code & Country
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _zipController,
                                    decoration: InputDecoration(
                                      labelText: 'Postal/ZIP Code',
                                      prefixIcon: const Icon(
                                        Icons.markunread_mailbox_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Country',
                                      prefixIcon: const Icon(
                                        Icons.public_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    items:
                                        _countries.map((country) {
                                          return DropdownMenuItem(
                                            value: country,
                                            child: Text(country),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCountry = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Emergency Contact Information
                            Text(
                              'Emergency Contact Information',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _emergencyContactNameController,
                              decoration: InputDecoration(
                                labelText: 'Emergency Contact Name',
                                prefixIcon: const Icon(
                                  Icons.contact_emergency_outlined,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                  return 'Enter Correct number';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _emergencyContactPhoneController,
                              decoration: InputDecoration(
                                labelText: 'Emergency Contact Phone',
                                prefixIcon: const Icon(Icons.phone_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter emergency contact phone';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Education Information
                    SectionHeader(title: 'Education Details'),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Program Type
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Program Type',
                                prefixIcon: const Icon(Icons.school_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items:
                                  _programs.map((program) {
                                    return DropdownMenuItem(
                                      value: program,
                                      child: Text(program),
                                    );
                                  }).toList(),
                              onChanged: (value) => _updateProgram(value),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a program type';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Course Type
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Course Structure',
                                prefixIcon: const Icon(
                                  Icons.view_timeline_outlined,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items:
                                  _courseTypes.map((type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                              onChanged: (value) => _updateCourseType(value),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a course structure';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Course Selection (depends on program and course type)
                            if (_selectedProgram != null &&
                                _selectedCourseType != null)
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Course',
                                  prefixIcon: const Icon(Icons.book_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items:
                                    _getCurrentCourseList().map((course) {
                                      return DropdownMenuItem(
                                        value: course,
                                        child: Text(course),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCourse = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a course';
                                  }
                                  return null;
                                },
                              ),

                            if (_selectedCourseType == 'Year-wise' &&
                                _selectedCourse != null)
                              Column(
                                children: [
                                  const SizedBox(height: 16),
                                  DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      labelText: 'Year',
                                      prefixIcon: const Icon(
                                        Icons.calendar_view_month_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    items:
                                        _yearOptions.map((year) {
                                          return DropdownMenuItem(
                                            value: year,
                                            child: Text('Year $year'),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedYear = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select a year';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),

                            if (_selectedCourseType == 'Semester-wise' &&
                                _selectedCourse != null)
                              Column(
                                children: [
                                  const SizedBox(height: 16),
                                  DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      labelText: 'Semester',
                                      prefixIcon: const Icon(
                                        Icons.calendar_view_month_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    items:
                                        _semesterOptions.map((semester) {
                                          return DropdownMenuItem(
                                            value: semester,
                                            child: Text('Semester $semester'),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSemester = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select a semester';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),

                            const SizedBox(height: 16),

                            // Previous Education
                            Text(
                              'Previous Education',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _qualificationController,
                              decoration: InputDecoration(
                                labelText: 'Highest Qualification',
                                prefixIcon: const Icon(Icons.school_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your highest qualification';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _institutionController,
                              decoration: InputDecoration(
                                labelText: 'Institution Name',
                                prefixIcon: const Icon(
                                  Icons.account_balance_outlined,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your previous institution';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _gpaController,
                              decoration: InputDecoration(
                                labelText: 'GPA/Percentage',
                                prefixIcon: const Icon(Icons.grade_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your GPA or percentage';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Teacher Specific Fields
                    if (_showTeacherFields) ...[
                      SectionHeader(title: 'Teaching Information'),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _experienceController,
                                decoration: InputDecoration(
                                  labelText: 'Teaching Experience (Years)',
                                  prefixIcon: const Icon(Icons.work_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (_showTeacherFields &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter your teaching experience';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              TextFormField(
                                controller: _specialityController,
                                decoration: InputDecoration(
                                  labelText: 'Specialization/Subjects',
                                  prefixIcon: const Icon(Icons.star_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (_showTeacherFields &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter your specialization';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],

                    // Additional Information
                    SectionHeader(title: 'Additional Information'),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Accommodation
                            SwitchListTile(
                              title: Text(
                                'Do you need accommodation?',
                                style: theme.textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                'Toggle if you need college hostel accommodation',
                                style: theme.textTheme.bodySmall,
                              ),
                              value: _hasAccommodation,
                              onChanged: (value) {
                                setState(() {
                                  _hasAccommodation = value;
                                });
                              },
                              secondary: Icon(
                                Icons.home_outlined,
                                color: theme.colorScheme.primary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: theme.dividerColor,
                                  width: 1,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Scholarship
                            SwitchListTile(
                              title: Text(
                                'Are you applying for a scholarship?',
                                style: theme.textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                'Toggle if you want to apply for a scholarship',
                                style: theme.textTheme.bodySmall,
                              ),
                              value: _hasScholarship,
                              onChanged: (value) {
                                setState(() {
                                  _hasScholarship = value;
                                });
                              },
                              secondary: Icon(
                                Icons.school_outlined,
                                color: theme.colorScheme.primary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: theme.dividerColor,
                                  width: 1,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Medical Condition
                            SwitchListTile(
                              title: Text(
                                'Do you have any medical conditions?',
                                style: theme.textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                'Toggle if you have any medical conditions we should know about',
                                style: theme.textTheme.bodySmall,
                              ),
                              value: _hasMedicalCondition,
                              onChanged: (value) {
                                setState(() {
                                  _hasMedicalCondition = value;
                                });
                              },
                              secondary: Icon(
                                Icons.medical_services_outlined,
                                color: theme.colorScheme.primary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: theme.dividerColor,
                                  width: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Document Upload
                    SectionHeader(title: 'Document Upload'),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Please upload the following documents (PDF, JPG, PNG formats only)',
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),

                            // ID Proof
                            DocumentUploadItem(
                              label: 'Government ID Proof',
                              icon: Icons.badge_outlined,
                              fileName: _idProof?.path.split('/').last ?? '',
                              onTap: () => _pickDocument('id'),
                              theme: theme,
                            ),

                            const SizedBox(height: 16),

                            // Transcripts
                            DocumentUploadItem(
                              label: 'Academic Transcripts',
                              icon: Icons.description_outlined,
                              fileName:
                                  _transcripts?.path.split('/').last ?? '',
                              onTap: () => _pickDocument('transcripts'),
                              theme: theme,
                            ),

                            const SizedBox(height: 16),

                            // Certificates
                            DocumentUploadItem(
                              label: 'Certificates & Awards',
                              icon: Icons.card_membership_outlined,
                              fileName:
                                  _certificates?.path.split('/').last ?? '',
                              onTap: () => _pickDocument('certificates'),
                              theme: theme,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Payment Information
                    SectionHeader(title: 'Payment Information'),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select your preferred payment method for application fees',
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),

                            // Payment Methods as Cards
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: 1.5,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              children:
                                  _paymentMethods.map((method) {
                                    final IconData icon;
                                    switch (method) {
                                      case 'Credit/Debit Card':
                                        icon = Icons.credit_card;
                                        break;
                                      case 'Bank Transfer':
                                        icon = Icons.account_balance;
                                        break;
                                      case 'PayPal':
                                        icon = Icons.payment;
                                        break;
                                      case 'Scholarship':
                                        icon = Icons.school;
                                        break;
                                      case 'Cash':
                                        icon = Icons.money;
                                        break;
                                      default:
                                        icon = Icons.payment;
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedPaymentMethod = method;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              _selectedPaymentMethod == method
                                                  ? theme.colorScheme.primary
                                                      .withOpacity(0.2)
                                                  : theme.colorScheme.surface,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color:
                                                _selectedPaymentMethod == method
                                                    ? theme.colorScheme.primary
                                                    : theme.dividerColor,
                                            width: 2,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              icon,
                                              size: 32,
                                              color:
                                                  _selectedPaymentMethod ==
                                                          method
                                                      ? theme
                                                          .colorScheme
                                                          .primary
                                                      : theme.iconTheme.color,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              method,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color:
                                                    _selectedPaymentMethod ==
                                                            method
                                                        ? theme
                                                            .colorScheme
                                                            .primary
                                                        : null,
                                                fontWeight:
                                                    _selectedPaymentMethod ==
                                                            method
                                                        ? FontWeight.bold
                                                        : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),

                            if (_selectedPaymentMethod == null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Please select a payment method',
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Terms and Conditions
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Declaration',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Text(
                              'I hereby declare that all the information provided in this application is true and correct to the best of my knowledge. '
                              'I understand that any false information may result in the cancellation of my application or admission.',
                              style: theme.textTheme.bodyMedium,
                            ),

                            const SizedBox(height: 16),

                            Text(
                              'I agree to abide by the rules and regulations of the college.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child:
                            _isSubmitting
                                ? CircularProgressIndicator(
                                  color: theme.colorScheme.onPrimary,
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.send),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Submit Application',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Section Header Widget
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Document Upload Item Widget
class DocumentUploadItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final String fileName;
  final VoidCallback onTap;
  final ThemeData theme;

  const DocumentUploadItem({
    Key? key,
    required this.label,
    required this.icon,
    required this.fileName,
    required this.onTap,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              theme.brightness == Brightness.dark
                  ? Color(0xFF1A1A1A)
                  : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                fileName.isNotEmpty
                    ? theme.colorScheme.primary.withOpacity(0.5)
                    : theme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    fileName.isNotEmpty ? fileName : 'No file selected',
                    style: TextStyle(
                      color: theme.textTheme.bodySmall?.color,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              fileName.isNotEmpty ? Icons.check_circle : Icons.upload_file,
              color:
                  fileName.isNotEmpty
                      ? Colors.green
                      : theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

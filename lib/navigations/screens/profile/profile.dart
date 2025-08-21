import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cms/datatypes/datatypes.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

// import 'theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, dynamic>> menuItems = [
    {
      "icon": Icons.person_outline,
      "title": "Personal Information",
      "subtitle": "View and edit your personal details",
      "route": "/personal_information",
    },
    {
      "icon": Icons.work_outline,
      "title": "Professional Information",
      "subtitle": "View your work experience and skills",
      "route": "/professional_information",
    },
    {
      "icon": Icons.school_outlined,
      "title": "Educational Information",
      "subtitle": "View your academic qualifications",
      "route": "/educational_information",
    },

    {
      "icon": Icons.lock_outline,
      "title": "Account Settings",
      "subtitle": "Manage your password and security settings",
      "route": "/account_settings",
    },
  ];

  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("User info not found!")));
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final firstName = userData['firstName'] ?? "Guest";
          final lastName = userData['lastName'] ?? "Guest";
          final email = userData['eMail'] ?? "admin@examplecollege.edu.np";
          final mobNo = userData['mobNo'] ?? "98xxxxxxxx";
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(firstName, lastName, email, mobNo),
                SizedBox(height: 20),
                _buildMenuSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
    String firstName,
    String lastName,
    String email,
    String mobNo,
  ) {
    return Container(
      color: blueColor,
      padding: EdgeInsets.only(bottom: 30.0),
      child: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.asset(
                "assets/images/img1profile.jpg",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Mr. $firstName $lastName",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Campus Chief",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildContactInfo(Icons.email, email),
              SizedBox(width: 20),
              _buildContactInfo(Icons.phone, mobNo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        SizedBox(width: 5),
        Text(text, style: TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account Settings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: menuItems.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: blueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(menuItems[index]["icon"], color: blueColor),
                ),
                title: Text(
                  menuItems[index]["title"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  menuItems[index]["subtitle"],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                onTap: () {
                  _navigateToScreen(context, menuItems[index]["route"]);
                },
              );
            },
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String route) {
    switch (route) {
      case "/personal_information":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonalInformationScreen()),
        );
        break;
      case "/professional_information":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfessionalInformationScreen(),
          ),
        );
        break;
      case "/educational_information":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EducationalInformationScreen(),
          ),
        );
        break;

      case "/account_settings":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountSettingsScreen()),
        );
        break;
    }
  }
}

// Personal Information Screen

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController(text: "Guest");
  final _lastNameController = TextEditingController(text: "User");
  final _emailController = TextEditingController(text: "admin@college.edu.np");
  final _phoneController = TextEditingController(text: "+977-98xxxxxxxx");
  final _addressController = TextEditingController(text: "Adresss, Nepal");

  DateTime? _selectedDate = DateTime(2035, 5, 15);
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo(uid!);
  }

  final uid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> _saveUserInfo(String uid) async {
    final userdoc = FirebaseFirestore.instance.collection('users').doc(uid);
    await userdoc.set({
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "eMail": _emailController.text.trim(),
      "mobNo": _phoneController.text.trim(),
      "address": _addressController.text.trim(),
      "DoB": _selectedDate?.toIso8601String(),
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _loadUserInfo(String uid) async {
    final userdoc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (userdoc.exists && userdoc.data() != null) {
      final userdata = userdoc.data()!;
      setState(() {
        _firstNameController.text = userdata["firstName"] ?? "";
        _lastNameController.text = userdata["lastName"] ?? "";
        _emailController.text = userdata["eMail"] ?? "";
        _phoneController.text = userdata["mobNo"] ?? "";
        _addressController.text = userdata["address"] ?? "";
        _selectedDate =
            userdata["DoB"] != null ? DateTime.tryParse(userdata["DoB"]) : null;
        _isEditing = false;
      });
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Details"),
        backgroundColor: blueColor,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                if (_formKey.currentState!.validate()) {
                  _saveUserInfo(uid!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Information saved")),
                  );
                }
              }
              setState(() => _isEditing = !_isEditing);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/img1profile.jpg",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildFieldCard(
                icon: Icons.person,
                label: "First Name",
                controller: _firstNameController,
                isEditable: _isEditing,
              ),
              _buildFieldCard(
                icon: Icons.person_outline,
                label: "Last Name",
                controller: _lastNameController,
                isEditable: _isEditing,
              ),
              _buildFieldCard(
                icon: Icons.email,
                label: "Email",
                controller: _emailController,
                isEditable: _isEditing,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildFieldCard(
                icon: Icons.phone,
                label: "Phone",
                controller: _phoneController,
                isEditable: _isEditing,
                keyboardType: TextInputType.phone,
              ),
              _buildFieldCard(
                icon: Icons.location_on,
                label: "Address",
                controller: _addressController,
                isEditable: _isEditing,
                maxLines: 2,
              ),
              _buildDateCard(
                icon: Icons.calendar_today,
                label: "Date of Birth",
                date: _selectedDate,
                isEditable: _isEditing,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditable,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(width: 1, color: blueColor),
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: blueColor),
        title:
            isEditable
                ? TextFormField(
                  controller: controller,
                  cursorColor: blueColor,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: TextStyle(color: blueColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 1.5, color: blueColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 0.5, color: blueColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter $label';
                    }
                    return null;
                  },
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).hintColor.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        controller.text,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildDateCard({
    required IconData icon,
    required String label,
    required DateTime? date,
    required bool isEditable,
  }) {
    final formattedDate =
        date != null ? "${date.day}/${date.month}/${date.year}" : "Select Date";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(width: 1, color: blueColor),
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: blueColor),
        title:
            isEditable
                ? InkWell(
                  onTap: () async {
                    final picked = await showMaterialDatePicker(
                      context: context,
                      initialDate:
                          date != null
                              ? NepaliDateTime.fromDateTime(date)
                              : NepaliDateTime(2045),
                      firstDate: NepaliDateTime(2040),
                      lastDate: NepaliDateTime.now(),
                    );

                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Icon(Icons.edit_calendar, color: blueColor, size: 18),
                      ],
                    ),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).hintColor.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

// Professional Information Screen
class ProfessionalInformationScreen extends StatefulWidget {
  @override
  _ProfessionalInformationScreenState createState() =>
      _ProfessionalInformationScreenState();
}

class _ProfessionalInformationScreenState
    extends State<ProfessionalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _positionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _experienceController = TextEditingController();
  final _skillsController = TextEditingController();
  DateTime? _joinDate;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfessionalInfo(uid!);
  }

  final uid = FirebaseAuth.instance.currentUser?.uid;
  Future<void> _loadProfessionalInfo(String uid) async {
    final professionalInfo =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (professionalInfo.exists && professionalInfo.data() != null) {
      final professionalData = professionalInfo.data()!;
      setState(() {
        _positionController.text =
            professionalData['jobProfession'] ?? "Campus Chief";
        _departmentController.text =
            professionalData['jobDepartment'] ?? "Administration";
        _experienceController.text =
            professionalData['jobExperince'] ?? "15 years";
        _skillsController.text =
            professionalData['jobSkill'] ?? "Leadership, Management, Education";
        _joinDate =
            professionalData["jobJoin"] != null
                ? DateTime.tryParse(professionalData["jobJoin"])
                : null;
      });
    }
  }

  Future<void> _saveProfessionalInfo(String? uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      'jobProfession': _positionController.text.trim(),
      'jobDepartment': _departmentController.text.trim(),
      'jobExperince': _experienceController.text.trim(),
      'jobSkill': _skillsController.text.trim(),
      'jobJoin': _joinDate?.toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Professional Information"),
        backgroundColor: blueColor,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                if (_formKey.currentState!.validate()) {
                  await _saveProfessionalInfo(uid!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Professional information updated successfully!",
                      ),
                    ),
                  );
                }
              }
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildFieldCard(
                icon: Icons.work,
                label: "Position",
                controller: _positionController,
                isEditable: _isEditing,
              ),
              _buildFieldCard(
                icon: Icons.business,
                label: "Department",
                controller: _departmentController,
                isEditable: _isEditing,
              ),
              _buildFieldCard(
                icon: Icons.timeline,
                label: "Experience",
                controller: _experienceController,
                isEditable: _isEditing,
              ),
              _buildFieldCard(
                icon: Icons.star,
                label: "Skills",
                controller: _skillsController,
                isEditable: _isEditing,
                maxLines: 3,
              ),
              _buildDateCard(
                icon: Icons.calendar_today,
                label: "Join Date",
                date: _joinDate,
                isEditable: _isEditing,
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Achievements",
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildAchievementCard(
                "Excellence in Leadership",
                "Awarded for outstanding leadership in education sector",
                Icons.emoji_events,
              ),
              const SizedBox(height: 12),
              _buildAchievementCard(
                "Best Campus Chief 2023",
                "Recognized as the best campus chief of the year",
                Icons.star,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditable,
    int maxLines = 1,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(width: 1, color: blueColor),
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: blueColor),
        title:
            isEditable
                ? TextFormField(
                  controller: controller,
                  cursorColor: blueColor,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: TextStyle(color: blueColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 1.5, color: blueColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 0.5, color: blueColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter $label';
                    }
                    return null;
                  },
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).hintColor.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        controller.text,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildDateCard({
    required IconData icon,
    required String label,
    required DateTime? date,
    required bool isEditable,
  }) {
    final formattedDate =
        date != null ? "${date.day}/${date.month}/${date.year}" : "Select Date";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(width: 1, color: blueColor),
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: blueColor),
        title:
            isEditable
                ? InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: date ?? DateTime(1990),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _joinDate = picked;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Icon(Icons.edit_calendar, size: 18),
                      ],
                    ),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).hintColor.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildAchievementCard(
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(width: 1, color: blueColor),
      ),
      child: ListTile(
        leading: Icon(icon, color: blueColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}

// Educational Information Screen
class EducationalInformationScreen extends StatefulWidget {
  @override
  _EducationalInformationScreenState createState() =>
      _EducationalInformationScreenState();
}

class _EducationalInformationScreenState
    extends State<EducationalInformationScreen> {
  List<Map<String, dynamic>> educationList = [];

  @override
  void initState() {
    super.initState();
    _loadEducationData();
  }

  Future<void> _loadEducationData() async {
    setState(() {
      educationList = [
        {
          "degree": "Master of Business Administration",
          "institution": "Tribhuvan University",
          "year": "2008",
          "grade": "First Division",
        },
        {
          "degree": "Bachelor of Business Studies",
          "institution": "Kathmandu University",
          "year": "2005",
          "grade": "Distinction",
        },
      ];
    });
  }

  Future<void> _saveEducationData() async {
    // Removed SharedPreferences saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Educational Information"),
        backgroundColor: blueColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Education History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: educationList.length,
              itemBuilder: (context, index) {
                return _buildEducationCard(educationList[index], index);
              },
            ),
            SizedBox(height: 24),
            Text(
              "Certifications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildCertificationCard(
              "Leadership Excellence Certificate",
              "Institute of Management",
              "2020",
            ),
            SizedBox(height: 12),
            _buildCertificationCard(
              "Educational Administration",
              "Education Board Nepal",
              "2018",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueColor,
        onPressed: _showAddEducationDialog,
        child: Icon(Icons.add),
        tooltip: "Add Education",
      ),
    );
  }

  Widget _buildEducationCard(Map<String, dynamic> education, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: blueColor, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      education["degree"],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(child: Text("Delete"), value: "delete"),
                        ],
                    onSelected: (value) async {
                      if (value == "delete") {
                        setState(() {
                          educationList.removeAt(index);
                        });
                        await _saveEducationData();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.school, size: 16, color: blueColor),
                  SizedBox(width: 8),
                  Text(education["institution"]),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: blueColor),
                  SizedBox(width: 8),
                  Text(education["year"]),
                  SizedBox(width: 20),
                  Icon(Icons.grade, size: 16, color: blueColor),
                  SizedBox(width: 8),
                  Text(education["grade"]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertificationCard(String title, String issuer, String year) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: blueColor, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          leading: Icon(Icons.verified, color: blueColor),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("$issuer • $year"),
        ),
      ),
    );
  }

  void _showAddEducationDialog() {
    final _formKey = GlobalKey<FormState>();
    final degreeController = TextEditingController();
    final institutionController = TextEditingController();
    final yearController = TextEditingController();
    final gradeController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Add Education",
              style: TextStyle(fontWeight: FontWeight.bold, color: blueColor),
            ),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: degreeController,
                      cursorColor: blueColor,
                      decoration: InputDecoration(
                        labelText: "Degree",
                        labelStyle: TextStyle(color: blueColor),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1.5, color: blueColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 0.5, color: blueColor),
                        ),
                      ),
                      validator:
                          (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? "Required"
                                  : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: institutionController,
                      cursorColor: blueColor,
                      decoration: InputDecoration(
                        labelText: "Institution",
                        labelStyle: TextStyle(color: blueColor),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1.5, color: blueColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 0.5, color: blueColor),
                        ),
                      ),
                      validator:
                          (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? "Required"
                                  : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: yearController,
                      cursorColor: blueColor,
                      decoration: InputDecoration(
                        labelText: "Year",
                        labelStyle: TextStyle(color: blueColor),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1.5, color: blueColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 0.5, color: blueColor),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty)
                          return "Required";
                        if (!RegExp(r'^\d{4}$').hasMatch(value.trim()))
                          return "Enter a valid 4-digit year";
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: gradeController,
                      cursorColor: blueColor,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        labelText: "Grade",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1.5, color: blueColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 0.5, color: blueColor),
                        ),
                      ),
                      validator:
                          (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? "Required"
                                  : null,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: blueColor)),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      educationList.add({
                        "degree": degreeController.text.trim(),
                        "institution": institutionController.text.trim(),
                        "year": yearController.text.trim(),
                        "grade": gradeController.text.trim(),
                      });
                    });
                    await _saveEducationData();
                    Navigator.pop(context);
                  }
                },
                child: Text("Add", style: TextStyle(color: blueColor)),
              ),
            ],
          ),
    );
  }
}

// Account Setting Screen

class AccountSettingsScreen extends StatefulWidget {
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String? _hashedPassword;

  void _hashPassword() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter new and confirm passwords")),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }

    final bytes = utf8.encode(newPassword);
    final digest = sha256.convert(bytes);

    setState(() {
      _hashedPassword = digest.toString();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Password hashed successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Password Hashing"),
        backgroundColor: blueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPasswordField(
              label: "Current Password",
              controller: _currentPasswordController,
              obscureText: _obscureCurrent,
              toggleVisibility:
                  () => setState(() => _obscureCurrent = !_obscureCurrent),
            ),
            SizedBox(height: 16),
            _buildPasswordField(
              label: "New Password",
              controller: _newPasswordController,
              obscureText: _obscureNew,
              toggleVisibility:
                  () => setState(() => _obscureNew = !_obscureNew),
            ),
            SizedBox(height: 16),
            _buildPasswordField(
              label: "Confirm Password",
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              toggleVisibility:
                  () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _hashPassword,
              child: Text("Hash Password"),
            ),
            SizedBox(height: 24),
            if (_hashedPassword != null) ...[
              Text(
                "SHA-256 Hashed Password:",
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              SelectableText(
                _hashedPassword!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: blueColor,
                ),
              ),
              SizedBox(height: 24),
              Text(
                "SHA-256 is a cryptographic hash function that converts any input into a fixed-size 256-bit hash. "
                "It is widely used for securely storing passwords because it’s computationally infeasible to reverse or find collisions.",
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:cms/datatypes/datatypes.dart';

import 'package:shared_preferences/shared_preferences.dart';

// Import the theme provider
// import 'theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, dynamic>> statsItems = [
    {"icon": Icons.pending_actions, "label": "Pending", "count": "05"},
    {"icon": Icons.approval, "label": "Approved", "count": "12"},
    {"icon": Icons.people_outline, "label": "Students", "count": "1108"},
    {"icon": Icons.person_outline, "label": "Teachers", "count": "68"},
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 20),
            _buildStatsSection(),
            SizedBox(height: 20),
            _buildMenuSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
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
            "Mr. Amit Mahato",
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
              _buildContactInfo(Icons.email, "amitm@examplecollege.edu.np"),
              SizedBox(width: 20),
              _buildContactInfo(Icons.phone, "+977-9825780505"),
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

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Overview",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    statsItems.map((item) {
                      return _buildStatItem(
                        item["icon"],
                        item["label"],
                        item["count"],
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String count) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: blueColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: blueColor, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: blueColor,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _selectedDate;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadPersonalInfo();
  }

  Future<void> _loadPersonalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstNameController.text = prefs.getString('firstName') ?? "Amit";
      _lastNameController.text = prefs.getString('lastName') ?? "Mahato";
      _emailController.text =
          prefs.getString('email') ?? "amitm@examplecollege.edu.np";
      _phoneController.text = prefs.getString('phone') ?? "+977-9825780505";
      _addressController.text =
          prefs.getString('address') ?? "Kathmandu, Nepal";
      final dobString = prefs.getString('dob');
      _selectedDate =
          dobString != null
              ? DateTime.tryParse(dobString)
              : DateTime(1985, 5, 15);
    });
  }

  Future<void> _savePersonalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', _firstNameController.text);
    await prefs.setString('lastName', _lastNameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('address', _addressController.text);
    if (_selectedDate != null) {
      await prefs.setString('dob', _selectedDate!.toIso8601String());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;
    final cardColor = theme.cardColor;
    final labelStyle = TextStyle(color: theme.hintColor.withOpacity(0.7));

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
                  await _savePersonalInfo();
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
              // Profile Image
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

              // Fields
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon),
        title:
            isEditable
                ? TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    labelText: label,
                    border: InputBorder.none,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon),
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
    _loadProfessionalInfo();
  }

  Future<void> _loadProfessionalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _positionController.text = prefs.getString('position') ?? "Campus Chief";
      _departmentController.text =
          prefs.getString('department') ?? "Administration";
      _experienceController.text = prefs.getString('experience') ?? "15 years";
      _skillsController.text =
          prefs.getString('skills') ?? "Leadership, Management, Education";
      final dateStr = prefs.getString('joinDate');
      _joinDate =
          dateStr != null ? DateTime.tryParse(dateStr) : DateTime(2010, 1, 15);
    });
  }

  Future<void> _saveProfessionalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('position', _positionController.text);
    await prefs.setString('department', _departmentController.text);
    await prefs.setString('experience', _experienceController.text);
    await prefs.setString('skills', _skillsController.text);
    if (_joinDate != null) {
      await prefs.setString('joinDate', _joinDate!.toIso8601String());
    }
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
                  await _saveProfessionalInfo();
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon),
        title:
            isEditable
                ? TextFormField(
                  controller: controller,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    labelText: label,
                    border: InputBorder.none,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon),
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
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
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
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString('educationList');
    if (storedData != null) {
      final List decoded = jsonDecode(storedData);
      setState(() {
        educationList = List<Map<String, dynamic>>.from(decoded);
      });
    } else {
      // Wrap this in setState to update UI on first load
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
  }

  Future<void> _saveEducationData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('educationList', jsonEncode(educationList));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Educational Information"),
        // Removed IconButton here because we use FAB now
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

      // WhatsApp-style FAB for adding education
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEducationDialog,
        child: Icon(Icons.add),
        tooltip: "Add Education",
      ),
    );
  }

  Widget _buildEducationCard(Map<String, dynamic> education, int index) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.only(bottom: 12),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                PopupMenuButton(
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(child: Text("Edit"), value: "edit"),
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
                Icon(Icons.school, size: 16, color: theme.colorScheme.primary),
                SizedBox(width: 8),
                Text(education["institution"]),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text(education["year"]),
                SizedBox(width: 20),
                Icon(Icons.grade, size: 16, color: theme.colorScheme.primary),
                SizedBox(width: 8),
                Text(education["grade"]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationCard(String title, String issuer, String year) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(Icons.verified, color: theme.colorScheme.primary),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$issuer • $year"),
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
            title: Text("Add Education"),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: degreeController,
                      decoration: InputDecoration(labelText: "Degree"),
                      validator:
                          (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? "Required"
                                  : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: institutionController,
                      decoration: InputDecoration(labelText: "Institution"),
                      validator:
                          (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? "Required"
                                  : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: yearController,
                      decoration: InputDecoration(labelText: "Year"),
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
                      decoration: InputDecoration(labelText: "Grade"),
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
                child: Text("Cancel"),
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
                child: Text("Add"),
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

    // Hash the password using SHA-256
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
      appBar: AppBar(title: Text("Password Hashing")),
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
                  color: theme.colorScheme.primary,
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

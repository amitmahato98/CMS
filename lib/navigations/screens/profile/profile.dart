import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cms/datatypes/datatypes.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as nepali_picker;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
          final lastName = userData['lastName'] ?? "User";
          final email = userData['eMail'] ?? "admin@examplecollege.edu.np";
          final mobNo = userData['mobNo'] ?? "98xxxxxxxx";
          final jobProfession = userData['jobProfession'] ?? 'JobTitle';
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(
                  firstName,
                  lastName,
                  email,
                  mobNo,
                  jobProfession,
                ),
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
    String jobProfession,
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
            jobProfession,
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

  NepaliDateTime? _selectedDate = NepaliDateTime(2045, 5, 15);
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
            userdata["DoB"] != null
                ? NepaliDateTime.tryParse(userdata["DoB"])
                : null;
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
    required NepaliDateTime? date,
    required bool isEditable,
  }) {
    final formattedDate =
        date != null ? date.format("yyyy-MM-dd") : "Select Date";
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
                      initialDate: date ?? NepaliDateTime.now(),
                      firstDate: NepaliDateTime(2000),
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
            professionalData['jobExperince'] ?? "0 years";
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
        date != null
            ? NepaliDateTime.fromDateTime(date).format(
              "yyyy-MM-dd",
            ) // show Nepali date
            : "Select Date";

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
                    final picked = await nepali_picker.showAdaptiveDatePicker(
                      context: context,
                      initialDate:
                          date != null
                              ? NepaliDateTime.fromDateTime(date)
                              : NepaliDateTime(2047, 1, 1),
                      firstDate: NepaliDateTime(2000, 1, 1),
                      lastDate: NepaliDateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _joinDate =
                            picked.toDateTime(); // store as normal DateTime
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

// Educational Information Screen
class EducationalInformationScreen extends StatefulWidget {
  @override
  _EducationalInformationScreenState createState() =>
      _EducationalInformationScreenState();
}

class _EducationalInformationScreenState
    extends State<EducationalInformationScreen> {
  final degreeController = TextEditingController();
  final institutionController = TextEditingController();
  final yearController = TextEditingController();
  final gradeController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: Duration(seconds: 4)),
      );
  }

  Future<void> _saveEducationData() async {
    if (uid == null) return;
    final educationList = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection('educations');

    // checking for duplication avialible;
    final existingEducationList =
        await educationList
            .where('degree', isEqualTo: degreeController.text.trim())
            .where('institution', isEqualTo: institutionController.text.trim())
            .where('year', isEqualTo: yearController.text.trim())
            .where('grade', isEqualTo: gradeController.text.trim())
            .get();

    if (existingEducationList.docs.isNotEmpty) {
      _showSnackBar("Education Data Already Exists !");
      return;
    }

    await educationList.add({
      'degree': degreeController.text.trim(),
      'institution': institutionController.text.trim(),
      'year': yearController.text.trim(),
      'grade': gradeController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    _showSnackBar('Education Added Succesfully !');

    degreeController.clear();
    yearController.clear();
    gradeController.clear();
    institutionController.clear();
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
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('educations')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  _showSnackBar("Error :${snapshot.error}");
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final educationDocs = snapshot.data!.docs;
                if (educationDocs.isEmpty) {
                  return Center(child: Text("No Data Found !"));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: educationDocs.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final doc = educationDocs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildEducationCard(data, doc.id);
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueColor,
        onPressed: _showAddEducationDialog,
        tooltip: "Add Education",
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildEducationCard(Map<String, dynamic> education, String docId) {
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
                      education["degree"] ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(value: "delete", child: Text("Delete")),
                        ],
                    onSelected: (value) async {
                      if (value == "delete") {
                        try {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .collection('educations')
                              .doc(docId)
                              .delete();
                          _showSnackBar("Education deleted");
                        } catch (e) {
                          _showSnackBar("Delete failed: $e");
                        }
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
                  Text(education["institution"] ?? ""),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: blueColor),
                  SizedBox(width: 8),
                  Text(education["year"] ?? ""),
                  SizedBox(width: 20),
                  Icon(Icons.grade, size: 16, color: blueColor),
                  SizedBox(width: 8),
                  Text(education["grade"] ?? ""),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddEducationDialog() {
    final _formKey = GlobalKey<FormState>();

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

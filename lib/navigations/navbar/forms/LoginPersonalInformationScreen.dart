import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms/datatypes/datatypes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class LoginPersonalInformationScreen extends StatefulWidget {
  const LoginPersonalInformationScreen({super.key});

  @override
  State<LoginPersonalInformationScreen> createState() =>
      _LoginPersonalInformationScreenState();
}

class _LoginPersonalInformationScreenState
    extends State<LoginPersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final _positionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _experienceController = TextEditingController();
  final _skillsController = TextEditingController();

  final _degreeController = TextEditingController();
  final _institutionController = TextEditingController();
  final _yearController = TextEditingController();
  final _gradeController = TextEditingController();

  NepaliDateTime? _dob;
  NepaliDateTime? _joinDate;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> _saveUserInfo(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "eMail": _emailController.text.trim(),
      "mobNo": "+977${_phoneController.text.trim()}",
      "address": _addressController.text.trim(),
      "DoB": _dob?.toIso8601String(),
      "jobProfession": _positionController.text.trim(),
      "jobDepartment": _departmentController.text.trim(),
      "jobExperience": _experienceController.text.trim(),
      "jobSkill": _skillsController.text.trim(),
      "jobJoin": _joinDate?.toIso8601String(),
      "degree": _degreeController.text.trim(),
      "institution": _institutionController.text.trim(),
      "year": _yearController.text.trim(),
      "grade": _gradeController.text.trim(),
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    Navigator.pop(context);
  }

  String? _validateName(String? value, String field) {
    if (value == null || value.isEmpty) return "Please enter $field";
    if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value)) {
      return "$field can only contain alphabets";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Please enter email";
    if (value != value.toLowerCase()) return "Email must be lowercase";
    if (!RegExp(
      r"^[a-z0-9]+(\.[a-z0-9]+)*@[a-z0-9]+\.[a-z]{2,}$",
    ).hasMatch(value)) {
      return "Enter a valid email (only dot allowed, one @)";
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Please enter phone number";
    if (!RegExp(r"^(97|98)[0-9]{8}$").hasMatch(value)) {
      return "Phone must start with 97/98 and be 10 digits";
    }
    return null;
  }

  String? _validateGrade(String? value) {
    if (value == null || value.isEmpty) return "Please enter grade";
    if (!RegExp(r"^[A-E][+-]?$").hasMatch(value)) {
      return "Grade must be A–E with optional + or - (e.g., B+)";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Your Profile"),
        backgroundColor: blueColor,
        automaticallyImplyLeading: false,
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
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),

              _buildFieldCard(
                icon: Icons.person,
                label: "First Name",
                controller: _firstNameController,
                validator: (v) => _validateName(v, "First Name"),
              ),
              _buildFieldCard(
                icon: Icons.person_outline,
                label: "Last Name",
                controller: _lastNameController,
                validator: (v) => _validateName(v, "Last Name"),
              ),
              _buildFieldCard(
                icon: Icons.email,
                label: "Email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              _buildFieldCard(
                icon: Icons.phone,
                label: "Phone (without +977)",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
              ),
              _buildFieldCard(
                icon: Icons.location_on,
                label: "Address",
                controller: _addressController,
                maxLines: 2,
                validator:
                    (v) =>
                        v == null || v.isEmpty ? "Please enter Address" : null,
              ),
              _buildNepaliDateCard(
                icon: Icons.calendar_today,
                label: "Date of Birth",
                date: _dob,
                onPicked: (d) => setState(() => _dob = d),
              ),

              const Divider(height: 30),
              Text(
                "Job Information",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              _buildFieldCard(
                icon: Icons.work,
                label: "Profession",
                controller: _positionController,
                validator:
                    (v) =>
                        v == null || v.isEmpty
                            ? "Please enter Profession"
                            : null,
              ),
              _buildFieldCard(
                icon: Icons.apartment,
                label: "Department",
                controller: _departmentController,
                validator:
                    (v) =>
                        v == null || v.isEmpty
                            ? "Please enter Department"
                            : null,
              ),
              _buildFieldCard(
                icon: Icons.timeline,
                label: "Experience",
                controller: _experienceController,
                validator:
                    (v) =>
                        v == null || v.isEmpty
                            ? "Please enter Experience"
                            : null,
              ),
              _buildFieldCard(
                icon: Icons.build,
                label: "Skills",
                controller: _skillsController,
                maxLines: 2,
                validator:
                    (v) =>
                        v == null || v.isEmpty ? "Please enter Skills" : null,
              ),
              _buildNepaliDateCard(
                icon: Icons.date_range,
                label: "Join Date",
                date: _joinDate,
                onPicked: (d) => setState(() => _joinDate = d),
              ),

              const Divider(height: 30),
              Text(
                "Education Information",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              _buildFieldCard(
                icon: Icons.school,
                label: "Degree",
                controller: _degreeController,
                validator:
                    (v) =>
                        v == null || v.isEmpty ? "Please enter Degree" : null,
              ),
              _buildFieldCard(
                icon: Icons.account_balance,
                label: "Institution",
                controller: _institutionController,
                validator:
                    (v) =>
                        v == null || v.isEmpty
                            ? "Please enter Institution"
                            : null,
              ),
              _buildFieldCard(
                icon: Icons.calendar_month,
                label: "Year",
                controller: _yearController,
                keyboardType: TextInputType.number,
                validator:
                    (v) => v == null || v.isEmpty ? "Please enter Year" : null,
              ),
              _buildFieldCard(
                icon: Icons.grade,
                label: "Grade",
                controller: _gradeController,
                validator: _validateGrade,
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _saveUserInfo(uid!);
                  }
                },
                child: Text(
                  "Save & Continue",
                  style: TextStyle(color: whiteColor),
                ),
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
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
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
        title: TextFormField(
          controller: controller,
          cursorColor: blueColor,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: "Enter $label",
            border: InputBorder.none,
          ),
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildNepaliDateCard({
    required IconData icon,
    required String label,
    required NepaliDateTime? date,
    required Function(NepaliDateTime) onPicked,
  }) {
    final formattedDate =
        date != null
            ? "${date.day}/${date.month}/${date.year}"
            : "Select $label";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(width: 1, color: blueColor),
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: blueColor),
        title: InkWell(
          onTap: () async {
            final picked = await showMaterialDatePicker(
              context: context,
              initialDate: NepaliDateTime.now(),
              firstDate: NepaliDateTime(2000),
              lastDate: NepaliDateTime.now(),
            );
            if (picked != null) onPicked(picked);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formattedDate),
                Icon(Icons.edit_calendar, color: blueColor, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

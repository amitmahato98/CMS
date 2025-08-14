import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'teacher.dart';

class AddNewTeacherPage extends StatefulWidget {
  final Teacher? teacher;

  const AddNewTeacherPage({super.key, this.teacher});

  @override
  State<AddNewTeacherPage> createState() => _AddNewTeacherPageState();
}

class _AddNewTeacherPageState extends State<AddNewTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final qualification = TextEditingController();
  final specialization = TextEditingController();
  final experience = TextEditingController();
  String designation = 'Lecturer';
  String department = 'BSc CSIT';
  DateTime joiningDate = DateTime.now();
  late bool isEditing;

  @override
  void initState() {
    super.initState();
    isEditing = widget.teacher != null;

    if (isEditing) {
      final t = widget.teacher!;
      name.text = t.name;
      email.text = t.email;
      phone.text = t.phone;
      address.text = t.address;
      qualification.text = t.qualification;
      specialization.text = t.specialization;
      experience.text = t.experience;
      designation = t.designation;
      department = t.department;
      joiningDate = DateTime.tryParse(t.joiningDate) ?? DateTime.now();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: joiningDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        joiningDate = picked;
      });
    }
  }

  Future<void> _saveTeacher() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<Teacher> teachers = [];
      final existing = prefs.getString('teachers');
      if (existing != null) {
        final decoded = jsonDecode(existing) as List;
        teachers = decoded.map((e) => Teacher.fromJson(e)).toList();
      }

      final updatedTeacher = Teacher(
        id:
            isEditing
                ? widget.teacher!.id
                : 'TCH${DateTime.now().millisecondsSinceEpoch}',
        name: name.text,
        email: email.text,
        phone: phone.text,
        address: address.text,
        department: department,
        designation: designation,
        qualification: qualification.text,
        specialization: specialization.text,
        experience: experience.text,
        joiningDate: joiningDate.toIso8601String(),
      );

      if (isEditing) {
        final index = teachers.indexWhere((t) => t.id == widget.teacher!.id);
        if (index != -1) {
          teachers[index] = updatedTeacher;
        }
      } else {
        teachers.add(updatedTeacher);
      }

      await prefs.setString(
        'teachers',
        jsonEncode(teachers.map((t) => t.toJson()).toList()),
      );

      Navigator.pop(context, updatedTeacher);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Teacher' : 'Add Teacher'),
        backgroundColor: blueColor,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    cursorColor: blueColor,
                    controller: name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: blueColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: blueColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: blueColor, width: 1.5),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v)) {
                        return 'Only alphabets allowed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    cursorColor: blueColor,
                    controller: email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: blueColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: blueColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: blueColor, width: 1.5),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (!RegExp(
                        r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$',
                      ).hasMatch(v)) {
                        return 'Enter valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    cursorColor: blueColor,
                    controller: phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(color: blueColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: blueColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: blueColor, width: 1.5),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (!RegExp(r'^\d{10}$').hasMatch(v)) {
                        return 'Enter 10-digit number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    cursorColor: blueColor,
                    controller: address,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(color: blueColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: blueColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: blueColor, width: 1.5),
                      ),
                    ),
                    validator:
                        (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    cursorColor: blueColor,
                    controller: qualification,
                    decoration: InputDecoration(
                      labelText: 'Qualification',
                      labelStyle: TextStyle(color: blueColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: blueColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: blueColor, width: 1.5),
                      ),
                    ),
                    validator:
                        (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    cursorColor: blueColor,
                    controller: specialization,
                    decoration: InputDecoration(
                      labelText: 'Specialization',
                      labelStyle: TextStyle(color: blueColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: blueColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: blueColor, width: 1.5),
                      ),
                    ),
                    validator:
                        (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    cursorColor: blueColor,
                    controller: experience,
                    decoration: InputDecoration(
                      labelText: 'Experience (years)',
                      labelStyle: TextStyle(color: blueColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: blueColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: blueColor, width: 1.5),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (int.tryParse(v) == null || int.parse(v) < 0) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: designation.isNotEmpty ? designation : null,
                    decoration: InputDecoration(
                      labelText: 'Designation',
                      labelStyle: TextStyle(color: blueColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: blueColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: blueColor, width: 1.5),
                      ),
                    ),
                    items:
                        ['Lecturer', 'Assistant Professor', 'Professor']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => designation = val ?? ''),
                    validator:
                        (v) =>
                            v == null || v.isEmpty
                                ? 'Please select a designation'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Joining Date: ${joiningDate.toLocal().toString().split(' ')[0]}',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _pickDate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blueColor,
                        ),
                        child: const Text(
                          'Pick Date',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      icon: Icon(
                        isEditing ? Icons.save : Icons.add,
                        color: whiteColor,
                      ),
                      onPressed: _saveTeacher,
                      label: Text(isEditing ? 'Update Teacher' : 'Add Teacher'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueColor,
                        foregroundColor: whiteColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

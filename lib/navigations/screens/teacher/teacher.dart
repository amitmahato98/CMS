import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'AddNewTeacherPage.dart'; // Assuming you created this already

class Teacher {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String department;
  final String designation;
  final String qualification;
  final String specialization;
  final String experience;
  final String joiningDate;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.department,
    required this.designation,
    required this.qualification,
    required this.specialization,
    required this.experience,
    required this.joiningDate,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    address: json['address'],
    department: json['department'],
    designation: json['designation'],
    qualification: json['qualification'],
    specialization: json['specialization'],
    experience: json['experience'],
    joiningDate: json['joiningDate'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'department': department,
    'designation': designation,
    'qualification': qualification,
    'specialization': specialization,
    'experience': experience,
    'joiningDate': joiningDate,
  };
}

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  List<Teacher> _teachers = [];
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('teachers');
    if (data != null) {
      final List decoded = json.decode(data);
      setState(() {
        _teachers = decoded.map((e) => Teacher.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveTeachers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _teachers.map((e) => e.toJson()).toList();
    await prefs.setString('teachers', json.encode(data));
  }

  void _toggleExpansion(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? null : index;
    });
  }

  void _navigateToAdd({Teacher? teacher, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddNewTeacherPage(teacher: teacher)),
    );

    if (result != null && result is Teacher) {
      setState(() {
        if (index != null) {
          _teachers[index] = result;
        } else {
          _teachers.add(result);
        }
      });
      _saveTeachers();
    }
  }

  void _deleteTeacher(int index) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Teacher'),
          content: const Text('Are you sure you want to delete this teacher?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false); // close dialog with false
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // close dialog with true
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _teachers.removeAt(index);
        _expandedIndex = null;
      });

      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_teachers.map((e) => e.toJson()).toList());
      await prefs.setString('teachers', encoded);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Teacher deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teachers'),
        backgroundColor: const Color(0xFF1E88E5),
      ),
      body:
          _teachers.isEmpty
              ? const Center(child: Text('No teachers added yet.'))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _teachers.length,
                itemBuilder: (context, index) {
                  final t = _teachers[index];
                  final isExpanded = _expandedIndex == index;

                  return GestureDetector(
                    onTap: () => _toggleExpansion(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? theme.cardColor
                                : colorScheme.primary.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            isDark
                                                ? colorScheme.onSurface
                                                : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${t.designation} - ${t.department}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color:
                                            isDark
                                                ? colorScheme.onSurface
                                                    .withOpacity(0.7)
                                                : Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${t.experience} yrs',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isDark
                                          ? colorScheme.onSurface
                                          : Colors.white,
                                ),
                              ),
                            ],
                          ),

                          // Expanded info
                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _infoRow(
                                    context,
                                    Icons.email,
                                    'Email',
                                    t.email,
                                  ),
                                  _infoRow(context, Icons.key_off, 'id', t.id),
                                  _infoRow(
                                    context,
                                    Icons.phone,
                                    'Phone',
                                    t.phone,
                                  ),
                                  _infoRow(
                                    context,
                                    Icons.home,
                                    'Address',
                                    t.address,
                                  ),
                                  _infoRow(
                                    context,
                                    Icons.school,
                                    'Qualification',
                                    t.qualification,
                                  ),
                                  _infoRow(
                                    context,
                                    Icons.book,
                                    'Specialization',
                                    t.specialization,
                                  ),
                                  _infoRow(
                                    context,
                                    Icons.calendar_month,
                                    'Joining Date',
                                    _formatDate(t.joiningDate),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        onPressed:
                                            () => _navigateToAdd(
                                              teacher: t,
                                              index: index,
                                            ),
                                        icon: const Icon(Icons.edit),
                                        label: const Text('Edit'),
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              isDark
                                                  ? Colors.amber
                                                  : Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      TextButton.icon(
                                        onPressed: () => _deleteTeacher(index),
                                        icon: const Icon(Icons.delete),
                                        label: const Text('Delete'),
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              isDark
                                                  ? Colors.redAccent
                                                  : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            crossFadeState:
                                isExpanded
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 300),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: textColor),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }
}

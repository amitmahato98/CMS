import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addnewstudentpage.dart';

class NewStudent extends StatefulWidget {
  const NewStudent({super.key});

  @override
  State<NewStudent> createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  List<Map<String, dynamic>> students = [];
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('students') ?? [];
    setState(() {
      students =
          list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    });
  }

  Future<void> _saveStudents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'students',
      students.map((s) => jsonEncode(s)).toList(),
    );
  }

  Future<void> _addOrEditStudent(
    Map<String, dynamic> student, {
    int? index,
  }) async {
    if (index == null) {
      students.add(student);
    } else {
      students[index] = student;
    }
    await _saveStudents();
    setState(() {});
  }

  Future<void> _deleteStudent(int index) async {
    students.removeAt(index);
    await _saveStudents();
    setState(() {});
  }

  void _confirmDelete(int index) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Student'),
          content: const Text('Are you sure you want to delete this student?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Properly closes the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(
                  context,
                ).pop(true); // Confirm delete and close dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        _deleteStudent(index);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Student deleted')));
      }
    });
  }

  void _toggleExpand(int index) {
    setState(() {
      _expandedIndex = (_expandedIndex == index) ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text("Students"), backgroundColor: primary),
      body:
          students.isEmpty
              ? const Center(child: Text("No students added yet."))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  final expanded = _expandedIndex == index;

                  return GestureDetector(
                    onTap: () => _toggleExpand(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? theme.cardColor
                                : primary.withOpacity(0.95),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student['name'] ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            isDark
                                                ? theme.colorScheme.onSurface
                                                : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      student['program'] ?? '',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color:
                                            isDark
                                                ? theme.colorScheme.onSurface
                                                    .withOpacity(0.7)
                                                : Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                student['studentId'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isDark
                                          ? theme.colorScheme.onSurface
                                          : Colors.white,
                                ),
                              ),
                            ],
                          ),

                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _infoRow(
                                    Icons.email,
                                    'Email',
                                    student['email'],
                                  ),
                                  _infoRow(
                                    Icons.phone,
                                    'Phone',
                                    student['phone'],
                                  ),
                                  _infoRow(
                                    Icons.home,
                                    'Address',
                                    student['address'],
                                  ),
                                  _infoRow(
                                    Icons.people,
                                    'Gender',
                                    student['gender'],
                                  ),
                                  _infoRow(
                                    Icons.calendar_today,
                                    'DOB',
                                    student['dateOfBirth']?.split('T')[0] ?? '',
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.amber,
                                        ),
                                        onPressed: () async {
                                          final updated = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => AddNewStudentPage(
                                                    studentData: student,
                                                  ),
                                            ),
                                          );
                                          if (updated != null) {
                                            await _addOrEditStudent(
                                              updated,
                                              index: index,
                                            );
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => _confirmDelete(index),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            crossFadeState:
                                expanded
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
        backgroundColor: primary,
        onPressed: () async {
          final newStudent = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNewStudentPage()),
          );
          if (newStudent != null) _addOrEditStudent(newStudent);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? Colors.white : Colors.black87;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text.rich(
            TextSpan(
              text: '$label: ',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

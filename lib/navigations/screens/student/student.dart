import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addnewstudentpage.dart';

class NewStudent extends StatefulWidget {
  const NewStudent({super.key});

  @override
  State<NewStudent> createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> filteredStudents = [];
  int? _expandedIndex;

  String searchQuery = '';

  Future<void> _addOrEditStudent(
    Map<String, dynamic> student, {
    int? index,
  }) async {
    if (index == null) {
      students.add(student);
    } else {
      students[index] = student;
    }

    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(student['studentId'])
          .set(student);
      setState(() {});
    } catch (e, st) {
      debugPrint('Error saving student: $e\n$st');
      final err = e.toString();
      String message = 'Failed to save student.';
      if (err.contains('permission-denied')) {
        message =
            'Permission denied when saving student. Check Firestore rules and user roles.';
      } else {
        message = err;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteStudent(int index) async {
    final student = students[index];
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(student['studentId'])
          .delete();
      students.removeAt(index);
      setState(() {});
    } catch (e, st) {
      debugPrint('Error deleting student: $e\n$st');
      final err = e.toString();
      String message = 'Failed to delete student.';
      if (err.contains('permission-denied')) {
        message =
            'Permission denied when deleting student. Only admin may delete.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    }
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
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
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
    setState(() => _expandedIndex = (_expandedIndex == index) ? null : index);
  }

  void _filterStudents() {
    filteredStudents =
        students.where((student) {
          final searchLower = searchQuery.toLowerCase();
          return (student['rollNumber']?.toLowerCase().contains(searchLower) ==
                  true) ||
              (student['name']?.toLowerCase().contains(searchLower) == true) ||
              (student['program']?.toLowerCase().contains(searchLower) ==
                  true) ||
              (student['batch']?.toLowerCase().contains(searchLower) == true) ||
              (student['phone']?.toLowerCase().contains(searchLower) == true) ||
              (student['registrationNumber']?.toLowerCase().contains(
                    searchLower,
                  ) ==
                  true) ||
              (student['email']?.toLowerCase().contains(searchLower) == true);
        }).toList();

    filteredStudents.sort(
      (a, b) => (a['rollNumber'] ?? '').compareTo(b['rollNumber'] ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = blueColor;

    return Scaffold(
      appBar: AppBar(title: const Text("Students"), backgroundColor: primary),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint('Stream error: ${snapshot.error}');
            return Center(
              child: Text('Error loading students: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          students =
              snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _filterStudents();
            });
          });

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: blueColor.withOpacity(0.5)),
                    hintText:
                        'Roll No, Name, Course, Batch, Phone, Reg No, Email',
                    prefixIcon: Icon(Icons.search, color: blueColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark ? theme.cardColor : Colors.grey[200],
                  ),
                  onChanged: (val) {
                    searchQuery = val;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _filterStudents();
                      });
                    });
                  },
                ),
              ),
              Expanded(
                child:
                    filteredStudents.isEmpty
                        ? const Center(child: Text("No students found."))
                        : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = filteredStudents[index];
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
                                  border: Border.all(
                                    width: 1,
                                    color: blueColor,
                                  ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                student['name'] ?? '',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      isDark
                                                          ? theme
                                                              .colorScheme
                                                              .onSurface
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
                                                          ? theme
                                                              .colorScheme
                                                              .onSurface
                                                              .withOpacity(0.7)
                                                          : Colors.white
                                                              .withOpacity(0.9),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          student['rollNumber'] ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color:
                                                isDark
                                                    ? theme
                                                        .colorScheme
                                                        .onSurface
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _infoRow(
                                              Icons.person_2_rounded,
                                              'Father Name',
                                              student['fatherFullName'] ?? '',
                                            ),
                                            _infoRow(
                                              Icons.confirmation_number,
                                              'Roll Number',
                                              student['rollNumber'] ?? '',
                                            ),
                                            _infoRow(
                                              Icons.confirmation_number,
                                              'Registration Number',
                                              student['registrationNumber'] ??
                                                  '',
                                            ),
                                            _infoRow(
                                              Icons.confirmation_number,
                                              'Batch Year',
                                              student['batch'] ?? '',
                                            ),
                                            _infoRow(
                                              Icons.email,
                                              'Email',
                                              student['email'] ?? '',
                                            ),
                                            _infoRow(
                                              Icons.phone,
                                              'Phone',
                                              student['phone'] ?? '',
                                            ),
                                            _infoRow(
                                              Icons.home,
                                              'Address',
                                              student['address'] ?? '',
                                            ),
                                            _infoRow(
                                              Icons.people,
                                              'Gender',
                                              student['gender'] ?? '',
                                            ),
                                            _infoRow(
                                              Icons.calendar_today,
                                              'DOB',
                                              student['dateOfBirth']?.split(
                                                    'T',
                                                  )[0] ??
                                                  '',
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton.icon(
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Colors.amber,
                                                  ),
                                                  label: const Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                      color: Colors.amber,
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    final updated =
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (
                                                                  _,
                                                                ) => AddNewStudentPage(
                                                                  studentData:
                                                                      student,
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
                                                TextButton.icon(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.redAccent,
                                                  ),
                                                  label: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                                  onPressed:
                                                      () =>
                                                          _confirmDelete(index),
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
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
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

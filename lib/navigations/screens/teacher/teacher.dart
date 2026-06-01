import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'AddNewTeacherPage.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  late final Stream<QuerySnapshot> _teachersStream;
  List<Map<String, dynamic>> teachers = [];
  int? _expandedIndex;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _teachersStream =
        FirebaseFirestore.instance.collection('teachers').snapshots();
  }

  Future<void> _addOrEditTeacher(
    Map<String, dynamic> teacher, {
    int? index,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacher['id'])
          .set(teacher);
    } catch (e, st) {
      debugPrint('Error saving teacher: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save teacher.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteTeacher(int index) async {
    final teacher = teachers[index];
    try {
      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacher['id'])
          .delete();
    } catch (e, st) {
      debugPrint('Error deleting teacher: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete teacher.'),
            backgroundColor: Colors.red,
          ),
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
          title: const Text('Delete Teacher'),
          content: const Text('Are you sure you want to delete this teacher?'),
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
        _deleteTeacher(index);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Teacher deleted')));
        }
      }
    });
  }

  void _toggleExpansion(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? null : index;
    });
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Teachers'), backgroundColor: blueColor),
      body: StreamBuilder<QuerySnapshot>(
        stream: _teachersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allDocs = snapshot.data!.docs;
          teachers =
              allDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();

          final query = searchQuery.toLowerCase();
          final filteredData =
              query.isEmpty
                  ? teachers
                  : teachers.where((t) {
                    return (t['name']?.toString().toLowerCase().contains(
                              query,
                            ) ??
                            false) ||
                        (t['email']?.toString().toLowerCase().contains(query) ??
                            false) ||
                        (t['department']?.toString().toLowerCase().contains(
                              query,
                            ) ??
                            false);
                  }).toList();

          if (filteredData.isEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                ),
                const Expanded(
                  child: Center(child: Text('No teachers found.')),
                ),
              ],
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (val) => setState(() => searchQuery = val),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final t = filteredData[index];
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
                                  : blueColor.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white24,
                                  radius: 24,
                                  child: Text(
                                    (t['name'] ?? 'T').isNotEmpty
                                        ? (t['name'] ?? 'T')
                                            .substring(0, 1)
                                            .toUpperCase()
                                        : 'T',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        t['name'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        t['designation'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            AnimatedCrossFade(
                              firstChild: const SizedBox(height: 0),
                              secondChild: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        isDark
                                            ? Colors.grey[850]
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow(
                                        'Department',
                                        t['department'] ?? '',
                                        isDark,
                                      ),
                                      _buildDetailRow(
                                        'Email',
                                        t['email'] ?? '',
                                        isDark,
                                      ),
                                      _buildDetailRow(
                                        'Phone',
                                        t['phone'] ?? '',
                                        isDark,
                                      ),
                                      _buildDetailRow(
                                        'Qualification',
                                        t['qualification'] ?? '',
                                        isDark,
                                      ),
                                      _buildDetailRow(
                                        'Specialization',
                                        t['specialization'] ?? '',
                                        isDark,
                                      ),
                                      _buildDetailRow(
                                        'Experience',
                                        '${t['experience']} years',
                                        isDark,
                                      ),
                                      _buildDetailRow(
                                        'Joining Date',
                                        t['joiningDate']
                                                ?.toString()
                                                .split(' ')
                                                .first ??
                                            '',
                                        isDark,
                                      ),
                                      const Divider(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton.icon(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                            label: const Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            onPressed: () async {
                                              final updated =
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (_) =>
                                                              AddNewTeacherPage(
                                                                teacherData: t,
                                                              ),
                                                    ),
                                                  );
                                              if (updated != null) {
                                                await _addOrEditTeacher(
                                                  updated,
                                                  index: index,
                                                );
                                              }
                                            },
                                          ),
                                          TextButton.icon(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            label: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            onPressed:
                                                () => _confirmDelete(index),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_teacher_fab',
        backgroundColor: blueColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNewTeacherPage()),
          );
          if (updated != null) {
            await _addOrEditTeacher(updated);
          }
        },
      ),
    );
  }
}

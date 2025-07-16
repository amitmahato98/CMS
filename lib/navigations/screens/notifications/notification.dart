import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Model for notifications
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String
  targetType; // "teacher", "student", "nonteaching", "parent" or "all"
  final List<String> recipientIds;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.targetType,
    required this.recipientIds,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'targetType': targetType,
      'recipientIds': recipientIds,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      targetType: json['targetType'],
      recipientIds: List<String>.from(json['recipientIds']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

// Teacher model
class Teachers {
  final String id;
  final String name;
  final String department;

  Teachers({required this.id, required this.name, required this.department});
}

// Student model
class Students {
  final String id;
  final String name;
  final String course;
  final int year;

  Students({
    required this.id,
    required this.name,
    required this.course,
    required this.year,
  });
}

// Non-Teaching Staff model
class NonTeachingStaff {
  final String id;
  final String name;
  final String role;
  final String department;

  NonTeachingStaff({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
  });
}

// Parent model
class Parents {
  final String id;
  final String name;
  final String studentName;
  final String studentId;
  final String contactNumber;

  Parents({
    required this.id,
    required this.name,
    required this.studentName,
    required this.studentId,
    required this.contactNumber,
  });
}

// Sample data
class MockDataService {
  static List<Teachers> getTeachers() {
    return [
      Teachers(id: 't1', name: 'Dr. Sharma', department: 'Computer Science'),
      Teachers(id: 't2', name: 'Prof. Gupta', department: 'Electronics'),
      Teachers(id: 't3', name: 'Dr. Patel', department: 'Mathematics'),
      Teachers(id: 't4', name: 'Prof. Kumar', department: 'Physics'),
      Teachers(id: 't5', name: 'Dr. Singh', department: 'Mechanical'),
    ];
  }

  static List<Students> getStudents() {
    return [
      Students(id: 's1', name: 'Amit Kumar', course: 'B.Tech CSE', year: 2),
      Students(id: 's2', name: 'Priya Sharma', course: 'B.Tech IT', year: 1),
      Students(id: 's3', name: 'Rahul Singh', course: 'B.Tech ECE', year: 3),
      Students(id: 's4', name: 'Neha Patel', course: 'B.Tech ME', year: 4),
      Students(id: 's5', name: 'Vikram Gupta', course: 'M.Tech CSE', year: 1),
      Students(id: 's6', name: 'Ananya Roy', course: 'M.Tech ECE', year: 2),
    ];
  }

  static List<NonTeachingStaff> getNonTeachingStaff() {
    return [
      NonTeachingStaff(
        id: 'n1',
        name: 'Ramesh Yadav',
        role: 'Lab Assistant',
        department: 'Computer Science',
      ),
      NonTeachingStaff(
        id: 'n2',
        name: 'Suresh Kumar',
        role: 'Security Guard',
        department: 'Administration',
      ),
      NonTeachingStaff(
        id: 'n3',
        name: 'Lakshmi Devi',
        role: 'Cleaner',
        department: 'Housekeeping',
      ),
      NonTeachingStaff(
        id: 'n4',
        name: 'Mohan Singh',
        role: 'Librarian',
        department: 'Library',
      ),
      NonTeachingStaff(
        id: 'n5',
        name: 'Rekha Patel',
        role: 'Administrative Assistant',
        department: 'Office',
      ),
    ];
  }

  static List<Parents> getParents() {
    return [
      Parents(
        id: 'p1',
        name: 'Mr. Rajesh Kumar',
        studentName: 'Amit Kumar',
        studentId: 's1',
        contactNumber: '9876543210',
      ),
      Parents(
        id: 'p2',
        name: 'Mrs. Anjali Sharma',
        studentName: 'Priya Sharma',
        studentId: 's2',
        contactNumber: '9876543211',
      ),
      Parents(
        id: 'p3',
        name: 'Mr. Vijay Singh',
        studentName: 'Rahul Singh',
        studentId: 's3',
        contactNumber: '9876543212',
      ),
      Parents(
        id: 'p4',
        name: 'Mrs. Meena Patel',
        studentName: 'Neha Patel',
        studentId: 's4',
        contactNumber: '9876543213',
      ),
      Parents(
        id: 'p5',
        name: 'Mr. Sanjay Gupta',
        studentName: 'Vikram Gupta',
        studentId: 's5',
        contactNumber: '9876543214',
      ),
      Parents(
        id: 'p6',
        name: 'Mrs. Kavita Roy',
        studentName: 'Ananya Roy',
        studentId: 's6',
        contactNumber: '9876543215',
      ),
    ];
  }
}

// SharedPreferences service for notifications
class NotificationStorageService {
  static const String _notificationsKey = 'college_notifications';

  // Save notification
  static Future<bool> saveNotification(NotificationModel notification) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> storedNotifications =
          prefs.getStringList(_notificationsKey) ?? [];

      // Add new notification
      storedNotifications.add(jsonEncode(notification.toJson()));

      // Save back to prefs
      return await prefs.setStringList(_notificationsKey, storedNotifications);
    } catch (e) {
      print('Error saving notification: $e');
      return false;
    }
  }

  // Get all notifications
  static Future<List<NotificationModel>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> storedNotifications =
          prefs.getStringList(_notificationsKey) ?? [];

      return storedNotifications
          .map(
            (notificationStr) =>
                NotificationModel.fromJson(jsonDecode(notificationStr)),
          )
          .toList()
        ..sort(
          (a, b) => b.timestamp.compareTo(a.timestamp),
        ); // Sort by newest first
    } catch (e) {
      print('Error retrieving notifications: $e');
      return [];
    }
  }
}

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({Key? key}) : super(key: key);

  @override
  _SendNotificationPageState createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedTargetType = 'all';
  List<String> _selectedTeacherIds = [];
  List<String> _selectedStudentIds = [];
  List<String> _selectedNonTeachingStaffIds = [];
  List<String> _selectedParentIds = [];

  bool _isSending = false;
  List<NotificationModel> _notificationHistory = [];
  bool _isLoading = true;

  // For history filter
  String _historyFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNotificationHistory();
  }

  Future<void> _loadNotificationHistory() async {
    setState(() {
      _isLoading = true;
    });

    _notificationHistory = await NotificationStorageService.getNotifications();

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleSelectAllTeachers(bool select) {
    if (select) {
      _selectedTeacherIds =
          MockDataService.getTeachers().map((t) => t.id).toList();
    } else {
      _selectedTeacherIds = [];
    }
    setState(() {});
  }

  void _toggleSelectAllStudents(bool select) {
    if (select) {
      _selectedStudentIds =
          MockDataService.getStudents().map((s) => s.id).toList();
    } else {
      _selectedStudentIds = [];
    }
    setState(() {});
  }

  void _toggleSelectAllNonTeachingStaff(bool select) {
    if (select) {
      _selectedNonTeachingStaffIds =
          MockDataService.getNonTeachingStaff().map((n) => n.id).toList();
    } else {
      _selectedNonTeachingStaffIds = [];
    }
    setState(() {});
  }

  void _toggleSelectAllParents(bool select) {
    if (select) {
      _selectedParentIds =
          MockDataService.getParents().map((p) => p.id).toList();
    } else {
      _selectedParentIds = [];
    }
    setState(() {});
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate at least one recipient is selected
    bool noRecipientsSelected = false;

    if (_selectedTargetType == 'teachers' && _selectedTeacherIds.isEmpty) {
      noRecipientsSelected = true;
    } else if (_selectedTargetType == 'students' &&
        _selectedStudentIds.isEmpty) {
      noRecipientsSelected = true;
    } else if (_selectedTargetType == 'nonteaching' &&
        _selectedNonTeachingStaffIds.isEmpty) {
      noRecipientsSelected = true;
    } else if (_selectedTargetType == 'parents' && _selectedParentIds.isEmpty) {
      noRecipientsSelected = true;
    } else if (_selectedTargetType == 'all' &&
        _selectedTeacherIds.isEmpty &&
        _selectedStudentIds.isEmpty &&
        _selectedNonTeachingStaffIds.isEmpty &&
        _selectedParentIds.isEmpty) {
      noRecipientsSelected = true;
    }

    if (noRecipientsSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one recipient'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // Combine recipient IDs based on target type
      List<String> recipientIds = [];
      if (_selectedTargetType == 'teachers' || _selectedTargetType == 'all') {
        recipientIds.addAll(_selectedTeacherIds);
      }
      if (_selectedTargetType == 'students' || _selectedTargetType == 'all') {
        recipientIds.addAll(_selectedStudentIds);
      }
      if (_selectedTargetType == 'nonteaching' ||
          _selectedTargetType == 'all') {
        recipientIds.addAll(_selectedNonTeachingStaffIds);
      }
      if (_selectedTargetType == 'parents' || _selectedTargetType == 'all') {
        recipientIds.addAll(_selectedParentIds);
      }

      // Create notification
      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        message: _messageController.text,
        targetType: _selectedTargetType,
        recipientIds: recipientIds,
        timestamp: DateTime.now(),
      );

      // Save notification
      bool success = await NotificationStorageService.saveNotification(
        notification,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification sent successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Reset form
        _titleController.clear();
        _messageController.clear();
        setState(() {
          _selectedTeacherIds = [];
          _selectedStudentIds = [];
          _selectedNonTeachingStaffIds = [];
          _selectedParentIds = [];
        });

        // Refresh history
        _loadNotificationHistory();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send notification'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Send Notifications'), Tab(text: 'History')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildSendNotificationTab(), _buildHistoryTab()],
      ),
    );
  }

  Widget _buildSendNotificationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Notification Title',
                hintText: 'Enter title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Message field
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Notification Message',
                hintText: 'Enter message',
                prefixIcon: Icon(Icons.message),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a message';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Target type selection
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send To:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    // Radio buttons for target selection
                    RadioListTile<String>(
                      title: const Text('Teachers Only'),
                      value: 'teachers',
                      groupValue: _selectedTargetType,
                      onChanged: (value) {
                        setState(() {
                          _selectedTargetType = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      title: const Text('Students Only'),
                      value: 'students',
                      groupValue: _selectedTargetType,
                      onChanged: (value) {
                        setState(() {
                          _selectedTargetType = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      title: const Text('Non-Teaching Staff Only'),
                      value: 'nonteaching',
                      groupValue: _selectedTargetType,
                      onChanged: (value) {
                        setState(() {
                          _selectedTargetType = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      title: const Text('Parents Only'),
                      value: 'parents',
                      groupValue: _selectedTargetType,
                      onChanged: (value) {
                        setState(() {
                          _selectedTargetType = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      title: const Text('All Groups'),
                      value: 'all',
                      groupValue: _selectedTargetType,
                      onChanged: (value) {
                        setState(() {
                          _selectedTargetType = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Teacher selection
            if (_selectedTargetType == 'teachers' ||
                _selectedTargetType == 'all')
              _buildTeacherSelection(),

            const SizedBox(height: 16),

            // Student selection
            if (_selectedTargetType == 'students' ||
                _selectedTargetType == 'all')
              _buildStudentSelection(),

            const SizedBox(height: 16),

            // Non-Teaching Staff selection
            if (_selectedTargetType == 'nonteaching' ||
                _selectedTargetType == 'all')
              _buildNonTeachingStaffSelection(),

            const SizedBox(height: 16),

            // Parents selection
            if (_selectedTargetType == 'parents' ||
                _selectedTargetType == 'all')
              _buildParentsSelection(),

            const SizedBox(height: 24),

            // Send button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSending ? null : _sendNotification,
                icon:
                    _isSending
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Icon(Icons.send),
                label: Text(_isSending ? 'Sending...' : 'Send Notification'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherSelection() {
    List<Teachers> teachers = MockDataService.getTeachers();
    bool allTeachersSelected =
        teachers.length == _selectedTeacherIds.length && teachers.isNotEmpty;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Teachers',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    Text(
                      'Select All',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Checkbox(
                      value: allTeachersSelected,
                      onChanged:
                          (value) => _toggleSelectAllTeachers(value ?? false),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                Teachers teacher = teachers[index];
                return CheckboxListTile(
                  title: Text(teacher.name),
                  subtitle: Text(teacher.department),
                  value: _selectedTeacherIds.contains(teacher.id),
                  onChanged: (selected) {
                    setState(() {
                      if (selected!) {
                        _selectedTeacherIds.add(teacher.id);
                      } else {
                        _selectedTeacherIds.remove(teacher.id);
                      }
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentSelection() {
    List<Students> students = MockDataService.getStudents();
    bool allStudentsSelected =
        students.length == _selectedStudentIds.length && students.isNotEmpty;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Students',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    Text(
                      'Select All',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Checkbox(
                      value: allStudentsSelected,
                      onChanged:
                          (value) => _toggleSelectAllStudents(value ?? false),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: students.length,
              itemBuilder: (context, index) {
                Students student = students[index];
                return CheckboxListTile(
                  title: Text(student.name),
                  subtitle: Text('${student.course} - Year ${student.year}'),
                  value: _selectedStudentIds.contains(student.id),
                  onChanged: (selected) {
                    setState(() {
                      if (selected!) {
                        _selectedStudentIds.add(student.id);
                      } else {
                        _selectedStudentIds.remove(student.id);
                      }
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNonTeachingStaffSelection() {
    List<NonTeachingStaff> staffList = MockDataService.getNonTeachingStaff();
    bool allStaffSelected =
        staffList.length == _selectedNonTeachingStaffIds.length &&
        staffList.isNotEmpty;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Non-Teaching Staff',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    Text(
                      'Select All',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Checkbox(
                      value: allStaffSelected,
                      onChanged:
                          (value) =>
                              _toggleSelectAllNonTeachingStaff(value ?? false),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: staffList.length,
              itemBuilder: (context, index) {
                NonTeachingStaff staff = staffList[index];
                return CheckboxListTile(
                  title: Text(staff.name),
                  subtitle: Text('${staff.role} - ${staff.department}'),
                  value: _selectedNonTeachingStaffIds.contains(staff.id),
                  onChanged: (selected) {
                    setState(() {
                      if (selected!) {
                        _selectedNonTeachingStaffIds.add(staff.id);
                      } else {
                        _selectedNonTeachingStaffIds.remove(staff.id);
                      }
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParentsSelection() {
    List<Parents> parents = MockDataService.getParents();
    bool allParentsSelected =
        parents.length == _selectedParentIds.length && parents.isNotEmpty;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Parents',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    Text(
                      'Select All',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Checkbox(
                      value: allParentsSelected,
                      onChanged:
                          (value) => _toggleSelectAllParents(value ?? false),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: parents.length,
              itemBuilder: (context, index) {
                Parents parent = parents[index];
                return CheckboxListTile(
                  title: Text(parent.name),
                  subtitle: Text(
                    'Parent of ${parent.studentName} (${parent.contactNumber})',
                  ),
                  value: _selectedParentIds.contains(parent.id),
                  onChanged: (selected) {
                    setState(() {
                      if (selected!) {
                        _selectedParentIds.add(parent.id);
                      } else {
                        _selectedParentIds.remove(parent.id);
                      }
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filter notifications based on selected filter
    List<NotificationModel> filteredNotifications = _notificationHistory;
    if (_historyFilter != 'all') {
      filteredNotifications =
          _notificationHistory.where((notification) {
            // Check if notification targetType matches filter directly
            if (notification.targetType == _historyFilter) {
              return true;
            }

            // If notification is for all users but we want to filter by specific type
            if (notification.targetType == 'all') {
              // Check if any recipient IDs match the filter prefix
              if (_historyFilter == 'teachers') {
                return notification.recipientIds.any(
                  (id) => id.startsWith('t'),
                );
              } else if (_historyFilter == 'students') {
                return notification.recipientIds.any(
                  (id) => id.startsWith('s'),
                );
              } else if (_historyFilter == 'nonteaching') {
                return notification.recipientIds.any(
                  (id) => id.startsWith('n'),
                );
              } else if (_historyFilter == 'parents') {
                return notification.recipientIds.any(
                  (id) => id.startsWith('p'),
                );
              }
            }
            return false;
          }).toList();
    }

    if (filteredNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white38
                      : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _notificationHistory.isEmpty
                  ? 'No notification history yet'
                  : 'No notifications found for selected filter',
              style: TextStyle(
                fontSize: 18,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationCard(filteredNotifications[index]);
      },
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _historyFilter == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _historyFilter = value;
        });
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[700]
              : Colors.grey[300],
      labelStyle: TextStyle(
        color:
            isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    final recipients = _formatRecipients(notification);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            _getIconForTargetType(notification.targetType),
            color: Colors.white,
          ),
        ),
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              recipients,
              style: TextStyle(
                fontSize: 12,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDateTime(notification.timestamp),
              style: TextStyle(
                fontSize: 12,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
              ),
            ),
          ],
        ),
        children: [Text(notification.message)],
      ),
    );
  }

  IconData _getIconForTargetType(String targetType) {
    switch (targetType) {
      case 'teachers':
        return Icons.school;
      case 'students':
        return Icons.person;
      case 'nonteaching':
        return Icons.work;
      case 'parents':
        return Icons.family_restroom;
      case 'all':
      default:
        return Icons.people;
    }
  }

  String _formatRecipients(NotificationModel notification) {
    int totalRecipients = notification.recipientIds.length;

    if (totalRecipients == 0) {
      return 'No recipients';
    }

    // Count different recipient types
    int teacherCount = 0;
    int studentCount = 0;
    int staffCount = 0;
    int parentCount = 0;

    for (var id in notification.recipientIds) {
      if (id.startsWith('t'))
        teacherCount++;
      else if (id.startsWith('s'))
        studentCount++;
      else if (id.startsWith('n'))
        staffCount++;
      else if (id.startsWith('p'))
        parentCount++;
    }

    if (notification.targetType == 'teachers') {
      return 'Sent to $teacherCount teachers';
    } else if (notification.targetType == 'students') {
      return 'Sent to $studentCount students';
    } else if (notification.targetType == 'nonteaching') {
      return 'Sent to $staffCount non-teaching staff';
    } else if (notification.targetType == 'parents') {
      return 'Sent to $parentCount parents';
    } else {
      // Build string for mixed recipients
      List<String> recipientGroups = [];
      if (teacherCount > 0) {
        recipientGroups.add('$teacherCount teachers');
      }
      if (studentCount > 0) {
        recipientGroups.add('$studentCount students');
      }
      if (staffCount > 0) {
        recipientGroups.add('$staffCount non-teaching staff');
      }
      if (parentCount > 0) {
        recipientGroups.add('$parentCount parents');
      }

      return 'Sent to ' + recipientGroups.join(', ');
    }
  }

  String _formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String time =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    if (dateOnly == today) {
      return 'Today, $time';
    } else if (dateOnly == yesterday) {
      return 'Yesterday, $time';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}, $time';
    }
  }
}

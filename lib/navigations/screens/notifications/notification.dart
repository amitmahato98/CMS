import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cms/theme/theme_provider.dart';

// Models
class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? department;
  final String? semester;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.department,
    this.semester,
  });
}

class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String senderName;
  final List<String> recipientIds;
  final NotificationType type;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.senderName,
    required this.recipientIds,
    required this.type,
  });
}

enum NotificationType { urgent, announcement, event, reminder, general }

// Service for notifications
class NotificationService {
  // Simulate backend service
  Future<bool> sendNotification(Notification notification) async {
    // Here you would integrate with your actual backend service
    // This is a mock implementation
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  // Get notification history
  Future<List<Notification>> getNotificationHistory() async {
    // Mock implementation
    await Future.delayed(Duration(milliseconds: 800));
    return [
      Notification(
        id: '1',
        title: 'Exam Schedule Released',
        message:
            'The final examination schedule for this semester has been published.',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        senderName: 'Admin',
        recipientIds: ['all-students'],
        type: NotificationType.announcement,
      ),
      Notification(
        id: '2',
        title: 'Faculty Meeting',
        message:
            'Reminder: Faculty meeting tomorrow at 2:00 PM in the conference room.',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        senderName: 'Admin',
        recipientIds: ['all-teachers'],
        type: NotificationType.reminder,
      ),
    ];
  }

  // Get mock users for demonstration
  Future<List<User>> getUsers() async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      User(
        id: 't1',
        name: 'Dr. Sarah Johnson',
        email: 'sarah.johnson@college.edu',
        role: 'teacher',
        department: 'Computer Science',
      ),
      User(
        id: 't2',
        name: 'Prof. Michael Chen',
        email: 'michael.chen@college.edu',
        role: 'teacher',
        department: 'Mathematics',
      ),
      User(
        id: 't3',
        name: 'Dr. Emily Rodriguez',
        email: 'emily.rodriguez@college.edu',
        role: 'teacher',
        department: 'Physics',
      ),
      User(
        id: 's1',
        name: 'John Smith',
        email: 'john.smith@college.edu',
        role: 'student',
        department: 'Computer Science',
        semester: '4',
      ),
      User(
        id: 's2',
        name: 'Emma Williams',
        email: 'emma.williams@college.edu',
        role: 'student',
        department: 'Physics',
        semester: '2',
      ),
      User(
        id: 's3',
        name: 'Alex Johnson',
        email: 'alex.johnson@college.edu',
        role: 'student',
        department: 'Mathematics',
        semester: '6',
      ),
    ];
  }

  // Get departments
  Future<List<String>> getDepartments() async {
    await Future.delayed(Duration(milliseconds: 300));
    return [
      'Computer Science',
      'Mathematics',
      'Physics',
      'Chemistry',
      'Engineering',
    ];
  }

  // Get semesters
  Future<List<String>> getSemesters() async {
    await Future.delayed(Duration(milliseconds: 300));
    return ['1', '2', '3', '4', '5', '6', '7', '8'];
  }
}

// Provider for notification state
class NotificationProvider with ChangeNotifier {
  final NotificationService _service = NotificationService();
  List<User> _allUsers = [];
  List<User> _selectedUsers = [];
  List<String> _departments = [];
  List<String> _semesters = [];
  List<Notification> _notificationHistory = [];
  bool _isLoading = false;
  String _selectedDepartment = 'All';
  String _selectedSemester = 'All';
  String _selectedRole = 'All';

  List<User> get allUsers => _allUsers;
  List<User> get selectedUsers => _selectedUsers;
  List<User> get filteredUsers {
    List<User> filtered = List.from(_allUsers);

    // Apply role filter
    if (_selectedRole != 'All') {
      filtered =
          filtered
              .where((user) => user.role == _selectedRole.toLowerCase())
              .toList();
    }

    // Apply department filter
    if (_selectedDepartment != 'All') {
      filtered =
          filtered
              .where((user) => user.department == _selectedDepartment)
              .toList();
    }

    // Apply semester filter (only for students)
    if (_selectedSemester != 'All') {
      filtered =
          filtered
              .where(
                (user) =>
                    user.role != 'student' ||
                    user.semester == _selectedSemester,
              )
              .toList();
    }

    return filtered;
  }

  List<String> get departments => ['All', ..._departments];
  List<String> get semesters => ['All', ..._semesters];
  List<Notification> get notificationHistory => _notificationHistory;
  bool get isLoading => _isLoading;
  String get selectedDepartment => _selectedDepartment;
  String get selectedSemester => _selectedSemester;
  String get selectedRole => _selectedRole;

  Future<void> loadInitialData() async {
    _setLoading(true);

    try {
      _allUsers = await _service.getUsers();
      _departments = await _service.getDepartments();
      _semesters = await _service.getSemesters();
      _notificationHistory = await _service.getNotificationHistory();
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      _setLoading(false);
    }
  }

  void setSelectedRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  void setSelectedDepartment(String department) {
    _selectedDepartment = department;
    notifyListeners();
  }

  void setSelectedSemester(String semester) {
    _selectedSemester = semester;
    notifyListeners();
  }

  void toggleUserSelection(User user) {
    if (_selectedUsers.any((u) => u.id == user.id)) {
      _selectedUsers.removeWhere((u) => u.id == user.id);
    } else {
      _selectedUsers.add(user);
    }
    notifyListeners();
  }

  void selectAllFilteredUsers() {
    List<User> filtered = filteredUsers;

    // Check if all filtered users are already selected
    bool allSelected = filtered.every(
      (user) =>
          _selectedUsers.any((selectedUser) => selectedUser.id == user.id),
    );

    if (allSelected) {
      // Deselect all filtered users
      _selectedUsers.removeWhere(
        (selectedUser) => filtered.any((user) => user.id == selectedUser.id),
      );
    } else {
      // Add all filtered users that aren't already selected
      for (var user in filtered) {
        if (!_selectedUsers.any((selectedUser) => selectedUser.id == user.id)) {
          _selectedUsers.add(user);
        }
      }
    }

    notifyListeners();
  }

  void clearSelection() {
    _selectedUsers.clear();
    notifyListeners();
  }

  Future<bool> sendNotification({
    required String title,
    required String message,
    required NotificationType type,
  }) async {
    if (_selectedUsers.isEmpty) return false;

    _setLoading(true);
    try {
      // Create notification object
      final notification = Notification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        message: message,
        timestamp: DateTime.now(),
        senderName: 'Admin',
        recipientIds: _selectedUsers.map((user) => user.id).toList(),
        type: type,
      );

      // Send notification
      final result = await _service.sendNotification(notification);

      if (result) {
        // Add to history
        _notificationHistory.insert(0, notification);
        notifyListeners();
      }

      return result;
    } catch (e) {
      print('Error sending notification: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

// Main notification management screen
class SendNotification extends StatefulWidget {
  @override
  _SendNotificationState createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load initial data when the screen is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).loadInitialData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Send Notifications', icon: Icon(Icons.send)),
            Tab(text: 'History', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ],
        child: TabBarView(
          controller: _tabController,
          children: [SendNotificationTab(), NotificationHistoryTab()],
        ),
      ),
    );
  }
}

// Tab for sending notifications
class SendNotificationTab extends StatefulWidget {
  @override
  _SendNotificationTabState createState() => _SendNotificationTabState();
}

class _SendNotificationTabState extends State<SendNotificationTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  NotificationType _selectedType = NotificationType.general;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return notificationProvider.isLoading &&
            notificationProvider.allUsers.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Column(
          children: [
            FilterSection(),
            RecipientSelectionSection(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notification Details',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          prefixIcon: Icon(Icons.title),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: 'Message',
                          prefixIcon: Icon(Icons.message),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a message';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Notification Type',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      NotificationTypeSelector(
                        selectedType: _selectedType,
                        onTypeSelected: (type) {
                          setState(() {
                            _selectedType = type;
                          });
                        },
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.send),
                          label: Text('Send Notification'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed:
                              notificationProvider.selectedUsers.isEmpty
                                  ? null
                                  : () => _sendNotification(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
  }

  Future<void> _sendNotification(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    if (notificationProvider.selectedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one recipient')),
      );
      return;
    }

    final success = await notificationProvider.sendNotification(
      title: _titleController.text.trim(),
      message: _messageController.text.trim(),
      type: _selectedType,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification sent successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _titleController.clear();
      _messageController.clear();
      setState(() {
        _selectedType = NotificationType.general;
      });

      // Clear selection if needed
      notificationProvider.clearSelection();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send notification. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Filter section for filtering users
class FilterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF151515) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list,
                color: themeProvider.currentTheme.primaryColor,
              ),
              SizedBox(width: 8),
              Text(
                'Filter Recipients',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildRoleFilter(context),
                SizedBox(width: 12),
                _buildDepartmentFilter(context),
                SizedBox(width: 12),
                if (notificationProvider.selectedRole == 'All' ||
                    notificationProvider.selectedRole == 'Students')
                  _buildSemesterFilter(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleFilter(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              themeProvider.isDarkMode ? Color(0xFF2A2A2A) : Colors.grey[300]!,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: notificationProvider.selectedRole,
          items:
              ['All', 'Teachers', 'Students'].map((role) {
                return DropdownMenuItem<String>(value: role, child: Text(role));
              }).toList(),
          onChanged: (value) {
            if (value != null) {
              notificationProvider.setSelectedRole(value);
            }
          },
          hint: Text('Select Role'),
          icon: Icon(
            Icons.arrow_drop_down,
            color: themeProvider.currentTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDepartmentFilter(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              themeProvider.isDarkMode ? Color(0xFF2A2A2A) : Colors.grey[300]!,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: notificationProvider.selectedDepartment,
          items:
              notificationProvider.departments.map((department) {
                return DropdownMenuItem<String>(
                  value: department,
                  child: Text(department),
                );
              }).toList(),
          onChanged: (value) {
            if (value != null) {
              notificationProvider.setSelectedDepartment(value);
            }
          },
          hint: Text('Select Department'),
          icon: Icon(
            Icons.arrow_drop_down,
            color: themeProvider.currentTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSemesterFilter(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              themeProvider.isDarkMode ? Color(0xFF2A2A2A) : Colors.grey[300]!,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: notificationProvider.selectedSemester,
          items:
              notificationProvider.semesters.map((semester) {
                return DropdownMenuItem<String>(
                  value: semester,
                  child: Text(semester),
                );
              }).toList(),
          onChanged: (value) {
            if (value != null) {
              notificationProvider.setSelectedSemester(value);
            }
          },
          hint: Text('Select Semester'),
          icon: Icon(
            Icons.arrow_drop_down,
            color: themeProvider.currentTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}

// Section for selecting recipients
class RecipientSelectionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people,
                    color: themeProvider.currentTheme.primaryColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Recipients',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    icon: Icon(Icons.select_all),
                    label: Text('Select All'),
                    onPressed: () {
                      notificationProvider.selectAllFilteredUsers();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton.icon(
                    icon: Icon(Icons.clear_all),
                    label: Text('Clear All'),
                    onPressed:
                        notificationProvider.selectedUsers.isEmpty
                            ? null
                            : () {
                              notificationProvider.clearSelection();
                            },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${notificationProvider.selectedUsers.length} recipients selected',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode ? Color(0xFF2A2A2A) : Colors.grey[300]!,
              ),
            ),
            child:
                notificationProvider.filteredUsers.isEmpty
                    ? Center(
                      child: Text(
                        'No users match the selected filters',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    )
                    : ListView.builder(
                      itemCount: notificationProvider.filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = notificationProvider.filteredUsers[index];
                        final isSelected = notificationProvider.selectedUsers
                            .any((u) => u.id == user.id);

                        return ListTile(
                          title: Text(user.name),
                          subtitle: Text(
                            user.role.capitalize() +
                                (user.department != null
                                    ? ' - ${user.department}'
                                    : '') +
                                (user.semester != null
                                    ? ' (Semester ${user.semester})'
                                    : ''),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: themeProvider
                                .currentTheme
                                .primaryColor
                                .withOpacity(0.8),
                            child: Text(
                              user.name.substring(0, 1),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (_) {
                              notificationProvider.toggleUserSelection(user);
                            },
                            activeColor:
                                themeProvider.currentTheme.primaryColor,
                          ),
                          onTap: () {
                            notificationProvider.toggleUserSelection(user);
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

// Notification type selector
class NotificationTypeSelector extends StatelessWidget {
  final NotificationType selectedType;
  final Function(NotificationType) onTypeSelected;

  const NotificationTypeSelector({
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            NotificationType.values.map((type) {
              final isSelected = type == selectedType;

              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_getTypeLabel(type)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      onTypeSelected(type);
                    }
                  },
                  avatar: Icon(
                    _getTypeIcon(type),
                    color:
                        isSelected
                            ? Colors.white
                            : isDarkMode
                            ? Colors.white70
                            : Colors.black87,
                    size: 18,
                  ),
                  backgroundColor:
                      isDarkMode ? Color(0xFF1A1A1A) : Colors.grey[200],
                  selectedColor: _getTypeColor(type),
                  labelStyle: TextStyle(
                    color:
                        isSelected
                            ? Colors.white
                            : isDarkMode
                            ? Colors.white70
                            : Colors.black87,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              );
            }).toList(),
      ),
    );
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.urgent:
        return 'Urgent';
      case NotificationType.announcement:
        return 'Announcement';
      case NotificationType.event:
        return 'Event';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.general:
        return 'General';
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.urgent:
        return Icons.priority_high;
      case NotificationType.announcement:
        return Icons.campaign;
      case NotificationType.event:
        return Icons.event;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.urgent:
        return Colors.red;
      case NotificationType.announcement:
        return Colors.blue;
      case NotificationType.event:
        return Colors.purple;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.general:
        return Colors.green;
    }
  }
}

// Tab for notification history
class NotificationHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    if (notificationProvider.isLoading &&
        notificationProvider.notificationHistory.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (notificationProvider.notificationHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: isDarkMode ? Colors.white38 : Colors.black26,
            ),
            SizedBox(height: 16),
            Text(
              'No notification history yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: notificationProvider.notificationHistory.length,
      itemBuilder: (context, index) {
        final notification = notificationProvider.notificationHistory[index];
        return NotificationHistoryCard(notification: notification);
      },
    );
  }
}

// Card for displaying notification history
class NotificationHistoryCard extends StatelessWidget {
  final Notification notification;

  const NotificationHistoryCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: _getTypeColor(notification.type).withOpacity(0.8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    _getTypeIcon(notification.type),
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    _getTypeLabel(notification.type),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    _formatDate(notification.timestamp),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    notification.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: isDarkMode ? Colors.white54 : Colors.black54,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Sent by: ${notification.senderName}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white54 : Colors.black54,
                        ),
                      ),
                      Spacer(),
                      Text(
                        _getRecipientInfo(notification),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _getRecipientInfo(Notification notification) {
    if (notification.recipientIds.contains('all-students')) {
      return 'To: All Students';
    } else if (notification.recipientIds.contains('all-teachers')) {
      return 'To: All Teachers';
    } else {
      return 'To: ${notification.recipientIds.length} recipients';
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.urgent:
        return Icons.priority_high;
      case NotificationType.announcement:
        return Icons.campaign;
      case NotificationType.event:
        return Icons.event;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.urgent:
        return 'Urgent';
      case NotificationType.announcement:
        return 'Announcement';
      case NotificationType.event:
        return 'Event';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.general:
        return 'General';
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.urgent:
        return Colors.red;
      case NotificationType.announcement:
        return Colors.blue;
      case NotificationType.event:
        return Colors.purple;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.general:
        return Colors.green;
    }
  }
}

// Extension for string capitalization
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

// Widget to integrate the notification system into your app
class SendNotificationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'College Admin - Notifications',
            theme: themeProvider.currentTheme,
            home: SendNotification(),
          );
        },
      ),
    );
  }
}

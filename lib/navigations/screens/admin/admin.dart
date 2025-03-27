import 'package:cms/datatypes/datatypes.dart';
import 'package:cms/navigations/screens/admin/addstudentPage.dart'; // Fix import
import 'package:cms/navigations/screens/admin/announcementpage.dart';
import 'package:cms/navigations/screens/admin/eventdetails.dart';
import 'package:cms/navigations/screens/admin/more_recentactivities.dart';
import 'package:cms/navigations/screens/admin/notiications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cms/theme/theme_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> students = []; // Initialize empty list
  DateTime selectedMonth = DateTime.now(); // Add this line

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            color: theme.colorScheme.primary,
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    'Administrator Dashboard',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color: theme.colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const NotificationsScreen(),
                              ),
                            );
                          });
                        },
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '5',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsSection(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Recent Activities'),
                        _buildActivityList(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Upcoming Events'),
                        _buildEventCalendar(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Quick Actions'),
                        _buildQuickActionPanel(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('System Status'),
                        _buildSystemStatusPanel(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex < 5 ? _selectedIndex : 0,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: isDarkMode ? Colors.white70 : Colors.grey[600],
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Finance'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Faculty'),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Dashboard Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Students',
                  '1108',
                  Icons.people,
                  theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Faculty Members',
                  '68',
                  Icons.school,
                  Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Active Courses',
                  '42',
                  Icons.book,
                  Colors.orange.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Pending Actions',
                  '7',
                  Icons.pending_actions,
                  Colors.red.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor:
                  isDarkMode ? Color(0xFF2A2A2A) : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton.icon(
            icon: Icon(
              Icons.refresh,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            label: Text(
              'Refresh',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListView.separated(
        itemCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        separatorBuilder:
            (context, index) => Divider(
              height: 1.0,
              color: isDarkMode ? Color(0xFF2A2A2A) : Colors.grey[300],
            ),
        itemBuilder: (context, index) {
          Color iconBgColor =
              index % 3 == 0
                  ? Colors.blue.shade100.withOpacity(isDarkMode ? 0.3 : 1.0)
                  : index % 3 == 1
                  ? Colors.green.shade100.withOpacity(isDarkMode ? 0.3 : 1.0)
                  : Colors.orange.shade100.withOpacity(isDarkMode ? 0.3 : 1.0);

          Color iconColor =
              index % 3 == 0
                  ? Colors.blue.shade700
                  : index % 3 == 1
                  ? Colors.green.shade700
                  : Colors.orange.shade700;

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: iconBgColor,
              child: Icon(
                index % 3 == 0
                    ? Icons.person_add
                    : index % 3 == 1
                    ? Icons.edit_document
                    : Icons.payment,
                color: iconColor,
                size: 20,
              ),
            ),
            title: Text(
              index % 3 == 0
                  ? 'New student registered'
                  : index % 3 == 1
                  ? 'Course syllabus updated'
                  : 'Tuition payment received',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'By ${index % 3 == 0 ? 'System' : 'Admin User'} • ${index * 2 + 1} hours ago',
              style: TextStyle(
                color: isDarkMode ? Colors.white60 : Colors.grey[600],
                fontSize: 12,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.info_sharp),
              color: iconColor,
              onPressed: () {
                final RecentActivity activity = RecentActivity(
                  title:
                      index % 3 == 0
                          ? 'New student registered'
                          : index % 3 == 1
                          ? 'Course syllabus updated'
                          : 'Tuition payment received',
                  subtitle:
                      'By ${index % 3 == 0 ? 'System' : 'Admin User'} • ${index * 2} hours ago',
                  icon:
                      index % 3 == 0
                          ? Icons.person_add
                          : index % 3 == 1
                          ? Icons.edit_document
                          : Icons.payment,
                  iconBackgroundColor:
                      index % 3 == 0
                          ? Colors.blue.shade100
                          : index % 3 == 1
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                  iconColor:
                      index % 3 == 0
                          ? Colors.blue.shade700
                          : index % 3 == 1
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                  time: DateTime.now().subtract(Duration(hours: index * 2 + 1)),
                  details:
                      index % 3 == 0
                          ? {
                            "Student Name": "Student ${index + 1}",
                            "Student ID": "S2023${100 + index}",
                            "Course": "Computer Science",
                            "Email": "student${index + 1}@mail.com",
                            "Phone": "+977 98 0123-456${index}",
                            "Address":
                                "${index + 1}23 College, University Town",
                            "Registration Date": "March 23, 2025",
                          }
                          : index % 3 == 1
                          ? {
                            "Course": "Course ${index + 1}",
                            "Course Code": "CSC${300 + index}",
                            "Updated By": "Prof. Sushanti Mandi",
                            "Major Changes": "Updated content for Spring 2025",
                            "Previous Version": "v2.0",
                            "Current Version": "v2.1",
                            "Effective Date": "April 1, 2025",
                          }
                          : {
                            "Student": "Student ${index + 1}",
                            "Student ID": "S2022${50 + index}",
                            "Amount": "NPR ${1000 + index * 100}.00",
                            "Payment Method": "Online Transfer",
                            "Transaction ID": "TRX${78945612 + index}",
                            "Payment Date": "March 23, 2025",
                            "Semester": "Spring 2025",
                          },
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ActivityDetailScreen(activity: activity),
                  ),
                );
              },
            ),
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget _buildEventCalendar() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(selectedMonth),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          selectedMonth = DateTime(
                            selectedMonth.year,
                            selectedMonth.month - 1,
                            1,
                          );
                        });
                      },
                      iconSize: 20,
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          selectedMonth = DateTime(
                            selectedMonth.year,
                            selectedMonth.month + 1,
                            1,
                          );
                        });
                      },
                      iconSize: 20,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final String eventTitle =
                    index == 0
                        ? 'Faculty Meeting'
                        : index == 1
                        ? 'Semester Registration Deadline'
                        : index == 2
                        ? 'Campus Tour for New Students'
                        : 'Board Review Meeting';

                Color eventColor =
                    index % 2 == 0 ? theme.colorScheme.primary : Colors.orange;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EventDetailsPage(
                              eventIndex: index,
                              eventTitle: eventTitle,
                            ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: eventColor.withOpacity(isDarkMode ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: eventColor.withOpacity(isDarkMode ? 0.3 : 0.2),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${index + 22}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'MAR',
                                style: TextStyle(
                                  color:
                                      isDarkMode
                                          ? Colors.white60
                                          : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eventTitle,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                index == 0
                                    ? '9:00 AM - 11:00 AM • Conference Room'
                                    : index == 1
                                    ? 'All Day • Online Portal'
                                    : index == 2
                                    ? '2:00 PM - 4:00 PM • Main Campus'
                                    : '10:00 AM - 12:00 PM • Admin Building',
                                style: TextStyle(
                                  color:
                                      isDarkMode
                                          ? Colors.white60
                                          : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color color, {
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildQuickActionPanel() {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildQuickActionButton(
              'Add New Student',
              Icons.person_add,
              Colors.blue,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNewStudentPage(),
                  ),
                );

                if (result != null && mounted) {
                  setState(() {
                    students.add(result);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Student added successfully!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            _buildQuickActionButton(
              'Create Announcement',
              Icons.announcement,
              Colors.orange,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateAnnouncementPage(),
                  ),
                );
              },
            ),
            _buildQuickActionButton(
              'Generate Reports',
              Icons.assessment,
              Colors.purple,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateAnnouncementPage(),
                  ),
                );
              },
            ),
            _buildQuickActionButton(
              'Manage Faculty',
              Icons.people,
              Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateAnnouncementPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatusPanel() {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatusItem('Server Status', 'Online', Colors.green),
            _buildStatusItem('Database', 'Healthy', Colors.green),
            _buildStatusItem('Storage', '75% Used', Colors.orange),
            _buildStatusItem('Backup', 'Last: 1 day ago', Colors.blue),
            _buildStatusItem('Security', 'No threats detected', Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String title, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: color.withOpacity(0.3), width: 1.0),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

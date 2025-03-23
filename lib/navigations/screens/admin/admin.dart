import 'package:cms/datatypes/datatypes.dart';
import 'package:cms/navigations/screens/admin/more_recentactivities.dart';
import 'package:cms/navigations/screens/admin/notiications.dart';
import 'package:flutter/material.dart';

// Color Constants

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  // bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // Using drawer for navigation instead of a row-based layout
      drawer: Drawer(
        elevation: 16.0, // Increase elevation for better shadow
        width:
            MediaQuery.of(context).size.width *
            0.75, // Set width to 75% of screen
        child: Container(
          color: darkBlack,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: darkBlack),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: darkBlue,
                          radius: 24,
                          child: const Text(
                            'CM',
                            style: TextStyle(
                              color: cardTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'College Manager',
                            style: TextStyle(
                              color: cardTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Admin Info
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/img1profile.jpg',
                          ),

                          radius: 16,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin User',
                                style: TextStyle(
                                  color: cardTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'admin@college.edu',
                                style: TextStyle(
                                  color: grayColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Navigation Items
              _buildNavItem(0, Icons.dashboard, 'Dashboard'),
              _buildNavItem(1, Icons.people, 'Students'),
              _buildNavItem(2, Icons.school, 'Faculty'),
              _buildNavItem(3, Icons.book, 'Courses'),
              _buildNavItem(4, Icons.calendar_today, 'Schedule'),
              _buildNavItem(5, Icons.payment, 'Finance'),
              _buildNavItem(6, Icons.assessment, 'Reports'),
              _buildNavItem(7, Icons.announcement, 'Announcements'),
              _buildNavItem(8, Icons.settings, 'Settings'),

              // Logout option at bottom
              const Divider(color: grayColor),
              ListTile(
                leading: const Icon(Icons.logout, color: grayColor),
                title: const Text('Logout', style: TextStyle(color: grayColor)),
                onTap: () {
                  // Implement logout function
                },
              ),
            ],
          ),
        ),
      ),
      // Main content
      body: Column(
        children: [
          // App Bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            color: blueColor,
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Builder(
                    builder:
                        (context) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                  ),
                  const Text(
                    'Administrator Dashboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkBlack,
                    ),
                  ),
                  const Spacer(),
                  // Action Buttons
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        color: Colors.white,
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
                          child: const Text(
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

          // Main content - Use Expanded to fill available space
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Section
                  _buildStatsSection(),

                  // Activity Section
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

                  // Calendar Section
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

                  // Quick Actions
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

                  // System Status
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

                  // Bottom padding
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation as an alternative for Android
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex < 5 ? _selectedIndex : 0,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: blueColor,
        unselectedItemColor: grayColor,
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

  Widget _buildNavItem(int index, IconData icon, String title) {
    final bool isSelected = index == _selectedIndex;
    return ListTile(
      leading: Icon(icon, color: isSelected ? blueColor : grayColor),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? cardTextColor : grayColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          _selectedIndex = index;
          Navigator.pop(context); // Close drawer after selection
        });
      },
      selectedTileColor: darkBlue.withOpacity(0.2),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Dashboard Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Two stats in one row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Students',
                  '1,250',
                  Icons.people,
                  Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Faculty Members',
                  '85',
                  Icons.school,
                  Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Two more stats in one row
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
                  style: const TextStyle(
                    color: grayColor,
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
              backgroundColor: lightGrayColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton.icon(
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Refresh'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListView.separated(
        itemCount: 5,
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // Prevent nested scrolling issues
        padding: const EdgeInsets.all(16.0),
        separatorBuilder:
            (context, index) =>
                const Divider(height: 1.0, color: lightGrayColor),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  index % 3 == 0
                      ? Colors.blue.shade100
                      : index % 3 == 1
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
              child: Icon(
                index % 3 == 0
                    ? Icons.person_add
                    : index % 3 == 1
                    ? Icons.edit_document
                    : Icons.payment,
                color:
                    index % 3 == 0
                        ? Colors.blue.shade700
                        : index % 3 == 1
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                size: 20,
              ),
            ),
            title: Text(
              index % 3 == 0
                  ? 'New student registered'
                  : index % 3 == 1
                  ? 'Course syllabus updated'
                  : 'Tuition payment received',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'By ${index % 3 == 0 ? 'System' : 'Admin User'} • ${index * 2 + 1} hours ago',
              style: const TextStyle(color: grayColor, fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),

              onPressed: () {
                // Create a RecentActivity object based on the current list item
                final RecentActivity activity = RecentActivity(
                  title:
                      index % 3 == 0
                          ? 'New student registered'
                          : index % 3 == 1
                          ? 'Course syllabus updated'
                          : 'Tuition payment received',
                  subtitle:
                      'By ${index % 3 == 0 ? 'System' : 'Admin User'} • ${index * 2 + 1} hours ago',
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
                            "Registration Date": "March 23, 2025",
                            "Email": "student${index + 1}@mail.com",
                            "Phone": "+1 (555) 123-456${index}",
                            "Address":
                                "${index + 1}23 College, University Town",
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
                            "Amount": "\nNPR ${1000 + index * 100}.00",
                            "Payment Method": "Online Transfer",
                            "Transaction ID": "TRX${78945612 + index}",
                            "Payment Date": "March 23, 2025",
                            "Semester": "Spring 2025",
                          },
                );

                // Navigate directly to the detail screen for this activity
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
                const Text(
                  'March 2025',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {},
                      iconSize: 20,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {},
                      iconSize: 20,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Events List - Use ListView.builder with shrinkWrap to avoid scrolling issues
            ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Prevent nested scrolling issues
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color:
                        index % 2 == 0
                            ? darkBlue.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color:
                          index % 2 == 0
                              ? darkBlue.withOpacity(0.2)
                              : Colors.orange.withOpacity(0.2),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${index + 22}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Text(
                              'MAR',
                              style: TextStyle(color: grayColor, fontSize: 12),
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
                              index == 0
                                  ? 'Faculty Meeting'
                                  : index == 1
                                  ? 'Semester Registration Deadline'
                                  : index == 2
                                  ? 'Campus Tour for New Students'
                                  : 'Board Review Meeting',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
                              style: const TextStyle(
                                color: grayColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
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
            ),
            _buildQuickActionButton(
              'Create Announcement',
              Icons.campaign,
              Colors.orange,
            ),
            _buildQuickActionButton(
              'Generate Reports',
              Icons.assessment,
              Colors.purple,
            ),
            _buildQuickActionButton(
              'Manage Faculty',
              Icons.people,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, Color color) {
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
        onPressed: () {},
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

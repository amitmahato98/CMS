import 'package:cms/navigations/screens/chat/teacher/ChatHomeScreen.dart';
import 'package:cms/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Teacherchat extends StatefulWidget {
  @override
  _TeacherchatState createState() => _TeacherchatState();
}

class _TeacherchatState extends State<Teacherchat> {
  int _currentIndex = 0;
  final bool _isAdmin = true; // Set this based on authentication

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Dashboard(isAdmin: _isAdmin),
          ChatHomeScreen(isAdmin: _isAdmin),
          AttendanceChatSection(),
          TeacherProfileScreen(isAdmin: _isAdmin),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: isDarkMode ? Colors.white60 : Colors.grey[600],
        backgroundColor: isDarkMode ? Color(0xFF0A0A0A) : Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Dashboard Placeholder
class Dashboard extends StatelessWidget {
  final bool isAdmin;

  const Dashboard({Key? key, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Admin Dashboard' : 'Teacher Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Show notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              // Toggle theme
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Center(child: Text('Dashboard Content')),
    );
  }
}

// Profile Screen Placeholder
class TeacherProfileScreen extends StatelessWidget {
  final bool isAdmin;

  const TeacherProfileScreen({Key? key, required this.isAdmin})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Profile Content')),
    );
  }
}

import 'package:cms/navigations/screens/attendence/attendanceAnalitycs.dart';
import 'package:cms/navigations/screens/attendence/attendanceSetting.dart';
import 'package:cms/navigations/screens/attendence/attendenceInterface.dart';
import 'package:cms/navigations/screens/attendence/attendenceReport.dart';
import 'package:cms/theme/theme_provider.dart';
import 'package:flutter/material.dart';

class AttendanceDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceAnalyticsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceReportsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats Cards
            _buildQuickStatsSection(context),

            SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            _buildQuickActionsGrid(context),

            SizedBox(height: 24),

            // Recent Activity
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            _buildRecentActivityList(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TakeAttendanceScreen()),
          );
        },
        icon: Icon(Icons.how_to_reg),
        label: Text('Take Attendance'),
      ),
    );
  }

  Widget _buildQuickStatsSection(BuildContext context) {
    return Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildStatCard(
            context,
            'Attendance',
            '87%',
            Icons.today,
            Colors.green,
          ),
          _buildStatCard(
            context,
            'This Week',
            '92%',
            Icons.date_range,
            Colors.blue,
          ),
          _buildStatCard(
            context,
            'Below 75%',
            '23 Students',
            Icons.warning,
            Colors.orange,
          ),
          _buildStatCard(
            context,
            'Pending',
            '3 Classes',
            Icons.pending_actions,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildActionCard(context, 'Take Attendance', Icons.how_to_reg),
        _buildActionCard(context, 'View Reports', Icons.assessment),
        _buildActionCard(
          context,
          'Attendance Alerts',
          Icons.notification_important,
        ),
        _buildActionCard(context, 'Mark Bulk', Icons.group),
        _buildActionCard(context, 'QR Attendance', Icons.qr_code),
        _buildActionCard(context, 'Export Data', Icons.download),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon) {
    final primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AttendanceSettingsScreen()),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primaryColor, size: 32),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child: Icon(
                _getActivityIcon(index),
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            title: Text(_getActivityTitle(index)),
            subtitle: Text(_getActivityTime(index)),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceReportsScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getActivityIcon(int index) {
    final icons = [
      Icons.class_,
      Icons.edit,
      Icons.warning,
      Icons.class_,
      Icons.upload_file,
    ];
    return icons[index];
  }

  String _getActivityTitle(int index) {
    final titles = [
      'BCS-401 Attendance Recorded',
      'MCA-102 Attendance Updated',
      'Low Attendance Alert: John Doe',
      'BCA-201 Attendance Recorded',
      'Attendance Report Generated',
    ];
    return titles[index];
  }

  String _getActivityTime(int index) {
    final times = [
      '10 minutes ago',
      '1 hour ago',
      '2 hours ago',
      'Today, 10:30 AM',
      'Yesterday, 4:15 PM',
    ];
    return times[index];
  }
}

import 'package:cms/navigations/screens/admin/adminPannel/adminPannel.dart';
import 'package:cms/navigations/screens/admit-card-generator/admitcardgenerator.dart';
import 'package:cms/navigations/screens/approve/leave-request/leave-request-approve.dart';

import 'package:cms/navigations/screens/examination/resultpage.dart';
import 'package:cms/navigations/screens/id-card-generator/idcardgenerator.dart';

import 'package:cms/navigations/screens/notifications/notification.dart';
import 'package:cms/navigations/screens/student/student.dart';
import 'package:cms/navigations/screens/teacher/teacher.dart';
import 'package:cms/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cms/navigations/screens/profile/profile.dart';

import 'package:provider/provider.dart';
// import 'package:cms/theme/theme_provider.dart' as theme_provider;

class Dashboard extends StatefulWidget {
  final Function(Widget) onSectionSelected;

  const Dashboard({Key? key, required this.onSectionSelected})
    : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Key _refreshKey = UniqueKey();

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    setState(() {
      _refreshKey = UniqueKey();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Dashboard refreshed')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                OverVeiw(
                  key: _refreshKey,
                  onSectionSelected: widget.onSectionSelected,
                ),
                SizedBox(height: 20),
                Gridbuild(onSectionSelected: widget.onSectionSelected),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OverVeiw extends StatefulWidget {
  final Function(Widget) onSectionSelected;

  const OverVeiw({super.key, required this.onSectionSelected});

  @override
  State<OverVeiw> createState() => _OverVeiwState();
}

class _OverVeiwState extends State<OverVeiw> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 0, right: 8, left: 8, bottom: 8),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        color: theme.colorScheme.primary,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onSectionSelected(ProfileScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back,",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            "Amit Mahato | Dean",
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 18,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onPrimary.withOpacity(
                                0.2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: theme.colorScheme.onPrimary,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/images/img1profile.jpg",
                                fit: BoxFit.cover,
                                width: 80,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ViewCount(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ViewCount extends StatefulWidget {
  const ViewCount({super.key});

  @override
  State<ViewCount> createState() => _ViewCountState();
}

class _ViewCountState extends State<ViewCount> {
  List<Map<String, dynamic>> countMap = [
    {"number": "68", "Title": "Teachers", "icon": Icons.person_outline},
    {"number": "1108", "Title": "Students", "icon": Icons.school_outlined},
    {
      "number": "16",
      "Title": "Admin's",
      "icon": Icons.admin_panel_settings_outlined,
    },
    {"number": "969", "Title": "Parents", "icon": Icons.people_outline},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      width: MediaQuery.of(context).size.width - 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            countMap.map((data) {
              return _buildCountItem(
                data["number"],
                data["Title"],
                data["icon"],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCountItem(String numberStr, String title, IconData icon) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    final int targetNumber = int.parse(numberStr);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: targetNumber.toDouble()),
      duration: Duration(seconds: 4),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        double progress = value / targetNumber;

        return Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          color: isDarkMode ? theme.cardTheme.color : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomPaint(
                  painter: CircleProgressPainter(
                    progress: progress,
                    color: theme.colorScheme.primary,
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(icon, size: 16, color: theme.colorScheme.primary),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress;

  final Color color;

  CircleProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 3.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;

    final backgroundPaint =
        Paint()
          ..color = color.withOpacity(0.1)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final foregroundPaint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final angle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Gridbuild extends StatefulWidget {
  final Function(Widget) onSectionSelected;

  const Gridbuild({Key? key, required this.onSectionSelected})
    : super(key: key);

  @override
  State<Gridbuild> createState() => _GridbuildState();
}

class _GridbuildState extends State<Gridbuild> {
  final List<Map<String, dynamic>> gridMap = [
    {
      "icon": "assets/icons/parent.png",
      "title": "Admin Pannel",
      "description": "Manage and monitor user accounts, roles.",
    },
    {
      "icon": "assets/icons/icons2-teacher.png",
      "title": "Teacher",
      "description": "Manage teacher profiles and assignments",
    },
    {
      "icon": "assets/icons/icons3-students.png",
      "title": "Students",
      "description": "Manage student profiles and academic records",
    },
    {
      "icon": "assets/icons/icon6-form.png",
      "title": "Admit Card",
      "description": "Generates Admit Card for Students",
    },
    {
      "icon": "assets/icons/icons4-approve.png",
      "title": "Approve",
      "description": "Review and approve leave requests",
    },
    {
      "icon": "assets/icons/examination.png",
      "title": "Examination",
      "description": "Manage exams, results and grade reports",
    },
    {
      "icon": "assets/icons/examination.png",
      "title": "ID Card",
      "description": "Generates ID card of students",
    },
    {
      "icon": "assets/icons/icon7-notification.png",
      "title": "Notifications",
      "description": "Send and manage important announcements",
    },
  ];

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    final int itemToShow = _isExpanded ? gridMap.length : 6;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Campus Services",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: itemToShow,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisExtent: 200,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      final String title = gridMap.elementAt(index)["title"];
                      final Map<String, Widget> screenMap = {
                        "Students": NewStudent(),
                        "Admin Pannel": UserManagementScreen(),
                        "Teacher": TeacherScreen(),
                        "Admit Card": AdmitCardGenerator(),
                        "Notifications": SendNotificationPage(),
                        "Approve": LeaveRequestApprove(),
                        "Examination": ResultPage(),
                        "ID Card": IDCardGenerator(),
                      };
                      if (screenMap.containsKey(title)) {
                        widget.onSectionSelected(screenMap[title]!);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            isDarkMode
                                ? theme.colorScheme.surface
                                : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 110,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                gridMap.elementAt(index)['icon'],
                                height: 70,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gridMap.elementAt(index)['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  gridMap.elementAt(index)['description'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        isDarkMode
                                            ? Colors.white70
                                            : Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
        if (gridMap.length > 6)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded ? "Show Less" : "Show More",
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:cms/datatypes/datatypes.dart';
import 'package:cms/navigations/screens/admin/admin.dart';
import 'package:cms/navigations/screens/approve/leave-request/leave-request-approve.dart';
import 'package:cms/navigations/screens/attendence/attendence.dart';
import 'package:cms/navigations/screens/chat/parent/parentchat.dart';
import 'package:cms/navigations/screens/chat/student/studentchat.dart';
import 'package:cms/navigations/screens/chat/teacher/teacherchat.dart';
import 'package:cms/navigations/screens/form/form.dart';
import 'package:cms/navigations/screens/library/library.dart';
import 'package:cms/navigations/screens/meeting/meeting.dart';
import 'package:cms/navigations/screens/notifications/notification.dart';
import 'package:cms/navigations/screens/student/student.dart';
import 'package:cms/navigations/screens/teacher/teacher.dart';
import 'package:cms/utils/full_screen_route.dart';
import 'package:flutter/material.dart';
import 'package:cms/navigations/screens/profile/profile.dart';
import 'package:cms/navigations/screens/examination/examination.dart';
import 'package:cms/navigations/screens/timetable/timetable.dart';
import 'package:provider/provider.dart';
import 'package:cms/theme/theme_provider.dart';

class Dashboard extends StatelessWidget {
  final Function(Widget) onSectionSelected;

  const Dashboard({Key? key, required this.onSectionSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              OverVeiw(onSectionSelected: onSectionSelected),
              SizedBox(height: 20),
              Gridbuild(onSectionSelected: onSectionSelected),
              SizedBox(height: 10),
            ],
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

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

  Widget _buildCountItem(String number, String title, IconData icon) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: isDarkMode ? theme.cardTheme.color : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withOpacity(0.1),
                border: Border.all(color: theme.colorScheme.primary, width: 3),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    number,
                    style: TextStyle(
                      fontSize: 14,
                      color: blueColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(icon, size: 16, color: theme.colorScheme.primary),
                ],
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
  }
}

class FloatingButtonMenu extends StatefulWidget {
  const FloatingButtonMenu({super.key});

  @override
  State<FloatingButtonMenu> createState() => _FloatingButtonMenuState();
}

class _FloatingButtonMenuState extends State<FloatingButtonMenu> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: isExpanded,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              constraints: BoxConstraints(maxWidth: 150),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOptions(Icons.school, "Teacher"),
                      Divider(color: const Color.fromARGB(174, 37, 37, 37)),
                      _buildOptions(Icons.family_restroom, "Parent"),
                      Divider(color: const Color.fromARGB(174, 37, 37, 37)),
                      _buildOptions(Icons.person, "Student"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          backgroundColor: blueColor,
          child: Icon(
            isExpanded ? Icons.close : Icons.message,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  _buildOptions(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == "Teacher") {
          setState(() {
            Navigator.push(
              context,
              FullScreenRoute(builder: (context) => Teacherchat()),
            );
            isExpanded = false;
          });
        } else if (label == "Parent") {
          setState(() {
            Navigator.push(
              context,
              FullScreenRoute(builder: (context) => ParentChat()),
            );
            isExpanded = false;
          });
        } else if (label == "Student") {
          setState(() {
            Navigator.push(
              context,
              FullScreenRoute(builder: (context) => Studentchat()),
            );
            isExpanded = false;
          });
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color.fromARGB(255, 124, 124, 124), size: 24),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
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
      "icon": "assets/icons/icons1-library.png",
      "title": "Library",
      "description": "Access digital books, journals, and resources",
    },
    {
      "icon": "assets/icons/icons2-teacher.png",
      "title": "Teacher",
      "description": "Manage teacher profiles and assignments",
    },
    {
      "icon": "assets/icons/parent.png",
      "title": "Parents",
      "description": "Parent communication and student progress tracking",
    },
    {
      "icon": "assets/icons/icons3-students.png",
      "title": "Students",
      "description": "Manage student profiles and academic records",
    },
    {
      "icon": "assets/icons/icons4-admin.png",
      "title": "Administrator",
      "description": "System administration and management",
    },
    {
      "icon": "assets/icons/icon5-attendance.png",
      "title": "Attendence",
      "description": "Track and manage attendance records",
    },
    {
      "icon": "assets/icons/icon6-form.png",
      "title": "Form",
      "description": "Create and manage various application forms",
    },
    {
      "icon": "assets/icons/icon7-notification.png",
      "title": "Notifications",
      "description": "Send and manage important announcements",
    },
    {
      "icon": "assets/icons/icon8-meeting.png",
      "title": "Meeting",
      "description": "Schedule and manage virtual meetings",
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
      "icon": "assets/icons/timetable.png",
      "title": "Timetable",
      "description": "Class schedules and academic calendar",
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
                        "Students": Student(),
                        "Teacher": Teacher(),
                        "Administrator": AdminDashboard(),
                        "Library": Library(),
                        "Attendence": Attendence(),
                        "Notifications": SendNotification(),
                        "Form": FormFillUp(),
                        "Meeting": Meeting(),
                        "Approve": LeaveRequestApprove(),
                        "Parents": ParentChat(),
                        "Examination": Examination(),
                        "Timetable": Timetable(),
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

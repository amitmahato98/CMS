import 'package:cms/datatypes/datatypes.dart';
import 'package:cms/navigations/screens/admin/admin.dart';
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
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Container(child: Expanded(child: Gridbuild()))],
            ),
          ),
        ),
        floatingActionButton: FloatingButtonMenu(),
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
                      Divider(color: const Color.fromARGB(255, 37, 37, 37)),
                      _buildOptions(Icons.family_restroom, "Parent"),
                      Divider(color: const Color.fromARGB(255, 37, 37, 37)),
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
              MaterialPageRoute(builder: (context) => Teacherchat()),
            );
            isExpanded = false;
          });
        } else if (label == "Parent") {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ParentChat()),
            );
            isExpanded = false;
          });
        } else if (label == "Student") {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Studentchat()),
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
  const Gridbuild({super.key});

  @override
  State<Gridbuild> createState() => _GridbuildState();
}

class _GridbuildState extends State<Gridbuild> {
  final List<Map<String, dynamic>> gridMap = [
    {"icon": "assets/icons/icons1-library.png", "title": "Library"},
    {"icon": "assets/icons/icons2-teacher.png", "title": "Teacher"},
    {"icon": "assets/icons/icons3-students.png", "title": "Students"},
    {"icon": "assets/icons/icons4-admin.png", "title": "Administrator"},
    {"icon": "assets/icons/icon5-attendance.png", "title": "Attendence"},
    {"icon": "assets/icons/icon6-form.png", "title": "Form"},
    {"icon": "assets/icons/icon7-notification.png", "title": "Notifications"},
    {"icon": "assets/icons/icon8-meeting.png", "title": "Meeting"},
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: gridMap.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisExtent: 200,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.all(7.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (gridMap.elementAt(index)['title'] == "Students") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Student()),
                  );
                } else if (gridMap.elementAt(index)["title"] == "Teacher") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Teacher()),
                  );
                } else if (gridMap.elementAt(index)["title"] ==
                    "Administrator") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Admin()),
                  );
                } else if (gridMap.elementAt(index)["title"] == "Library") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Library()),
                  );
                } else if (gridMap.elementAt(index)["title"] == "Attendence") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Attendence()),
                  );
                } else if (gridMap.elementAt(index)["title"] ==
                    "Notifications") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SendNotification()),
                  );
                } else if (gridMap.elementAt(index)["title"] == "Form") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FormFillUp()),
                  );
                } else if (gridMap.elementAt(index)["title"] == "Meeting") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Meeting()),
                  );
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: GrayColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Image.asset(gridMap.elementAt(index)['icon'], height: 115),
                    SizedBox(height: 18),
                    Text(
                      "${gridMap.elementAt(index)['title']}",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

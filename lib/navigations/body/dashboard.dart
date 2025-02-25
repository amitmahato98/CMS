import 'package:cms/datatypes/datatypes.dart';
import 'package:cms/navigations/navbar/navbar.dart';
import 'package:cms/navigations/screens/admin/admin.dart';
import 'package:cms/navigations/screens/attendence/attendence.dart';
import 'package:cms/navigations/screens/form/form.dart';
import 'package:cms/navigations/screens/library/library.dart';
import 'package:cms/navigations/screens/meeting/meeting.dart';
import 'package:cms/navigations/screens/notifications/notification.dart';
import 'package:cms/navigations/screens/student/student.dart';
import 'package:cms/navigations/screens/teacher/teacher.dart';
import 'package:flutter/cupertino.dart';
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
        body: Padding(padding: const EdgeInsets.all(8.0), child: Gridbuild()),
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
        mainAxisExtent: 180,
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset(gridMap.elementAt(index)['icon'], height: 110),
                    Text("${gridMap.elementAt(index)['title']}"),
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

import 'package:cms/datatypes/datatypes.dart';
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
    {"icon": "assets/icons/icons1-library.png", "title": "Add library"},
    {"icon": "assets/icons/icons2-teacher.png", "title": "Add Teacher"},
    {"icon": "assets/icons/icons3-students.png", "title": "Add students"},
    {"icon": "assets/icons/icons4-admin.png", "title": "Add Administrator"},
    {"icon": "assets/icons/icons1-library.png", "title": "Add library"},
    {"icon": "assets/icons/icons2-teacher.png", "title": "Add Teacher"},
    {"icon": "assets/icons/icons3-students.png", "title": "Add students"},
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: gridMap.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 120,
      ),
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.all(7.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: blueColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.asset(gridMap.elementAt(index)['icon'], height: 70),
                  Text("${gridMap.elementAt(index)['title']}"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

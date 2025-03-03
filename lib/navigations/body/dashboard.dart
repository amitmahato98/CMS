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

class Dashboard extends StatelessWidget {
  final Function(Widget) onSectionSelected;

  const Dashboard({Key? key, required this.onSectionSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            OverVeiw(),
            SizedBox(height: 20),
            Gridbuild(onSectionSelected: onSectionSelected),
            // FloatingButtonMenu(),
          ],
        ),
      ),
    );
  }
}

class OverVeiw extends StatefulWidget {
  const OverVeiw({super.key});

  @override
  State<OverVeiw> createState() => _OverVeiwState();
}

class _OverVeiwState extends State<OverVeiw> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, right: 8, left: 8, bottom: 8),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 225,
          width: double.infinity,
          decoration: BoxDecoration(
            color: blueColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Admin()),
                      );
                    });
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
                              color: cardTextColor,
                            ),
                          ),
                          Text(
                            "Mr.Amit Mahato | Cammpus Cheif",
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 18,
                              color: cardTextColor,
                            ),
                          ),
                        ],
                      ),

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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
    {"number": "68", "Title": "Teachers"},
    {"number": "1108", "Title": "Students"},
    {"number": "16", "Title": "Admin's"},
    {"number": "969", "Title": "Parents"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105, // Increased for better visibility
      width: MediaQuery.sizeOf(context).width - 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // spacing: 15,
        children:
            countMap.map((data) {
              return _buildCountItem(data["number"], data["Title"]);
            }).toList(),
      ),
    );
  }

  Widget _buildCountItem(String number, String title) {
    return Material(
      elevation: 5,
      // color: GrayColor,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 5),
              ),
              alignment: Alignment.center,
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 15,
                  color: const Color.fromARGB(255, 255, 0, 0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  // color: cardTextColor,
                ),
              ),
            ), // Title
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
    {"icon": "assets/icons/icons1-library.png", "title": "Library"},
    {"icon": "assets/icons/icons2-teacher.png", "title": "Teacher"},
    {"icon": "assets/icons/icons3-students.png", "title": "Students"},
    {"icon": "assets/icons/icons4-admin.png", "title": "Administrator"},
    {"icon": "assets/icons/icon5-attendance.png", "title": "Attendence"},
    {"icon": "assets/icons/icon6-form.png", "title": "Form"},
    {"icon": "assets/icons/icon7-notification.png", "title": "Notifications"},
    {"icon": "assets/icons/icon8-meeting.png", "title": "Meeting"},
    {"icon": "assets/icons/icons4-approve.png", "title": "Approve"},
  ];

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final int itemToShow = _isExpanded ? gridMap.length : 4;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: GrayColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: GridView.builder(
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
              return Padding(
                padding: const EdgeInsets.all(7.0),
                child: GestureDetector(
                  onTap: () {
                    final String title = gridMap.elementAt(index)["title"];
                    final Map<String, Widget> screenMap = {
                      "Students": Student(),
                      "Teacher": Teacher(),
                      "Administrator": Admin(),
                      "Library": Library(),
                      "Attendence": Attendence(),
                      "Notifications": SendNotification(),
                      "Form": FormFillUp(),
                      "Meeting": Meeting(),
                      "Approve": LeaveRequestApprove(),
                    };
                    if (screenMap.containsKey(title)) {
                      widget.onSectionSelected(screenMap[title]!);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: GrayColor,
                    ),
                    child: Material(
                      elevation: 7,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Image.asset(
                              gridMap.elementAt(index)['icon'],
                              height: 115,
                            ),
                            SizedBox(height: 18),
                            Text(
                              gridMap.elementAt(index)['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (gridMap.length > 4)
          Transform.translate(
            offset: Offset(0, -10), // Move up by 10 pixels
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Container(
                    width: 150,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(100),
                      ),
                      color: GrayColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isExpanded ? "Less" : "More",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

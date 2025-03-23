import 'package:cms/datatypes/datatypes.dart';
import 'package:cms/navigations/screens/aboutus/aboutus.dart';
import 'package:cms/navigations/screens/admin/admin.dart';
import 'package:cms/navigations/screens/exam/exam.dart';
import 'package:cms/navigations/screens/examination/examination.dart';
import 'package:cms/navigations/screens/notifications/notification.dart';
import 'package:cms/navigations/screens/policies/policies.dart';
import 'package:cms/navigations/screens/profile/profile.dart';
import 'package:cms/navigations/screens/setting/setting.dart';
import 'package:cms/navigations/screens/student/student.dart';
import 'package:cms/navigations/screens/teacher/teacher.dart';
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: blueColor),
            child: GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: const AssetImage(
                      "assets/images/img1profile.jpg",
                    ),
                    onBackgroundImageError: (exception, stackTrace) {},
                    // child: const Icon(Icons.person, size: 35),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Amit Mahato", style: TextStyle(fontSize: 20)),
                        Text("Admin", style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboard()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.supervised_user_circle),
            title: const Text("Students"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Student()),
              );
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.people),
            title: Text("Staff"),
            children: [
              ListTile(
                leading: Icon(Icons.person_4),
                title: Text(" Teaching"),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Teacher()),
                    ),
              ),
              ListTile(
                leading: Icon(Icons.engineering),
                title: Text("Non-Teaching"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.edit_document),
            title: Text("Exam Section"),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Examination()),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Send Notification"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SendNotification()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy_rounded),
            title: Text("Policies"),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Policy()),
                ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About Us"),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs()),
                ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Setting"),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Setting()),
                ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

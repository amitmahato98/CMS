import 'package:cms/datatypes/datatypes.dart';
import 'package:cms/navigations/screens/aboutus/aboutus.dart';
import 'package:cms/navigations/screens/examination/resultpage.dart';
import 'package:cms/navigations/screens/notifications/notification.dart';
import 'package:cms/navigations/screens/policies/policies.dart';
import 'package:cms/navigations/screens/profile/profile.dart';
import 'package:cms/navigations/screens/student/student.dart';
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
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Amit Mahato",
                          style: TextStyle(fontSize: 20, color: whiteColor),
                        ),
                        Text(
                          "Admin",
                          style: TextStyle(fontSize: 15, color: whiteColor),
                        ),
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
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.supervised_user_circle),
            title: const Text("Students"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewStudent()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.edit_document),
            title: Text("Result "),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultPage()),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Send Notification"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SendNotificationPage()),
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
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

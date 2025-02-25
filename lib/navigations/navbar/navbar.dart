import 'package:cms/datatypes/datatypes.dart';
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
              onTap: () => Navigator.of(context).pop(),
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
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.supervised_user_circle),
            title: const Text("Students"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.people),
            title: Text("Staff"),
            children: [
              ListTile(
                leading: Icon(Icons.person_4),
                title: Text(" Teaching"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.engineering),
                title: Text("Non-Teaching"),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.edit_document),
            title: Text("Exam Section"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Send Notification"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy_rounded),
            title: Text("Policies"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About Us"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Setting"),
            onTap: () => Navigator.pop(context),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms/auth/auth_service.dart';
import 'package:cms/auth/login_page.dart';
import 'package:cms/datatypes/datatypes.dart';
import 'package:cms/navigations/screens/aboutus/aboutus.dart';
import 'package:cms/navigations/screens/examination/resultpage.dart';
import 'package:cms/navigations/screens/notifications/notification.dart';
import 'package:cms/navigations/screens/policies/policies.dart';
import 'package:cms/navigations/screens/profile/profile.dart';
import 'package:cms/navigations/screens/student/student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("User name not found")));
        }
        final userdata = snapshot.data!.data() as Map<String, dynamic>;
        final fName = userdata['firstName'] ?? 'Guest';
        final lName = userdata['lastName'] ?? 'User';

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
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
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
                              "$fName $lName",
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
                leading: Icon(Icons.person, color: blueColor),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.supervised_user_circle, color: blueColor),
                title: const Text("Students"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewStudent()),
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.edit_document, color: blueColor),
                title: Text("Result "),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultPage()),
                    ),
              ),
              ListTile(
                leading: Icon(Icons.notifications, color: blueColor),
                title: const Text("Send Notification"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendNotificationPage(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.policy_rounded, color: blueColor),
                title: Text("Policies"),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Policy()),
                    ),
              ),
              ListTile(
                leading: Icon(Icons.info, color: blueColor),
                title: Text("About Us"),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutUs()),
                    ),
              ),

              ListTile(
                leading: Icon(Icons.logout_rounded, color: blueColor),
                title: Text("Logout"),
                onTap: () async {
                  Navigator.of(context).pop(); // close drawer
                  await AuthService().signOut(); // sign out
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false, // remove all previous routes
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Logged out successfully")),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:cms/navigations/body/dashboard.dart';
import 'package:cms/navigations/navbar/navbar.dart';
import 'package:cms/navigations/screens/notifications/notification.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color blueColor = Color(0xFF167AFA);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CMS",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Navbar(),
        appBar: AppBar(
          backgroundColor: blueColor,
          title: const Text("Admin"),
          actions: [
            Builder(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendNotification(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: Dashboard(),
      ),
    );
  }
}

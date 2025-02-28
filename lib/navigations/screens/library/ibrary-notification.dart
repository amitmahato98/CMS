import 'package:flutter/material.dart';

class LibraryNotification extends StatefulWidget {
  const LibraryNotification({super.key});

  @override
  State<LibraryNotification> createState() => _LibraryNotificationState();
}

class _LibraryNotificationState extends State<LibraryNotification> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Library Notification"),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Center(child: Text("Its the Library Notification Section !")),
      ),
    );
  }
}
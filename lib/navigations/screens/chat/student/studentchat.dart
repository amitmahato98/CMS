import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Studentchat extends StatefulWidget {
  const Studentchat({super.key});

  @override
  State<Studentchat> createState() => _StudentchatState();
}

class _StudentchatState extends State<Studentchat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Chats"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(child: Text("Its the Student Chat Section !")),
    );
  }
}

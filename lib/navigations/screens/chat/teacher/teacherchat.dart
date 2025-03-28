import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Teacherchat extends StatefulWidget {
  const Teacherchat({super.key});

  @override
  State<Teacherchat> createState() => _TeacherchatState();
}

class _TeacherchatState extends State<Teacherchat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text("Teacher Chats"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(child: Text("Its the Teacher Chat Section !")),
    );
  }
}

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text('Teacher Chats'),
        ),
        body: Center(child: Text("This is Teacher admin Chat Section !")),
      ),
    );
  }
}

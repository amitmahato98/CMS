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
          title: Text('Student Chats'),
        ),
        body: Center(child: Text("This is Student admin Chat Section !")),
      ),
    );
  }
}

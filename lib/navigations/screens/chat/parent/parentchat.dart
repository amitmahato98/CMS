import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ParentChat extends StatefulWidget {
  const ParentChat({super.key});

  @override
  State<ParentChat> createState() => _ParentChatState();
}

class _ParentChatState extends State<ParentChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Parent Chats'),
      ),
      body: Center(child: Text("This is Parent admin Chat Section !")),
    );
  }
}

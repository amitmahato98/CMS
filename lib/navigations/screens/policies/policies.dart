import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Policy extends StatefulWidget {
  const Policy({super.key});

  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Policies"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(child: Text("Its the Policies Section !")),
    );
  }
}

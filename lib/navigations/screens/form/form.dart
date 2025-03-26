import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormFillUp extends StatefulWidget {
  const FormFillUp({super.key});

  @override
  State<FormFillUp> createState() => _FormFillUpState();
}

class _FormFillUpState extends State<FormFillUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(child: Text("Its the Form Section !")),
    );
  }
}

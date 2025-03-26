import 'package:flutter/material.dart';

class LeaveRequestApprove extends StatefulWidget {
  const LeaveRequestApprove({super.key});

  @override
  State<LeaveRequestApprove> createState() => _LeaveRequestApproveState();
}

class _LeaveRequestApproveState extends State<LeaveRequestApprove> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave Request"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(child: Text("its Admin page")),
    );
  }
}

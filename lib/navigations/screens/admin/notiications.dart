// notifications.dart
import 'package:flutter/material.dart';

class Notification {
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;

  Notification({
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Notification> _notifications = [
    Notification(
      title: "New Student Registration",
      message: "A new student has been registered in the system",
      time: DateTime.now().subtract(Duration(hours: 1)),
    ),
    Notification(
      title: "Course Syllabus Updated",
      message: "The syllabus for CS101 has been updated",
      time: DateTime.now().subtract(Duration(hours: 3)),
    ),
    Notification(
      title: "Fee Payment Received",
      message: "Fee payment received from Student ID: S12345",
      time: DateTime.now().subtract(Duration(hours: 5)),
    ),
    Notification(
      title: "System Maintenance",
      message: "System will be under maintenance tonight from 2-4 AM",
      time: DateTime.now().subtract(Duration(hours: 6)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body:
          _notifications.isEmpty
              ? Center(child: Text('No notifications'))
              : ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: notification.isRead ? Colors.grey : Colors.blue,
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight:
                              notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.message),
                          SizedBox(height: 4),
                          Text(
                            _formatTime(notification.time),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          // Mark as read
                          _notifications[index] = Notification(
                            title: notification.title,
                            message: notification.message,
                            time: notification.time,
                            isRead: true,
                          );
                        });

                        // Show notification details
                        _showNotificationDetails(notification);
                      },
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  );
                },
              ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  void _showNotificationDetails(Notification notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notification.title),
          content: Text(notification.message),
          actions: [
            TextButton(
              child: Text('Mark as Read'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

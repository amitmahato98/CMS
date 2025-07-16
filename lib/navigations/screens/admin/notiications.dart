import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Notification copyWith({bool? isRead}) {
    return Notification(
      title: title,
      message: message,
      time: time,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  final int initialUnreadCount;

  const NotificationsScreen({Key? key, required this.initialUnreadCount})
    : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Notification> _notifications = []; // Initialized immediately
  late int _unreadCount;
  Set<String> _readTitles = {};

  @override
  void initState() {
    super.initState();
    _unreadCount = widget.initialUnreadCount;
    _loadReadStatus();
  }

  Future<void> _loadReadStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _readTitles = prefs.getStringList('read_notifications')?.toSet() ?? {};

    final rawNotifications = [
      Notification(
        title: "New Student Registration",
        message: "A new student has been registered in the system",
        time: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Notification(
        title: "Course Syllabus Updated",
        message: "The syllabus for CS101 has been updated",
        time: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      Notification(
        title: "Fee Payment Received",
        message: "Fee payment received from Student ID: S12345",
        time: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Notification(
        title: "System Maintenance",
        message: "System will be under maintenance tonight from 2-4 AM",
        time: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];

    _notifications =
        rawNotifications
            .map((n) => n.copyWith(isRead: _readTitles.contains(n.title)))
            .toList();

    _unreadCount = _notifications.where((n) => !n.isRead).length;

    setState(() {});
  }

  Future<void> _markAsRead(int index) async {
    final notification = _notifications[index];
    if (!notification.isRead) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _readTitles.add(notification.title);
      await prefs.setStringList('read_notifications', _readTitles.toList());

      setState(() {
        _notifications[index] = notification.copyWith(isRead: true);
        _unreadCount--;
      });
    }

    _showNotificationDetails(notification);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _unreadCount); // Return count to previous screen
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          backgroundColor: Colors.blue,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _unreadCount);
            },
          ),
        ),
        body:
            _notifications.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.notifications,
                          color:
                              notification.isRead ? Colors.grey : Colors.blue,
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
                            const SizedBox(height: 4),
                            Text(
                              _formatTime(notification.time),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _markAsRead(index),
                      ),
                    );
                  },
                ),
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
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

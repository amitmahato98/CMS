import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cms/theme/theme_provider.dart';

class LibraryNotification extends StatelessWidget {
  const LibraryNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Library Notifications'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildNotificationCard(
            'Your book "Database Management Systems" is due tomorrow',
            '1 day ago',
            isDarkMode,
            theme,
          ),
          _buildNotificationCard(
            'New books available in Computer Science section',
            '3 days ago',
            isDarkMode,
            theme,
          ),
          _buildNotificationCard(
            'Thank you for returning "Programming in C++"',
            '1 week ago',
            isDarkMode,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    String message,
    String timeAgo,
    bool isDarkMode,
    ThemeData theme,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: isDarkMode ? 2 : 1,
      color: isDarkMode ? theme.colorScheme.surface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              timeAgo,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

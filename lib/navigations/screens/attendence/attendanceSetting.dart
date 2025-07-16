import 'dart:math';

import 'package:flutter/material.dart';

// 6. SETTINGS & CONFIGURATION SCREEN
class AttendanceSettingsScreen extends StatefulWidget {
  @override
  _AttendanceSettingsScreenState createState() =>
      _AttendanceSettingsScreenState();
}

class _AttendanceSettingsScreenState extends State<AttendanceSettingsScreen> {
  bool _sendNotifications = true;
  bool _allowLateMarking = false;
  bool _requireLocationVerification = true;
  bool _requireFaceRecognition = false;
  bool _autoMarkAbsent = true;

  String _minimumAttendanceRequired = '75%';
  String _absenceNotificationThreshold = '3 days';
  String _attendanceCalculationMethod = 'Daily Basis';
  String _qrCodeValidity = '5 minutes';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Show help information
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Settings
            Text(
              'General Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    context,
                    'Minimum Attendance Required',
                    _minimumAttendanceRequired,
                    Icons.rule,
                    onTap: () {
                      _showOptionsDialog(
                        context,
                        'Minimum Attendance Required',
                        ['65%', '70%', '75%', '80%', '85%'],
                        (value) {
                          setState(() {
                            _minimumAttendanceRequired = value;
                          });
                        },
                      );
                    },
                  ),
                  Divider(indent: 56, endIndent: 16),
                  _buildSettingItem(
                    context,
                    'Attendance Calculation Method',
                    _attendanceCalculationMethod,
                    Icons.calculate,
                    onTap: () {
                      _showOptionsDialog(
                        context,
                        'Attendance Calculation Method',
                        ['Daily Basis', 'Subject-wise', 'Lecture-wise'],
                        (value) {
                          setState(() {
                            _attendanceCalculationMethod = value;
                          });
                        },
                      );
                    },
                  ),
                  Divider(indent: 56, endIndent: 16),
                  _buildSettingItem(
                    context,
                    'QR Code Validity',
                    _qrCodeValidity,
                    Icons.qr_code,
                    onTap: () {
                      _showOptionsDialog(
                        context,
                        'QR Code Validity Duration',
                        ['1 minute', '3 minutes', '5 minutes', '10 minutes'],
                        (value) {
                          setState(() {
                            _qrCodeValidity = value;
                          });
                        },
                      );
                    },
                  ),
                  Divider(indent: 56, endIndent: 16),
                  _buildSwitchSettingItem(
                    context,
                    'Auto-mark Absent',
                    'Automatically mark students absent if not present',
                    Icons.update,
                    _autoMarkAbsent,
                    (value) {
                      setState(() {
                        _autoMarkAbsent = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Verification Settings
            Text(
              'Verification Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSwitchSettingItem(
                    context,
                    'Location Verification',
                    'Require students to be in class location',
                    Icons.location_on,
                    _requireLocationVerification,
                    (value) {
                      setState(() {
                        _requireLocationVerification = value;
                      });
                    },
                  ),
                  Divider(indent: 56, endIndent: 16),
                  _buildSwitchSettingItem(
                    context,
                    'Face Recognition',
                    'Use facial recognition to verify identity',
                    Icons.face,
                    _requireFaceRecognition,
                    (value) {
                      setState(() {
                        _requireFaceRecognition = value;
                      });
                    },
                  ),
                  Divider(indent: 56, endIndent: 16),
                  _buildSwitchSettingItem(
                    context,
                    'Allow Late Marking',
                    'Allow students to mark attendance after class begins',
                    Icons.timer,
                    _allowLateMarking,
                    (value) {
                      setState(() {
                        _allowLateMarking = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24), // Notification Settings
            Text(
              'Notification Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSwitchSettingItem(
                    context,
                    'Send Notifications',
                    'Send alerts to students about attendance',
                    Icons.notifications,
                    _sendNotifications,
                    (value) {
                      setState(() {
                        _sendNotifications = value;
                      });
                    },
                  ),
                  Divider(indent: 56, endIndent: 16),
                  _buildSettingItem(
                    context,
                    'Absence Notification Threshold',
                    _absenceNotificationThreshold,
                    Icons.warning,
                    onTap: () {
                      _showOptionsDialog(
                        context,
                        'Absence Notification Threshold',
                        ['1 day', '2 days', '3 days', '5 days', '7 days'],
                        (value) {
                          setState(() {
                            _absenceNotificationThreshold = value;
                          });
                        },
                      );
                    },
                  ),
                  Divider(indent: 56, endIndent: 16),
                  _buildSettingItem(
                    context,
                    'Notification Recipients',
                    'Students, Parents, Faculty',
                    Icons.people,
                    onTap: () {
                      // Show notification recipients selection dialog
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Data Management
            Text(
              'Data Management',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    context,
                    'Export Attendance Data',
                    'CSV, Excel, PDF',
                    Icons.download,
                    onTap: () {
                      // Show export options dialog
                    },
                  ),
                  Divider(indent: 56, endIndent: 16),
                  _buildSettingItem(
                    context,
                    'Auto Backup Frequency',
                    'Daily',
                    Icons.backup,
                    onTap: () {
                      _showOptionsDialog(
                        context,
                        'Auto Backup Frequency',
                        ['Daily', 'Weekly', 'Monthly', 'Never'],
                        (value) {
                          // Update backup frequency
                        },
                      );
                    },
                  ),
                  Divider(indent: 56, endIndent: 16),
                  _buildSettingItem(
                    context,
                    'Data Retention Period',
                    '5 Years',
                    Icons.access_time,
                    onTap: () {
                      _showOptionsDialog(
                        context,
                        'Data Retention Period',
                        ['1 Year', '2 Years', '5 Years', '10 Years', 'Forever'],
                        (value) {
                          // Update data retention period
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Leave Management
            Text(
              'Leave Management',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    context,
                    'Maximum Leave Days',
                    '15 days per semester',
                    Icons.event_busy,
                    onTap: () {
                      _showOptionsDialog(
                        context,
                        'Maximum Leave Days',
                        ['10 days', '15 days', '20 days', '30 days'],
                        (value) {
                          // Update maximum leave days
                        },
                      );
                    },
                  ),
                  Divider(indent: 56, endIndent: 16),
                  _buildSettingItem(
                    context,
                    'Medical Leave Documentation',
                    'Required for > 3 days',
                    Icons.medical_services,
                    onTap: () {
                      _showOptionsDialog(
                        context,
                        'Medical Leave Documentation',
                        [
                          'Required for all',
                          'Required for > 3 days',
                          'Required for > 5 days',
                          'Not required',
                        ],
                        (value) {
                          // Update medical leave documentation requirement
                        },
                      );
                    },
                  ),
                  Divider(indent: 56, endIndent: 16),
                  _buildSwitchSettingItem(
                    context,
                    'Auto-approve Leave Requests',
                    'Automatically approve certain types of leave',
                    Icons.approval,
                    false,
                    (value) {
                      // Toggle auto-approve setting
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Access Control
            Text(
              'Access Control',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    context,
                    'Faculty Access Levels',
                    'Manage faculty permissions',
                    Icons.security,
                    onTap: () {
                      // Show faculty access management screen
                    },
                  ),
                  Divider(indent: 56, endIndent: 16),
                  _buildSettingItem(
                    context,
                    'Department Admin Access',
                    'Manage department admin permissions',
                    Icons.admin_panel_settings,
                    onTap: () {
                      // Show department admin management screen
                    },
                  ),
                  Divider(indent: 56, endIndent: 16),
                  _buildSettingItem(
                    context,
                    'Student Portal Access',
                    'Manage student portal features',
                    Icons.school,
                    onTap: () {
                      // Show student portal access management screen
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Reset & Restore section
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Show reset confirmation dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Save Settings'),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Restore default settings
                    },
                    child: Text('Restore Default Settings'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSettingItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 22,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(
    BuildContext context,
    String title,
    List<String> options,
    Function(String) onSelect,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(options[index]),
                    onTap: () {
                      onSelect(options[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }
}

// 7. ADDITIONAL COMPONENTS

// QR Code Attendance Widget
class QRCodeAttendanceWidget extends StatefulWidget {
  @override
  _QRCodeAttendanceWidgetState createState() => _QRCodeAttendanceWidgetState();
}

class _QRCodeAttendanceWidgetState extends State<QRCodeAttendanceWidget> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QR Code Attendance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _isGenerating = true;
                  });
                  // Simulate QR code regeneration
                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      _isGenerating = false;
                    });
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          _isGenerating
              ? CircularProgressIndicator()
              : Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(16),
                child: CustomPaint(painter: QRCodePainter()),
              ),
          SizedBox(height: 16),
          Text(
            'Valid for 05:00 minutes',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Show this QR code to students to mark attendance',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  // Share QR code
                },
                icon: Icon(Icons.share),
                label: Text('Share'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Download QR code
                },
                icon: Icon(Icons.download),
                label: Text('Download'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// QR Code Painter (mock)
class QRCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

    // Draw a simple mock QR code pattern
    final cellSize = size.width / 25;

    // Draw the three corner squares
    // Top left corner
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 2, cellSize * 2, cellSize * 7, cellSize * 7),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 3, cellSize * 3, cellSize * 5, cellSize * 5),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 4, cellSize * 4, cellSize * 3, cellSize * 3),
      paint,
    );

    // Top right corner
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 16, cellSize * 2, cellSize * 7, cellSize * 7),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 17, cellSize * 3, cellSize * 5, cellSize * 5),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 18, cellSize * 4, cellSize * 3, cellSize * 3),
      paint,
    );

    // Bottom left corner
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 2, cellSize * 16, cellSize * 7, cellSize * 7),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 3, cellSize * 17, cellSize * 5, cellSize * 5),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 4, cellSize * 18, cellSize * 3, cellSize * 3),
      paint,
    );

    // Draw some random dots to make it look like a QR code
    final random = Random(42); // Fixed seed for consistent pattern

    for (int i = 0; i < 25; i++) {
      for (int j = 0; j < 25; j++) {
        // Skip the corner markers
        if ((i < 9 && j < 9) || (i < 9 && j > 15) || (i > 15 && j < 9)) {
          continue;
        }

        // Randomly fill some cells
        if (random.nextDouble() < 0.3) {
          canvas.drawRect(
            Rect.fromLTWH(i * cellSize, j * cellSize, cellSize, cellSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Face Recognition Attendance Widget
class FaceRecognitionWidget extends StatefulWidget {
  @override
  _FaceRecognitionWidgetState createState() => _FaceRecognitionWidgetState();
}

class _FaceRecognitionWidgetState extends State<FaceRecognitionWidget> {
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Face Recognition',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                _isScanning
                    ? Stack(
                      alignment: Alignment.center,
                      children: [
                        // Simulated camera view
                        Icon(
                          Icons.face,
                          size: 80,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        // Scanning animation
                        Container(
                          width: double.infinity,
                          height: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    )
                    : Center(
                      child: Icon(
                        Icons.camera_alt,
                        size: 48,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isScanning = !_isScanning;
              });
            },
            icon: Icon(_isScanning ? Icons.stop : Icons.play_arrow),
            label: Text(
              _isScanning ? 'Stop Scanning' : 'Start Face Recognition',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _isScanning
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 48),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Position the student\'s face in the frame to mark attendance',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

// Manual Attendance Widget
class ManualAttendanceWidget extends StatefulWidget {
  @override
  _ManualAttendanceWidgetState createState() => _ManualAttendanceWidgetState();
}

class _ManualAttendanceWidgetState extends State<ManualAttendanceWidget> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _students = [
    'Rahul Sharma',
    'Priya Patel',
    'Arjun Singh',
    'Sneha Gupta',
    'Vikram Malhotra',
    'Anjali Desai',
    'Rajesh Kumar',
    'Neha Verma',
  ];

  final Map<String, bool> _attendance = {
    'Rahul Sharma': true,
    'Priya Patel': true,
    'Arjun Singh': false,
    'Sneha Gupta': true,
    'Vikram Malhotra': false,
    'Anjali Desai': true,
    'Rajesh Kumar': false,
    'Neha Verma': true,
  };

  List<String> get _filteredStudents {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return _students;
    }
    return _students
        .where((student) => student.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manual Attendance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search students...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          SizedBox(height: 16),
          // Attendance controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Student List (${_filteredStudents.length})',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // Mark all present
                      setState(() {
                        for (var student in _students) {
                          _attendance[student] = true;
                        }
                      });
                    },
                    icon: Icon(Icons.check_circle, size: 18),
                    label: Text('All Present'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Mark all absent
                      setState(() {
                        for (var student in _students) {
                          _attendance[student] = false;
                        }
                      });
                    },
                    icon: Icon(Icons.cancel, size: 18),
                    label: Text('All Absent'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          // Student list
          Container(
            constraints: BoxConstraints(maxHeight: 300),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _filteredStudents.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                final isPresent = _attendance[student] ?? false;

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      student.substring(0, 1),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(student),
                  subtitle: Text('Roll No: CSE${100 + index}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.check_circle,
                          color:
                              isPresent
                                  ? Colors.green
                                  : Colors.grey.withOpacity(0.5),
                        ),
                        onPressed: () {
                          setState(() {
                            _attendance[student] = true;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color:
                              !isPresent
                                  ? Colors.red
                                  : Colors.grey.withOpacity(0.5),
                        ),
                        onPressed: () {
                          setState(() {
                            _attendance[student] = false;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          // Save button
          ElevatedButton(
            onPressed: () {
              // Save attendance
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 48),
            ),
            child: Text('Save Attendance'),
          ),
        ],
      ),
    );
  }
}

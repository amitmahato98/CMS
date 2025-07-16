import 'package:flutter/material.dart';

class AttendanceAnalyticsScreen extends StatefulWidget {
  @override
  _AttendanceAnalyticsScreenState createState() =>
      _AttendanceAnalyticsScreenState();
}

class _AttendanceAnalyticsScreenState extends State<AttendanceAnalyticsScreen> {
  String _selectedPeriod = 'This Month';
  String _selectedClass = 'All Classes';
  String _selectedSubject = 'All Subjects';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Analytics'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // Export analytics
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter bar
            Container(
              padding: EdgeInsets.all(12),
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
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: DropdownButton<String>(
                        value: _selectedPeriod,
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: Icon(Icons.arrow_drop_down),
                        items:
                            [
                              'Today',
                              'This Week',
                              'This Month',
                              'This Semester',
                              'Custom Range',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedPeriod = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: DropdownButton<String>(
                        value: _selectedClass,
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: Icon(Icons.arrow_drop_down),
                        items:
                            [
                              'All Classes',
                              'CSE - Sem 3',
                              'ECE - Sem 5',
                              'ME - Sem 1',
                              'Civil - Sem 7',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedClass = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Overall Stats
            Text(
              'Overall Attendance Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard(
                  context,
                  '85%',
                  'Average Attendance',
                  Icons.people,
                  Color(0xFF1E88E5),
                ),
                SizedBox(width: 16),
                _buildStatCard(
                  context,
                  '92%',
                  'Highest Class Attendance',
                  Icons.emoji_events,
                  Color(0xFF43A047),
                ),
                SizedBox(width: 16),
                _buildStatCard(
                  context,
                  '72%',
                  'Lowest Class Attendance',
                  Icons.warning,
                  Color(0xFFE53935),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Attendance Trend Chart
            Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Attendance Trend',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(
                            context,
                          ).dividerColor.withOpacity(0.2),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedSubject,
                          isDense: true,
                          underline: SizedBox(),
                          icon: Icon(Icons.arrow_drop_down, size: 18),
                          items:
                              [
                                'All Subjects',
                                'Data Structures',
                                'Database Management',
                                'Computer Networks',
                                'Operating Systems',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedSubject = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: LineChartPainter(
                        isDark: isDark,
                        primaryColor: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Week 1'),
                      Text('Week 2'),
                      Text('Week 3'),
                      Text('Week 4'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Day-wise Attendance
            Text(
              'Day-wise Attendance Pattern',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Container(
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
                  Container(
                    height: 180,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: BarChartPainter(
                        isDark: isDark,
                        primaryColor: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Mon'),
                      Text('Tue'),
                      Text('Wed'),
                      Text('Thu'),
                      Text('Fri'),
                      Text('Sat'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Students at Risk
            Text(
              'Students at Risk',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Container(
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
                  _buildRiskStudentItem(
                    context,
                    'Rahul Sharma',
                    'CSE101',
                    'CSE - Sem 3',
                    65,
                    'At Risk',
                    Color(0xFFE53935),
                  ),
                  Divider(),
                  _buildRiskStudentItem(
                    context,
                    'Priya Patel',
                    'ECE205',
                    'ECE - Sem 5',
                    70,
                    'Warning',
                    Color(0xFFFFA000),
                  ),
                  Divider(),
                  _buildRiskStudentItem(
                    context,
                    'Arjun Singh',
                    'ME102',
                    'ME - Sem 1',
                    68,
                    'At Risk',
                    Color(0xFFE53935),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: TextButton(
                      onPressed: () {
                        // View all at-risk students
                      },
                      child: Text('View All At-Risk Students'),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Subject-wise Attendance
            Text(
              'Subject-wise Attendance',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Container(
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
                  _buildSubjectAttendanceItem(
                    context,
                    'Data Structures',
                    'CSE - Sem 3',
                    'Prof. Rajesh Kumar',
                    87,
                    Color(0xFF43A047),
                  ),
                  Divider(),
                  _buildSubjectAttendanceItem(
                    context,
                    'Database Management',
                    'CSE - Sem 3',
                    'Prof. Anjali Sharma',
                    92,
                    Color(0xFF43A047),
                  ),
                  Divider(),
                  _buildSubjectAttendanceItem(
                    context,
                    'Computer Networks',
                    'CSE - Sem 3',
                    'Prof. Vikram Joshi',
                    76,
                    Color(0xFFFFA000),
                  ),
                  Divider(),
                  _buildSubjectAttendanceItem(
                    context,
                    'Operating Systems',
                    'CSE - Sem 3',
                    'Prof. Sunita Rao',
                    83,
                    Color(0xFF43A047),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Generate detailed report
        },
        icon: Icon(Icons.save_alt),
        label: Text('Export Report'),
        backgroundColor: primaryColor,
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
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
            Icon(icon, color: color, size: 28),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskStudentItem(
    BuildContext context,
    String name,
    String rollNo,
    String className,
    int attendance,
    String status,
    Color statusColor,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.1),
            child: Text(
              name.substring(0, 1),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  '$rollNo • $className',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$attendance%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectAttendanceItem(
    BuildContext context,
    String subject,
    String className,
    String professor,
    int attendance,
    Color statusColor,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  '$professor • $className',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    '$attendance%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    attendance > 85
                        ? Icons.check_circle
                        : attendance > 75
                        ? Icons.warning
                        : Icons.error,
                    color: statusColor,
                    size: 16,
                  ),
                ],
              ),
              SizedBox(height: 4),
              Container(
                width: 100,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: attendance / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for line chart visualization
class LineChartPainter extends CustomPainter {
  final bool isDark;
  final Color primaryColor;

  LineChartPainter({required this.isDark, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = primaryColor
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

    final fillPaint =
        Paint()
          ..color = primaryColor.withOpacity(0.2)
          ..style = PaintingStyle.fill;

    final gridPaint =
        Paint()
          ..color =
              isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05)
          ..strokeWidth = 1;

    // Draw horizontal grid lines
    for (int i = 1; i < 5; i++) {
      double y = size.height - (i * size.height / 5);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Sample data points (attendance percentage for 4 weeks)
    final points = [
      Offset(0, size.height * 0.4), // 80%
      Offset(size.width / 3, size.height * 0.3), // 85%
      Offset(size.width * 2 / 3, size.height * 0.5), // 75%
      Offset(size.width, size.height * 0.25), // 87.5%
    ];

    // Draw path
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Draw filled area under the line
    final fillPath = Path();
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(points[0].dx, size.height);

    for (int i = 0; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);

    // Draw data points
    final pointPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final pointStrokePaint =
        Paint()
          ..color = primaryColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    for (var point in points) {
      canvas.drawCircle(point, 6, pointStrokePaint);
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Custom painter for bar chart visualization
class BarChartPainter extends CustomPainter {
  final bool isDark;
  final Color primaryColor;

  BarChartPainter({required this.isDark, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint =
        Paint()
          ..color =
              isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05)
          ..strokeWidth = 1;

    // Draw horizontal grid lines
    for (int i = 1; i < 5; i++) {
      double y = size.height - (i * size.height / 5);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Sample data (attendance percentage for each day)
    final data = [85, 90, 82, 88, 86, 78];
    final barWidth = size.width / (data.length * 2);

    for (int i = 0; i < data.length; i++) {
      final barHeight = (data[i] / 100) * size.height;
      final x = (i * 2 + 1) * barWidth;

      final rect = Rect.fromLTWH(
        x - barWidth / 2,
        size.height - barHeight,
        barWidth,
        barHeight,
      );

      // Create a gradient for the bar
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [primaryColor.withOpacity(0.7), primaryColor],
      );

      final paint =
          Paint()
            ..shader = gradient.createShader(rect)
            ..style = PaintingStyle.fill;

      // Draw the bar with rounded top corners
      final roundedRect = RRect.fromRectAndCorners(
        rect,
        topLeft: Radius.circular(barWidth / 2),
        topRight: Radius.circular(barWidth / 2),
      );

      canvas.drawRRect(roundedRect, paint);

      // Draw the percentage on top of the bar
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${data[i]}%',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black54,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          size.height - barHeight - textPainter.height - 5,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

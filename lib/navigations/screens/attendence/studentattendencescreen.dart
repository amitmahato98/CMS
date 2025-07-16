import 'package:cms/theme/theme_provider.dart';
import 'package:flutter/material.dart';

class StudentAttendanceDetailsScreen extends StatefulWidget {
  final String studentId;
  final String studentName;

  const StudentAttendanceDetailsScreen({
    Key? key,
    required this.studentId,
    required this.studentName,
  }) : super(key: key);

  @override
  _StudentAttendanceDetailsScreenState createState() =>
      _StudentAttendanceDetailsScreenState();
}

class _StudentAttendanceDetailsScreenState
    extends State<StudentAttendanceDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 90)),
    end: DateTime.now(),
  );
  String _selectedSubject = 'All Subjects';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Attendance'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Share attendance report
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Show more options
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: 'Overview'), Tab(text: 'Details')],
        ),
      ),
      body: Column(
        children: [
          // Student info header
          Container(
            padding: EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: primaryColor.withOpacity(0.2),
                  child: Text(
                    widget.studentName.substring(0, 1),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.studentName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Roll: ${widget.studentId} | BCS-401 A',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        _buildAttendanceStatusChip(
                          context,
                          'Overall: 88%',
                          Colors.green,
                        ),
                        SizedBox(width: 8),
                        _buildAttendanceStatusChip(
                          context,
                          'Last Month: 92%',
                          Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filter chips
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final result = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(Duration(days: 365)),
                        lastDate: DateTime.now(),
                        initialDateRange: _dateRange,
                      );
                      if (result != null) {
                        setState(() {
                          _dateRange = result;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        color: Theme.of(context).cardTheme.color,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.date_range, size: 16),
                          SizedBox(width: 8),
                          Text(
                            '${_dateRange.start.day}/${_dateRange.start.month} - ${_dateRange.end.day}/${_dateRange.end.month}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).dividerColor),
                      color: Theme.of(context).cardTheme.color,
                    ),
                    child: DropdownButton<String>(
                      value: _selectedSubject,
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: Icon(Icons.arrow_drop_down),
                      items:
                          [
                            'All Subjects',
                            'Database Management',
                            'Web Development',
                            'Algorithms',
                          ].map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSubject = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildOverviewTab(), _buildDetailsTab()],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Edit attendance
          _showEditAttendanceDialog(context);
        },
        icon: Icon(Icons.edit),
        label: Text('Edit'),
      ),
    );
  }

  Widget _buildAttendanceStatusChip(
    BuildContext context,
    String label,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attendance stats cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Present',
                  '102 Days',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Absent',
                  '14 Days',
                  Icons.cancel,
                  Colors.red,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Leave',
                  '6 Days',
                  Icons.event_busy,
                  Colors.orange,
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          Text(
            'Attendance Trend',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),

          // Attendance graph
          Container(
            height: 200,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Placeholder(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              child: Center(child: Text('Attendance Trend Graph')),
            ),
          ),

          SizedBox(height: 24),

          Text(
            'Subject-wise Attendance',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),

          // Subject-wise attendance list
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              final subjects = [
                'Database Management',
                'Web Development',
                'Algorithms',
                'Operating Systems',
                'Computer Networks',
              ];
              final attendance = 78 + (index % 20);

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(subjects[index]),
                  subtitle: Text('${attendance}% (${30 + index}/40 Classes)'),
                  trailing: Container(
                    width: 80,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).dividerColor,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80 * attendance / 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _getAttendanceColor(attendance),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    // Navigate to subject details
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Subject',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Divider(height: 24),

                // Attendance records
                ...List.generate(20, (index) {
                  final date = DateTime.now().subtract(Duration(days: index));
                  final day = '${date.day}/${date.month}/${date.year}';

                  final subjects = [
                    'Database',
                    'Web Dev',
                    'Algorithms',
                    'OS',
                    'Networks',
                  ];

                  final subject = subjects[index % subjects.length];
                  final status =
                      index % 7 == 0
                          ? 'Absent'
                          : (index % 11 == 0 ? 'Leave' : 'Present');
                  final statusColor =
                      status == 'Present'
                          ? Colors.green
                          : (status == 'Absent' ? Colors.red : Colors.orange);

                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(child: Text(day)),
                        Expanded(child: Text(subject)),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
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
          Icon(icon, color: color),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Color _getAttendanceColor(int attendance) {
    if (attendance >= 75) {
      return Colors.green;
    } else if (attendance >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  void _showEditAttendanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Attendance'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    // Show date picker
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    prefixIcon: Icon(Icons.book),
                  ),
                  items:
                      [
                        'Database Management',
                        'Web Development',
                        'Algorithms',
                      ].map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                  onChanged: (value) {},
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Status',
                    prefixIcon: Icon(Icons.how_to_reg),
                  ),
                  items:
                      ['Present', 'Absent', 'Leave'].map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                  onChanged: (value) {},
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Remarks (Optional)',
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Attendance updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

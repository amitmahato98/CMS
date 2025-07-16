import 'package:cms/theme/theme_provider.dart';
import 'package:flutter/material.dart';

class AttendanceReportsScreen extends StatefulWidget {
  @override
  _AttendanceReportsScreenState createState() =>
      _AttendanceReportsScreenState();
}

class _AttendanceReportsScreenState extends State<AttendanceReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 30)),
    end: DateTime.now(),
  );
  String _selectedClass = 'All Classes';
  String _selectedSection = 'All Sections';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: Text('Attendance Reports'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Daily'),
            Tab(text: 'Student'),
            Tab(text: 'Summary'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // Export report
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Exporting report...')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: [
                _buildFilterChip(
                  context,
                  '${_dateRange.start.day}/${_dateRange.start.month} - ${_dateRange.end.day}/${_dateRange.end.month}',
                  Icons.date_range,
                  () async {
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
                ),
                _buildFilterChip(context, _selectedClass, Icons.class_, () {
                  // Show class selection dialog
                }),
                _buildFilterChip(context, _selectedSection, Icons.group, () {
                  // Show section selection dialog
                }),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDailyReportTab(),
                _buildStudentReportTab(),
                _buildSummaryReportTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Generating new report...')));
        },
        child: Icon(Icons.add),
        tooltip: 'Generate New Report',
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Theme.of(context).primaryColor),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Options',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 24),

              Text('Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),

              // Date range picker
              InkWell(
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
                      Navigator.pop(context);
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_dateRange.start.day}/${_dateRange.start.month} - ${_dateRange.end.day}/${_dateRange.end.month}',
                  ),
                ),
              ),
              SizedBox(height: 24),

              Text('Class', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              // Class dropdown
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedClass,
                  isExpanded: true,
                  underline: SizedBox(),
                  items:
                      ['All Classes', 'BCS-401', 'MCA-102', 'BCA-201'].map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedClass = value!;
                      Navigator.pop(context);
                    });
                  },
                ),
              ),

              SizedBox(height: 24),

              Text('Section', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              // Section dropdown
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedSection,
                  isExpanded: true,
                  underline: SizedBox(),
                  items:
                      ['All Sections', 'A', 'B', 'C'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSection = value!;
                      Navigator.pop(context);
                    });
                  },
                ),
              ),

              Spacer(),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Apply filters
                      },
                      child: Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailyReportTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily attendance graph
          Container(
            height: 220,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Attendance Trend',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                Expanded(
                  child: Placeholder(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    child: Center(child: Text('Attendance Graph')),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          Text('Daily Records', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 16),

          // Daily attendance list
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text('${_getRandomDate()}'),
                  subtitle: Text('BCS-401 | Database Management | Section A'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${85 + index % 10}%',
                        style: TextStyle(
                          color: _getAttendanceColor(85 + index % 10),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '34/40 Present',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  onTap: () {
                    // Navigate to detailed view
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStudentReportTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or ID...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Student list with percentage
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 12,
            itemBuilder: (context, index) {
              final attendance = 75 + (index % 25);
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text('Student ${index + 1}'),
                  subtitle: Text('Roll: CS20${index + 1} | BCS-401'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getAttendanceColor(
                            attendance,
                          ).withOpacity(0.2),
                        ),
                        child: Center(
                          child: Text(
                            '$attendance%',
                            style: TextStyle(
                              color: _getAttendanceColor(attendance),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withOpacity(0.1),
                    child: Text(
                      'S${index + 1}',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onTap: () {
                    // Navigate to student details
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryReportTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Average Attendance',
                  '89%',
                  Icons.show_chart,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Below 75%',
                  '12 Students',
                  Icons.warning,
                  Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Classes Held',
                  '186',
                  Icons.class_,
                  Colors.green,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Attendance Pending',
                  '2 Classes',
                  Icons.pending_actions,
                  Colors.red,
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          Text(
            'Class-wise Summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),

          // Class-wise summary
          Container(
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
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final classes = [
                  'BCS-401',
                  'MCA-102',
                  'BCA-201',
                  'MCA-304',
                  'BCS-202',
                ];
                final subjects = [
                  'Database Management',
                  'Web Development',
                  'Algorithms',
                  'Machine Learning',
                  'Operating Systems',
                ];
                final attendance = 82 + (index % 15);

                return ListTile(
                  title: Text(classes[index]),
                  subtitle: Text(subjects[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$attendance%',
                        style: TextStyle(
                          color: _getAttendanceColor(attendance),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () {
                    // Navigate to class details
                  },
                );
              },
            ),
          ),

          SizedBox(height: 24),

          Text('Monthly Trends', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 16),

          // Monthly trend graph
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
              child: Center(child: Text('Monthly Attendance Graph')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  String _getRandomDate() {
    final now = DateTime.now();
    final random = now.subtract(Duration(days: _getRandomInt(0, 30)));
    return '${random.day}/${random.month}/${random.year}';
  }

  int _getRandomInt(int min, int max) {
    return min + (DateTime.now().millisecond % (max - min));
  }

  Color _getAttendanceColor(int percentage) {
    if (percentage < 75) {
      return Colors.red;
    } else if (percentage < 85) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}

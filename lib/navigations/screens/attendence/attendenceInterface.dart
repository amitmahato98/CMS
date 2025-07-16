import 'package:cms/navigations/screens/attendence/attendanceSetting.dart';
import 'package:cms/navigations/screens/attendence/qrattendence.dart';
import 'package:cms/theme/theme_provider.dart';
import 'package:flutter/material.dart';

class TakeAttendanceScreen extends StatefulWidget {
  @override
  _TakeAttendanceScreenState createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  String selectedClass = 'BCS-401';
  String selectedSection = 'A';
  String selectedSubject = 'Database Management';
  DateTime selectedDate = DateTime.now();

  // Sample student list
  final List<Map<String, dynamic>> students = [
    {'id': 1, 'name': 'John Doe', 'roll': 'CS2001', 'status': 'present'},
    {'id': 2, 'name': 'Jane Smith', 'roll': 'CS2002', 'status': 'present'},
    {'id': 3, 'name': 'Robert Johnson', 'roll': 'CS2003', 'status': 'absent'},
    {'id': 4, 'name': 'Emily Brown', 'roll': 'CS2004', 'status': 'present'},
    {'id': 5, 'name': 'Michael Wilson', 'roll': 'CS2005', 'status': 'leave'},
    {'id': 6, 'name': 'Sarah Taylor', 'roll': 'CS2006', 'status': 'present'},
    {'id': 7, 'name': 'David Miller', 'roll': 'CS2007', 'status': 'present'},
    {'id': 8, 'name': 'Jessica Anderson', 'roll': 'CS2008', 'status': 'absent'},
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Take Attendance'),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RandomQRSection()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Class selection header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        context,
                        'Class',
                        selectedClass,
                        ['BCS-401', 'BCA-102', 'BCA-201'],
                        (val) => setState(() => selectedClass = val!),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        context,
                        'Section',
                        selectedSection,
                        ['A', 'B', 'C'],
                        (val) => setState(() => selectedSection = val!),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        context,
                        'Subject',
                        selectedSubject,
                        [
                          'Database Management',
                          'Web Development',
                          'Algorithms',
                          'Operating Systems',
                          'Computer Networks',
                          'Software Engineering',
                          'Data Structures',
                          'Discrete Mathematics',
                        ],
                        (val) => setState(() => selectedSubject = val!),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now().subtract(
                              Duration(days: 30),
                            ),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            color:
                                Theme.of(
                                  context,
                                ).inputDecorationTheme.fillColor,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16),
                              SizedBox(width: 8),
                              Text(
                                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quick stats bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: primaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttendanceStat('Total', '8', Icons.people),
                _buildAttendanceStat(
                  'Present',
                  '5',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildAttendanceStat('Absent', '2', Icons.cancel, Colors.red),
                _buildAttendanceStat(
                  'Leave',
                  '1',
                  Icons.event_busy,
                  Colors.orange,
                ),
              ],
            ),
          ),

          // Quick actions
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Mark all present
                    setState(() {
                      for (var student in students) {
                        student['status'] = 'present';
                      }
                    });
                  },
                  icon: Icon(Icons.check_circle),
                  label: Text('All Present'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
                SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    // Mark all absent
                    setState(() {
                      for (var student in students) {
                        student['status'] = 'absent';
                      }
                    });
                  },
                  icon: Icon(Icons.cancel),
                  label: Text('All Absent'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ),

          // Student list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 100), // Space for submit button
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryColor.withOpacity(0.2),
                        child: Text(
                          student['name'].toString().substring(0, 1),
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      title: Text(student['name']),
                      subtitle: Text('Roll: ${student['roll']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAttendanceButton(
                            'Present',
                            Icons.check_circle,
                            Colors.green,
                            student['status'] == 'present',
                            () => setState(() => student['status'] = 'present'),
                          ),
                          SizedBox(width: 8),
                          _buildAttendanceButton(
                            'Absent',
                            Icons.cancel,
                            Colors.red,
                            student['status'] == 'absent',
                            () => setState(() => student['status'] = 'absent'),
                          ),
                          SizedBox(width: 8),
                          _buildAttendanceButton(
                            'Leave',
                            Icons.event_busy,
                            Colors.orange,
                            student['status'] == 'leave',
                            () => setState(() => student['status'] = 'leave'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // Submit attendance
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Attendance submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Submit Attendance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
            color: Theme.of(context).inputDecorationTheme.fillColor,
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: SizedBox(),
            icon: Icon(Icons.arrow_drop_down),
            items:
                items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceStat(
    String label,
    String value,
    IconData icon, [
    Color? color,
  ]) {
    final finalColor = color ?? Theme.of(context).primaryColor;

    return Column(
      children: [
        Icon(icon, color: finalColor),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: finalColor),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildAttendanceButton(
    String label,
    IconData icon,
    Color color,
    bool isSelected,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color:
                  isSelected
                      ? color
                      : Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

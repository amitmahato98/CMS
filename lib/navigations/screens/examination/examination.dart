import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:cms/theme/theme_provider.dart';

class Examination extends StatefulWidget {
  const Examination({Key? key}) : super(key: key);

  @override
  State<Examination> createState() => _ExaminationState();
}

class _ExaminationState extends State<Examination>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime(2025, 4);

  // Keys for SharedPreferences
  static const String UPCOMING_EXAMS_KEY = 'upcoming_exams';
  static const String PAST_RESULTS_KEY = 'past_results';

  // Lists to store exams and results
  List<Map<String, dynamic>> upcomingExams = [];
  List<Map<String, dynamic>> pastResults = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load saved data when app initializes
    _loadSavedData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Method to load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Load upcoming exams
      final examsJson = prefs.getString(UPCOMING_EXAMS_KEY);
      if (examsJson != null) {
        final List<dynamic> savedExams = json.decode(examsJson);
        upcomingExams = savedExams.cast<Map<String, dynamic>>();
      } else {
        // Default data if no saved exams
        upcomingExams = [
          {
            "subject": "Database Management Systems",
            "code": "CSC301",
            "date": "2025-04-15",
            "time": "10:00 AM - 1:00 PM",
            "venue": "Examination Hall A",
            "type": "Mid Term",
          },
          {
            "subject": "Computer Networks",
            "code": "CSC302",
            "date": "2025-04-17",
            "time": "10:00 AM - 1:00 PM",
            "venue": "Examination Hall B",
            "type": "Mid Term",
          },
          {
            "subject": "Operating Systems",
            "code": "CSC303",
            "date": "2025-04-19",
            "time": "10:00 AM - 1:00 PM",
            "venue": "Examination Hall A",
            "type": "Mid Term",
          },
          {
            "subject": "Software Engineering",
            "code": "CSC304",
            "date": "2025-04-21",
            "time": "10:00 AM - 1:00 PM",
            "venue": "Examination Hall C",
            "type": "Mid Term",
          },
        ];
      }

      // Load past results
      final resultsJson = prefs.getString(PAST_RESULTS_KEY);
      if (resultsJson != null) {
        final List<dynamic> savedResults = json.decode(resultsJson);
        pastResults = savedResults.cast<Map<String, dynamic>>();
      } else {
        // Default data if no saved results
        pastResults = [
          {
            "subject": "Data Structures",
            "code": "CSC201",
            "date": "2025-01-15",
            "grade": "A",
            "percentage": "87%",
            "status": "Passed",
          },
          {
            "subject": "Algorithms",
            "code": "CSC202",
            "date": "2025-01-17",
            "grade": "A+",
            "percentage": "92%",
            "status": "Passed",
          },
          {
            "subject": "Object Oriented Programming",
            "code": "CSC203",
            "date": "2025-01-19",
            "grade": "B+",
            "percentage": "78%",
            "status": "Passed",
          },
          {
            "subject": "Web Development",
            "code": "CSC204",
            "date": "2025-01-21",
            "grade": "A",
            "percentage": "85%",
            "status": "Passed",
          },
        ];
      }
    });
  }

  // Method to save data to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save upcoming exams
    await prefs.setString(UPCOMING_EXAMS_KEY, json.encode(upcomingExams));

    // Save past results
    await prefs.setString(PAST_RESULTS_KEY, json.encode(pastResults));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text("Examination"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Upcoming Exams"),
            Tab(text: "Results"),
            Tab(text: "Schedule"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddDialog(context);
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingExamsTab(),
          _buildResultsTab(),
          _buildScheduleTab(),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String selectedType = "Exam";
    String subject = "";
    String code = "";
    DateTime? selectedDate;
    String time = "";
    String venue = "";
    String examType = "Mid Term";
    String grade = "";
    String percentage = "";
    String status = "Pass";

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Add New Entry"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedType = newValue!;
                          });
                        },
                        items:
                            ['Exam', 'Result'].map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        decoration: InputDecoration(labelText: "Type"),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Subject"),
                        onSaved: (value) {
                          subject = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the subject";
                          }
                          if (value.length < 3) {
                            return "Subject must be at least 3 characters long";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Course Code"),
                        onSaved: (value) {
                          code = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the course code";
                          }
                          if (!RegExp(r'^[A-Z]{3}[0-9]{3}$').hasMatch(value)) {
                            return "Code must be 2 uppercase letters followed by 3 numbers";
                          }
                          return null;
                        },
                      ),
                      if (selectedType == "Exam") ...[
                        DropdownButtonFormField<String>(
                          value: examType,
                          onChanged: (String? newValue) {
                            setState(() {
                              examType = newValue!;
                            });
                          },
                          items:
                              [
                                'Mid Term',
                                'Final Term',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          decoration: InputDecoration(labelText: "Exam Type"),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Date"),
                          controller: TextEditingController(
                            text:
                                selectedDate != null
                                    ? "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}"
                                    : '',
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          validator: (value) {
                            if (selectedDate == null) {
                              return "Please select a future date";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Time"),
                          onSaved: (value) {
                            time = value!;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter the exam time";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Hall Venue"),
                          onSaved: (value) {
                            venue = value!;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter the exam venue";
                            }
                            return null;
                          },
                        ),
                      ],
                      if (selectedType == "Result") ...[
                        DropdownButtonFormField<String>(
                          value: status,
                          onChanged: (String? newValue) {
                            setState(() {
                              status = newValue!;
                            });
                          },
                          items:
                              ['Pass', 'Fail'].map<DropdownMenuItem<String>>((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          decoration: InputDecoration(
                            labelText: "Result Status",
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Grade"),
                          onSaved: (value) {
                            grade = value!;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter the grade";
                            }
                            if (!RegExp(r'^[A-F][+-]?$').hasMatch(value)) {
                              return "Invalid grade format (e.g., A, B+, C-)";
                            }

                            final passableGrades = [
                              'A+',
                              'A',
                              'A-',
                              'B+',
                              'B',
                              'B-',
                              'C+',
                              'C',
                            ];
                            final failGrades = ['D+', 'D', 'D-', 'F'];

                            if (status == "Pass" &&
                                !passableGrades.contains(value)) {
                              return "Passing grade must be C or above";
                            } else if (status == "Fail" &&
                                !failGrades.contains(value)) {
                              return "Failing grade must be below C";
                            }

                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Percentage"),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            percentage = value!;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter the percentage";
                            }
                            double? parsedValue = double.tryParse(value);
                            if (parsedValue == null ||
                                parsedValue < 0 ||
                                parsedValue > 100) {
                              return "Please enter a valid percentage (0-100)";
                            }

                            if (status == "Pass" && parsedValue < 40) {
                              return "Passing percentage must be 40% or above";
                            } else if (status == "Fail" && parsedValue >= 40) {
                              return "Failing percentage must be below 40%";
                            }

                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Result Published Date",
                          ),
                          controller: TextEditingController(
                            text:
                                selectedDate != null
                                    ? "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}"
                                    : '',
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          validator: (value) {
                            if (selectedDate == null) {
                              return "Please select a result published date";
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        if (selectedType == "Exam") {
                          upcomingExams.add({
                            "subject": subject,
                            "code": code,
                            "date":
                                selectedDate!.toIso8601String().split('T')[0],
                            "time": time,
                            "venue": venue,
                            "type": examType,
                          });
                        } else if (selectedType == "Result") {
                          pastResults.add({
                            "subject": subject,
                            "code": code,
                            "date":
                                selectedDate!.toIso8601String().split('T')[0],
                            "grade": grade,
                            "percentage": "$percentage%",
                            "status": status,
                          });
                        }

                        // Save data after adding
                        _saveData();
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // The rest of the methods (_buildUpcomingExamsTab, _buildResultsTab, _buildScheduleTab,
  // _buildSectionHeader, _buildExamInfoItem, _buildResultInfoItem)
  // remain exactly the same as in the original implementation.

  // They are not repeated here to save space, but would be identical to the original code.
  // You can copy them from the original implementation.

  Widget _buildUpcomingExamsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Upcoming Examinations", Icons.timeline),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: upcomingExams.length,
            itemBuilder: (context, index) {
              final exam = upcomingExams[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              exam["subject"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              exam["type"],
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Course Code: ${exam["code"]}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      SizedBox(height: 12),
                      Divider(),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildExamInfoItem(
                            Icons.calendar_today,
                            exam["date"],
                          ),
                          _buildExamInfoItem(Icons.access_time, exam["time"]),
                          _buildExamInfoItem(Icons.location_on, exam["venue"]),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton.icon(
                            icon: Icon(Icons.download),
                            label: Text("Syllabus"),
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.alarm),
                            label: Text("Set Reminder"),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Examination Results", Icons.assessment),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: pastResults.length,
            itemBuilder: (context, index) {
              final result = pastResults[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result["subject"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Course Code: ${result["code"]}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                result["grade"],
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildResultInfoItem("Date", result["date"]),
                          _buildResultInfoItem(
                            "Percentage",
                            result["percentage"],
                          ),
                          _buildResultInfoItem("Status", result["status"]),
                        ],
                      ),
                      SizedBox(height: 16),
                      OutlinedButton.icon(
                        icon: Icon(Icons.download_outlined),
                        label: Text("Download Result"),
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Exam Schedule Calendar", Icons.calendar_month),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
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
                      "${_selectedDate.year}-${_selectedDate.month}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: blueColor,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 16,
                            color: blueColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedDate = DateTime(
                                _selectedDate.year,
                                _selectedDate.month - 1,
                              );
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: blueColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedDate = DateTime(
                                _selectedDate.year,
                                _selectedDate.month + 1,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                  ),
                  itemCount:
                      DateTime(_selectedDate.year, _selectedDate.month + 1)
                          .difference(
                            DateTime(_selectedDate.year, _selectedDate.month),
                          )
                          .inDays,
                  itemBuilder: (context, index) {
                    final day = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      index + 1,
                    );
                    final isExamDay = upcomingExams.any(
                      (exam) =>
                          DateTime.parse(exam["date"]).day == day.day &&
                          DateTime.parse(exam["date"]).month == day.month &&
                          DateTime.parse(exam["date"]).year == day.year,
                    );
                    return Container(
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isExamDay ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              isExamDay
                                  ? Colors.blue
                                  : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "${day.day}",
                          style: TextStyle(
                            color: isExamDay ? Colors.white : Colors.black,
                            fontWeight:
                                isExamDay ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          _buildSectionHeader("Upcoming Exams This Month", Icons.event_note),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: upcomingExams.length,
            itemBuilder: (context, index) {
              final exam = upcomingExams[index];
              final examDate = DateTime.parse(exam["date"]);
              if (examDate.month == _selectedDate.month &&
                  examDate.year == _selectedDate.year) {
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        exam["date"].split("-")[2],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    exam["subject"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${exam["time"]} - ${exam["venue"]}",
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      exam["code"],
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildExamInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildResultInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

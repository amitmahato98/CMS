import 'package:flutter/material.dart';
import 'package:cms/datatypes/datatypes.dart';

class Examination extends StatefulWidget {
  const Examination({Key? key}) : super(key: key);

  @override
  State<Examination> createState() => _ExaminationState();
}

class _ExaminationState extends State<Examination> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
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

  final List<Map<String, dynamic>> upcomingExams = [
    {
      "subject": "Database Management Systems",
      "code": "CS301",
      "date": "Apr 15, 2025",
      "time": "10:00 AM - 1:00 PM",
      "venue": "Examination Hall A",
      "type": "Mid Term"
    },
    {
      "subject": "Computer Networks",
      "code": "CS302",
      "date": "Apr 17, 2025",
      "time": "10:00 AM - 1:00 PM",
      "venue": "Examination Hall B",
      "type": "Mid Term"
    },
    {
      "subject": "Operating Systems",
      "code": "CS303",
      "date": "Apr 19, 2025",
      "time": "10:00 AM - 1:00 PM",
      "venue": "Examination Hall A",
      "type": "Mid Term"
    },
    {
      "subject": "Software Engineering",
      "code": "CS304",
      "date": "Apr 21, 2025",
      "time": "10:00 AM - 1:00 PM",
      "venue": "Examination Hall C",
      "type": "Mid Term"
    },
  ];

  final List<Map<String, dynamic>> pastResults = [
    {
      "subject": "Data Structures",
      "code": "CS201",
      "date": "Jan 15, 2025",
      "grade": "A",
      "percentage": "87%",
      "status": "Passed"
    },
    {
      "subject": "Algorithms",
      "code": "CS202",
      "date": "Jan 17, 2025",
      "grade": "A+",
      "percentage": "92%",
      "status": "Passed"
    },
    {
      "subject": "Object Oriented Programming",
      "code": "CS203",
      "date": "Jan 19, 2025",
      "grade": "B+",
      "percentage": "78%",
      "status": "Passed"
    },
    {
      "subject": "Web Development",
      "code": "CS204",
      "date": "Jan 21, 2025",
      "grade": "A",
      "percentage": "85%",
      "status": "Passed"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text("Examination", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: "Upcoming Exams"),
            Tab(text: "Results"),
            Tab(text: "Schedule"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueColor,
        child: Icon(Icons.add),
        onPressed: () {
          // Add functionality for creating new exam/result
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
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: blueColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              exam["type"],
                              style: TextStyle(
                                color: blueColor,
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
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 12),
                      Divider(),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildExamInfoItem(Icons.calendar_today, exam["date"]),
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
                              foregroundColor: blueColor,
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.alarm),
                            label: Text("Set Reminder"),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blueColor,
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
                              color: blueColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                result["grade"],
                                style: TextStyle(
                                  color: blueColor,
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
                          _buildResultInfoItem("Percentage", result["percentage"]),
                          _buildResultInfoItem("Status", result["status"]),
                        ],
                      ),
                      SizedBox(height: 16),
                      OutlinedButton.icon(
                        icon: Icon(Icons.download_outlined),
                        label: Text("Download Result"),
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: blueColor,
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
                      "April 2025",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, size: 16),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios, size: 16),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Calendar placeholder
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                  ),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    // Highlight exam days
                    final isExamDay = [14, 16, 18, 20].contains(index);
                    return Container(
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isExamDay ? blueColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isExamDay ? blueColor : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            color: isExamDay ? Colors.white : Colors.black,
                            fontWeight: isExamDay ? FontWeight.bold : FontWeight.normal,
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
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: blueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      exam["date"].split(" ")[1],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: blueColor,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  exam["subject"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "${exam["time"]} - ${exam["venue"]}",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: blueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    exam["code"],
                    style: TextStyle(
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: blueColor),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildExamInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildResultInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

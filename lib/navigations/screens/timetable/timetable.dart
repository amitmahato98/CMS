import 'package:flutter/material.dart';
import 'package:cms/datatypes/datatypes.dart';

class Timetable extends StatefulWidget {
  const Timetable({Key? key}) : super(key: key);

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDayIndex = 0; // 0 = Sunday, 6 = Saturday

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Set today as default selected day
    final today = DateTime.now().weekday % 7;
    _selectedDayIndex = today;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<String> weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // Updated weekly schedule with Saturday as holiday
  final List<List<Map<String, dynamic>>> weeklySchedule = [
    // Sunday
    [
      {
        "subject": "Software Engineering",
        "time": "09:00 AM - 10:30 AM",
        "room": "Room 203",
        "teacher": "Prof. Anita Dharane",
        "color": Color(0xFFD1C4E9),
      },
      {
        "subject": "Web Development",
        "time": "10:45 AM - 12:15 PM",
        "room": "Lab 102",
        "teacher": "Prof. Web Expert",
        "color": Color(0xFFFFCCBC),
      },
      {
        "subject": "Lunch Break",
        "time": "12:15 PM - 01:00 PM",
        "room": "Cafeteria",
        "teacher": "",
        "color": Color(0xFFFFE0B2),
      },
      {
        "subject": "Data Structures",
        "time": "01:00 PM - 02:30 PM",
        "room": "Room 301",
        "teacher": "Dr. Micheal Sharma",
        "color": Color(0xFFC5CAE9),
      },
    ],
    // Monday
    [
      {
        "subject": "Database Management",
        "time": "08:30 AM - 10:00 AM",
        "room": "Room 201",
        "teacher": "Prof. Sushant Sharma",
        "color": Color(0xFFF8BBD0),
      },
      {
        "subject": "Computer Networks",
        "time": "10:15 AM - 11:45 AM",
        "room": "Lab 101",
        "teacher": "Dr. Mandip Raj",
        "color": Color(0xFFB3E5FC),
      },
      {
        "subject": "Lunch Break",
        "time": "11:45 AM - 12:30 PM",
        "room": "Cafeteria",
        "teacher": "",
        "color": Color(0xFFFFE0B2),
      },
      {
        "subject": "Operating Systems",
        "time": "12:30 PM - 02:00 PM",
        "room": "Room 305",
        "teacher": "Prof. Rajesh Kumar",
        "color": Color(0xFFDCEDC8),
      },
    ],
    // Tuesday
    [
      {
        "subject": "Software Engineering",
        "time": "09:00 AM - 10:30 AM",
        "room": "Room 203",
        "teacher": "Prof. Anita Dharane",
        "color": Color(0xFFD1C4E9),
      },
      {
        "subject": "Web Development",
        "time": "10:45 AM - 12:15 PM",
        "room": "Lab 102",
        "teacher": "Prof. Web Expert",
        "color": Color(0xFFFFCCBC),
      },
      {
        "subject": "Lunch Break",
        "time": "12:15 PM - 01:00 PM",
        "room": "Cafeteria",
        "teacher": "",
        "color": Color(0xFFFFE0B2),
      },
      {
        "subject": "Data Structures",
        "time": "01:00 PM - 02:30 PM",
        "room": "Room 301",
        "teacher": "Dr. Micheal Sharma",
        "color": Color(0xFFC5CAE9),
      },
    ],
    // Wednesday
    [
      {
        "subject": "App Development",
        "time": "08:30 AM - 10:00 AM",
        "room": "Lab 103",
        "teacher": "Mr. Mobile Expert",
        "color": Color(0xFFB2DFDB),
      },
      {
        "subject": "Artificial Intelligence",
        "time": "10:15 AM - 11:45 AM",
        "room": "Room 205",
        "teacher": "Dr. AI Specialist",
        "color": Color(0xFFF0F4C3),
      },
      {
        "subject": "Lunch Break",
        "time": "11:45 AM - 12:30 PM",
        "room": "Cafeteria",
        "teacher": "",
        "color": Color(0xFFFFE0B2),
      },
      {
        "subject": "Database Lab",
        "time": "12:30 PM - 02:30 PM",
        "room": "Lab 104",
        "teacher": "Prof. Database Expert",
        "color": Color(0xFFF8BBD0),
      },
    ],
    // Thursday
    [
      {
        "subject": "Computer Architecture",
        "time": "09:00 AM - 10:30 AM",
        "room": "Room 207",
        "teacher": "Prof. Architecture Expert",
        "color": Color(0xFFCFD8DC),
      },
      {
        "subject": "Computer Networks Lab",
        "time": "10:45 AM - 12:45 PM",
        "room": "Lab 105",
        "teacher": "Dr. Networks Specialist",
        "color": Color(0xFFB3E5FC),
      },
      {
        "subject": "Lunch Break",
        "time": "12:45 PM - 01:30 PM",
        "room": "Cafeteria",
        "teacher": "",
        "color": Color(0xFFFFE0B2),
      },
      {
        "subject": "Project Work",
        "time": "01:30 PM - 03:00 PM",
        "room": "Project Lab",
        "teacher": "Multiple Faculties",
        "color": Color(0xFFE1BEE7),
      },
    ],
    // Friday
    [
      {
        "subject": "Cloud Computing",
        "time": "08:30 AM - 10:00 AM",
        "room": "Room 208",
        "teacher": "Dr. Cloud Expert",
        "color": Color(0xFFFFCDD2),
      },
      {
        "subject": "Machine Learning",
        "time": "10:15 AM - 11:45 AM",
        "room": "Lab 106",
        "teacher": "Prof. ML Specialist",
        "color": Color(0xFFBBDEFB),
      },
      {
        "subject": "Lunch Break",
        "time": "11:45 AM - 12:30 PM",
        "room": "Cafeteria",
        "teacher": "",
        "color": Color(0xFFFFE0B2),
      },
      {
        "subject": "Seminar",
        "time": "12:30 PM - 02:00 PM",
        "room": "Seminar Hall",
        "teacher": "Guest Speakers",
        "color": Color(0xFFC8E6C9),
      },
    ],
    // Saturday (Holiday)
    [],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text("Timetable", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [Tab(text: "Daily View"), Tab(text: "Weekly View")],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueColor,
        child: Icon(Icons.calendar_today),
        onPressed: () {
          // Calendar selection functionality
          _showDatePicker(context);
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildDailyView(), _buildWeeklyView()],
      ),
    );
  }

  Widget _buildDailyView() {
    return Column(
      children: [
        _buildDaySelector(),
        Expanded(
          child:
              weeklySchedule[_selectedDayIndex].isEmpty
                  ? _buildNoClassesView()
                  : _buildDaySchedule(weeklySchedule[_selectedDayIndex]),
        ),
      ],
    );
  }

  Widget _buildDaySelector() {
    return Container(
      height: 60,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weekDays.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedDayIndex == index;
          bool isToday = DateTime.now().weekday % 7 == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4.5,
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? blueColor
                        : (isToday
                            ? blueColor.withOpacity(0.1)
                            : Colors.transparent),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isToday ? blueColor : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekDays[index].substring(0, 3),
                    style: TextStyle(
                      color:
                          isSelected
                              ? Colors.white
                              : (isToday ? blueColor : Colors.black),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isToday && !isSelected)
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      width: 10,
                      height: 12,
                      decoration: BoxDecoration(
                        color: blueColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDaySchedule(List<Map<String, dynamic>> daySchedule) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: daySchedule.length,
      itemBuilder: (context, index) {
        final session = daySchedule[index];
        final bool isBreak = session["subject"].contains("Break");

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 75,
                child: Text(
                  session["time"].split(" - ")[0],
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 20,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: session["color"],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    if (index < daySchedule.length - 1)
                      Container(
                        width: 2,
                        height: isBreak ? 60 : 120,
                        color: Colors.grey[300],
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: session["color"].withOpacity(0.7),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session["subject"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(height: 8),
                        if (!isBreak) ...[
                          _buildClassInfoRow(Icons.person, session["teacher"]),
                          SizedBox(height: 4),
                          _buildClassInfoRow(Icons.room, session["room"]),
                          SizedBox(height: 4),
                          _buildClassInfoRow(
                            Icons.access_time,
                            session["time"].split(" - ")[1],
                          ),
                        ] else
                          _buildClassInfoRow(
                            Icons.location_on,
                            session["room"],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoClassesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            "No Classes Scheduled",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Enjoy your day off!",
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyView() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Weekly Schedule", Icons.event_note),
            SizedBox(height: 16),
            Container(
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 10,
                  headingRowColor: MaterialStateProperty.all(
                    blueColor.withOpacity(0.1),
                  ),
                  columns: [
                    DataColumn(
                      label: Text(
                        "Time",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                        ),
                      ),
                    ),
                    ...weekDays
                        .map(
                          (day) => DataColumn(
                            label: Text(
                              day.substring(0, 3),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: blueColor,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                  rows: [
                    _buildTimeTableRow("8:30 - 10:00", 0),
                    _buildTimeTableRow("10:15 - 11:45", 1),
                    _buildTimeTableRow("12:30 - 2:00", 3),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            _buildSectionHeader("Upcoming Classes", Icons.upcoming),
            SizedBox(height: 16),
            _buildUpcomingClassesList(),
          ],
        ),
      ),
    );
  }

  DataRow _buildTimeTableRow(String timeSlot, int slotIndex) {
    return DataRow(
      cells: [
        DataCell(
          Container(
            width: 92,
            child: Text(
              timeSlot,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        ...List.generate(7, (dayIndex) {
          // Skip Saturday
          if (dayIndex < 6 && weeklySchedule[dayIndex].length > slotIndex) {
            final subject = weeklySchedule[dayIndex][slotIndex];
            return DataCell(
              Container(
                width: 160,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: subject["color"].withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject["subject"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: 1),
                    Text(
                      subject["room"],
                      style: TextStyle(
                        fontSize: 9,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return DataCell(Container(width: 110));
          }
        }),
      ],
    );
  }

  Widget _buildUpcomingClassesList() {
    // Get next 3 classes from today
    final today = DateTime.now().weekday % 7;
    final currentTimeHour = DateTime.now().hour;
    final currentTimeMinute = DateTime.now().minute;

    List<Map<String, dynamic>> upcomingClasses = [];

    // Check today's remaining classes
    for (var session in weeklySchedule[today]) {
      if (!session["subject"].contains("Break")) {
        // Parse time like "08:30 AM" to compare
        final startTime = session["time"].split(" - ")[0];
        final isPM = startTime.contains("PM");
        final timeComponents = startTime
            .replaceAll(" AM", "")
            .replaceAll(" PM", "")
            .split(":");
        var hour = int.parse(timeComponents[0]);
        if (isPM && hour < 12) hour += 12;
        final minute = int.parse(timeComponents[1]);

        if (hour > currentTimeHour ||
            (hour == currentTimeHour && minute > currentTimeMinute)) {
          upcomingClasses.add({...session, "day": weekDays[today]});
          if (upcomingClasses.length >= 3) break;
        }
      }
    }

    // Add classes from upcoming days if needed
    if (upcomingClasses.length < 3) {
      int nextDay = (today + 1) % 7;
      while (nextDay != today && upcomingClasses.length < 3) {
        for (var session in weeklySchedule[nextDay]) {
          if (!session["subject"].contains("Break")) {
            upcomingClasses.add({...session, "day": weekDays[nextDay]});
            if (upcomingClasses.length >= 3) break;
          }
        }
        nextDay = (nextDay + 1) % 7;
      }
    }

    return upcomingClasses.isEmpty
        ? Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "No upcoming classes found",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        )
        : Column(
          children:
              upcomingClasses.map((session) {
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: session["color"].withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.book, color: Colors.black87),
                        ),
                      ],
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            session["subject"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: blueColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            session["day"].substring(0, 3),
                            style: TextStyle(
                              fontSize: 12,
                              color: blueColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        _buildClassInfoRow(Icons.access_time, session["time"]),
                        SizedBox(height: 4),
                        _buildClassInfoRow(Icons.person, session["teacher"]),
                        SizedBox(height: 4),
                        _buildClassInfoRow(Icons.room, session["room"]),
                      ],
                    ),
                  ),
                );
              }).toList(),
        );
  }

  Widget _buildClassInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: blueColor),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025, 1),
      lastDate: DateTime(2025, 12),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: blueColor,
            colorScheme: ColorScheme.light(primary: blueColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDayIndex = picked.weekday % 7;
      });
    }
  }
}

import 'package:cms/navigations/screens/library/bookhistory.dart';
import 'package:cms/navigations/screens/library/books.dart';
import 'package:cms/navigations/screens/library/ibrary-notification.dart';
import 'package:flutter/material.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  String selectedFaculty = 'BSc.CSIT';
  String selectedTimePeriod = '1';
  bool isLibrary = true; // true for library, false for returns
  bool isYearBased = false;

  final List<String> faculties = [
    'BSc.CSIT',
    'BIT',
    'BTech',
    'NUTRITION',
    'PHYSIC',
  ];

  final List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  final List<String> years = ['1', '2', '3', '4'];

  @override
  void initState() {
    super.initState();
    _updateTimePeriodType();
  }

  void _updateTimePeriodType() {
    // Check if the selected faculty uses years instead of semesters
    isYearBased = ['BTech', 'NUTRITION', 'PHYSIC'].contains(selectedFaculty);

    // Reset selected time period to first value when switching between year/semester
    selectedTimePeriod = '1';
  }

  @override
  Widget build(BuildContext context) {
    // Modern blue color scheme
    const Color primaryBlue = Color(0xFF1E88E5);
    const Color lightBlue = Color(0xFFBBDEFB);
    const Color darkBlue = Color(0xFF0D47A1);
    const Color backgroundColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        title: const Text(
          'Library',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          LibraryNotification(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder:
                (context) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.menu_book_rounded,
                          color: primaryBlue,
                        ),
                        title: const Text(
                          'Library Books',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onTap: () {
                          setState(() => isLibrary = true);
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(
                          Icons.assignment_return_rounded,
                          color: primaryBlue,
                        ),
                        title: const Text(
                          'Return Books',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onTap: () {
                          setState(() => isLibrary = false);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
          );
        },
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.swap_horiz),
        label: const Text('Switch View'),
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightBlue, backgroundColor],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 4),
                    child: Text(
                      isLibrary ? 'Available Books' : 'Book Return History',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                  ),

                  // Filters Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: darkBlue,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Faculty dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedFaculty,
                              icon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: primaryBlue,
                              ),
                              items:
                                  faculties.map((String faculty) {
                                    return DropdownMenuItem<String>(
                                      value: faculty,
                                      child: Text(
                                        faculty,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedFaculty = newValue!;
                                  _updateTimePeriodType();
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Semester/Year dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedTimePeriod,
                              icon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: primaryBlue,
                              ),
                              items:
                                  (isYearBased ? years : semesters).map((
                                    String period,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: period,
                                      child: Text(
                                        isYearBased
                                            ? 'Year $period'
                                            : 'Semester $period',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedTimePeriod = newValue!;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Search bar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search books...',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: primaryBlue,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                            onChanged: (value) {
                              // Implement search functionality
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Books content with animated transition
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child:
                        isLibrary
                            ? LibraryBooks(
                              key: const ValueKey('library'),
                              faculty: selectedFaculty,
                              semester: selectedTimePeriod,
                            )
                            : LibraryBooksHistory(
                              key: const ValueKey('history'),
                              faculty: selectedFaculty,
                              semester: selectedTimePeriod,
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

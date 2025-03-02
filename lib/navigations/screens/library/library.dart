import 'package:cms/datatypes/datatypes.dart';
import 'package:cms/navigations/screens/library/all_books_page.dart';
import 'package:cms/navigations/screens/library/all_history_page.dart';
import 'package:cms/navigations/screens/library/book_detail.dart';
import 'package:cms/navigations/screens/library/ibrary-notification.dart';
// import 'package:cms/navigations/screens/library/Library-notification.dart';
import 'package:flutter/material.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  String selectedFaculty = 'BSc.CSIT';
  String selectedSemester = '1';
  bool isLibrary = true; // true for library, false for returns

  final List<String> faculties = [
    'BSc.CSIT',
    'BIT',
    'BTech',
    'NUTRITION',
    'PHYSIC',
    
  ];

  final List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Library'),
          actions: [
            IconButton(
              icon: Icon(Icons.notification_important),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder:
                (context) => Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.book),
                        title: Text('Library Books'),
                        onTap: () {
                          setState(() => isLibrary = true);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.assignment_return),
                        title: Text('Return Books'),
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
        child: Icon(Icons.swap_horiz),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          color: GrayColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdowns
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedFaculty,
                        items:
                            faculties.map((String faculty) {
                              return DropdownMenuItem<String>(
                                value: faculty,
                                child: Text(faculty),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFaculty = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedSemester,
                        items:
                            semesters.map((String semester) {
                              return DropdownMenuItem<String>(
                                value: semester,
                                child: Text('Semester $semester'),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSemester = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Search Bar
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(25),
                child: SearchBar(
                  onChanged: (value) {
                    // Implement search
                  },
                  hintText: 'Search books...',
                ),
              ),
              SizedBox(height: 20),
              // Show either Library or Returns based on selection
              isLibrary
                  ? LibraryBooks(
                    faculty: selectedFaculty,
                    semester: selectedSemester,
                  )
                  : LibraryBooksHistory(
                    faculty: selectedFaculty,
                    semester: selectedSemester,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class LibraryBooks extends StatefulWidget {
  final String faculty;
  final String semester;

  const LibraryBooks({
    super.key,
    required this.faculty,
    required this.semester,
  });

  @override
  State<LibraryBooks> createState() => _LibraryBooksState();
}

class _LibraryBooksState extends State<LibraryBooks> {
  // Sample book data - you can expand this
  Map<String, List<Map<String, dynamic>>> facultyBooks = {
    'BSc.CSIT': [
      {
        "image": "assets/icons/icon6-form.png",
        "title": "Discrete Mathematics",
        "author": "Sushanr Suman Pokharel",
        "category": "Mathematics",
        "copies": 36,
        "semester": "1",
        "description":
            "Essential discrete mathematics concepts for computer science students.",
      },
      {
        "image": "assets/icons/icons1-library.png",
        "title": "C Programming",
        "author": " Sushant Mahadev",
        "category": "Programming",
        "copies": 36,
        "semester": "1",
        "description":
            "Comprehensive guide to C programming language fundamentals.",
      },
      {
        "image": "assets/icons/icons4-approve.png",
        "title": "Digital Logic",
        "author": "Dharti Bsdkmori",
        "category": "Electronics",
        "copies": 36,
        "semester": "1",
        "description":
            "Introduction to digital logic design and boolean algebra.",
      },
      {
        "image": "assets/images/profile.png",
        "title": "Physics",
        "author": "Bikash Holiday",
        "category": "Physics",
        "copies": 36,
        "semester": "1",
        "description": "Fundamental physics concepts for first-year students.",
      },
      {
        "image": "assets/icons/icons3-students.png",
        "title": "Technical Writing",
        "author": "Mandip Sony",
        "category": "English",
        "copies": 36,
        "semester": "1",
        "description": "Guide to technical writing and communication.",
      },
      // Semester 3
      {
        "image": "assets/images/profile.png",
        "title": "Calculus",
        "author": "Mandip TonyStark",
        "category": "Mathematics",
        "copies": 36,
        "semester": "3",
        "description":
            "Comprehensive calculus text covering derivatives and integrals.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "3",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "3",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "3",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "3",
        "description": "OOP concepts using C++ programming language.",
      },
      // Semester 4
      {
        "image": "assets/images/profile.png",
        "title": "Calculus",
        "author": "Mandip TonyStark",
        "category": "Mathematics",
        "copies": 36,
        "semester": "4",
        "description":
            "Comprehensive calculus text covering derivatives and integrals.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "4",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "4",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "4",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "4",
        "description": "OOP concepts using C++ programming language.",
      },
      // Semester 2
      {
        "image": "assets/images/profile.png",
        "title": "Calculus",
        "author": "Mandip TonyStark",
        "category": "Mathematics",
        "copies": 36,
        "semester": "2",
        "description":
            "Comprehensive calculus text covering derivatives and integrals.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "2",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "2",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "2",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "2",
        "description": "OOP concepts using C++ programming language.",
      },
      // Semester 5
      {
        "image": "assets/images/profile.png",
        "title": "Calculus",
        "author": "Mandip TonyStark",
        "category": "Mathematics",
        "copies": 36,
        "semester": "5",
        "description":
            "Comprehensive calculus text covering derivatives and integrals.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "5",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "5",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "5",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "5",
        "description": "OOP concepts using C++ programming language.",
      },
      // Semester 6
      {
        "image": "assets/images/profile.png",
        "title": "Calculus",
        "author": "Mandip TonyStark",
        "category": "Mathematics",
        "copies": 36,
        "semester": "6",
        "description":
            "Comprehensive calculus text covering derivatives and integrals.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "6",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "6",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "6",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "6",
        "description": "OOP concepts using C++ programming language.",
      },
      // Semester 7
      {
        "image": "assets/images/profile.png",
        "title": "Calculus",
        "author": "Mandip TonyStark",
        "category": "Mathematics",
        "copies": 36,
        "semester": "7",
        "description":
            "Comprehensive calculus text covering derivatives and integrals.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "7",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "7",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "7",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "7",
        "description": "OOP concepts using C++ programming language.",
      },
      // Semester 8
      {
        "image": "assets/images/profile.png",
        "title": "Calculus",
        "author": "Mandip TonyStark",
        "category": "Mathematics",
        "copies": 36,
        "semester": "8",
        "description":
            "Comprehensive calculus text covering derivatives and integrals.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "8",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "8",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "8",
        "description": "OOP concepts using C++ programming language.",
      },
      {
        "image": "assets/icons/icon8-meeting.png",
        "title": "Object-Oriented Programming",
        "author": "Rohan Bhargav",
        "category": "Programming",
        "copies": 36,
        "semester": "8",
        "description": "OOP concepts using C++ programming language.",
      },
    ],
    'BIT': [
      {
        "image": "assets/icons/icons4-approve.png",
        "title": "Python Programming",
        "author": "Eric Matthes",
        "category": "Programming",
        "copies": 36,
        "semester": "1",
        "description": "Introduction to Python programming language.",
      },
      {
        "image": "assets/icons/icon5-attendance.png",
        "title": "Web Technologies",
        "author": "Jennifer Robbins",
        "category": "Web",
        "copies": 36,
        "semester": "1",
        "description": "Fundamentals of web development and design.",
      },
    ],
    'BTech': [
      {
        "image": "assets/icons/icon5-attendance.png",
        "title": "Engineering Mechanics",
        "author": "R.C. Hibbeler",
        "category": "Mechanics",
        "copies": 36,
        "semester": "1",
        "description": "Fundamental principles of engineering mechanics.",
      },
    ],
    'NUTRITION': [
      {
        "image": "assets/icons/icon5-attendance.png",
        "title": "Basic Nutrition",
        "author": "Lisa Sanders",
        "category": "Nutrition",
        "copies": 36,
        "semester": "1",
        "description": "Introduction to nutrition science and dietetics.",
      },
    ],
    'PHYSIC': [
      {
        "image": "assets/icons/icon5-attendance.png",
        "title": "Quantum Physics",
        "author": "Stephen Hawking",
        "category": "Physics",
        "copies": 36,
        "semester": "1",
        "description": "Introduction to quantum mechanics and modern physics.",
      },
    ],
    'GEOLOGY': [
      {
        "image": "assets/icons/icons4-admin.png",
        "title": "Earth Science",
        "author": "Edward Tarbuck",
        "category": "Geology",
        "copies": 36,
        "semester": "1",
        "description":
            "Comprehensive introduction to geology and earth sciences.",
      },
    ],
  };

  List<Map<String, dynamic>> getBooks() {
    return (facultyBooks[widget.faculty] ?? [])
        .where((book) => book['semester'] == widget.semester)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final books = getBooks();
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
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
                "Available Books",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllBooksPage(books: books),
                    ),
                  );
                },
                child: Text("View All"),
              ),
            ],
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: books.length > 5 ? 5 : books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                leading: Image.asset(
                  book['image'],
                  width: 40,
                  height: 40,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.book, size: 40),
                ),
                title: Text(book['title']),
                subtitle: Text("Available: ${book['copies']} copies"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetail(book: book),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class LibraryBooksHistory extends StatefulWidget {
  final String faculty;
  final String semester;

  const LibraryBooksHistory({
    super.key,
    required this.faculty,
    required this.semester,
  });

  @override
  State<LibraryBooksHistory> createState() => _LibraryBooksHistoryState();
}

class _LibraryBooksHistoryState extends State<LibraryBooksHistory> {
  // Sample history data
  Map<String, List<Map<String, dynamic>>> facultyHistory = {
    'BSc.CSIT': [
      {
        "image": "assets/icons/icon6-form.png",
        "title": "Discrete Mathematics",
        "borrowDate": "2024-02-15",
        "returnDate": "2024-03-01",
        "status": "Returned",
        "student": "Sushant Pokheral",
        "class": "BSc.CSIT Sem 1",
        "semester": "1",
        "rollNo": "001",
        "condition": "Good",
      },
      {
        "image": "assets/icons/icons1-library.png",
        "title": "C Programming",
        "borrowDate": "2024-02-20",
        "returnDate": "2024-03-05",
        "status": "Pending",
        "student": "Mandip Nepal",
        "class": "BSc.CSIT Sem 1",
        "semester": "1",
        "rollNo": "002",
        "condition": "Fair",
      },
    ],
    'BIT': [
      {
        "image": "assets/icons/icons4-approve.png",
        "title": "Python Programming",
        "borrowDate": "2024-02-18",
        "returnDate": "2024-03-03",
        "status": "Returned",
        "student": "Mandip Sushant",
        "class": "BIT Sem 1",
        "semester": "1",
        "rollNo": "001",
        "condition": "Excellent",
      },
    ],
  };

  List<Map<String, dynamic>> getHistory() {
    return (facultyHistory[widget.faculty] ?? [])
        .where((history) => history['semester'] == widget.semester)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final history = getHistory();
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
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
                "Book Returns",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllHistoryPage(history: history),
                    ),
                  );
                },
                child: Text("View All"),
              ),
            ],
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: history.length > 5 ? 5 : history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                leading: Image.asset(
                  item['image'],
                  width: 40,
                  height: 40,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.history, size: 40),
                ),
                title: Text(item['title']),
                subtitle: Text("Borrowed: ${item['borrowDate']}"),
                trailing: Text(
                  item['status'],
                  style: TextStyle(
                    color:
                        item['status'] == 'Returned'
                            ? Colors.green
                            : Colors.orange,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

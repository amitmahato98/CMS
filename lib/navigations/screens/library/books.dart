import 'package:cms/navigations/screens/library/all_books_page.dart';
import 'package:cms/navigations/screens/library/book_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cms/theme/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);
    final books = getBooks();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Available Books",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AllBooksPage(
                            books: books,
                            title: "All Books",
                            faculty: widget.faculty,
                            semester: widget.semester,
                          ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: const [
                    Text(
                      "View All",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          books.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.book_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "No books available for this semester",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: books.length > 5 ? 5 : books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode
                              ? theme.colorScheme.surface
                              : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color:
                              isDarkMode
                                  ? Colors.black26
                                  : Colors.black.withOpacity(0.05),
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color:
                              isDarkMode
                                  ? theme.colorScheme.primary.withOpacity(0.2)
                                  : theme.colorScheme.surface.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            book['image'],
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Icon(
                                  Icons.book,
                                  size: 24,
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.7,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      title: Text(
                        book['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "Available: ${book['copies']} copies",
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                isDarkMode ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDarkMode
                                  ? theme.colorScheme.primary.withOpacity(0.2)
                                  : Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Details",
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailPage(book: book),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
          if (books.length > 5)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Center(
                child: Text(
                  "Showing 5 of ${books.length} items",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

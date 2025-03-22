import 'package:cms/navigations/screens/library/all_history_page.dart';
import 'package:flutter/material.dart';

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
  // Sample history data with additional faculty information
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
      {
        "image": "assets/icons/icon5-notice.png",
        "title": "Introduction to Computer Science",
        "borrowDate": "2024-01-10",
        "returnDate": "2024-01-25",
        "status": "Returned",
        "student": "Anjali Sharma",
        "class": "BSc.CSIT Sem 1",
        "semester": "1",
        "rollNo": "003",
        "condition": "Excellent",
      },
      {
        "image": "assets/icons/icons3-assignment.png",
        "title": "Digital Logic",
        "borrowDate": "2024-02-25",
        "returnDate": "2024-03-10",
        "status": "Pending",
        "student": "Rahul Patel",
        "class": "BSc.CSIT Sem 1",
        "semester": "1",
        "rollNo": "004",
        "condition": "Good",
      },
    ],
    'PHYSIC': [
      {
        "image": "assets/icons/icon6-form.png",
        "title": "Discrete PHYSIC",
        "borrowDate": "2024-02-15",
        "returnDate": "2024-03-01",
        "status": "Returned",
        "student": "Sushant Pokheral",
        "class": "PHYSIC year 1",
        "year": "1",
        "rollNo": "001",
        "condition": "Good",
      },
      {
        "image": "assets/icons/icons1-library.png",
        "title": "C PHYSIC",
        "borrowDate": "2024-02-20",
        "returnDate": "2024-03-05",
        "status": "Pending",
        "student": "Mandip Nepal",
        "class": "PHYSICT year 1",
        "year": "2",
        "rollNo": "002",
        "condition": "Fair",
      },
      {
        "image": "assets/icons/icons2-calendar.png",
        "title": "Modern Physics",
        "borrowDate": "2024-01-12",
        "returnDate": "2024-01-28",
        "status": "Returned",
        "student": "Priya Thakur",
        "class": "PHYSIC year 1",
        "year": "1",
        "rollNo": "003",
        "condition": "Good",
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
      {
        "image": "assets/icons/icons1-library.png",
        "title": "Database Management Systems",
        "borrowDate": "2024-02-01",
        "returnDate": "2024-02-15",
        "status": "Returned",
        "student": "Ravi Kumar",
        "class": "BIT Sem 1",
        "semester": "1",
        "rollNo": "005",
        "condition": "Good",
      },
      {
        "image": "assets/icons/icons3-assignment.png",
        "title": "Business Communication",
        "borrowDate": "2024-03-01",
        "returnDate": "2024-03-15",
        "status": "Pending",
        "student": "Anish Gupta",
        "class": "BIT Sem 1",
        "semester": "1",
        "rollNo": "007",
        "condition": "Fair",
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

    // Modern color scheme (matching the other pages)
    const Color primaryBlue = Color(0xFF1E88E5);
    const Color lightBlue = Color(0xFFBBDEFB);
    const Color darkBlue = Color(0xFF0D47A1);

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
                  Icon(Icons.history_rounded, color: darkBlue, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    "Book Returns",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: darkBlue,
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
                      builder: (context) => AllHistoryPage(history: history),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: primaryBlue,
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
          history.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "No borrowing history available",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length > 5 ? 5 : history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
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
                          color: lightBlue.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item['image'],
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Icon(
                                  Icons.menu_book_rounded,
                                  size: 24,
                                  color: primaryBlue.withOpacity(0.7),
                                ),
                          ),
                        ),
                      ),
                      title: Text(
                        item['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "Borrowed: ${item['borrowDate']}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
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
                              item['status'] == 'Returned'
                                  ? Colors.green[50]
                                  : Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item['status'] == 'Returned'
                                  ? Icons.check_circle_outline
                                  : Icons.watch_later_outlined,
                              size: 14,
                              color:
                                  item['status'] == 'Returned'
                                      ? Colors.green[700]
                                      : Colors.orange[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item['status'],
                              style: TextStyle(
                                color:
                                    item['status'] == 'Returned'
                                        ? Colors.green[700]
                                        : Colors.orange[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          if (history.length > 5)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Center(
                child: Text(
                  "Showing 5 of ${history.length} items",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
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

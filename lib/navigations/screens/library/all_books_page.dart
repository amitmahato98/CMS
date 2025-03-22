import 'package:flutter/material.dart';
import 'package:cms/navigations/screens/library/book_detail.dart';

class AllBooksPage extends StatelessWidget {
  final List<Map<String, dynamic>> books;

  const AllBooksPage({super.key, required this.books});

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
          'All Books',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                'Browse Collection',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: Text(
                '${books.length} books available',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetail(book: book),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                color: Colors.grey[200],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Image.asset(
                                  book['image'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.book_rounded,
                                              size: 50,
                                              color: primaryBlue.withOpacity(
                                                0.7,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Cover not available',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'By ${book['author']}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              int.parse(
                                                        book['copies']
                                                            .toString(),
                                                      ) >
                                                      0
                                                  ? Colors.green[50]
                                                  : Colors.red[50],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              int.parse(
                                                        book['copies']
                                                            .toString(),
                                                      ) >
                                                      0
                                                  ? Icons.check_circle_outline
                                                  : Icons.error_outline,
                                              size: 12,
                                              color:
                                                  int.parse(
                                                            book['copies']
                                                                .toString(),
                                                          ) >
                                                          0
                                                      ? Colors.green[700]
                                                      : Colors.red[700],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${book['copies']}',
                                              style: TextStyle(
                                                color:
                                                    int.parse(
                                                              book['copies']
                                                                  .toString(),
                                                            ) >
                                                            0
                                                        ? Colors.green[700]
                                                        : Colors.red[700],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: Colors.grey[400],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cms/navigations/screens/library/book_detail.dart';
import 'package:provider/provider.dart';
import 'package:cms/theme/theme_provider.dart';

class AllBooksPage extends StatelessWidget {
  final String title;
  final String faculty;
  final String semester;
  final List<Map<String, dynamic>>? books;

  const AllBooksPage({
    Key? key,
    required this.title,
    required this.faculty,
    required this.semester,
    this.books,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    // Mock data for books
    final List<Map<String, dynamic>> booksData = [
      {
        'id': 'book1',
        'title': 'Database Management Systems',
        'author': 'Ramakrishnan & Gehrke',
        'image': 'assets/images/book_covers/dbms.jpg',
        'cover': 'assets/images/book_covers/dbms.jpg',
        'rating': 4.7,
        'reviews': 142,
        'pages': 346,
        'description':
            'A comprehensive guide to database management systems and design principles.',
        'publisher': 'McGraw-Hill Education',
        'published': '2002',
        'isbn': '978-0072465631',
        'status': 'Available',
      },
      {
        'id': 'book2',
        'title': 'Introduction to Algorithms',
        'author': 'Cormen, Leiserson, Rivest & Stein',
        'image': 'assets/images/book_covers/algorithms.jpg',
        'cover': 'assets/images/book_covers/algorithms.jpg',
        'rating': 4.9,
        'reviews': 215,
        'pages': 1312,
        'description':
            'A comprehensive introduction to the modern study of computer algorithms.',
        'publisher': 'MIT Press',
        'published': '2009',
        'isbn': '978-0262033848',
        'status': 'Available',
      },
    ];

    // Use provided books or fallback to booksData
    final displayBooks = books ?? booksData;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title for $faculty - ${semester} Semester',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.primary,
                ),
                filled: true,
                fillColor:
                    isDarkMode ? theme.colorScheme.surface : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: displayBooks.length,
                itemBuilder: (context, index) {
                  final book = displayBooks[index];
                  return _buildBookListItem(context, book, isDarkMode, theme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookListItem(
    BuildContext context,
    Map<String, dynamic> book,
    bool isDarkMode,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookDetailPage(book: book)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? theme.colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode ? Colors.black26 : Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Book Cover
            Container(
              width: 80,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(book['cover'] ?? book['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Book Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'by ${book['author']}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '${book['rating'] ?? '4.5'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          ' (${book['reviews'] ?? '120'} reviews)',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isDarkMode ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            book['status'] ?? 'Available',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
  }
}

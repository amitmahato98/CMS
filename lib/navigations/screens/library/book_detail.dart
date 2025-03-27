import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cms/theme/theme_provider.dart';

class BookDetailPage extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Book Cover
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: book['id'] ?? 'book-cover',
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(book['cover'] ?? book['image']),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: [0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black38 : Colors.white38,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black38 : Colors.white38,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bookmark_border,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black38 : Colors.white38,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.share,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),

          // Book Details
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: Offset(0, -30),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Author
                      Text(
                        book['title'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'by ${book['author']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white70 : Colors.grey[700],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Rating and Stats
                      Row(
                        children: [
                          _buildStatCard(
                            context,
                            'Rating',
                            '${book['rating'] ?? '4.5'}',
                            Icons.star,
                            Colors.amber,
                            isDarkMode,
                            theme,
                          ),
                          SizedBox(width: 16),
                          _buildStatCard(
                            context,
                            'Reviews',
                            '${book['reviews'] ?? '120'}',
                            Icons.comment,
                            Colors.green,
                            isDarkMode,
                            theme,
                          ),
                          SizedBox(width: 16),
                          _buildStatCard(
                            context,
                            'Pages',
                            '${book['pages'] ?? '250'}',
                            Icons.menu_book,
                            Colors.blue,
                            isDarkMode,
                            theme,
                          ),
                        ],
                      ),

                      SizedBox(height: 32),

                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        book['description'] ?? 'No description available.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: isDarkMode ? Colors.white70 : Colors.grey[800],
                        ),
                      ),

                      SizedBox(height: 32),

                      // Additional Info
                      Text(
                        'Additional Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildInfoItem(
                        'Publisher',
                        book['publisher'] ?? 'Unknown',
                        Icons.business,
                        isDarkMode,
                        theme,
                      ),
                      Divider(
                        color: isDarkMode ? Colors.white24 : Colors.grey[300],
                      ),
                      _buildInfoItem(
                        'Published Date',
                        book['published'] ?? 'Unknown',
                        Icons.calendar_today,
                        isDarkMode,
                        theme,
                      ),
                      Divider(
                        color: isDarkMode ? Colors.white24 : Colors.grey[300],
                      ),
                      _buildInfoItem(
                        'Language',
                        book['language'] ?? 'English',
                        Icons.language,
                        isDarkMode,
                        theme,
                      ),
                      Divider(
                        color: isDarkMode ? Colors.white24 : Colors.grey[300],
                      ),
                      _buildInfoItem(
                        'ISBN',
                        book['isbn'] ?? 'Unknown',
                        Icons.qr_code,
                        isDarkMode,
                        theme,
                      ),

                      SizedBox(height: 32),

                      // Borrow Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Borrow Book',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Reserve Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: theme.colorScheme.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Reserve for Later',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
    ThemeData theme,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? theme.colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode ? Colors.black12 : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon,
    bool isDarkMode,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white60 : Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cms/theme/theme_provider.dart';

class AllHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const AllHistoryPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text(
          'Book History',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDarkMode
                    ? [theme.colorScheme.surface, theme.colorScheme.background]
                    : [
                      theme.colorScheme.primary.withOpacity(0.1),
                      theme.colorScheme.background,
                    ],
            stops: [0.0, 0.3],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                'Borrowing History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: Text(
                '${history.length} records found',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? theme.colorScheme.surface : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              isDarkMode
                                  ? Colors.black.withOpacity(0.2)
                                  : Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      childrenPadding: EdgeInsets.zero,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              isDarkMode
                                  ? theme.colorScheme.surface.withOpacity(0.7)
                                  : Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item['image'],
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.book_rounded,
                                    size: 28,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.7),
                                  ),
                                ),
                          ),
                        ),
                      ),
                      title: Text(
                        item['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Borrowed: ${item['borrowDate']}',
                          style: TextStyle(
                            color:
                                isDarkMode ? Colors.white70 : Colors.grey[600],
                            fontSize: 14,
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
                                  ? (isDarkMode
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.green[50])
                                  : (isDarkMode
                                      ? Colors.orange.withOpacity(0.2)
                                      : Colors.orange[50]),
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
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? theme.colorScheme.surface.withOpacity(0.7)
                                    : Colors.grey[50],
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(16),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  'Borrowing Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              _buildInfoRow(
                                'Student',
                                item['student'],
                                isDarkMode,
                                theme,
                              ),
                              _buildInfoRow(
                                'Class',
                                item['class'],
                                isDarkMode,
                                theme,
                              ),
                              _buildInfoRow(
                                'Borrow Date',
                                item['borrowDate'],
                                isDarkMode,
                                theme,
                              ),
                              _buildInfoRow(
                                'Return Date',
                                item['returnDate'],
                                isDarkMode,
                                theme,
                              ),
                              _buildInfoRow(
                                'Status',
                                item['status'],
                                isDarkMode,
                                theme,
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildInfoRow(
    String label,
    String value,
    bool isDarkMode,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

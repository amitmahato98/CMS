import 'package:flutter/material.dart';

class AllHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const AllHistoryPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    // Modern blue color scheme (matching AllBooksPage)
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
          'Book History',
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
                'Borrowing History',
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
                '${history.length} records found',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
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
                          color: Colors.grey[200],
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
                                    color: primaryBlue.withOpacity(0.7),
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
                            color: Colors.grey[600],
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
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
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
                                    color: darkBlue,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              _buildInfoRow('Student', item['student']),
                              _buildInfoRow('Class', item['class']),
                              _buildInfoRow('Borrow Date', item['borrowDate']),
                              _buildInfoRow('Return Date', item['returnDate']),
                              _buildInfoRow('Status', item['status']),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
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

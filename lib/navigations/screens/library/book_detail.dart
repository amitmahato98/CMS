import 'package:flutter/material.dart';

class BookDetail extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetail({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    // Modern blue color scheme (matching the other pages)
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
          'Book Details',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image section with gradient overlay
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: lightBlue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Book image
                  Center(
                    child: Image.asset(
                      book['image'],
                      fit: BoxFit.contain,
                      height: 200,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.book_rounded,
                                  size: 80,
                                  color: primaryBlue.withOpacity(0.7),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Cover not available',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ),
                  ),
                  // Bottom gradient for smooth transition
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            backgroundColor.withOpacity(0.8),
                            backgroundColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Availability indicator
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            int.parse(book['copies'].toString()) > 0
                                ? Colors.green[50]
                                : Colors.red[50],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            int.parse(book['copies'].toString()) > 0
                                ? Icons.check_circle_outline
                                : Icons.error_outline,
                            size: 14,
                            color:
                                int.parse(book['copies'].toString()) > 0
                                    ? Colors.green[700]
                                    : Colors.red[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            int.parse(book['copies'].toString()) > 0
                                ? 'Available'
                                : 'Unavailable',
                            style: TextStyle(
                              color:
                                  int.parse(book['copies'].toString()) > 0
                                      ? Colors.green[700]
                                      : Colors.red[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Book details section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and author
                  Text(
                    book['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By ${book['author']}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Book information card
                  _buildInfoCard(context, [
                    _buildInfoRow('Category', book['category']),
                    _buildInfoRow('Available Copies', '${book['copies']}'),
                    if (book['semester'] != null)
                      _buildInfoRow('Semester', book['semester']),
                  ], primaryBlue),
                  const SizedBox(height: 20),

                  // Description card
                  _buildDescriptionCard(
                    context,
                    book['description'] ?? 'No description available.',
                    primaryBlue,
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  _buildActionButtons(context, primaryBlue, darkBlue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    List<Widget> children,
    Color accentColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: accentColor, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Book Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(
    BuildContext context,
    String description,
    Color accentColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description_outlined, color: accentColor, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    Color primaryColor,
    Color darkColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Implement borrow functionality (keeping original logic)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Book borrowed successfully')),
              );
            },
            icon: const Icon(Icons.book),
            label: const Text(
              'Borrow Book',
              style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Implement reserve functionality (keeping original logic)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Book reserved successfully')),
              );
            },
            icon: const Icon(Icons.bookmark_border),
            label: const Text(
              'Reserve',
              style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: darkColor,
              side: BorderSide(color: darkColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

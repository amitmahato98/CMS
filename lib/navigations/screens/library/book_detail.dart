import 'package:flutter/material.dart';

class BookDetail extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetail({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Image.asset(
                book['image'],
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) => Icon(Icons.book, size: 100),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'By ${book['author']}',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  _buildInfoCard(context, [
                    _buildInfoRow('Category', book['category']),
                    _buildInfoRow('Available Copies', '${book['copies']}'),
                    if (book['semester'] != null)
                      _buildInfoRow('Semester', book['semester']),
                  ]),
                  SizedBox(height: 16),
                  _buildDescriptionCard(
                    context,
                    book['description'] ?? 'No description available.',
                  ),
                  SizedBox(height: 16),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context, String description) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(description, style: TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Implement borrow functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Book borrowed successfully')),
              );
            },
            icon: Icon(Icons.book),
            label: Text('Borrow Book'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Implement reserve functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Book reserved successfully')),
              );
            },
            icon: Icon(Icons.bookmark_border),
            label: Text('Reserve'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

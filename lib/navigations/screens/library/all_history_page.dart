import 'package:flutter/material.dart';

class AllHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const AllHistoryPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book History'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              leading: Image.asset(
                item['image'],
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.history, size: 40),
              ),
              title: Text(item['title']),
              subtitle: Text('Borrowed: ${item['borrowDate']}'),
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item['status'] == 'Returned'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item['status'],
                  style: TextStyle(
                    color: item['status'] == 'Returned'
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

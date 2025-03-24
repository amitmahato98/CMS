import 'package:flutter/material.dart';

class CreateAnnouncementPage extends StatefulWidget {
  const CreateAnnouncementPage({Key? key}) : super(key: key);

  @override
  _CreateAnnouncementPageState createState() => _CreateAnnouncementPageState();
}

class _CreateAnnouncementPageState extends State<CreateAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final List<String> _recipients = [
    'All Students',
    'All Faculty',
    'Computer Science Department',
    'Engineering Department',
  ];
  final List<String> _selectedRecipients = [];

  bool _isPinned = false;
  bool _isUrgent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitAnnouncement() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedRecipients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one recipient'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Announcement created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Announcement'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Announcement Title
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Announcement Title',
                          prefixIcon: const Icon(Icons.title),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Announcement Content
                      TextFormField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          labelText: 'Announcement Content',
                          alignLabelWithHint: true,
                          prefixIcon: const Icon(Icons.message),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: 6,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter announcement content';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Recipients Section
                      const Text(
                        'Recipients',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Recipients Chip selection
                      Wrap(
                        spacing: 8.0,
                        children:
                            _recipients.map((recipient) {
                              final isSelected = _selectedRecipients.contains(
                                recipient,
                              );
                              return FilterChip(
                                label: Text(recipient),
                                selected: isSelected,
                                selectedColor: Colors.orange.withOpacity(0.2),
                                checkmarkColor: Colors.orange,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedRecipients.add(recipient);
                                    } else {
                                      _selectedRecipients.remove(recipient);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Options Section
                      const Text(
                        'Options',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Pin Announcement
                      SwitchListTile(
                        title: const Text('Pin Announcement'),
                        subtitle: const Text(
                          'Keep at the top of announcements list',
                        ),
                        value: _isPinned,
                        activeColor: Colors.orange,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            _isPinned = value;
                          });
                        },
                      ),

                      // Mark as Urgent
                      SwitchListTile(
                        title: const Text('Mark as Urgent'),
                        subtitle: const Text(
                          'Highlight and send push notifications',
                        ),
                        value: _isUrgent,
                        activeColor: Colors.orange,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            _isUrgent = value;
                          });
                        },
                      ),

                      // Attachment section
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.attachment),
                        label: const Text('Add Attachment'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Attachment functionality
                        },
                      ),
                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.send, color: Colors.white),
                          label: const Text(
                            'Post Announcement',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _submitAnnouncement,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
    );
  }
}

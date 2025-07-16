import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatHomeScreen extends StatefulWidget {
  final bool isAdmin;

  const ChatHomeScreen({Key? key, required this.isAdmin}) : super(key: key);

  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.isAdmin ? 3 : 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardTheme.color;

    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  autofocus: true,
                )
                : Text(widget.isAdmin ? 'Admin Chat' : 'Teacher Chat'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          if (widget.isAdmin)
            IconButton(
              icon: Icon(Icons.group_add),
              onPressed: () {
                // Show dialog to create new group
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Chats'),
            Tab(text: 'Groups'),
            if (widget.isAdmin) Tab(text: 'Broadcasts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatListView(isAdmin: widget.isAdmin, filter: 'direct'),
          ChatListView(isAdmin: widget.isAdmin, filter: 'group'),
          if (widget.isAdmin) BroadcastView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.message, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewMessageScreen(isAdmin: widget.isAdmin),
            ),
          );
        },
      ),
    );
  }
}

// Chat List Component
class ChatListView extends StatelessWidget {
  final bool isAdmin;
  final String filter;

  const ChatListView({Key? key, required this.isAdmin, required this.filter})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardTheme.color;

    // Simulated data - would come from your backend
    final List<Map<String, dynamic>> chats = [
      {
        'id': '1',
        'name':
            filter == 'direct'
                ? (isAdmin ? 'John Smith (Physics)' : 'Admin')
                : 'Physics Department',
        'lastMessage': 'Please submit the attendance report',
        'time': '10:30 AM',
        'unread': 2,
        'isOnline': true,
        'avatar': 'assets/avatar1.png',
        'category': 'attendance',
      },
      {
        'id': '2',
        'name':
            filter == 'direct'
                ? (isAdmin ? 'Sarah Johnson (Math)' : 'Admin')
                : 'Math Department',
        'lastMessage': 'The meeting is scheduled for tomorrow',
        'time': 'Yesterday',
        'unread': 0,
        'isOnline': false,
        'avatar': 'assets/avatar2.png',
        'category': 'general',
      },
      {
        'id': '3',
        'name':
            filter == 'direct'
                ? (isAdmin ? 'David Lee (English)' : 'Admin')
                : 'All Teachers',
        'lastMessage': 'New attendance policy is now available',
        'time': '2 days ago',
        'unread': 5,
        'isOnline': true,
        'avatar': 'assets/avatar3.png',
        'category': 'attendance',
      },
    ];

    return Column(
      children: [
        // Category filter
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip(context, 'All', true),
              SizedBox(width: 8),
              _buildFilterChip(context, 'Attendance', false),
              SizedBox(width: 8),
              _buildFilterChip(context, 'Events', false),
              SizedBox(width: 8),
              _buildFilterChip(context, 'Important', false),
            ],
          ),
        ),

        // Chat list
        Expanded(
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(chat['avatar']),
                        radius: 24,
                      ),
                      if (chat['isOnline'])
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    isDarkMode
                                        ? Color(0xFF121212)
                                        : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat['name'],
                          style: TextStyle(
                            fontWeight:
                                chat['unread'] > 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        chat['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      if (chat['category'] == 'attendance')
                        Container(
                          margin: EdgeInsets.only(right: 4),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Attendance',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          chat['lastMessage'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ),
                      if (chat['unread'] > 0)
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat['unread'].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ChatDetailScreen(
                              chatId: chat['id'],
                              chatName: chat['name'],
                              isOnline: chat['isOnline'],
                              isAdmin: isAdmin,
                              isGroup: filter == 'group',
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // Apply filter
      },
      backgroundColor: isDarkMode ? Color(0xFF1A1A1A) : Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color:
            isSelected
                ? Theme.of(context).primaryColor
                : (isDarkMode ? Colors.white : Colors.black87),
      ),
    );
  }
}

// Chat Detail Screen
class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String chatName;
  final bool isOnline;
  final bool isAdmin;
  final bool isGroup;

  const ChatDetailScreen({
    Key? key,
    required this.chatId,
    required this.chatName,
    required this.isOnline,
    required this.isAdmin,
    required this.isGroup,
  }) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isAttachmentVisible = false;

  // Sample message data
  final List<Map<String, dynamic>> messages = [
    {
      'id': '1',
      'text': 'Please submit the attendance report for this month',
      'time': '10:30 AM',
      'isMe': true,
      'isRead': true,
      'type': 'text',
    },
    {
      'id': '2',
      'text': 'I will submit it by tomorrow',
      'time': '10:32 AM',
      'isMe': false,
      'isRead': true,
      'type': 'text',
    },
    {
      'id': '3',
      'text':
          'Could you also include the students who were absent for more than 3 days?',
      'time': '10:35 AM',
      'isMe': true,
      'isRead': true,
      'type': 'text',
    },
    {
      'id': '4',
      'text': 'Sure, I will include that information.',
      'time': '10:36 AM',
      'isMe': false,
      'isRead': true,
      'type': 'text',
    },
    {
      'id': '5',
      'text': 'Here is the attendance report template',
      'time': '10:40 AM',
      'isMe': true,
      'isRead': false,
      'type': 'file',
      'fileName': 'attendance_template.xlsx',
      'fileSize': '245 KB',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardTheme.color;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/avatar1.png'),
              radius: 20,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.chatName, style: TextStyle(fontSize: 16)),
                  Text(
                    widget.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildChatActions(context),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              reverse: false,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['isMe'];

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: isMe ? 64 : 0,
                      right: isMe ? 0 : 64,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isMe
                              ? primaryColor
                              : (isDarkMode
                                  ? Color(0xFF1A1A1A)
                                  : Colors.grey[200]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message['type'] == 'text')
                          Text(
                            message['text'],
                            style: TextStyle(
                              color:
                                  isMe
                                      ? Colors.white
                                      : (isDarkMode
                                          ? Colors.white
                                          : Colors.black87),
                            ),
                          )
                        else if (message['type'] == 'file')
                          _buildFileMessage(context, message, isMe),
                        SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              message['time'],
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                    isMe
                                        ? Colors.white70
                                        : (isDarkMode
                                            ? Colors.white60
                                            : Colors.black54),
                              ),
                            ),
                            if (isMe)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Icon(
                                  message['isRead']
                                      ? Icons.done_all
                                      : Icons.done,
                                  size: 14,
                                  color:
                                      message['isRead']
                                          ? Colors.white70
                                          : Colors.white60,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Attachment options
          if (_isAttachmentVisible)
            Container(
              padding: EdgeInsets.all(8),
              color: isDarkMode ? Color(0xFF1A1A1A) : Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    context,
                    Icons.image,
                    'Photo',
                    Colors.purple,
                  ),
                  _buildAttachmentOption(
                    context,
                    Icons.insert_drive_file,
                    'Document',
                    Colors.blue,
                  ),
                  _buildAttachmentOption(
                    context,
                    Icons.camera_alt,
                    'Camera',
                    Colors.red,
                  ),
                  _buildAttachmentOption(
                    context,
                    Icons.mic,
                    'Audio',
                    Colors.orange,
                  ),
                ],
              ),
            ),

          // Message input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF1A1A1A) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isAttachmentVisible ? Icons.close : Icons.attach_file,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isAttachmentVisible = !_isAttachmentVisible;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          isDarkMode ? Color(0xFF151515) : Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 24,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Send message
                      if (_messageController.text.trim().isNotEmpty) {
                        // Add message to the chat
                        setState(() {
                          messages.add({
                            'id': '${messages.length + 1}',
                            'text': _messageController.text,
                            'time':
                                '${DateTime.now().hour}:${DateTime.now().minute}',
                            'isMe': true,
                            'isRead': false,
                            'type': 'text',
                          });
                          _messageController.clear();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileMessage(
    BuildContext context,
    Map<String, dynamic> message,
    bool isMe,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color:
            isMe
                ? Colors.white.withOpacity(0.1)
                : (isDarkMode
                    ? Color(0xFF252525)
                    : Colors.white.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.insert_drive_file,
            color: isMe ? Colors.white : Theme.of(context).primaryColor,
            size: 24,
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message['fileName'],
                style: TextStyle(
                  color:
                      isMe
                          ? Colors.white
                          : (isDarkMode ? Colors.white : Colors.black87),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                message['fileSize'],
                style: TextStyle(
                  fontSize: 12,
                  color:
                      isMe
                          ? Colors.white70
                          : (isDarkMode ? Colors.white60 : Colors.black54),
                ),
              ),
            ],
          ),
          SizedBox(width: 8),
          Icon(
            Icons.download,
            color: isMe ? Colors.white70 : Theme.of(context).primaryColor,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildChatActions(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDarkMode ? Color(0xFF151515) : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
            onTap: () {
              Navigator.pop(context);
              // Show search UI
            },
          ),
          if (widget.isAdmin)
            ListTile(
              leading: Icon(Icons.push_pin),
              title: Text('Pin Chat'),
              onTap: () {
                Navigator.pop(context);
                // Pin chat
              },
            ),
          if (widget.isGroup && widget.isAdmin)
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Add Member'),
              onTap: () {
                Navigator.pop(context);
                // Show add member UI
              },
            ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Mute Notifications'),
            onTap: () {
              Navigator.pop(context);
              // Mute notifications
            },
          ),
          if (widget.isAdmin)
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete Chat', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // Show delete confirmation
              },
            ),
        ],
      ),
    );
  }
}

// Broadcast View Component for Admin
class BroadcastView extends StatefulWidget {
  @override
  _BroadcastViewState createState() => _BroadcastViewState();
}

class _BroadcastViewState extends State<BroadcastView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedCategory = 'General';
  List<String> _recipients = [];

  final List<Map<String, dynamic>> broadcasts = [
    {
      'id': '1',
      'title': 'End of Term Exams',
      'message': 'Please submit all grades by next Friday',
      'time': '2 days ago',
      'category': 'Academic',
      'recipients': ['All Teachers'],
    },
    {
      'id': '2',
      'title': 'New Attendance Policy',
      'message':
          'Starting next month, all attendance must be submitted by 10am',
      'time': '1 week ago',
      'category': 'Attendance',
      'recipients': ['All Teachers'],
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        // Category filter
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip(context, 'All', true),
              SizedBox(width: 8),
              _buildFilterChip(context, 'Attendance', false),
              SizedBox(width: 8),
              _buildFilterChip(context, 'Academic', false),
              SizedBox(width: 8),
              _buildFilterChip(context, 'Events', false),
            ],
          ),
        ),

        // Broadcast list
        Expanded(
          child: ListView.builder(
            itemCount: broadcasts.length,
            itemBuilder: (context, index) {
              final broadcast = broadcasts[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          broadcast['title'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        broadcast['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              broadcast['category'],
                              style: TextStyle(
                                fontSize: 10,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'To: ${broadcast['recipients'].join(', ')}',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    isDarkMode
                                        ? Colors.white60
                                        : Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        broadcast['message'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // View broadcast details
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // Apply filter
      },
      backgroundColor: isDarkMode ? Color(0xFF1A1A1A) : Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color:
            isSelected
                ? Theme.of(context).primaryColor
                : (isDarkMode ? Colors.white : Colors.black87),
      ),
    );
  }
}

// New Message Screen
class NewMessageScreen extends StatefulWidget {
  final bool isAdmin;

  const NewMessageScreen({Key? key, required this.isAdmin}) : super(key: key);

  @override
  _NewMessageScreenState createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _contacts = [
    {
      'id': '1',
      'name': 'John Smith',
      'department': 'Physics',
      'avatar': 'assets/avatar1.png',
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Sarah Johnson',
      'department': 'Math',
      'avatar': 'assets/avatar2.png',
      'isOnline': false,
    },
    {
      'id': '3',
      'id': '3',
      'name': 'David Lee',
      'department': 'English',
      'avatar': 'assets/avatar3.png',
      'isOnline': true,
    },
    {
      'id': '4',
      'name': 'Maria Garcia',
      'department': 'Chemistry',
      'avatar': 'assets/avatar4.png',
      'isOnline': false,
    },
    {
      'id': '5',
      'name': 'Robert Chen',
      'department': 'Computer Science',
      'avatar': 'assets/avatar5.png',
      'isOnline': true,
    },
  ];

  List<Map<String, dynamic>> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _filteredContacts = List.from(_contacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = List.from(_contacts);
      } else {
        _filteredContacts =
            _contacts
                .where(
                  (contact) =>
                      contact['name'].toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      contact['department'].toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Message'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode ? Color(0xFF1A1A1A) : Colors.grey[200],
              ),
              onChanged: _filterContacts,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (widget.isAdmin)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.group, color: Colors.white),
              ),
              title: Text('Create Group Chat'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateGroupScreen()),
                );
              },
            ),
          if (widget.isAdmin)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.campaign, color: Colors.white),
              ),
              title: Text('New Broadcast Message'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewBroadcastScreen()),
                );
              },
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(contact['avatar']),
                        radius: 24,
                      ),
                      if (contact['isOnline'])
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    isDarkMode
                                        ? Color(0xFF121212)
                                        : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(contact['name']),
                  subtitle: Text(contact['department']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ChatDetailScreen(
                              chatId: contact['id'],
                              chatName:
                                  contact['name'] +
                                  ' (' +
                                  contact['department'] +
                                  ')',
                              isOnline: contact['isOnline'],
                              isAdmin: widget.isAdmin,
                              isGroup: false,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Create Group Screen
class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _contacts = [
    {
      'id': '1',
      'name': 'John Smith',
      'department': 'Physics',
      'avatar': 'assets/avatar1.png',
      'isSelected': false,
    },
    {
      'id': '2',
      'name': 'Sarah Johnson',
      'department': 'Math',
      'avatar': 'assets/avatar2.png',
      'isSelected': false,
    },
    {
      'id': '3',
      'name': 'David Lee',
      'department': 'English',
      'avatar': 'assets/avatar3.png',
      'isSelected': false,
    },
    {
      'id': '4',
      'name': 'Maria Garcia',
      'department': 'Chemistry',
      'avatar': 'assets/avatar4.png',
      'isSelected': false,
    },
    {
      'id': '5',
      'name': 'Robert Chen',
      'department': 'Computer Science',
      'avatar': 'assets/avatar5.png',
      'isSelected': false,
    },
  ];

  List<Map<String, dynamic>> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _filteredContacts = List.from(_contacts);
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = List.from(_contacts);
      } else {
        _filteredContacts =
            _contacts
                .where(
                  (contact) =>
                      contact['name'].toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      contact['department'].toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
      }
    });
  }

  int get _selectedCount =>
      _contacts.where((contact) => contact['isSelected']).length;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
        actions: [
          if (_selectedCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '$_selectedCount selected',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.group),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode ? Color(0xFF1A1A1A) : Colors.grey[200],
              ),
              onChanged: _filterContacts,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                final originalIndex = _contacts.indexWhere(
                  (c) => c['id'] == contact['id'],
                );

                return CheckboxListTile(
                  title: Text(contact['name']),
                  subtitle: Text(contact['department']),
                  secondary: CircleAvatar(
                    backgroundImage: AssetImage(contact['avatar']),
                  ),
                  value: _contacts[originalIndex]['isSelected'],
                  activeColor: primaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      _contacts[originalIndex]['isSelected'] = value!;
                      _filteredContacts = List.from(_filteredContacts);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            _selectedCount > 0
                ? () {
                  // Create group logic
                  Navigator.pop(context);
                  // Navigate to the new group chat
                }
                : null,
        label: Text('Create Group'),
        icon: Icon(Icons.check),
        backgroundColor: _selectedCount > 0 ? primaryColor : Colors.grey,
      ),
    );
  }
}

// New Broadcast Screen
class NewBroadcastScreen extends StatefulWidget {
  @override
  _NewBroadcastScreenState createState() => _NewBroadcastScreenState();
}

class _NewBroadcastScreenState extends State<NewBroadcastScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedCategory = 'General';
  List<String> _categories = [
    'General',
    'Attendance',
    'Academic',
    'Events',
    'Urgent',
  ];

  final List<Map<String, dynamic>> _recipients = [
    {'id': '1', 'name': 'All Teachers', 'isSelected': false},
    {'id': '2', 'name': 'Physics Department', 'isSelected': false},
    {'id': '3', 'name': 'Math Department', 'isSelected': false},
    {'id': '4', 'name': 'English Department', 'isSelected': false},
    {'id': '5', 'name': 'Chemistry Department', 'isSelected': false},
    {'id': '6', 'name': 'Computer Science Department', 'isSelected': false},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  int get _selectedCount =>
      _recipients.where((recipient) => recipient['isSelected']).length;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(title: Text('New Broadcast')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items:
                  _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Recipients',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _recipients.length,
              itemBuilder: (context, index) {
                final recipient = _recipients[index];

                return CheckboxListTile(
                  title: Text(recipient['name']),
                  value: recipient['isSelected'],
                  activeColor: primaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      recipient['isSelected'] = value!;
                    });
                  },
                );
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                TextButton.icon(
                  icon: Icon(Icons.attach_file),
                  label: Text('Add Attachment'),
                  onPressed: () {
                    // Add attachment logic
                  },
                ),
                Spacer(),
                ElevatedButton.icon(
                  icon: Icon(Icons.send),
                  label: Text('Send Broadcast'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                      _selectedCount > 0 &&
                              _titleController.text.isNotEmpty &&
                              _messageController.text.isNotEmpty
                          ? () {
                            // Send broadcast logic
                            Navigator.pop(context);
                          }
                          : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Attendance Chat Section (for Teachers)
class AttendanceChatSection extends StatefulWidget {
  @override
  _AttendanceChatSectionState createState() => _AttendanceChatSectionState();
}

class _AttendanceChatSectionState extends State<AttendanceChatSection> {
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> _attendanceIssues = [
    {
      'id': '1',
      'studentName': 'Alex Johnson',
      'rollNumber': 'CS2021-001',
      'date': '2023-04-15',
      'status': 'pending',
      'reason': 'Medical leave',
      'attachment': 'medical_certificate.pdf',
    },
    {
      'id': '2',
      'studentName': 'Emily Chen',
      'rollNumber': 'CS2021-042',
      'date': '2023-04-14',
      'status': 'approved',
      'reason': 'Family emergency',
      'attachment': null,
    },
    {
      'id': '3',
      'studentName': 'Michael Brown',
      'rollNumber': 'CS2021-028',
      'date': '2023-04-13',
      'status': 'rejected',
      'reason': 'Sports event',
      'attachment': 'sports_notice.pdf',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Issues'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _attendanceIssues.length,
        itemBuilder: (context, index) {
          final issue = _attendanceIssues[index];

          Color statusColor;
          IconData statusIcon;

          switch (issue['status']) {
            case 'pending':
              statusColor = Colors.orange;
              statusIcon = Icons.hourglass_empty;
              break;
            case 'approved':
              statusColor = Colors.green;
              statusIcon = Icons.check_circle;
              break;
            case 'rejected':
              statusColor = Colors.red;
              statusIcon = Icons.cancel;
              break;
            default:
              statusColor = Colors.grey;
              statusIcon = Icons.help;
          }

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: statusColor.withOpacity(0.2),
                child: Icon(statusIcon, color: statusColor),
              ),
              title: Text(
                issue['studentName'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Roll No: ${issue['rollNumber']} • ${issue['date']}',
              ),
              trailing: Text(
                issue['status'].toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reason:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(issue['reason']),
                      SizedBox(height: 8),
                      if (issue['attachment'] != null) ...[
                        Text(
                          'Attachment:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? Color(0xFF1A1A1A)
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.insert_drive_file,
                                color: primaryColor,
                              ),
                              SizedBox(width: 8),
                              Text(issue['attachment']),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.download, color: primaryColor),
                                onPressed: () {
                                  // Download attachment
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 16),
                      if (issue['status'] == 'pending')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              icon: Icon(Icons.close, color: Colors.red),
                              label: Text(
                                'Reject',
                                style: TextStyle(color: Colors.red),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Reject logic
                              },
                            ),
                            SizedBox(width: 8),
                            ElevatedButton.icon(
                              icon: Icon(Icons.check),
                              label: Text('Approve'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Approve logic
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new attendance issue
        },
        child: Icon(Icons.add),
        backgroundColor: primaryColor,
      ),
    );
  }
}

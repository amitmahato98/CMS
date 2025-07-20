import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen>
    with TickerProviderStateMixin {
  String selectedFilter = 'all';
  String searchQuery = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<User> users = [];
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadPreferences();
    await _loadUsers();
    await _loadFilterState();
    _animationController.forward();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadUsers() async {
    if (prefs == null) return;

    final usersJson = prefs!.getStringList('users_data');
    if (usersJson != null && usersJson.isNotEmpty) {
      setState(() {
        users =
            usersJson.map((userString) {
              final userMap = jsonDecode(userString);
              return User.fromJson(userMap);
            }).toList();
      });
    } else {
      _loadDefaultUsers();
    }
  }

  void _loadDefaultUsers() {
    setState(() {
      users = [
        User(
          id: '1',
          name: 'Dr. Saroj Karki',
          email: 'sarojkrki@school.edu',
          role: UserRole.teacher,
          status: UserStatus.pending,
          initials: 'SK',
        ),
        User(
          id: '2',
          name: 'Alexender Chetry',
          email: 'alex.chetrii@student.edu',
          role: UserRole.student,
          status: UserStatus.pending,
          initials: 'AC',
        ),
        User(
          id: '3',
          name: 'Mandip Raina',
          email: 'mandeep.raina@parent.com',
          role: UserRole.parent,
          status: UserStatus.approved,
          initials: 'MR',
        ),
        User(
          id: '4',
          name: 'Admin Amit',
          email: 'admin@school.edu',
          role: UserRole.admin,
          status: UserStatus.pending,
          initials: 'AA',
        ),
        User(
          id: '5',
          name: 'Emly Rai',
          email: 'emm.lee@student.edu',
          role: UserRole.student,
          status: UserStatus.pending,
          initials: 'ER',
        ),
        User(
          id: '6',
          name: 'Prof. Michael Mandip',
          email: 'michael.mandip@school.edu',
          role: UserRole.teacher,
          status: UserStatus.pending,
          initials: 'MM',
        ),
        User(
          id: '7',
          name: 'Time Raina',
          email: 'time.raina@parent.com',
          role: UserRole.parent,
          status: UserStatus.pending,
          initials: 'TR',
        ),
        User(
          id: '8',
          name: 'Admin Mahato',
          email: 'admin.mahato@school.edu',
          role: UserRole.admin,
          status: UserStatus.approved,
          initials: 'AM',
        ),
        User(
          id: '9',
          name: 'Sushant Rai',
          email: 'sush.antman@student.edu',
          role: UserRole.student,
          status: UserStatus.approved,
          initials: 'ER',
        ),
        User(
          id: '10',
          name: 'Prof. Michael Prabhat',
          email: 'michael.mandip@school.edu',
          role: UserRole.teacher,
          status: UserStatus.pending,
          initials: 'MP',
        ),
        User(
          id: '11',
          name: 'Dhruv Rathee',
          email: 'dhruv.rathee@parent.com',
          role: UserRole.parent,
          status: UserStatus.pending,
          initials: 'DR',
        ),
        User(
          id: '12',
          name: 'Admin Amit Mahato',
          email: 'admin.amit.mahato@school.edu',
          role: UserRole.admin,
          status: UserStatus.pending,
          initials: 'AM',
        ),
      ];
    });
    _saveUsers();
  }

  Future<void> _saveUsers() async {
    if (prefs == null) return;

    final usersJson = users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs!.setStringList('users_data', usersJson);
  }

  Future<void> _loadFilterState() async {
    if (prefs == null) return;

    final savedFilter = prefs!.getString('selected_filter');
    final savedSearch = prefs!.getString('search_query');

    if (savedFilter != null) {
      setState(() {
        selectedFilter = savedFilter;
      });
    }

    if (savedSearch != null) {
      setState(() {
        searchQuery = savedSearch;
      });
    }
  }

  Future<void> _saveFilterState() async {
    if (prefs == null) return;

    await prefs!.setString('selected_filter', selectedFilter);
    await prefs!.setString('search_query', searchQuery);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<User> get filteredUsers {
    List<User> filtered = users;

    if (selectedFilter != 'all') {
      if (['teacher', 'student', 'parent', 'admin'].contains(selectedFilter)) {
        filtered =
            filtered
                .where(
                  (user) =>
                      user.role.toString().split('.').last == selectedFilter,
                )
                .toList();
      } else {
        filtered =
            filtered
                .where(
                  (user) =>
                      user.status.toString().split('.').last == selectedFilter,
                )
                .toList();
      }
    }

    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (user) =>
                    user.name.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    user.email.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildFuturisticAppBar(context, isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildSearchAndFilter(context, isDark),
            _buildFilterTabs(context, isDark),
            Expanded(child: _buildUserList(context, isDark)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildFuturisticAppBar(
    BuildContext context,
    bool isDark,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: blueColor,
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(Icons.group, color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          Text(
            'User Management',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, bool isDark) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? darkBlack : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? darkBlack : Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: isDark ? Colors.white70 : Colors.grey.shade600,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                  _saveFilterState();
                },
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.inter(
                    color: isDark ? Colors.white54 : Colors.grey.shade500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context, bool isDark) {
    final filters = [
      {'key': 'all', 'label': 'All', 'icon': Icons.people},
      {'key': 'teacher', 'label': 'Teachers', 'icon': Icons.school},
      {'key': 'student', 'label': 'Students', 'icon': Icons.person},
      {'key': 'parent', 'label': 'Parents', 'icon': Icons.family_restroom},
      {'key': 'admin', 'label': 'Admins', 'icon': Icons.admin_panel_settings},
      {'key': 'pending', 'label': 'Pending', 'icon': Icons.pending},
    ];

    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter['key'];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter['key'] as String;
              });
              _saveFilterState();
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? blueColor
                        : isDark
                        ? darkBlack
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color:
                      isSelected
                          ? blueColor
                          : isDark
                          ? darkBlack
                          : Colors.grey.shade300,
                  width: 1,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: blueColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    color:
                        isSelected
                            ? Colors.white
                            : isDark
                            ? Colors.white70
                            : Colors.grey.shade700,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    filter['label'] as String,
                    style: GoogleFonts.inter(
                      color:
                          isSelected
                              ? Colors.white
                              : isDark
                              ? Colors.white70
                              : Colors.grey.shade700,
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserList(BuildContext context, bool isDark) {
    final filtered = filteredUsers;

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? darkBlack : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 48,
                color: isDark ? Colors.white38 : Colors.grey.shade400,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'No users found',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _buildUserCard(context, filtered[index], isDark, index);
      },
    );
  }

  Widget _buildUserCard(
    BuildContext context,
    User user,
    bool isDark,
    int index,
  ) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 16),
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 600),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? darkBlack : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? darkBlack : Colors.grey.shade200,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isDark
                              ? Colors.black.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.1),
                      blurRadius: 15,
                      offset: Offset(0, 4),
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildFuturisticAvatar(user, isDark),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color:
                                        isDark
                                            ? Colors.white70
                                            : Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildRoleChip(user.role, isDark),
                                    SizedBox(width: 8),
                                    _buildStatusBadge(user.status, isDark),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          _buildActionButton(
                            context,
                            icon: Icons.delete_outline,
                            color: const Color.fromARGB(255, 226, 88, 85),
                            onPressed: () => _showDeleteDialog(context, user),
                          ),
                        ],
                      ),
                      if (user.status == UserStatus.pending) ...[
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                context,
                                icon: Icons.check,
                                color: Color(0xFF4CAF50),
                                label: 'Approve',
                                isExpanded: true,
                                onPressed: () => _approveUser(user),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildActionButton(
                                context,
                                icon: Icons.close,
                                color: Colors.orange.shade400,
                                label: 'Reject',
                                isExpanded: true,
                                onPressed: () => _rejectUser(user),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFuturisticAvatar(User user, bool isDark) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [blueColor, Color(0xFF1976D2)],
        ),
        border: Border.all(color: isDark ? darkBlack : Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: blueColor.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          user.initials,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleChip(UserRole role, bool isDark) {
    Color chipColor;
    IconData chipIcon;

    switch (role) {
      case UserRole.teacher:
        chipColor = blueColor;
        chipIcon = Icons.school;
        break;
      case UserRole.student:
        chipColor = Color.fromARGB(255, 76, 175, 80);
        chipIcon = Icons.person;
        break;
      case UserRole.parent:
        chipColor = Color.fromARGB(255, 158, 158, 158);
        chipIcon = Icons.family_restroom;
        break;
      case UserRole.admin:
        chipColor = Color.fromARGB(255, 230, 116, 116);
        chipIcon = Icons.admin_panel_settings;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(chipIcon, size: 12, color: chipColor),
          SizedBox(width: 4),
          Text(
            role.toString().split('.').last.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: chipColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(UserStatus status, bool isDark) {
    Color badgeColor;
    IconData badgeIcon;

    switch (status) {
      case UserStatus.approved:
        badgeColor = Color.fromARGB(255, 75, 173, 78);
        badgeIcon = Icons.check_circle;
        break;
      case UserStatus.pending:
        badgeColor = Color.fromARGB(255, 255, 193, 7);
        badgeIcon = Icons.access_time;
        break;
      case UserStatus.rejected:
        badgeColor = Color.fromARGB(255, 229, 115, 115);
        badgeIcon = Icons.cancel;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, size: 12, color: badgeColor),
          SizedBox(width: 4),
          Text(
            status.toString().split('.').last.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    String? label,
    bool isExpanded = false,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: isExpanded ? 44 : 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isExpanded ? 12 : 18),
          ),
          padding:
              isExpanded
                  ? EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  : EdgeInsets.all(6),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isExpanded ? 18 : 16),
            if (label != null && isExpanded) ...[
              SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, User user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String deleteReason = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? darkBlack : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border.all(
                  color: isDark ? darkBlack : Colors.grey.shade200,
                  width: 1,
                ),
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red.shade400,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delete User',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              'This action cannot be undone',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color:
                                    isDark
                                        ? Colors.white70
                                        : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Please provide a reason for deleting ${user.name} (optional):',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? darkBlack : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? darkBlack : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      onChanged: (value) => deleteReason = value,
                      maxLines: 3,
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter reason (optional)...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                        hintStyle: GoogleFonts.inter(
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: isDark ? darkBlack : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  isDark
                                      ? Colors.white70
                                      : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteUser(user, deleteReason);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Delete',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _approveUser(User user) {
    setState(() {
      users =
          users
              .map(
                (u) =>
                    u.id == user.id
                        ? u.copyWith(status: UserStatus.approved)
                        : u,
              )
              .toList();
    });
    _saveUsers();
    _showSnackbar('${user.name} approved successfully', Colors.green);
  }

  void _rejectUser(User user) {
    setState(() {
      users =
          users
              .map(
                (u) =>
                    u.id == user.id
                        ? u.copyWith(status: UserStatus.rejected)
                        : u,
              )
              .toList();
    });
    _saveUsers();
    _showSnackbar('${user.name} rejected', Colors.orange);
  }

  void _deleteUser(User user, String reason) {
    setState(() {
      users.removeWhere((u) => u.id == user.id);
    });
    _saveUsers();

    _saveDeletionLog(user, reason);
    _showSnackbar('${user.name} deleted successfully', Colors.red);
  }

  Future<void> _saveDeletionLog(User user, String reason) async {
    if (prefs == null) return;

    final deletionLogs = prefs!.getStringList('deletion_logs') ?? [];
    final logEntry = {
      'user_name': user.name,
      'user_email': user.email,
      'user_role': user.role.toString(),
      'reason': reason.isEmpty ? 'No reason provided' : reason,
      'deleted_at': DateTime.now().toIso8601String(),
    };

    deletionLogs.add(jsonEncode(logEntry));
    await prefs!.setStringList('deletion_logs', deletionLogs);
  }

  Future<List<Map<String, dynamic>>> getDeletionLogs() async {
    if (prefs == null) return [];

    final deletionLogs = prefs!.getStringList('deletion_logs') ?? [];
    return deletionLogs
        .map((log) => jsonDecode(log) as Map<String, dynamic>)
        .toList();
  }

  Future<void> clearOldDeletionLogs({int daysToKeep = 30}) async {
    if (prefs == null) return;

    final deletionLogs = prefs!.getStringList('deletion_logs') ?? [];
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));

    final filteredLogs =
        deletionLogs.where((logString) {
          final log = jsonDecode(logString);
          final deletedAt = DateTime.parse(log['deleted_at']);
          return deletedAt.isAfter(cutoffDate);
        }).toList();

    await prefs!.setStringList('deletion_logs', filteredLogs);
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.check_circle, color: Colors.white, size: 16),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

// User Model
class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final UserStatus status;
  final String initials;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.initials,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString(),
      'status': status.toString(),
      'initials': initials,
      'avatarUrl': avatarUrl,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == json['role'],
        orElse: () => UserRole.student,
      ),
      status: UserStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => UserStatus.pending,
      ),
      initials: json['initials'],
      avatarUrl: json['avatarUrl'],
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    UserStatus? status,
    String? initials,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      initials: initials ?? this.initials,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

// Enums
enum UserRole { teacher, student, parent, admin }

enum UserStatus { approved, pending, rejected }

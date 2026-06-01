import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'dart:async';
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
  StreamSubscription? _usersSub;
  bool _isLoading = true;

  // Firestore reference (single source of truth)
  final CollectionReference<Map<String, dynamic>> _usersRef = FirebaseFirestore
      .instance
      .collection('users');
  final CollectionReference<Map<String, dynamic>> _logsRef = FirebaseFirestore
      .instance
      .collection('deletion_logs');

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

  // ---------------------------------------------------------------------------
  // INITIALIZATION
  // ---------------------------------------------------------------------------

  Future<void> _initializeData() async {
    await _loadPreferences();
    await _loadFilterState();
    await _seedDefaultUsersIfEmpty(); // push 12 defaults to Firebase ONCE
    _listenToUsers(); // real-time sync from Firebase
    _animationController.forward();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  // ---------------------------------------------------------------------------
  // SEEDING — writes default users into Firestore only if the collection is empty
  // ---------------------------------------------------------------------------

  Future<void> _seedDefaultUsersIfEmpty() async {
    try {
      // Local guard so we don't try to re-seed after a manual wipe.
      final alreadySeeded = prefs?.getBool('users_seeded') ?? false;

      final snapshot = await _usersRef.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        await prefs?.setBool('users_seeded', true);
        return; // Firebase already has users — nothing to do.
      }

      if (alreadySeeded) return;

      final defaults = _defaultUsersList();
      final batch = FirebaseFirestore.instance.batch();
      for (final user in defaults) {
        batch.set(_usersRef.doc(user.id), user.toJson());
      }
      await batch.commit();
      await prefs?.setBool('users_seeded', true);
      debugPrint("✅ Seeded ${defaults.length} default users to Firebase.");
    } catch (e) {
      debugPrint("⚠️ Seeding failed (check rules/connection): $e");
      // Fallback so the UI is not empty if Firebase is unreachable.
      _loadUsersFromCacheOrDefaults();
    }
  }

  // ---------------------------------------------------------------------------
  // REAL-TIME LISTENER — Firestore is the single source of truth
  // ---------------------------------------------------------------------------

  void _listenToUsers() {
    _usersSub = _usersRef.snapshots().listen(
      (snapshot) {
        if (!mounted) return;
        setState(() {
          users =
              snapshot.docs.map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return User.fromJson(data);
              }).toList();
          _isLoading = false;
        });
        _saveUsersToCache(); // keep an offline cache
      },
      onError: (e) {
        debugPrint("⚠️ Firestore listen error: $e");
        _loadUsersFromCacheOrDefaults();
      },
    );
  }

  void _loadUsersFromCacheOrDefaults() {
    final usersJson = prefs?.getStringList('users_data');
    if (usersJson != null && usersJson.isNotEmpty) {
      setState(() {
        users = usersJson.map((s) => User.fromJson(jsonDecode(s))).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        users = _defaultUsersList();
        _isLoading = false;
      });
      _saveUsersToCache();
    }
  }

  Future<void> _saveUsersToCache() async {
    if (prefs == null) return;
    final usersJson = users.map((u) => jsonEncode(u.toJson())).toList();
    await prefs!.setStringList('users_data', usersJson);
  }

  // ---------------------------------------------------------------------------
  // DEFAULT USER DATA
  // ---------------------------------------------------------------------------

  List<User> _defaultUsersList() {
    return [
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
        initials: 'SR',
      ),
      User(
        id: '10',
        name: 'Prof. Michael Prabhat',
        email: 'michael.prabhat@school.edu',
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
  }

  // ---------------------------------------------------------------------------
  // FILTER STATE PERSISTENCE
  // ---------------------------------------------------------------------------

  Future<void> _loadFilterState() async {
    if (prefs == null) return;
    final savedFilter = prefs!.getString('selected_filter');
    final savedSearch = prefs!.getString('search_query');
    setState(() {
      if (savedFilter != null) selectedFilter = savedFilter;
      if (savedSearch != null) searchQuery = savedSearch;
    });
  }

  Future<void> _saveFilterState() async {
    if (prefs == null) return;
    await prefs!.setString('selected_filter', selectedFilter);
    await prefs!.setString('search_query', searchQuery);
  }

  @override
  void dispose() {
    _usersSub?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // FILTERING
  // ---------------------------------------------------------------------------

  List<User> get filteredUsers {
    List<User> filtered = users;

    if (selectedFilter != 'all') {
      if (['teacher', 'student', 'parent', 'admin'].contains(selectedFilter)) {
        filtered =
            filtered
                .where(
                  (u) => u.role.toString().split('.').last == selectedFilter,
                )
                .toList();
      } else {
        filtered =
            filtered
                .where(
                  (u) => u.status.toString().split('.').last == selectedFilter,
                )
                .toList();
      }
    }

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      filtered =
          filtered
              .where(
                (u) =>
                    u.name.toLowerCase().contains(q) ||
                    u.email.toLowerCase().contains(q),
              )
              .toList();
    }

    return filtered;
  }

  // ---------------------------------------------------------------------------
  // FIREBASE WRITE OPERATIONS (every action updates Firebase)
  // ---------------------------------------------------------------------------

  Future<void> _approveUser(User user) async {
    final updatedUser = user.copyWith(status: UserStatus.approved);
    final String currentAdminId =
        FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
    try {
      await _usersRef.doc(user.id).set({
        ...updatedUser.toJson(),
        'updated_at': FieldValue.serverTimestamp(),
        'approved_at': FieldValue.serverTimestamp(),
        'approved_by': currentAdminId,
      }, SetOptions(merge: true));
      _showSnackbar('${user.name} approved successfully', Colors.green);
    } catch (e) {
      debugPrint("❌ Failed to approve user: $e");
      _showSnackbar('Failed to approve ${user.name}', Colors.red);
    }
  }

  Future<void> _rejectUser(User user) async {
    final updatedUser = user.copyWith(status: UserStatus.rejected);
    final String currentAdminId =
        FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
    try {
      await _usersRef.doc(user.id).set({
        ...updatedUser.toJson(),
        'updated_at': FieldValue.serverTimestamp(),
        'rejected_at': FieldValue.serverTimestamp(),
        'rejected_by': currentAdminId,
      }, SetOptions(merge: true));
      _showSnackbar('${user.name} rejected', Colors.orange);
    } catch (e) {
      debugPrint("❌ Failed to reject user: $e");
      _showSnackbar('Failed to reject ${user.name}', Colors.red);
    }
  }

  Future<void> _deleteUser(User user, String reason) async {
    try {
      // Log the deletion FIRST so we never lose the record.
      await _saveDeletionLog(user, reason);

      // Permanently remove the user record from the database.
      await _usersRef.doc(user.id).delete();
      _showSnackbar('${user.name} deleted successfully', Colors.red);
    } catch (e) {
      debugPrint("❌ Failed to delete user: $e");
      _showSnackbar('Failed to delete ${user.name}', Colors.red);
    }
  }

  Future<void> _saveDeletionLog(User user, String reason) async {
    final String currentAdminId =
        FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
    await _logsRef.add({
      'user_id': user.id,
      'user_name': user.name,
      'user_email': user.email,
      'user_role': user.role.toString().split('.').last,
      'reason': reason.trim().isEmpty ? 'No reason provided' : reason.trim(),
      'deleted_by': currentAdminId,
      'deleted_at': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getDeletionLogs() async {
    final querySnapshot =
        await _logsRef.orderBy('deleted_at', descending: true).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> clearOldDeletionLogs({int daysToKeep = 30}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
    final querySnapshot =
        await _logsRef
            .where('deleted_at', isLessThan: Timestamp.fromDate(cutoffDate))
            .get();
    final batch = FirebaseFirestore.instance.batch();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

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
            Expanded(
              child:
                  _isLoading
                      ? Center(
                        child: CircularProgressIndicator(color: blueColor),
                      )
                      : _buildUserList(context, isDark),
            ),
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
          border: Border.all(color: blueColor, width: 1),
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
            Icon(Icons.search, color: blueColor, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: searchQuery)
                  ..selection = TextSelection.collapsed(
                    offset: searchQuery.length,
                  ),
                onChanged: (value) {
                  setState(() => searchQuery = value);
                  _saveFilterState();
                },
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
                cursorColor: blueColor,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1.5, color: blueColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 0.5, color: blueColor),
                  ),
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
              setState(() => selectedFilter = filter['key'] as String);
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
      itemBuilder:
          (context, index) =>
              _buildUserCard(context, filtered[index], isDark, index),
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
                  border: Border.all(color: blueColor, width: 1),
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
                            color: blueColor.withOpacity(0.6),
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
            Icon(icon, size: isExpanded ? 18 : 16, color: whiteColor),
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

  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 3),
        ),
      );
  }
}

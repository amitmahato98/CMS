import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StaffCategory { Teaching, Admin }

class LeaveRequest {
  final String name;
  final String position;
  final String reason;
  final DateTime fromDate;
  final DateTime toDate;
  final String status;
  final StaffCategory category;

  LeaveRequest({
    required this.name,
    required this.position,
    required this.reason,
    required this.fromDate,
    required this.toDate,
    this.status = 'Pending',
    required this.category,
  });

  String get id => "$name-${fromDate.toIso8601String()}";
}

class LeaveRequestApprove extends StatefulWidget {
  const LeaveRequestApprove({super.key});

  @override
  State<LeaveRequestApprove> createState() => _LeaveRequestApproveState();
}

class _LeaveRequestApproveState extends State<LeaveRequestApprove> {
  StaffCategory selectedCategory = StaffCategory.Teaching;
  late SharedPreferences prefs;

  List<LeaveRequest> leaveRequests = [
    LeaveRequest(
      name: "Dr. Ramesh Sharma",
      position: "Professor",
      reason: "Medical Leave",
      fromDate: DateTime(2025, 7, 10),
      toDate: DateTime(2025, 7, 12),
      category: StaffCategory.Teaching,
    ),
    LeaveRequest(
      name: "Ms. Anita Joshi",
      position: "Lecturer",
      reason: "Conference Abroad",
      fromDate: DateTime(2025, 7, 15),
      toDate: DateTime(2025, 7, 22),
      category: StaffCategory.Teaching,
    ),
    LeaveRequest(
      name: "Mr. Bishal Thapa",
      position: "Assistant Professor",
      reason: "Family Emergency",
      fromDate: DateTime(2025, 7, 18),
      toDate: DateTime(2025, 7, 20),
      category: StaffCategory.Teaching,
    ),
    LeaveRequest(
      name: "Mrs. Pramila Shrestha",
      position: "Senior Lecturer",
      reason: "Research Field Visit",
      fromDate: DateTime(2025, 7, 5),
      toDate: DateTime(2025, 7, 8),
      category: StaffCategory.Teaching,
    ),
    LeaveRequest(
      name: "Mr. Sagar Koirala",
      position: "Assistant Lecturer",
      reason: "Exam Duty in Another Campus",
      fromDate: DateTime(2025, 7, 25),
      toDate: DateTime(2025, 7, 27),
      category: StaffCategory.Teaching,
    ),
    LeaveRequest(
      name: "Dr. Bina Dhakal",
      position: "Associate Professor",
      reason: "International Seminar",
      fromDate: DateTime(2025, 7, 30),
      toDate: DateTime(2025, 8, 2),
      category: StaffCategory.Teaching,
    ),
    LeaveRequest(
      name: "Mrs. Sita Bhattarai",
      position: "Officer",
      reason: "Festival Leave",
      fromDate: DateTime(2025, 7, 24),
      toDate: DateTime(2025, 7, 27),
      category: StaffCategory.Admin,
    ),
    LeaveRequest(
      name: "Mr. Rajendra Subedi",
      position: "Assistant Officer",
      reason: "Personal Work",
      fromDate: DateTime(2025, 7, 12),
      toDate: DateTime(2025, 7, 14),
      category: StaffCategory.Admin,
    ),
    LeaveRequest(
      name: "Ms. Kabita Koirala",
      position: "Clerk",
      reason: "Medical Checkup",
      fromDate: DateTime(2025, 7, 16),
      toDate: DateTime(2025, 7, 17),
      category: StaffCategory.Admin,
    ),
    LeaveRequest(
      name: "Mr. Hari Prasad Adhikari",
      position: "Account Officer",
      reason: "Official Training",
      fromDate: DateTime(2025, 7, 6),
      toDate: DateTime(2025, 7, 10),
      category: StaffCategory.Admin,
    ),
    LeaveRequest(
      name: "Ms. Mina Basnet",
      position: "Computer Operator",
      reason: "Urgent Family Matter",
      fromDate: DateTime(2025, 7, 20),
      toDate: DateTime(2025, 7, 22),
      category: StaffCategory.Admin,
    ),
    LeaveRequest(
      name: "Mr. Keshav Bhattarai",
      position: "Store Keeper",
      reason: "Warehouse Inventory Work",
      fromDate: DateTime(2025, 7, 14),
      toDate: DateTime(2025, 7, 15),
      category: StaffCategory.Admin,
    ),
  ];

  @override
  void initState() {
    super.initState();
    loadSavedStatuses();
  }

  Future<void> loadSavedStatuses() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      leaveRequests =
          leaveRequests.map((req) {
            final savedStatus = prefs.getString(req.id);
            return LeaveRequest(
              name: req.name,
              position: req.position,
              reason: req.reason,
              fromDate: req.fromDate,
              toDate: req.toDate,
              category: req.category,
              status: savedStatus ?? req.status,
            );
          }).toList();
    });
  }

  Future<void> updateStatus(int index, String status) async {
    final request = leaveRequests[index];
    await prefs.setString(request.id, status);
    setState(() {
      leaveRequests[index] = LeaveRequest(
        name: request.name,
        position: request.position,
        reason: request.reason,
        fromDate: request.fromDate,
        toDate: request.toDate,
        category: request.category,
        status: status,
      );
    });
  }

  Widget buildRequestCard(LeaveRequest request, int index) {
    final theme = Theme.of(context);
    final formattedFrom =
        "${request.fromDate.day}/${request.fromDate.month}/${request.fromDate.year}";
    final formattedTo =
        "${request.toDate.day}/${request.toDate.month}/${request.toDate.year}";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(request.position, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: theme.primaryColor),
                const SizedBox(width: 6),
                Text(
                  "From: $formattedFrom  To: $formattedTo",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Reason: ${request.reason}",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(request.status),
                  backgroundColor:
                      request.status == 'Approved'
                          ? Colors.green.withOpacity(0.2)
                          : request.status == 'Rejected'
                          ? Colors.red.withOpacity(0.2)
                          : theme.colorScheme.primary.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color:
                        request.status == 'Approved'
                            ? Colors.green
                            : request.status == 'Rejected'
                            ? Colors.red
                            : theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      tooltip: 'Approve',
                      onPressed: () => updateStatus(index, 'Approved'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      tooltip: 'Reject',
                      onPressed: () => updateStatus(index, 'Rejected'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      tooltip: 'View Details',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (BuildContext dialogContext) => AlertDialog(
                                title: const Text("Leave Details"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name: ${request.name}"),
                                    Text("Position: ${request.position}"),
                                    Text("From: $formattedFrom"),
                                    Text("To: $formattedTo"),
                                    Text("Reason: ${request.reason}"),
                                    Text("Status: ${request.status}"),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Close"),
                                    onPressed:
                                        () => Navigator.pop(dialogContext),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRequests =
        leaveRequests
            .asMap()
            .entries
            .where((e) => e.value.category == selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Requests"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedCategory == StaffCategory.Teaching
                              ? Colors.blue
                              : Colors.grey[300],
                      foregroundColor:
                          selectedCategory == StaffCategory.Teaching
                              ? Colors.white
                              : Colors.black87,
                    ),
                    onPressed:
                        () => setState(() {
                          selectedCategory = StaffCategory.Teaching;
                        }),
                    child: const Text("Teacher"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedCategory == StaffCategory.Admin
                              ? Colors.blue
                              : Colors.grey[300],
                      foregroundColor:
                          selectedCategory == StaffCategory.Admin
                              ? Colors.white
                              : Colors.black87,
                    ),
                    onPressed:
                        () => setState(() {
                          selectedCategory = StaffCategory.Admin;
                        }),
                    child: const Text("Admin Staff"),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                filteredRequests.isEmpty
                    ? const Center(child: Text("No leave requests"))
                    : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children:
                          filteredRequests
                              .map(
                                (entry) =>
                                    buildRequestCard(entry.value, entry.key),
                              )
                              .toList(),
                    ),
          ),
        ],
      ),
    );
  }
}

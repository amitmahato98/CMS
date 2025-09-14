import 'package:cms/datatypes/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum StaffCategory { Teaching, Admin }

class LeaveRequest {
  final String id;
  final String name;
  final String position;
  final String reason;
  final DateTime fromDate;
  final DateTime toDate;
  final String status;
  final StaffCategory category;

  LeaveRequest({
    required this.id,
    required this.name,
    required this.position,
    required this.reason,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.category,
  });

  factory LeaveRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LeaveRequest(
      id: doc.id,
      name: data['name'] ?? '',
      position: data['position'] ?? '',
      reason: data['reason'] ?? '',
      fromDate: DateTime.parse(data['fromDate']),
      toDate: DateTime.parse(data['toDate']),
      status: data['status'] ?? 'Pending',
      category:
          data['category'] == 'Admin'
              ? StaffCategory.Admin
              : StaffCategory.Teaching,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'reason': reason,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'status': status,
      'category': category.name,
    };
  }
}

class LeaveRequestApprove extends StatefulWidget {
  const LeaveRequestApprove({super.key});

  @override
  State<LeaveRequestApprove> createState() => _LeaveRequestApproveState();
}

class _LeaveRequestApproveState extends State<LeaveRequestApprove> {
  StaffCategory selectedCategory = StaffCategory.Teaching;

  /// 🔹 Seeder: Uploads sample data only once
  Future<void> seedSampleData() async {
    final firestore = FirebaseFirestore.instance;

    final seededDoc = await firestore.collection("meta").doc("seeded").get();
    if (seededDoc.exists) return; // already seeded

    final samples = [
      LeaveRequest(
        id: "",
        name: "Dr. Ramesh Sharma",
        position: "Professor123",
        reason:
            "Medical Leave lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        fromDate: DateTime(2025, 7, 10),
        toDate: DateTime(2025, 7, 12),
        status: "Pending",
        category: StaffCategory.Teaching,
      ),
      LeaveRequest(
        id: "",
        name: "Ms. Anita Joshi",
        position: "Lecturer",
        reason: "Conference Abroad",
        fromDate: DateTime(2025, 7, 15),
        toDate: DateTime(2025, 7, 22),
        status: "Pending",
        category: StaffCategory.Teaching,
      ),
      LeaveRequest(
        id: "",
        name: "Mr. Bishal Thapa",
        position: "Assistant Professor",
        reason: "Family Emergency",
        fromDate: DateTime(2025, 7, 18),
        toDate: DateTime(2025, 7, 20),
        status: "Pending",
        category: StaffCategory.Teaching,
      ),
      LeaveRequest(
        id: "",
        name: "Mrs. Pramila Shrestha",
        position: "Senior Lecturer",
        reason: "Research Field Visit",
        fromDate: DateTime(2025, 7, 5),
        toDate: DateTime(2025, 7, 8),
        status: "Pending",
        category: StaffCategory.Teaching,
      ),
      LeaveRequest(
        id: "",
        name: "Mr. Sagar Koirala",
        position: "Assistant Lecturer",
        reason: "Exam Duty in Another Campus",
        fromDate: DateTime(2025, 7, 25),
        toDate: DateTime(2025, 7, 27),
        status: "Pending",
        category: StaffCategory.Teaching,
      ),
      LeaveRequest(
        id: "",
        name: "Dr. Bina Dhakal",
        position: "Associate Professor",
        reason: "International Seminar",
        fromDate: DateTime(2025, 7, 30),
        toDate: DateTime(2025, 8, 2),
        status: "Pending",
        category: StaffCategory.Teaching,
      ),
      LeaveRequest(
        id: "",
        name: "Mrs. Sita Bhattarai",
        position: "Officer",
        reason: "Festival Leave",
        fromDate: DateTime(2025, 7, 24),
        toDate: DateTime(2025, 7, 27),
        status: "Pending",
        category: StaffCategory.Admin,
      ),
      LeaveRequest(
        id: "",
        name: "Mr. Rajendra Subedi",
        position: "Assistant Officer",
        reason: "Personal Work",
        fromDate: DateTime(2025, 7, 12),
        toDate: DateTime(2025, 7, 14),
        status: "Pending",
        category: StaffCategory.Admin,
      ),
      LeaveRequest(
        id: "",
        name: "Ms. Kabita Koirala",
        position: "Clerk",
        reason: "Medical Checkup",
        fromDate: DateTime(2025, 7, 16),
        toDate: DateTime(2025, 7, 17),
        status: "Pending",
        category: StaffCategory.Admin,
      ),
      LeaveRequest(
        id: "",
        name: "Mr. Hari Prasad Adhikari",
        position: "Account Officer",
        reason: "Official Training",
        fromDate: DateTime(2025, 7, 6),
        toDate: DateTime(2025, 7, 10),
        status: "Pending",
        category: StaffCategory.Admin,
      ),
      LeaveRequest(
        id: "",
        name: "Ms. Mina Basnet",
        position: "Computer Operator",
        reason: "Urgent Family Matter",
        fromDate: DateTime(2025, 7, 20),
        toDate: DateTime(2025, 7, 22),
        status: "Pending",
        category: StaffCategory.Admin,
      ),
      LeaveRequest(
        id: "",
        name: "Mr. Keshav Bhattarai",
        position: "Store Keeper",
        reason: "Warehouse Inventory Work",
        fromDate: DateTime(2025, 7, 14),
        toDate: DateTime(2025, 7, 15),
        status: "Pending",
        category: StaffCategory.Admin,
      ),
    ];

    final batch = firestore.batch();
    for (var req in samples) {
      final docRef = firestore.collection("leaveRequests").doc();
      batch.set(docRef, req.toMap());
    }

    batch.set(firestore.collection("meta").doc("seeded"), {"done": true});
    await batch.commit();
  }

  Future<void> updateStatus(String docId, String status) async {
    await FirebaseFirestore.instance
        .collection("leaveRequests")
        .doc(docId)
        .update({"status": status});
  }

  Widget buildRequestCard(LeaveRequest request) {
    final theme = Theme.of(context);
    final formattedFrom =
        "${request.fromDate.day}/${request.fromDate.month}/${request.fromDate.year}";
    final formattedTo =
        "${request.toDate.day}/${request.toDate.month}/${request.toDate.year}";

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: blueColor.withOpacity(0.5), width: 1),
      ),
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
                color: blueColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(request.position, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: blueColor),
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
                          ? Colors.redAccent.withOpacity(0.2)
                          : theme.colorScheme.primary.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color:
                        request.status == 'Approved'
                            ? Colors.green
                            : request.status == 'Rejected'
                            ? Colors.redAccent
                            : theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      tooltip: 'Approve',
                      onPressed:
                          request.status == "Pending"
                              ? () => updateStatus(request.id, "Approved")
                              : () {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text("You can't change again"),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                              },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.redAccent),
                      tooltip: 'Reject',
                      onPressed:
                          request.status == "Pending"
                              ? () => updateStatus(request.id, "Rejected")
                              : () {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text("You can't change again"),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                              },
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
                                    child: Text(
                                      "Close",
                                      style: TextStyle(color: blueColor),
                                    ),
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
  void initState() {
    super.initState();
    seedSampleData(); // 🔹 run seeder once
  }

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection("leaveRequests")
        .where("category", isEqualTo: selectedCategory.name);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Requests"),
        backgroundColor: blueColor,
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
                              ? blueColor
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
                              ? blueColor
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
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No leave requests"));
                }

                final requests =
                    snapshot.data!.docs
                        .map((doc) => LeaveRequest.fromFirestore(doc))
                        .toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: requests.length,
                  itemBuilder: (context, i) => buildRequestCard(requests[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

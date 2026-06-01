import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cms/auth/login_page.dart';
import 'package:cms/main.dart'; // To access MainNavigator or Dashboard
import 'package:google_fonts/google_fonts.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = authSnapshot.data;

        if (user == null) {
          return const LoginPage();
        }

        // User is authenticated in Firebase Auth, now check Firestore status
        return StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),
          builder: (context, dbSnapshot) {
            if (dbSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!dbSnapshot.hasData || !dbSnapshot.data!.exists) {
              // Document deleted by admin -> force logout
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                try {
                  await user
                      .delete(); // Attempt to delete Auth record completely
                } catch (e) {
                  debugPrint("Could not delete auth user: $e");
                }
                await FirebaseAuth.instance.signOut();
              });

              return const Scaffold(
                body: Center(
                  child: Text(
                    "Your account has been deleted by an administrator.",
                  ),
                ),
              );
            }

            final data = dbSnapshot.data!.data() as Map<String, dynamic>? ?? {};
            final status = data['status'] ?? 'pending';

            if (status == 'deleted') {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                try {
                  await user.delete();
                } catch (e) {
                  debugPrint("Could not delete auth user: $e");
                }
                await FirebaseAuth.instance.signOut();
              });

              return const Scaffold(
                body: Center(
                  child: Text(
                    "Your account has been deleted by an administrator.",
                  ),
                ),
              );
            } else if (status == 'pending') {
              return const PendingApprovalScreen();
            } else if (status == 'rejected') {
              return const RejectedScreen();
            } else if (status == 'approved') {
              // Valid to proceed
              return MainNavigator();
            }

            // Fallback
            return const LoginPage();
          },
        );
      },
    );
  }
}

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Approval'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_empty, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              Text(
                'Waiting for Admin Approval',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your account has been created successfully, but it needs to be approved by an administrator before you can access the application.',
                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RejectedScreen extends StatelessWidget {
  const RejectedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Denied'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cancel_outlined, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              Text(
                'Account Rejected',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your registration request has been rejected by an administrator. You do not have access to the application.',
                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

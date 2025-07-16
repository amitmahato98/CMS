import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cms/datatypes/datatypes.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: const Text("About Us"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // College Logo
            CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage('assets/collage/cct.jpeg'),
              backgroundColor: Colors.white,
            ),

            const SizedBox(height: 16),

            // App Name
            Text(
              "Central Campus of Technology, CMS",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              "Empowering Education with Smart Digital Tools",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),

            const Divider(height: 40),

            // Mission
            _buildSectionTitle("Our Mission", theme),
            const SizedBox(height: 6),
            Text(
              "To simplify and digitize all campus processes for students, faculty, and staff, ensuring efficient and transparent operations.",
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 24),

            // Vision
            _buildSectionTitle("Our Vision", theme),
            const SizedBox(height: 6),
            Text(
              "To be Nepal’s most advanced and user-friendly education management platform, driving academic excellence and innovation through smart technology.",
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 24),

            // Key Features
            _buildSectionTitle("Key Features", theme),
            const SizedBox(height: 10),
            _buildFeatureItem(
              Icons.check_circle,
              "Digital Leave & Attendance System",
            ),
            _buildFeatureItem(
              Icons.notifications_active,
              "Real-time Notifications & Alerts",
            ),
            _buildFeatureItem(
              Icons.event_note,
              "Class Schedules and Academic Calendar",
            ),
            _buildFeatureItem(
              Icons.assignment_turned_in,
              "Assignment & Exam Management",
            ),
            _buildFeatureItem(
              Icons.settings,
              "Admin Dashboard with User Roles",
            ),

            const SizedBox(height: 24),

            // Developed By
            _buildSectionTitle("Developed By", theme),
            const SizedBox(height: 6),
            Text(
              "Amit Mahato\nBSc.CSIT Student, 6th Semester\nCentral Campus of Technology, Tribhuvan University\nKathmandu, Nepal",
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Contact Section with shadow
            _buildSectionTitle("Contact", theme),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.email,
                      color: theme.colorScheme.primary,
                    ),
                    title: GestureDetector(
                      onTap:
                          () => launchUrl(
                            Uri.parse('mailto:cms.support@cct.edu.np'),
                          ),
                      child: const Text("cms.support@cct.edu.np"),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: theme.colorScheme.primary,
                    ),
                    title: const Text("+977-9762921925"),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: theme.colorScheme.primary,
                    ),
                    title: GestureDetector(
                      onTap:
                          () => launchUrl(Uri.parse('https://cct.tu.edu.np/')),
                      child: const Text("https://cct.tu.edu.np/"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            Text(
              "Version 1.0.0 • © 2025 Central Campus of Technology",
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 22, color: blueColor),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

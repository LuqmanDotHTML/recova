import 'package:flutter/material.dart';
import 'student_home_screen.dart';
import 'my_reports_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'report_lost_screen.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});
  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _index = 0;
  final _screens = const [
    StudentHomeScreen(),
    SizedBox(), // placeholder — Report tab opens a page instead
    MyReportsScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          if (i == 1) {
            // Show bottom sheet to pick lost or found
            _showReportOptions();
          } else {
            setState(() => _index = i);
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Report'),
          NavigationDestination(icon: Icon(Icons.list_alt_outlined), selectedIcon: Icon(Icons.list_alt), label: 'My Reports'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications), label: 'Alerts'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _showReportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(context).colorScheme.outline, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('What would you like to report?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.search, color: Color(0xFFD85A30)),
              title: const Text('I lost something'),
              subtitle: const Text('Report an item you\'ve lost'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportLostScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.primary),
              title: const Text('I found something'),
              subtitle: const Text('Report an item you\'ve found'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportFoundScreen()));
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final themeP = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final profile = auth.profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Avatar
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                profile?.fullName.isNotEmpty == true ? profile!.fullName[0].toUpperCase() : '?',
                style: TextStyle(fontSize: 36, color: theme.colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(profile?.fullName ?? 'Unknown', style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
          if (profile?.studentId != null)
            Text(profile!.studentId!, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          // Settings
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: themeP.themeMode == ThemeMode.dark,
                    onChanged: (_) => themeP.toggleTheme(),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About UniFind'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'UniFind',
                      applicationVersion: '1.0.0',
                      children: [const Text('A Lost & Found platform for university students.')],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await auth.signOut();
                if (context.mounted) context.go(AppRoutes.login);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

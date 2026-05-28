import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final themeP = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final profile = auth.profile;
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(radius: 48, backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(profile?.fullName.isNotEmpty == true ? profile!.fullName[0].toUpperCase() : 'A',
                style: TextStyle(fontSize: 36, color: theme.colorScheme.primary))),
          ),
          const SizedBox(height: 12),
          Text(profile?.fullName ?? 'Admin', style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
          Text('Administrator', style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Card(child: Column(children: [
            ListTile(leading: const Icon(Icons.dark_mode_outlined), title: const Text('Dark Mode'),
              trailing: Switch(value: themeP.themeMode == ThemeMode.dark, onChanged: (_) => themeP.toggleTheme())),
          ])),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () async { await auth.signOut(); if (context.mounted) context.go(AppRoutes.login); },
            icon: const Icon(Icons.logout), label: const Text('Log Out'),
            style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.error, side: BorderSide(color: theme.colorScheme.error)),
          ),
        ],
      ),
    );
  }
}

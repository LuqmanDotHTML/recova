import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/report_provider.dart';
import '../../config/app_colors.dart';
import '../../widgets/admin/stat_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() { super.initState(); context.read<ReportProvider>().loadStats(); }

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<ReportProvider>();
    final stats = rp.stats;
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: RefreshIndicator(
        onRefresh: () => rp.loadStats(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                StatCard(label: 'Total Reports', value: '${stats['total'] ?? 0}', icon: Icons.description, color: AppColors.primaryLight),
                StatCard(label: 'Pending', value: '${stats['pending'] ?? 0}', icon: Icons.pending_actions, color: AppColors.secondaryLight),
                StatCard(label: 'Recovered', value: '${stats['recovered'] ?? 0}', icon: Icons.check_circle, color: AppColors.approvedTextLight),
                StatCard(label: 'Lost Items', value: '${stats['lost'] ?? 0}', icon: Icons.search_off, color: AppColors.errorLight),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

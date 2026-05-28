import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/report_provider.dart';
import '../../widgets/admin/chart_widget.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});
  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() { super.initState(); context.read<ReportProvider>().loadStats(); }

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<ReportProvider>().stats;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SimpleBarChart(title: 'Reports by status', data: {
            'Pending': stats['pending'] ?? 0,
            'Approved': stats['approved'] ?? 0,
            'Rejected': stats['rejected'] ?? 0,
            'Recovered': stats['recovered'] ?? 0,
          }),
          const SizedBox(height: 16),
          SimpleBarChart(title: 'Lost vs Found', data: {
            'Lost': stats['lost'] ?? 0,
            'Found': stats['found'] ?? 0,
          }),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Summary', style: theme.textTheme.titleSmall),
                const SizedBox(height: 12),
                _row('Total reports', '${stats['total'] ?? 0}', theme),
                _row('Recovery rate', stats['total'] != null && stats['total']! > 0
                    ? '${((stats['recovered'] ?? 0) / stats['total']! * 100).toStringAsFixed(1)}%' : 'N/A', theme),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, ThemeData theme) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: theme.textTheme.bodyMedium),
      Text(value, style: theme.textTheme.titleSmall),
    ]),
  );
}

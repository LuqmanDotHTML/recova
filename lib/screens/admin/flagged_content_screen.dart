import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/report_provider.dart';
import '../../widgets/common/report_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class FlaggedContentScreen extends StatefulWidget {
  const FlaggedContentScreen({super.key});
  @override
  State<FlaggedContentScreen> createState() => _FlaggedContentScreenState();
}

class _FlaggedContentScreenState extends State<FlaggedContentScreen> {
  @override
  void initState() { super.initState(); context.read<ReportProvider>().loadFlaggedReports(); }

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<ReportProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Flagged Content')),
      body: rp.isLoading
          ? const LoadingWidget()
          : rp.flaggedReports.isEmpty
              ? const EmptyStateWidget(icon: Icons.flag_outlined, title: 'No flagged content')
              : ListView.builder(
                  padding: const EdgeInsets.all(16), itemCount: rp.flaggedReports.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ReportCard(report: rp.flaggedReports[i], showStatus: true,
                      onTap: () => context.push('/admin/report/${rp.flaggedReports[i].id}')),
                  ),
                ),
    );
  }
}

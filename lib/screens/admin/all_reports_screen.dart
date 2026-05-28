import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/report_provider.dart';
import '../../widgets/common/report_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class AllReportsScreen extends StatefulWidget {
  const AllReportsScreen({super.key});
  @override
  State<AllReportsScreen> createState() => _AllReportsScreenState();
}

class _AllReportsScreenState extends State<AllReportsScreen> {
  String? _status;

  @override
  void initState() { super.initState(); context.read<ReportProvider>().loadAllReports(); }

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<ReportProvider>();
    final filters = [null, 'pending', 'approved', 'rejected', 'recovered'];
    final labels = ['All', 'Pending', 'Approved', 'Rejected', 'Recovered'];
    return Scaffold(
      appBar: AppBar(title: const Text('All Reports')),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(label: Text(labels[i]), selected: _status == filters[i],
                  onSelected: (_) { setState(() => _status = filters[i]); rp.loadAllReports(statusFilter: filters[i]); }),
              ),
            ),
          ),
          Expanded(
            child: rp.isLoading ? const LoadingWidget()
                : rp.reports.isEmpty ? const EmptyStateWidget(icon: Icons.inbox, title: 'No reports')
                : RefreshIndicator(
                    onRefresh: () => rp.loadAllReports(statusFilter: _status),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16), itemCount: rp.reports.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ReportCard(report: rp.reports[i], showStatus: true,
                          onTap: () => context.push('/admin/report/${rp.reports[i].id}')),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

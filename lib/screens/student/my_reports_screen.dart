import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/report_provider.dart';
import '../../widgets/common/report_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});
  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  String? _statusFilter;
  final _filters = [null, 'pending', 'approved', 'rejected', 'recovered'];
  final _labels = ['All', 'Pending', 'Approved', 'Rejected', 'Recovered'];

  @override
  void initState() { super.initState(); context.read<ReportProvider>().loadMyReports(); }

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<ReportProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Reports')),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_labels[i]),
                  selected: _statusFilter == _filters[i],
                  onSelected: (_) {
                    setState(() => _statusFilter = _filters[i]);
                    rp.loadMyReports(statusFilter: _filters[i]);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: rp.isLoading
                ? const LoadingWidget()
                : rp.myReports.isEmpty
                    ? const EmptyStateWidget(icon: Icons.note_add_outlined, title: 'No reports yet', subtitle: 'Tap the Report tab to submit one')
                    : RefreshIndicator(
                        onRefresh: () => rp.loadMyReports(statusFilter: _statusFilter),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: rp.myReports.length,
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ReportCard(
                              report: rp.myReports[i], showStatus: true,
                              onTap: () => context.push('/student/report/${rp.myReports[i].id}'),
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

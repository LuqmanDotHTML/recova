import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/report_provider.dart';
import '../../widgets/common/report_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/admin/approval_action_bar.dart';

class PendingApprovalsScreen extends StatefulWidget {
  const PendingApprovalsScreen({super.key});
  @override
  State<PendingApprovalsScreen> createState() => _PendingApprovalsScreenState();
}

class _PendingApprovalsScreenState extends State<PendingApprovalsScreen> {
  @override
  void initState() { super.initState(); context.read<ReportProvider>().loadPendingReports(); }

  Future<void> _reject(String id) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('Rejection Reason'),
          content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Why is this being rejected?'), maxLines: 3),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, ctrl.text), child: const Text('Reject')),
          ],
        );
      },
    );
    if (reason == null) return;
    if (!mounted) return;
    await context.read<ReportProvider>().updateStatus(id, 'rejected', reason: reason);
    if (mounted) context.read<ReportProvider>().loadPendingReports();
  }

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<ReportProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Pending Approvals (${rp.pendingReports.length})')),
      body: rp.isLoading
          ? const LoadingWidget()
          : rp.pendingReports.isEmpty
              ? const EmptyStateWidget(icon: Icons.check_circle_outline, title: 'All caught up!', subtitle: 'No pending reports')
              : RefreshIndicator(
                  onRefresh: () => rp.loadPendingReports(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: rp.pendingReports.length,
                    itemBuilder: (_, i) {
                      final r = rp.pendingReports[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          children: [
                            ReportCard(report: r, showStatus: true, onTap: () => context.push('/admin/report/${r.id}')),
                            const SizedBox(height: 8),
                            ApprovalActionBar(
                              onApprove: () async {
                                await rp.updateStatus(r.id, 'approved');
                                if (mounted) rp.loadPendingReports();
                              },
                              onReject: () => _reject(r.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

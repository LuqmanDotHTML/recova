import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/report_model.dart';
import '../../providers/report_provider.dart';
import '../../config/app_colors.dart';
import '../../widgets/common/type_badge.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/custom_button.dart';

class AdminReportDetailScreen extends StatefulWidget {
  final String reportId;
  const AdminReportDetailScreen({super.key, required this.reportId});
  @override
  State<AdminReportDetailScreen> createState() => _AdminReportDetailScreenState();
}

class _AdminReportDetailScreenState extends State<AdminReportDetailScreen> {
  Report? _report;
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    _report = await context.read<ReportProvider>().getReportById(widget.reportId);
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _action(String status, {String? reason}) async {
    await context.read<ReportProvider>().updateStatus(widget.reportId, status, reason: reason);
    await _load();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Report $status')));
  }

  Future<void> _reject() async {
    final ctrl = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rejection Reason'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Reason...'), maxLines: 3),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, ctrl.text), child: const Text('Reject')),
        ],
      ),
    );
    if (reason != null) _action('rejected', reason: reason);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_loading) return Scaffold(appBar: AppBar(), body: const LoadingWidget());
    final r = _report!;
    return Scaffold(
      appBar: AppBar(title: const Text('Report Detail')),
      body: ListView(
        children: [
          if (r.imageUrl != null)
            CachedNetworkImage(imageUrl: r.imageUrl!, height: 250, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [TypeBadge(type: r.type.name), const SizedBox(width: 8), StatusBadge(status: r.status.name)]),
              const SizedBox(height: 12),
              Text(r.title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('${r.location} · ${timeago.format(r.createdAt)}', style: theme.textTheme.bodySmall),
              const SizedBox(height: 16),
              Text(r.description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Reported by', style: theme.textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(r.reporterName ?? 'Unknown', style: theme.textTheme.bodyMedium),
                    if (r.reporterStudentId != null) Text('ID: ${r.reporterStudentId}', style: theme.textTheme.bodySmall),
                  ]),
                ),
              ),
              const SizedBox(height: 24),
              Text('Admin Actions', style: theme.textTheme.titleSmall),
              const SizedBox(height: 12),
              if (r.status.name == 'pending') ...[
                CustomButton(text: 'Approve', icon: Icons.check, onPressed: () => _action('approved'), color: AppColors.approvedTextLight),
                const SizedBox(height: 8),
                CustomButton(text: 'Reject', icon: Icons.close, isOutline: true, onPressed: _reject, color: AppColors.errorLight),
              ],
              const SizedBox(height: 8),
              CustomButton(text: 'Mark as Recovered', icon: Icons.celebration, isOutline: true,
                onPressed: () => _action('recovered'), color: AppColors.recoveredTextLight),
              const SizedBox(height: 8),
              CustomButton(text: 'Delete Report', icon: Icons.delete_outline, isOutline: true,
                onPressed: () async {
                  final confirm = await showDialog<bool>(context: context,
                    builder: (ctx) => AlertDialog(title: const Text('Delete?'), content: const Text('This cannot be undone.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        ElevatedButton(onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorLight), child: const Text('Delete')),
                      ]));
                  if (confirm == true && mounted) {
                    await context.read<ReportProvider>().deleteReport(widget.reportId);
                    if (mounted) Navigator.pop(context);
                  }
                }, color: AppColors.errorLight),
            ]),
          ),
        ],
      ),
    );
  }
}

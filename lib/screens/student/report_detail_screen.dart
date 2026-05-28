import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/report_model.dart';
import '../../providers/report_provider.dart';
import '../../widgets/common/type_badge.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/common/loading_widget.dart';

class ReportDetailScreen extends StatelessWidget {
  final String reportId;
  const ReportDetailScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Report Detail')),
      body: FutureBuilder<Report>(
        future: context.read<ReportProvider>().getReportById(reportId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const LoadingWidget();
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final r = snap.data!;
          return ListView(
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
                  if (r.status.name == 'rejected' && r.rejectionReason != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(children: [
                        Icon(Icons.info_outline, color: theme.colorScheme.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Rejected: ${r.rejectionReason}', style: TextStyle(color: theme.colorScheme.error))),
                      ]),
                    ),
                  ],
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}

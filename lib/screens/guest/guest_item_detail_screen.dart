import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:go_router/go_router.dart';
import '../../config/routes.dart';
import '../../models/report_model.dart';
import '../../providers/report_provider.dart';
import '../../widgets/common/type_badge.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/custom_button.dart';

class GuestItemDetailScreen extends StatelessWidget {
  final String reportId;
  const GuestItemDetailScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Item Detail')),
      body: FutureBuilder<Report>(
        future: context.read<ReportProvider>().getReportById(reportId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const LoadingWidget();
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          final report = snapshot.data!;
          return ListView(
            children: [
              if (report.imageUrl != null)
                CachedNetworkImage(imageUrl: report.imageUrl!, height: 250, width: double.infinity, fit: BoxFit.cover)
              else
                Container(height: 200, color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.image_outlined, size: 64, color: theme.colorScheme.outline)),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [TypeBadge(type: report.type.name), const SizedBox(width: 8), StatusBadge(status: report.status.name)]),
                    const SizedBox(height: 12),
                    Text(report.title, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    _infoRow(Icons.location_on_outlined, report.location, theme),
                    _infoRow(Icons.calendar_today, '${report.type.displayName} on ${report.dateOccurred.day}/${report.dateOccurred.month}/${report.dateOccurred.year}', theme),
                    if (report.categoryName != null) _infoRow(Icons.category_outlined, report.categoryName!, theme),
                    const SizedBox(height: 16),
                    Text('Description', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Text(report.description, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 16),
                    if (report.reporterName != null)
                      Text('Reported by: ${report.reporterName} · ${timeago.format(report.createdAt)}',
                        style: theme.textTheme.bodySmall),
                    const SizedBox(height: 24),
                    CustomButton(text: 'Log in to contact', icon: Icons.login, onPressed: () => context.go(AppRoutes.login)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(icon, size: 18, color: theme.colorScheme.outline),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ]),
    );
  }
}

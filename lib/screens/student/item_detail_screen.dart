import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:go_router/go_router.dart';
import '../../models/report_model.dart';
import '../../providers/report_provider.dart';
import '../../widgets/common/type_badge.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/student/contact_button.dart';

class ItemDetailScreen extends StatelessWidget {
  final String reportId;
  const ItemDetailScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Item Detail')),
      body: FutureBuilder<Report>(
        future: context.read<ReportProvider>().getReportById(reportId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const LoadingWidget();
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final r = snap.data!;
          return ListView(
            children: [
              if (r.imageUrl != null)
                CachedNetworkImage(imageUrl: r.imageUrl!, height: 250, width: double.infinity, fit: BoxFit.cover)
              else
                Container(height: 200, color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.image_outlined, size: 64, color: theme.colorScheme.outline)),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [TypeBadge(type: r.type.name), const SizedBox(width: 8), StatusBadge(status: r.status.name)]),
                  const SizedBox(height: 12),
                  Text(r.title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  _info(Icons.location_on_outlined, r.location, theme),
                  _info(Icons.calendar_today, '${r.dateOccurred.day}/${r.dateOccurred.month}/${r.dateOccurred.year}', theme),
                  if (r.categoryName != null) _info(Icons.category_outlined, r.categoryName!, theme),
                  const SizedBox(height: 16),
                  Text('Description', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Text(r.description, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  if (r.reporterName != null)
                    Text('Reported by: ${r.reporterName} · ${timeago.format(r.createdAt)}', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 24),
                  ContactButton(onPressed: () => context.push('/student/chat/${r.id}')),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _info(IconData icon, String text, ThemeData theme) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Icon(icon, size: 18, color: theme.colorScheme.outline), const SizedBox(width: 8),
      Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
    ]),
  );
}

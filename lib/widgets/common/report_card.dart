import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/report_model.dart';
import 'status_badge.dart';
import 'type_badge.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback onTap;
  final bool showStatus;

  const ReportCard({
    super.key,
    required this.report,
    required this.onTap,
    this.showStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Image
            SizedBox(
              width: 100,
              height: 100,
              child: report.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: report.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.image, size: 32),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.broken_image, size: 32),
                      ),
                    )
                  : Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.image_outlined, size: 32, color: theme.colorScheme.outline),
                    ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TypeBadge(type: report.type.name),
                        if (showStatus) ...[
                          const SizedBox(width: 6),
                          StatusBadge(status: report.status.name),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(report.title,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: theme.colorScheme.outline),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text('${report.location} · ${timeago.format(report.createdAt)}',
                            style: theme.textTheme.bodySmall,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

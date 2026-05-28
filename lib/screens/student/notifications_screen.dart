import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:go_router/go_router.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/empty_state_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() { super.initState(); context.read<NotificationProvider>().loadNotifications(); }

  IconData _icon(String? type) => switch (type) {
    'report_approved' => Icons.check_circle,
    'report_rejected' => Icons.cancel,
    'new_message' => Icons.chat_bubble,
    'item_recovered' => Icons.celebration,
    _ => Icons.notifications,
  };

  @override
  Widget build(BuildContext context) {
    final np = context.watch<NotificationProvider>();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (np.unreadCount > 0)
            TextButton(onPressed: np.markAllAsRead, child: const Text('Mark all read')),
        ],
      ),
      body: np.notifications.isEmpty
          ? const EmptyStateWidget(icon: Icons.notifications_off_outlined, title: 'No notifications')
          : ListView.builder(
              itemCount: np.notifications.length,
              itemBuilder: (_, i) {
                final n = np.notifications[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: n.isRead ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.primaryContainer,
                    child: Icon(_icon(n.type), color: n.isRead ? theme.colorScheme.outline : theme.colorScheme.primary, size: 20),
                  ),
                  title: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.w400 : FontWeight.w600)),
                  subtitle: Text(n.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Text(timeago.format(n.createdAt), style: theme.textTheme.labelSmall),
                  onTap: () {
                    np.markAsRead(n.id);
                    if (n.reportId != null) context.push('/student/report/${n.reportId}');
                  },
                );
              },
            ),
    );
  }
}

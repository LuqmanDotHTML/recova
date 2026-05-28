import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';

class NotificationService {
  final _client = Supabase.instance.client;

  Future<List<AppNotification>> getNotifications() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);
    return (response as List).map((e) => AppNotification.fromJson(e)).toList();
  }

  Future<int> getUnreadCount() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('is_read', false);
    return (response as List).length;
  }

  Future<void> markAsRead(String id) async {
    await _client.from('notifications').update({'is_read': true}).eq('id', id);
  }

  Future<void> markAllAsRead() async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('notifications').update({'is_read': true}).eq('user_id', userId);
  }

  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    String? type,
    String? reportId,
  }) async {
    await _client.from('notifications').insert({
      'user_id': userId,
      'title': title,
      'body': body,
      'type': type,
      'report_id': reportId,
    });
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message_model.dart';

class MessageService {
  final _client = Supabase.instance.client;

  Future<List<Message>> getMessages(String reportId) async {
    final response = await _client
        .from('messages')
        .select('*, sender:profiles!sender_id(full_name)')
        .eq('report_id', reportId)
        .order('created_at', ascending: true);
    return (response as List).map((e) => Message.fromJson(e)).toList();
  }

  Future<void> sendMessage({
    required String reportId,
    required String receiverId,
    required String content,
  }) async {
    await _client.from('messages').insert({
      'report_id': reportId,
      'sender_id': _client.auth.currentUser!.id,
      'receiver_id': receiverId,
      'content': content,
    });
  }

  Future<void> markAsRead(String messageId) async {
    await _client.from('messages').update({'is_read': true}).eq('id', messageId);
  }
}

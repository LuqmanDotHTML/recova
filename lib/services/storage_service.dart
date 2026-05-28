import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final _client = Supabase.instance.client;

  Future<String> uploadReportImage(File imageFile) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = 'reports/$fileName';
    await _client.storage.from('report-images').upload(path, imageFile);
    return _client.storage.from('report-images').getPublicUrl(path);
  }

  Future<String> uploadAvatar(File imageFile) async {
    final userId = _client.auth.currentUser!.id;
    final path = 'avatars/$userId.jpg';
    await _client.storage.from('avatars').upload(path, imageFile, fileOptions: const FileOptions(upsert: true));
    return _client.storage.from('avatars').getPublicUrl(path);
  }
}

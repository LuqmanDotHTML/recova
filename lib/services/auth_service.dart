import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class AuthService {
  final _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    String? studentId,
    String? phone,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'student_id': studentId,
        'phone': phone,
        'role': 'student',
      },
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<Profile> getProfile() async {
    final userId = currentUser!.id;
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    return Profile.fromJson(response);
  }

  Future<String> getUserRole() async {
    final userId = currentUser!.id;
    final response = await _client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .single();
    return response['role'] as String;
  }

  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    final userId = currentUser!.id;
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (fullName != null) updates['full_name'] = fullName;
    if (phone != null) updates['phone'] = phone;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    await _client.from('profiles').update(updates).eq('id', userId);
  }
}

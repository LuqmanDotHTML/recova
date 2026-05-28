import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/report_model.dart';
import '../models/category_model.dart';

class ReportService {
  final _client = Supabase.instance.client;

  // Fetch all approved reports (for home feed / guest)
  Future<List<Report>> getApprovedReports({String? search, int? categoryId}) async {
    var query = _client
        .from('reports')
        .select('*, profiles(full_name, student_id), categories(name, icon)')
        .inFilter('status', ['approved', 'recovered'])
        .order('created_at', ascending: false);

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }

    final response = await query;
    List<Report> reports = (response as List).map((e) => Report.fromJson(e)).toList();

    if (search != null && search.isNotEmpty) {
      final lower = search.toLowerCase();
      reports = reports.where((r) =>
        r.title.toLowerCase().contains(lower) ||
        r.description.toLowerCase().contains(lower) ||
        r.location.toLowerCase().contains(lower)
      ).toList();
    }
    return reports;
  }

  // Fetch my reports (student)
  Future<List<Report>> getMyReports({String? statusFilter}) async {
    final userId = _client.auth.currentUser!.id;
    var query = _client
        .from('reports')
        .select('*, categories(name, icon)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    if (statusFilter != null) {
      query = query.eq('status', statusFilter);
    }

    final response = await query;
    return (response as List).map((e) => Report.fromJson(e)).toList();
  }

  // Fetch single report by ID
  Future<Report> getReportById(String id) async {
    final response = await _client
        .from('reports')
        .select('*, profiles(full_name, student_id), categories(name, icon)')
        .eq('id', id)
        .single();
    return Report.fromJson(response);
  }

  // Create a new report
  Future<void> createReport({
    required String title,
    required String description,
    required String type,
    required int categoryId,
    required String location,
    required DateTime dateOccurred,
    String? imageUrl,
  }) async {
    await _client.from('reports').insert({
      'user_id': _client.auth.currentUser!.id,
      'title': title,
      'description': description,
      'type': type,
      'category_id': categoryId,
      'location': location,
      'date_occurred': dateOccurred.toIso8601String().split('T')[0],
      'image_url': imageUrl,
      'status': 'pending',
    });
  }

  // Update own report (if still pending)
  Future<void> updateReport(String id, Map<String, dynamic> updates) async {
    updates['updated_at'] = DateTime.now().toIso8601String();
    await _client.from('reports').update(updates).eq('id', id);
  }

  // Delete own report
  Future<void> deleteReport(String id) async {
    await _client.from('reports').delete().eq('id', id);
  }

  // ─── ADMIN ──────────────────────────────
  Future<List<Report>> getPendingReports() async {
    final response = await _client
        .from('reports')
        .select('*, profiles(full_name, student_id), categories(name, icon)')
        .eq('status', 'pending')
        .order('created_at', ascending: false);
    return (response as List).map((e) => Report.fromJson(e)).toList();
  }

  Future<List<Report>> getAllReports({String? statusFilter, String? typeFilter}) async {
    var query = _client
        .from('reports')
        .select('*, profiles(full_name, student_id), categories(name, icon)')
        .order('created_at', ascending: false);

    if (statusFilter != null) query = query.eq('status', statusFilter);
    if (typeFilter != null) query = query.eq('type', typeFilter);

    final response = await query;
    return (response as List).map((e) => Report.fromJson(e)).toList();
  }

  Future<List<Report>> getFlaggedReports() async {
    final response = await _client
        .from('reports')
        .select('*, profiles(full_name, student_id), categories(name, icon)')
        .eq('is_flagged', true)
        .order('created_at', ascending: false);
    return (response as List).map((e) => Report.fromJson(e)).toList();
  }

  Future<void> updateReportStatus(String id, String status, {String? reason}) async {
    final updates = <String, dynamic>{
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (reason != null) updates['rejection_reason'] = reason;
    await _client.from('reports').update(updates).eq('id', id);
  }

  Future<void> toggleFlag(String id, bool flagged) async {
    await _client.from('reports').update({
      'is_flagged': flagged,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  // ─── CATEGORIES ─────────────────────────
  Future<List<Category>> getCategories() async {
    final response = await _client.from('categories').select().order('id');
    return (response as List).map((e) => Category.fromJson(e)).toList();
  }

  // ─── STATISTICS ─────────────────────────
  Future<Map<String, int>> getReportStats() async {
    final all = await _client.from('reports').select('status, type');
    final list = all as List;
    return {
      'total': list.length,
      'pending': list.where((r) => r['status'] == 'pending').length,
      'approved': list.where((r) => r['status'] == 'approved').length,
      'rejected': list.where((r) => r['status'] == 'rejected').length,
      'recovered': list.where((r) => r['status'] == 'recovered').length,
      'lost': list.where((r) => r['type'] == 'lost').length,
      'found': list.where((r) => r['type'] == 'found').length,
    };
  }
}

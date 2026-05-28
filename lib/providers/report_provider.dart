import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../models/category_model.dart';
import '../services/report_service.dart';

class ReportProvider extends ChangeNotifier {
  final ReportService _reportService = ReportService();

  List<Report> _reports = [];
  List<Report> _myReports = [];
  List<Report> _pendingReports = [];
  List<Report> _flaggedReports = [];
  List<Category> _categories = [];
  Map<String, int> _stats = {};
  bool _isLoading = false;
  String? _error;

  List<Report> get reports => _reports;
  List<Report> get myReports => _myReports;
  List<Report> get pendingReports => _pendingReports;
  List<Report> get flaggedReports => _flaggedReports;
  List<Category> get categories => _categories;
  Map<String, int> get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories() async {
    try {
      _categories = await _reportService.getCategories();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> loadApprovedReports({String? search, int? categoryId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _reports = await _reportService.getApprovedReports(search: search, categoryId: categoryId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMyReports({String? statusFilter}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _myReports = await _reportService.getMyReports(statusFilter: statusFilter);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Report> getReportById(String id) async {
    return await _reportService.getReportById(id);
  }

  Future<bool> createReport({
    required String title,
    required String description,
    required String type,
    required int categoryId,
    required String location,
    required DateTime dateOccurred,
    String? imageUrl,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _reportService.createReport(
        title: title, description: description, type: type,
        categoryId: categoryId, location: location,
        dateOccurred: dateOccurred, imageUrl: imageUrl,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ─── ADMIN ──────────────────────────────
  Future<void> loadPendingReports() async {
    _isLoading = true;
    notifyListeners();
    try {
      _pendingReports = await _reportService.getPendingReports();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadAllReports({String? statusFilter, String? typeFilter}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _reports = await _reportService.getAllReports(statusFilter: statusFilter, typeFilter: typeFilter);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFlaggedReports() async {
    try {
      _flaggedReports = await _reportService.getFlaggedReports();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> updateStatus(String id, String status, {String? reason}) async {
    await _reportService.updateReportStatus(id, status, reason: reason);
  }

  Future<void> toggleFlag(String id, bool flagged) async {
    await _reportService.toggleFlag(id, flagged);
  }

  Future<void> deleteReport(String id) async {
    await _reportService.deleteReport(id);
  }

  Future<void> loadStats() async {
    try {
      _stats = await _reportService.getReportStats();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }
}

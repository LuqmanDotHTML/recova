import '../config/app_constants.dart';

class Report {
  final String id;
  final String userId;
  final ReportType type;
  final String title;
  final String description;
  final int? categoryId;
  final String? categoryName;
  final String location;
  final DateTime dateOccurred;
  final String? imageUrl;
  final ReportStatus status;
  final String? rejectionReason;
  final bool isFlagged;
  final String? reporterName;
  final String? reporterStudentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Report({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    this.categoryId,
    this.categoryName,
    required this.location,
    required this.dateOccurred,
    this.imageUrl,
    required this.status,
    this.rejectionReason,
    this.isFlagged = false,
    this.reporterName,
    this.reporterStudentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    // Handle nested joins from Supabase
    final profiles = json['profiles'] as Map<String, dynamic>?;
    final categories = json['categories'] as Map<String, dynamic>?;

    return Report(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: ReportType.fromString(json['type'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      categoryId: json['category_id'] as int?,
      categoryName: categories?['name'] as String?,
      location: json['location'] as String,
      dateOccurred: DateTime.parse(json['date_occurred'] as String),
      imageUrl: json['image_url'] as String?,
      status: ReportStatus.fromString(json['status'] as String),
      rejectionReason: json['rejection_reason'] as String?,
      isFlagged: json['is_flagged'] as bool? ?? false,
      reporterName: profiles?['full_name'] as String?,
      reporterStudentId: profiles?['student_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

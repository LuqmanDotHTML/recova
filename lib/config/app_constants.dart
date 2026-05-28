enum UserRole {
  student,
  admin,
  guest;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserRole.guest,
    );
  }
}

enum ReportStatus {
  pending,
  approved,
  rejected,
  recovered;

  static ReportStatus fromString(String value) {
    return ReportStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ReportStatus.pending,
    );
  }

  String get displayName => name[0].toUpperCase() + name.substring(1);
}

enum ReportType {
  lost,
  found;

  static ReportType fromString(String value) {
    return ReportType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ReportType.lost,
    );
  }

  String get displayName => name[0].toUpperCase() + name.substring(1);
}

class AppConstants {
  static const String appName = 'UniFind';
  static const String appTagline = 'Lost something? Found something? We connect them.';

  static const List<String> defaultCategories = [
    'Electronics', 'Books & Notes', 'ID Cards & Documents', 'Keys',
    'Clothing & Accessories', 'Water Bottles', 'Bags & Wallets', 'Others',
  ];

  static const List<String> campusLocations = [
    'Library Level 1', 'Library Level 2', 'Library Level 3',
    'Cafeteria Block A', 'Cafeteria Block B',
    'Lecture Hall A', 'Lecture Hall B', 'Lecture Hall C',
    'Lab Block C', 'Lab Block D', 'Student Lounge',
    'Parking Lot A', 'Parking Lot B',
    'Sports Complex', 'Gymnasium', 'Admin Building', 'Bus Stop', 'Others',
  ];
}

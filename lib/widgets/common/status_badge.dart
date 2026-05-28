import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (bg, fg) = _colors(isDark);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  (Color, Color) _colors(bool dark) => switch (status) {
    'pending'   => dark ? (AppColors.pendingBgDark, AppColors.pendingTextDark) : (AppColors.pendingBgLight, AppColors.pendingTextLight),
    'approved'  => dark ? (AppColors.approvedBgDark, AppColors.approvedTextDark) : (AppColors.approvedBgLight, AppColors.approvedTextLight),
    'rejected'  => dark ? (AppColors.rejectedBgDark, AppColors.rejectedTextDark) : (AppColors.rejectedBgLight, AppColors.rejectedTextLight),
    'recovered' => dark ? (AppColors.recoveredBgDark, AppColors.recoveredTextDark) : (AppColors.recoveredBgLight, AppColors.recoveredTextLight),
    _ => (Colors.grey.shade200, Colors.grey.shade800),
  };
}

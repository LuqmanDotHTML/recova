import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class TypeBadge extends StatelessWidget {
  final String type;
  const TypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLost = type == 'lost';
    final bg = isLost
        ? (isDark ? AppColors.lostBgDark : AppColors.lostBgLight)
        : (isDark ? AppColors.foundBgDark : AppColors.foundBgLight);
    final fg = isLost
        ? (isDark ? AppColors.lostTextDark : AppColors.lostTextLight)
        : (isDark ? AppColors.foundTextDark : AppColors.foundTextLight);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isLost ? Icons.search : Icons.check_circle_outline, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(type[0].toUpperCase() + type.substring(1),
            style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class ApprovalActionBar extends StatelessWidget {
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const ApprovalActionBar({super.key, required this.onApprove, required this.onReject});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onApprove,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Approve'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.approvedTextLight, foregroundColor: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onReject,
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Reject'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.errorLight, side: const BorderSide(color: AppColors.errorLight)),
          ),
        ),
      ],
    );
  }
}

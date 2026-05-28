import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_constants.dart';
import '../../providers/report_provider.dart';
import '../../widgets/student/report_form.dart';

class ReportLostScreen extends StatelessWidget {
  const ReportLostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure categories are loaded
    context.read<ReportProvider>().loadCategories();
    return Scaffold(
      appBar: AppBar(title: const Text('Report Lost Item')),
      body: const ReportForm(type: ReportType.lost),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_constants.dart';
import '../../providers/report_provider.dart';
import '../../widgets/student/report_form.dart';

class ReportFoundScreen extends StatelessWidget {
  const ReportFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ReportProvider>().loadCategories();
    return Scaffold(
      appBar: AppBar(title: const Text('Report Found Item')),
      body: const ReportForm(type: ReportType.found),
    );
  }
}

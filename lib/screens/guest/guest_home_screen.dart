import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes.dart';
import '../../providers/report_provider.dart';
import '../../widgets/common/report_card.dart';
import '../../widgets/common/search_bar_widget.dart';
import '../../widgets/common/category_chip.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});
  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  final _searchCtrl = TextEditingController();
  int? _selectedCategory;

  @override
  void initState() {
    super.initState();
    final rp = context.read<ReportProvider>();
    rp.loadCategories();
    rp.loadApprovedReports();
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  void _search(String query) {
    context.read<ReportProvider>().loadApprovedReports(search: query, categoryId: _selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final rp = context.watch<ReportProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('UniFind'),
        actions: [
          TextButton(onPressed: () => context.go(AppRoutes.login), child: const Text('Login')),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SearchBarWidget(controller: _searchCtrl, onChanged: _search),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CategoryChipList(
              categories: rp.categories,
              selectedId: _selectedCategory,
              onSelected: (id) {
                setState(() => _selectedCategory = id);
                context.read<ReportProvider>().loadApprovedReports(search: _searchCtrl.text, categoryId: id);
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: rp.isLoading
                ? const LoadingWidget()
                : rp.reports.isEmpty
                    ? const EmptyStateWidget(icon: Icons.inbox_outlined, title: 'No items found')
                    : RefreshIndicator(
                        onRefresh: () => rp.loadApprovedReports(search: _searchCtrl.text, categoryId: _selectedCategory),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: rp.reports.length,
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ReportCard(
                              report: rp.reports[i],
                              onTap: () => context.push('/guest/item/${rp.reports[i].id}'),
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

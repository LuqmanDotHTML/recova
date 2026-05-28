import 'package:flutter/material.dart';
import '../../models/category_model.dart';

class CategoryChipList extends StatelessWidget {
  final List<Category> categories;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  const CategoryChipList({super.key, required this.categories, this.selectedId, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('All'),
              selected: selectedId == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          ...categories.map((cat) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(cat.name),
              selected: selectedId == cat.id,
              onSelected: (_) => onSelected(selectedId == cat.id ? null : cat.id),
            ),
          )),
        ],
      ),
    );
  }
}

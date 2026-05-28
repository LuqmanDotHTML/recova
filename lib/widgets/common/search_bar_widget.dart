import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hint = 'Search items...',
    required this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: onFilterTap != null
            ? IconButton(icon: const Icon(Icons.tune), onPressed: onFilterTap)
            : null,
      ),
    );
  }
}

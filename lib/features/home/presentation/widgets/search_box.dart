import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search by location or boarding name',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: IconButton(
          tooltip: 'Filter',
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Filters will be available soon')),
          ),
          icon: const Icon(Icons.tune_rounded),
        ),
      ),
    );
  }
}

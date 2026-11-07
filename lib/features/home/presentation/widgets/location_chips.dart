import 'package:flutter/material.dart';

class LocationChips extends StatelessWidget {
  const LocationChips({
    required this.locations,
    required this.selectedLocation,
    required this.onSelected,
    super.key,
  });

  final List<String> locations;
  final String selectedLocation;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: locations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final location = locations[index];
          return ChoiceChip(
            label: Text(location),
            selected: location == selectedLocation,
            onSelected: (_) => onSelected(location),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          );
        },
      ),
    );
  }
}

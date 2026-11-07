import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: locations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final location = locations[index];
          final isSelected = location == selectedLocation;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelected(location),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark
                            ? const Color(0xFF1B4944)
                            : AppColors.softMint)
                        : (isDark
                            ? AppColors.darkElevatedSurface
                            : Colors.white),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? (isDark ? AppColors.darkPrimary : AppColors.teal)
                          : (isDark ? AppColors.darkBorder : AppColors.border),
                      width: isSelected ? 1.4 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.teal.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        Icon(
                          Icons.location_on_rounded,
                          size: 13,
                          color:
                              isDark ? AppColors.darkPrimary : AppColors.teal,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? (isDark
                                  ? AppColors.darkPrimaryText
                                  : AppColors.navy)
                              : (isDark
                                  ? AppColors.darkSecondaryText
                                  : AppColors.secondaryText),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

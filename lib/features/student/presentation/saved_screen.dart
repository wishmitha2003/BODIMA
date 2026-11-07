import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../home/data/boarding_listing.dart';
import '../../shared/data/mock_repository.dart';
import 'boarding_details_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({
    this.saved,
    this.onRemove,
    this.onListingTap,
    this.onExploreTap,
    super.key,
  });

  final Set<String>? saved;
  final ValueChanged<String>? onRemove;
  final ValueChanged<BoardingListing>? onListingTap;
  final VoidCallback? onExploreTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<Set<String>>(
      valueListenable: MockRepository.instance.savedListingsNotifier,
      builder: (context, savedSet, _) {
        final activeSaved = saved ?? savedSet;
        final allListings = MockRepository.instance.listingsNotifier.value;
        final savedItems =
            allListings.where((l) => activeSaved.contains(l.name)).toList();

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.background,
          appBar: AppBar(
            title: Row(
              children: [
                const Text(
                  'Saved Places',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                if (savedItems.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkElevatedSurface
                          : AppColors.softMint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${savedItems.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkPrimary : AppColors.teal,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          body: savedItems.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface
                                : AppColors.softMint,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_border_rounded,
                            size: 42,
                            color: isDark
                                ? AppColors.darkSecondaryText
                                : AppColors.secondaryTeal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No saved boardings yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? AppColors.darkPrimaryText
                                : AppColors.deepNavy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the heart icon on any boarding place near your campus to save it for quick reference.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: isDark
                                ? AppColors.darkSecondaryText
                                : AppColors.secondaryText,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: onExploreTap,
                          icon: const Icon(Icons.explore_outlined, size: 18),
                          label: const Text('Explore Boardings'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: savedItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = savedItems[index];

                    return Material(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color:
                              isDark ? AppColors.darkBorder : AppColors.border,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          if (onListingTap != null) {
                            onListingTap!(item);
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    BoardingDetailsScreen(listing: item),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  color: Color(item.imageColor),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.home_work_rounded,
                                  size: 34,
                                  color: AppColors.teal.withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? AppColors.darkPrimaryText
                                            : AppColors.deepNavy,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item.location} • ${item.campus}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? AppColors.darkSecondaryText
                                            : AppColors.secondaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.price,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: isDark
                                            ? AppColors.darkPrimary
                                            : AppColors.teal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                tooltip: 'Remove from Saved',
                                icon: const Icon(
                                  Icons.favorite_rounded,
                                  color: AppColors.error,
                                ),
                                onPressed: () {
                                  if (onRemove != null) {
                                    onRemove!(item.name);
                                  } else {
                                    MockRepository.instance
                                        .toggleSave(item.name);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

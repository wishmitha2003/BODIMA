import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../home/data/boarding_listing.dart';
import '../../shared/data/mock_repository.dart';
import '../../student/presentation/boarding_details_screen.dart';
import 'add_boarding_screen.dart';

class OwnerListingsScreen extends StatelessWidget {
  const OwnerListingsScreen({super.key});

  void _showDeleteDialog(BuildContext context, String listingName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Boarding Listing?'),
        content: Text(
          'Are you sure you want to remove "$listingName"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              MockRepository.instance.deleteListing(listingName);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Listing deleted successfully')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Properties',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        actions: [
          IconButton(
            tooltip: 'Add Listing',
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddBoardingScreen()),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<List<BoardingListing>>(
        valueListenable: MockRepository.instance.listingsNotifier,
        builder: (context, listings, _) {
          if (listings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.holiday_village_outlined, size: 56),
                  const SizedBox(height: 12),
                  const Text('No properties listed yet'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddBoardingScreen(),
                        ),
                      );
                    },
                    child: const Text('Add Your First Property'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: listings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final listing = listings[index];

              return Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Color(listing.imageColor),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.home_work_rounded,
                              size: 30,
                              color: AppColors.teal.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listing.name,
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
                                const SizedBox(height: 3),
                                Text(
                                  '${listing.location} • ${listing.campus}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.darkSecondaryText
                                        : AppColors.secondaryText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${listing.price} / month',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 10),

                      // Availability Toggle & Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                listing.isAvailable ? 'Vacant' : 'Occupied',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: listing.isAvailable
                                      ? AppColors.success
                                      : AppColors.secondaryText,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: listing.isAvailable,
                                  activeThumbColor: AppColors.success,
                                  onChanged: (val) {
                                    MockRepository.instance
                                        .updateListingAvailability(
                                      listing.name,
                                      val,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                tooltip: 'Preview Student View',
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 20,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => BoardingDetailsScreen(
                                        listing: listing,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                tooltip: 'Delete Listing',
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: AppColors.error,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    _showDeleteDialog(context, listing.name),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

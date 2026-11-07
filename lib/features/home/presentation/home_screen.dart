import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../data/boarding_listing.dart';
import 'widgets/bodima_header.dart';
import 'widgets/boarding_card.dart';
import 'widgets/location_chips.dart';
import 'widgets/search_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    this.onListingTap,
    this.onExploreTap,
    this.onProfileTap,
    super.key,
  });

  final ValueChanged<BoardingListing>? onListingTap;
  final VoidCallback? onExploreTap;
  final VoidCallback? onProfileTap;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _locations = [
    'Malabe',
    'Kaduwela',
    'Thalahena',
    'Battaramulla',
    'Hokandara'
  ];
  final Set<String> _favorites = {};
  String _selectedLocation = 'Malabe';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodimaHeader(onProfileTap: widget.onProfileTap),
                    const SizedBox(height: 28),
                    Text('Hello, welcome! 👋',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.teal,
                                  fontWeight: FontWeight.w700,
                                )),
                    const SizedBox(height: 8),
                    Text('Find your perfect\nboarding place.',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w800,
                              height: 1.12,
                            )),
                    const SizedBox(height: 10),
                    Text('Comfortable, verified stays near your campus.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.muted,
                            )),
                    const SizedBox(height: 24),
                    SearchBox(controller: _searchController),
                    const SizedBox(height: 28),
                    _sectionHeader(context, 'Popular locations'),
                    const SizedBox(height: 12),
                    LocationChips(
                      locations: _locations,
                      selectedLocation: _selectedLocation,
                      onSelected: (location) =>
                          setState(() => _selectedLocation = location),
                    ),
                    const SizedBox(height: 28),
                    _sectionHeader(context, 'Featured boardings',
                        showAction: true),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 300,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: sampleBoardings.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final listing = sampleBoardings[index];
                    return BoardingCard(
                      listing: listing,
                      onTap: () => widget.onListingTap?.call(listing),
                      isFavorite: _favorites.contains(listing.name),
                      onFavoriteChanged: () => setState(() {
                        if (!_favorites.add(listing.name)) {
                          _favorites.remove(listing.name);
                        }
                      }),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title,
      {bool showAction = false}) {
    return Row(
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w800)),
        const Spacer(),
        if (showAction)
          TextButton(
            onPressed: widget.onExploreTap,
            child: const Text('View all'),
          ),
      ],
    );
  }
}

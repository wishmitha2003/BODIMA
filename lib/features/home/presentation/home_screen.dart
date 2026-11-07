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
    this.isLoggedIn = true,
    super.key,
  });

  final ValueChanged<BoardingListing>? onListingTap;
  final VoidCallback? onExploreTap;
  final VoidCallback? onProfileTap;
  final bool isLoggedIn;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _campuses = [
    'All Campuses',
    'SLIIT (Malabe)',
    'UoM (Moratuwa)',
    'NSBM (Homagama)',
    'USJ (Nugegoda)',
    'UOC (Colombo)',
    'Kelaniya Uni',
  ];
  final _locations = [
    'All areas',
    'Malabe',
    'Katubedda',
    'Pitipana',
    'Gangodawila',
    'Colombo 07',
    'Dalugama',
    'Kaduwela',
  ];
  final Set<String> _favorites = {};
  String _selectedCampus = 'All Campuses';
  String _selectedLocation = 'All areas';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter featured boardings based on selected campus and location
    final filteredFeatured = sampleBoardings.where((item) {
      final matchesCampus =
          _selectedCampus == 'All Campuses' || item.campus == _selectedCampus;
      final matchesLocation = _selectedLocation == 'All areas' ||
          item.location == _selectedLocation;
      return matchesCampus && matchesLocation;
    }).toList();

    final displayListings =
        filteredFeatured.isEmpty ? sampleBoardings : filteredFeatured;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodimaHeader(
                      onProfileTap: widget.onProfileTap,
                      isLoggedIn: widget.isLoggedIn,
                    ),
                    const SizedBox(height: 28),

                    // Welcome & Headline
                    Text(
                      'Hello, welcome! 👋',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkPrimary : AppColors.teal,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Find your perfect\nboarding place.',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                        letterSpacing: -0.6,
                        color: isDark
                            ? AppColors.darkPrimaryText
                            : AppColors.deepNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Comfortable, verified stays near your campus.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.darkSecondaryText
                            : AppColors.secondaryText,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Search component
                    SearchBox(
                      controller: _searchController,
                      onTap: widget.onExploreTap,
                      onFilterTap: widget.onExploreTap,
                      onSubmitted: (_) => widget.onExploreTap?.call(),
                    ),
                    const SizedBox(height: 20),

                    // Elegant Promotional Highlight Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF122C30),
                                  const Color(0xFF17373C),
                                ]
                              : [
                                  AppColors.warmIvory,
                                  AppColors.softMint.withValues(alpha: 0.6),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.teal.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  isDark ? AppColors.darkSurface : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              color: AppColors.gold,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '100% Student Verified Stays',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13.5,
                                    color: isDark
                                        ? AppColors.darkPrimaryText
                                        : AppColors.deepNavy,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Zero broker fees • Direct landlord contact',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.darkSecondaryText
                                        : AppColors.secondaryText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),

                    // Select Campus section
                    _sectionHeader(
                      context,
                      'Select your Campus',
                      subtitle: 'Find verified boardings near your university',
                    ),
                    const SizedBox(height: 12),
                    LocationChips(
                      locations: _campuses,
                      selectedLocation: _selectedCampus,
                      onSelected: (campus) =>
                          setState(() => _selectedCampus = campus),
                    ),
                    const SizedBox(height: 22),

                    // Popular locations section
                    _sectionHeader(
                      context,
                      'Popular locations',
                      subtitle: 'Filter by area or town',
                    ),
                    const SizedBox(height: 12),
                    LocationChips(
                      locations: _locations,
                      selectedLocation: _selectedLocation,
                      onSelected: (location) =>
                          setState(() => _selectedLocation = location),
                    ),
                    const SizedBox(height: 28),

                    // Featured boardings section header
                    _sectionHeader(
                      context,
                      'Featured boardings',
                      subtitle: _selectedCampus == 'All Campuses'
                          ? 'Hand-picked student accommodations'
                          : 'Stays near $_selectedCampus',
                      showAction: true,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Horizontal Listing Carousel
            SliverToBoxAdapter(
              child: SizedBox(
                height: 310,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: displayListings.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final listing = displayListings[index];
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

            // Additional curated highlight
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF163E3B)
                              : AppColors.softMint,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.map_rounded,
                          size: 26,
                          color:
                              isDark ? AppColors.darkPrimary : AppColors.teal,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explore Map View',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.5,
                                color: isDark
                                    ? AppColors.darkPrimaryText
                                    : AppColors.deepNavy,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'View boarding distance & routes to your campus',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.darkSecondaryText
                                    : AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onExploreTap,
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkElevatedSurface
                                : AppColors.warmIvory,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color:
                                isDark ? AppColors.darkPrimary : AppColors.teal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    String title, {
    String? subtitle,
    bool showAction = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.secondaryText,
                ),
              ),
            ],
          ],
        ),
        const Spacer(),
        if (showAction)
          TextButton(
            onPressed: widget.onExploreTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View all',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? AppColors.darkPrimary : AppColors.teal,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: isDark ? AppColors.darkPrimary : AppColors.teal,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

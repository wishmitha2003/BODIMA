import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../home/data/boarding_listing.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    required this.saved,
    required this.onSaveChanged,
    required this.onListingTap,
    super.key,
  });
  final Set<String> saved;
  final ValueChanged<BoardingListing> onSaveChanged;
  final ValueChanged<BoardingListing> onListingTap;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _query = TextEditingController();
  String _location = 'All areas';
  bool _map = false;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final results = sampleBoardings.where((item) {
      final text = '${item.name} ${item.location}'.toLowerCase();
      return text.contains(_query.text.toLowerCase()) &&
          (_location == 'All areas' || item.location == _location);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color:
                  isDark ? AppColors.darkElevatedSurface : AppColors.warmIvory,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: IconButton(
              tooltip: 'Map view',
              onPressed: () => setState(() => _map = !_map),
              icon: Icon(
                _map ? Icons.format_list_bulleted_rounded : Icons.map_outlined,
                size: 20,
                color: isDark ? AppColors.darkPrimary : AppColors.teal,
              ),
            ),
          ),
        ],
      ),
      body: _map
          ? MapViewScreen(listings: results, onListingTap: widget.onListingTap)
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
              children: [
                TextField(
                  controller: _query,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search location or boarding',
                    prefixIcon: Icon(Icons.search_rounded),
                    suffixIcon: Icon(Icons.tune_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['All areas', 'Malabe', 'Kaduwela', 'Thalahena']
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(item),
                              selected: _location == item,
                              onSelected: (_) =>
                                  setState(() => _location = item),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      '${results.length} places found',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: isDark
                            ? AppColors.darkPrimaryText
                            : AppColors.deepNavy,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => _showFilters(context),
                      icon: const Icon(Icons.tune_rounded, size: 16),
                      label: const Text('Filters'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (results.isEmpty)
                  const _EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No boardings found',
                    message: 'Try a different area or search term.',
                  )
                else
                  ...results.map(
                    (listing) => _ListingTile(
                      listing: listing,
                      saved: widget.saved.contains(listing.name),
                      onTap: () => widget.onListingTap(listing),
                      onSave: () => widget.onSaveChanged(listing),
                    ),
                  ),
              ],
            ),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter boardings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            const ListTile(
              leading: Icon(Icons.payments_outlined),
              title: Text('Monthly rent'),
              subtitle: Text('Up to Rs. 30,000'),
              trailing: Icon(Icons.chevron_right_rounded),
            ),
            const ListTile(
              leading: Icon(Icons.bed_outlined),
              title: Text('Room type'),
              subtitle: Text('Any room type'),
              trailing: Icon(Icons.chevron_right_rounded),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply filters'),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedScreen extends StatelessWidget {
  const SavedScreen({
    required this.saved,
    required this.onRemove,
    required this.onListingTap,
    this.onExploreTap,
    super.key,
  });

  final Set<String> saved;
  final ValueChanged<String> onRemove;
  final ValueChanged<BoardingListing> onListingTap;
  final VoidCallback? onExploreTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final listings =
        sampleBoardings.where((item) => saved.contains(item.name)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved places',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
          ),
        ),
      ),
      body: listings.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF163E3B)
                            : AppColors.softMint,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        size: 46,
                        color: isDark ? AppColors.darkPrimary : AppColors.teal,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Nothing saved yet',
                      textAlign: TextAlign.center,
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
                      'Tap the heart icon on any boarding to save it for quick access later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: isDark
                            ? AppColors.darkSecondaryText
                            : AppColors.secondaryText,
                        height: 1.4,
                      ),
                    ),
                    if (onExploreTap != null) ...[
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: onExploreTap,
                        icon: const Icon(Icons.explore_outlined, size: 18),
                        label: const Text('Explore Boardings'),
                      ),
                    ],
                  ],
                ),
              ),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              children: [
                Row(
                  children: [
                    Text(
                      'Your Shortlist',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.darkPrimaryText
                            : AppColors.deepNavy,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF163E3B)
                            : AppColors.softMint,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${listings.length}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color:
                              isDark ? AppColors.darkPrimary : AppColors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...listings.map(
                  (item) => _ListingTile(
                    listing: item,
                    saved: true,
                    onTap: () => onListingTap(item),
                    onSave: () => onRemove(item.name),
                  ),
                ),
              ],
            ),
    );
  }
}

class BoardingDetailsScreen extends StatefulWidget {
  const BoardingDetailsScreen({
    required this.listing,
    required this.isSaved,
    required this.onSaveChanged,
    super.key,
  });

  final BoardingListing listing;
  final bool isSaved;
  final VoidCallback onSaveChanged;

  @override
  State<BoardingDetailsScreen> createState() => _BoardingDetailsScreenState();
}

class _BoardingDetailsScreenState extends State<BoardingDetailsScreen> {
  int _activeImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final listing = widget.listing;
    final isAvailableNow = listing.availability == 'Available Now';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Boarding Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
          ),
        ),
        actions: [
          IconButton(
            tooltip: widget.isSaved ? 'Remove from saved' : 'Save boarding',
            onPressed: widget.onSaveChanged,
            icon: Icon(
              widget.isSaved
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: widget.isSaved
                  ? const Color(0xFFE11D48)
                  : (isDark ? AppColors.darkPrimaryText : AppColors.deepNavy),
            ),
          ),
          IconButton(
            tooltip: 'Share',
            onPressed: () =>
                _message(context, 'Share link copied to clipboard'),
            icon: const Icon(Icons.share_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly Rent',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    listing.price,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppColors.darkPrimary : AppColors.teal,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _message(
                    context,
                    'Inquiry sent! The verified owner will contact you shortly.',
                  ),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                  label: const Text('Contact owner'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
        children: [
          // Premium Hero Image Presentation
          Container(
            height: 230,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(listing.imageColor),
                  Color(listing.imageColor).withValues(alpha: 0.75),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.home_work_rounded,
                    size: 96,
                    color: AppColors.teal.withValues(alpha: 0.45),
                  ),
                ),
                // Verified Badge
                if (listing.isVerified)
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.deepNavy,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: AppColors.gold,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Verified Property',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Image Index Indicator
                Positioned(
                  bottom: 12,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_activeImageIndex + 1}/3 Photos',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Mini Gallery Selectors
          Row(
            children: List.generate(3, (index) {
              final isSelected = _activeImageIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _activeImageIndex = index),
                  child: Container(
                    height: 52,
                    margin: EdgeInsets.only(
                      right: index < 2 ? 8 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: Color(listing.imageColor)
                          .withValues(alpha: isSelected ? 1.0 : 0.4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? (isDark ? AppColors.darkPrimary : AppColors.teal)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      index == 0
                          ? Icons.bed_rounded
                          : (index == 1
                              ? Icons.shower_rounded
                              : Icons.kitchen_rounded),
                      size: 22,
                      color: AppColors.teal.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // Title & Verification
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                        color: isDark
                            ? AppColors.darkPrimaryText
                            : AppColors.deepNavy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 15,
                          color: isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.secondaryText,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${listing.location}  •  ${listing.distance ?? 'Nearby'}',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: isDark
                                  ? AppColors.darkSecondaryText
                                  : AppColors.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.school_rounded,
                          size: 14,
                          color:
                              isDark ? AppColors.darkPrimary : AppColors.teal,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Near ${listing.campus} (${listing.walkTime})',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark ? AppColors.darkPrimary : AppColors.teal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isAvailableNow
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  listing.availability,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color:
                        isAvailableNow ? AppColors.success : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price & Terms Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color:
                  isDark ? AppColors.darkElevatedSurface : AppColors.warmIvory,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${listing.price}/month',
                      style: TextStyle(
                        color: isDark ? AppColors.darkPrimary : AppColors.teal,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Water & electricity terms apply',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.darkSecondaryText
                            : AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDark ? const Color(0xFF163E3B) : AppColors.softMint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '1 Month Deposit',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color:
                          isDark ? AppColors.darkPrimary : AppColors.deepNavy,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Property Quick Specs Grid
          Row(
            children: [
              _specTile(
                context,
                icon: Icons.bedroom_parent_outlined,
                label: 'Room Type',
                value: listing.roomType,
                isDark: isDark,
              ),
              const SizedBox(width: 10),
              _specTile(
                context,
                icon: Icons.people_outline_rounded,
                label: 'Gender Pref',
                value: listing.genderPreference,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _specTile(
                context,
                icon: Icons.directions_walk_rounded,
                label: 'Campus Proximity',
                value: listing.distance ?? 'Nearby campus',
                isDark: isDark,
              ),
              const SizedBox(width: 10),
              _specTile(
                context,
                icon: Icons.security_rounded,
                label: 'Security',
                value: 'Gated / Verified',
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // About Section
          Text(
            'About this place',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
              color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Text(
              'A comfortable, student-friendly boarding place with a safe environment and convenient access to universities, shops and public transport. Quiet study environment suitable for academic focus.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Facilities Section
          Text(
            'Facilities & Amenities',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
              color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Wi-Fi',
              'Attached Bathroom',
              'Parking',
              'Kitchen',
              'Study area',
              'Water supply',
              'Furnished',
            ].map((facility) {
              final isPresent = listing.facilities.contains(facility) ||
                  ['Study area', 'Water supply'].contains(facility);

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isPresent
                      ? (isDark ? const Color(0xFF163E3B) : AppColors.softMint)
                      : (isDark
                          ? AppColors.darkElevatedSurface
                          : AppColors.warmIvory),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isPresent
                        ? (isDark
                            ? AppColors.darkPrimary.withValues(alpha: 0.4)
                            : AppColors.teal.withValues(alpha: 0.3))
                        : (isDark ? AppColors.darkBorder : AppColors.border),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPresent
                          ? Icons.check_circle_rounded
                          : Icons.info_outline,
                      size: 14,
                      color: isPresent
                          ? (isDark ? AppColors.darkPrimary : AppColors.teal)
                          : (isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.secondaryText),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      facility,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight:
                            isPresent ? FontWeight.w700 : FontWeight.w500,
                        color: isPresent
                            ? (isDark
                                ? AppColors.darkPrimaryText
                                : AppColors.deepNavy)
                            : (isDark
                                ? AppColors.darkSecondaryText
                                : AppColors.secondaryText),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Verified Owner Information Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor:
                          isDark ? const Color(0xFF163E3B) : AppColors.softMint,
                      child: Icon(
                        Icons.person_rounded,
                        size: 32,
                        color: isDark ? AppColors.darkPrimary : AppColors.teal,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'S. K. Perera',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: isDark
                                  ? AppColors.darkPrimaryText
                                  : AppColors.deepNavy,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Verified Owner',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFB4852B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Typically responds within 30 minutes',
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
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Nearby landmarks
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color:
                  isDark ? AppColors.darkElevatedSurface : AppColors.warmIvory,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.near_me_rounded,
                  size: 20,
                  color: isDark ? AppColors.darkPrimary : AppColors.teal,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nearby landmarks',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: isDark
                              ? AppColors.darkPrimaryText
                              : AppColors.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${listing.campus} is only ${listing.walkTime} (${listing.distance ?? 'nearby'}). Convenient access to lecture halls, university canteen, study spots & main bus routes.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.secondaryText,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _specTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF163E3B) : AppColors.softMint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: isDark ? AppColors.darkPrimary : AppColors.teal,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.secondaryText,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkPrimaryText
                          : AppColors.deepNavy,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({
    required this.listings,
    required this.onListingTap,
    super.key,
  });

  final List<BoardingListing> listings;
  final ValueChanged<BoardingListing> onListingTap;

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  int _selectedListingIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final listings = widget.listings;
    final selectedListing =
        listings.isNotEmpty && _selectedListingIndex < listings.length
            ? listings[_selectedListingIndex]
            : (listings.isNotEmpty ? listings.first : null);

    return Stack(
      children: [
        // Stylized map background canvas
        Container(
          color: isDark ? const Color(0xFF0F1E21) : const Color(0xFFE8EFEA),
          child: CustomPaint(
            size: Size.infinite,
            painter: _MapGridPainter(isDark: isDark),
          ),
        ),

        // Map Pins for listings
        if (listings.isNotEmpty)
          ...listings.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isSelected = idx == _selectedListingIndex;

            // Distinct positions for mock map pins
            final positions = [
              const Offset(160, 240),
              const Offset(90, 340),
              const Offset(250, 310),
              const Offset(220, 180),
              const Offset(80, 170),
            ];
            final pos = positions[idx % positions.length];

            return Positioned(
              left: pos.dx,
              top: pos.dy,
              child: GestureDetector(
                onTap: () => setState(() => _selectedListingIndex = idx),
                child: AnimatedScale(
                  scale: isSelected ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.deepNavy
                          : (isDark ? AppColors.darkSurface : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.gold
                            : (isDark ? AppColors.darkBorder : AppColors.teal),
                        width: isSelected ? 2 : 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.home_rounded,
                          size: 13,
                          color: isSelected
                              ? AppColors.gold
                              : (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.teal),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.price,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                    ? AppColors.darkPrimaryText
                                    : AppColors.primaryText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

        // Campus Center Marker
        Positioned(
          left: 175,
          top: 290,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.teal,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.school_rounded, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  'SLIIT Campus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Floating Search & Filter bar
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: isDark ? AppColors.darkPrimary : AppColors.teal,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search this area (Malabe & surrounding)',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.secondaryText,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkElevatedSurface
                        : AppColors.warmIvory,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 16,
                    color: isDark ? AppColors.darkPrimary : AppColors.teal,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Floating Selected Boarding Preview Card
        if (selectedListing != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: Color(selectedListing.imageColor),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.home_work_rounded,
                      size: 36,
                      color: AppColors.teal.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            if (selectedListing.isVerified) ...[
                              const Icon(
                                Icons.verified_rounded,
                                size: 13,
                                color: AppColors.gold,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                selectedListing.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.5,
                                  color: isDark
                                      ? AppColors.darkPrimaryText
                                      : AppColors.deepNavy,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${selectedListing.location} • ${selectedListing.roomType}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkSecondaryText
                                : AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${selectedListing.price}/month',
                          style: TextStyle(
                            color:
                                isDark ? AppColors.darkPrimary : AppColors.teal,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'View details',
                    onPressed: () => widget.onListingTap(selectedListing),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkElevatedSurface
                            : AppColors.softMint,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color:
                            isDark ? AppColors.darkPrimary : AppColors.deepNavy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _MapGridPainter extends CustomPainter {
  const _MapGridPainter({required this.isDark});
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = isDark
          ? const Color(0xFF1E3538).withValues(alpha: 0.5)
          : const Color(0xFFD4E2DC)
      ..strokeWidth = 1.0;

    final roadPaint = Paint()
      ..color = isDark
          ? const Color(0xFF234044).withValues(alpha: 0.7)
          : const Color(0xFFF9F7F1)
      ..strokeWidth = 6.0;

    // Background road curves
    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..cubicTo(size.width * 0.4, size.height * 0.25, size.width * 0.6,
          size.height * 0.45, size.width, size.height * 0.4);
    canvas.drawPath(path, roadPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.2, 0)
      ..cubicTo(size.width * 0.35, size.height * 0.4, size.width * 0.5,
          size.height * 0.6, size.width * 0.8, size.height);
    canvas.drawPath(path2, roadPaint);

    // Subtle Grid lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    required this.onOwnerDashboard,
    this.isLoggedIn = true,
    this.userName = 'Student User',
    this.userEmail = 'student@example.com',
    this.onLoginTap,
    this.onRegisterTap,
    this.onLogout,
    super.key,
  });

  final VoidCallback onOwnerDashboard;
  final bool isLoggedIn;
  final String userName;
  final String userEmail;
  final VoidCallback? onLoginTap;
  final VoidCallback? onRegisterTap;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.navy, AppColors.teal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.teal.withValues(alpha: 0.3),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_person_rounded,
                    size: 46,
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Login & Create Account',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                    color:
                        isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please log in or create an account to view your verified student profile, shortlisted boardings, and host dashboard.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.secondaryText,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: onLoginTap,
                  icon: const Icon(Icons.login_rounded, size: 18),
                  label: const Text('Log In'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: onRegisterTap,
                  icon: const Icon(Icons.person_add_outlined, size: 18),
                  label: const Text('Create New Account'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: isDark ? AppColors.darkPrimary : AppColors.teal,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Only registered and logged-in students can view profiles, save properties, and directly contact verified landlords.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkSecondaryText
                                : AppColors.secondaryText,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          // Profile Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF132B2E), const Color(0xFF17383D)]
                    : [AppColors.warmIvory, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.teal, width: 2.5),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.softMint,
                      child: Icon(
                        Icons.person_rounded,
                        size: 46,
                        color: AppColors.navy,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(3.5),
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color:
                        isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDark ? const Color(0xFF163E3B) : AppColors.softMint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.school_rounded,
                        size: 13,
                        color: isDark ? AppColors.darkPrimary : AppColors.teal,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Verified Campus Member',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.deepNavy,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section 1: Account
          _sectionLabel('ACCOUNT & MANAGEMENT', isDark),
          const SizedBox(height: 10),
          _settingsCard(
            isDark: isDark,
            children: [
              _ProfileAction(
                icon: Icons.person_outline_rounded,
                label: 'Edit profile',
                onTap: () => _message(
                  context,
                  'Profile editing is ready for your details.',
                ),
              ),
              _divider(isDark),
              _ProfileAction(
                icon: Icons.dashboard_customize_outlined,
                label: 'Owner dashboard',
                trailingText: 'Host Mode',
                onTap: onOwnerDashboard,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Section 2: Preferences
          _sectionLabel('PREFERENCES', isDark),
          const SizedBox(height: 10),
          _settingsCard(
            isDark: isDark,
            children: [
              _ProfileAction(
                icon: Icons.notifications_none_rounded,
                label: 'Notification settings',
                onTap: () =>
                    _message(context, 'Notification preferences opened.'),
              ),
              _divider(isDark),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: AppTheme.themeMode,
                builder: (context, mode, _) {
                  final label = mode == ThemeMode.light
                      ? 'Light Theme'
                      : (mode == ThemeMode.dark
                          ? 'Dark Theme'
                          : 'System Default');
                  return _ProfileAction(
                    icon: mode == ThemeMode.dark
                        ? Icons.dark_mode_rounded
                        : (mode == ThemeMode.light
                            ? Icons.light_mode_rounded
                            : Icons.brightness_auto_rounded),
                    label: 'Theme',
                    trailingText: label,
                    onTap: () => _showThemePicker(context),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Section 3: Support & Access
          _sectionLabel('HELP & ACCESS', isDark),
          const SizedBox(height: 10),
          _settingsCard(
            isDark: isDark,
            children: [
              _ProfileAction(
                icon: Icons.help_outline_rounded,
                label: 'Help and support',
                onTap: () => _message(
                  context,
                  'Support team is ready to assist your queries.',
                ),
              ),
              _divider(isDark),
              _ProfileAction(
                icon: Icons.logout_rounded,
                label: 'Log out',
                onTap: onLogout ?? () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentMode = AppTheme.themeMode.value;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Appearance',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color:
                      isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 14),
              Material(
                color: isDark
                    ? AppColors.darkElevatedSurface
                    : AppColors.warmIvory,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _themeListTile(
                      context,
                      title: 'System Default',
                      subtitle: 'Sync with device system theme',
                      icon: Icons.brightness_auto_rounded,
                      mode: ThemeMode.system,
                      selected: currentMode == ThemeMode.system,
                      isDark: isDark,
                    ),
                    Divider(
                      height: 1,
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    _themeListTile(
                      context,
                      title: 'Light Theme',
                      subtitle: 'Warm Ivory, Surface White & Deep Navy',
                      icon: Icons.light_mode_rounded,
                      mode: ThemeMode.light,
                      selected: currentMode == ThemeMode.light,
                      isDark: isDark,
                    ),
                    Divider(
                      height: 1,
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    _themeListTile(
                      context,
                      title: 'Dark Theme',
                      subtitle: 'Deep Slate, Charcoal & Mint',
                      icon: Icons.dark_mode_rounded,
                      mode: ThemeMode.dark,
                      selected: currentMode == ThemeMode.dark,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _themeListTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode mode,
    required bool selected,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected
            ? (isDark ? AppColors.darkPrimary : AppColors.teal)
            : (isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected
              ? (isDark ? AppColors.darkPrimaryText : AppColors.deepNavy)
              : (isDark ? AppColors.darkSecondaryText : AppColors.primaryText),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
        ),
      ),
      trailing: selected
          ? Icon(
              Icons.check_rounded,
              color: isDark ? AppColors.darkPrimary : AppColors.teal,
            )
          : null,
      onTap: () {
        AppTheme.themeMode.value = mode;
        Navigator.pop(context);
      },
    );
  }

  Widget _sectionLabel(String label, bool isDark) => Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
        ),
      );

  Widget _settingsCard({
    required bool isDark,
    required List<Widget> children,
  }) =>
      Material(
        color: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      );

  Widget _divider(bool isDark) => Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
        color: isDark ? AppColors.darkBorder : AppColors.border,
      );
}

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Owner dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? AppColors.darkPrimary : AppColors.teal,
        foregroundColor: isDark ? AppColors.deepNavy : Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ListingFormScreen()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add listing',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
        children: [
          Text(
            'Welcome back, Owner!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Track your listed student properties & inquiry responses',
            style: TextStyle(
              fontSize: 13.5,
              color: isDark
                  ? AppColors.darkSecondaryText
                  : AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 20),

          // Statistics Grid
          Row(
            children: const [
              _Metric(
                label: 'Active listings',
                value: '2',
                icon: Icons.home_work_outlined,
              ),
              SizedBox(width: 12),
              _Metric(
                label: 'Inquiries',
                value: '8',
                icon: Icons.chat_bubble_outline_rounded,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              _Metric(
                label: 'Total Views',
                value: '184',
                icon: Icons.visibility_outlined,
              ),
              SizedBox(width: 12),
              _Metric(
                label: 'Occupancy',
                value: '100%',
                icon: Icons.check_circle_outline_rounded,
              ),
            ],
          ),
          const SizedBox(height: 28),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My listings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color:
                      isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                ),
              ),
              Text(
                '2 Stays Published',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...sampleBoardings.take(2).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Color(item.imageColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.home_rounded,
                          color: AppColors.teal,
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 3),
                          Text('${item.location} • ${item.price}/month'),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Active & Listed',
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert_rounded),
                        onPressed: () => _message(
                          context,
                          'Listing options: Edit, Pause, or Manage Photos',
                        ),
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

class ListingFormScreen extends StatelessWidget {
  const ListingFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add boarding',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 19,
            color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          Text(
            'Create New Listing',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Provide accurate boarding details for verified university tenants.',
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkSecondaryText
                  : AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 20),
          for (final field in [
            'Boarding title',
            'Description',
            'Monthly rent',
            'Address',
            'Contact number'
          ]) ...[
            TextField(
              decoration: InputDecoration(
                labelText: field,
                hintText: 'Enter $field',
              ),
            ),
            const SizedBox(height: 14),
          ],
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Nearby Campus / University',
            ),
            dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
            initialValue: 'SLIIT (Malabe)',
            items: const [
              DropdownMenuItem(
                  value: 'SLIIT (Malabe)', child: Text('SLIIT (Malabe)')),
              DropdownMenuItem(
                  value: 'UoM (Moratuwa)',
                  child: Text('University of Moratuwa (UoM)')),
              DropdownMenuItem(
                  value: 'NSBM (Homagama)',
                  child: Text('NSBM Green University')),
              DropdownMenuItem(
                  value: 'USJ (Nugegoda)',
                  child: Text('University of Sri Jayewardenepura (USJ)')),
              DropdownMenuItem(
                  value: 'UOC (Colombo)',
                  child: Text('University of Colombo (UOC)')),
              DropdownMenuItem(
                  value: 'Kelaniya Uni', child: Text('University of Kelaniya')),
              DropdownMenuItem(
                  value: 'General', child: Text('Other / Any University')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Gender preference',
            ),
            dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
            initialValue: 'Any',
            items: const [
              DropdownMenuItem(value: 'Any', child: Text('Any')),
              DropdownMenuItem(value: 'Female', child: Text('Female Only')),
              DropdownMenuItem(value: 'Male', child: Text('Male Only')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _message(
                context,
                'Listing saved as a draft. Verification review started.',
              );
            },
            child: const Text('Save listing'),
          ),
        ],
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    this.onLoginSuccess,
    this.initialRegister = false,
    super.key,
  });

  final void Function(String name, String email)? onLoginSuccess;
  final bool initialRegister;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _register = widget.initialRegister;
  bool _obscure = true;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Student User');
    _emailController = TextEditingController(text: 'student@example.com');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : 'Student User';
    final email = _emailController.text.trim().isNotEmpty
        ? _emailController.text.trim()
        : 'student@example.com';

    widget.onLoginSuccess?.call(name, email);
    _message(
      context,
      _register
          ? 'Account created successfully! Welcome, $name.'
          : 'Logged in successfully! Welcome back, $name.',
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _register ? 'Create account' : 'Welcome back',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          // Logo & Branding Icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navy, AppColors.teal],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.holiday_village_rounded,
                color: AppColors.gold,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              'BODIMA',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                color: isDark ? AppColors.darkPrimary : AppColors.deepNavy,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              _register
                  ? 'Join Sri Lanka’s verified student housing community'
                  : 'Log in to continue finding your ideal accommodation',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.secondaryText,
              ),
            ),
          ),
          const SizedBox(height: 28),

          if (_register) ...[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 14),
          ],

          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: _passwordController,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),

          if (_register) ...[
            const SizedBox(height: 14),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
          ],

          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submit,
            child: Text(_register ? 'Register' : 'Login'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => setState(() => _register = !_register),
            child: Text(
              _register
                  ? 'Already have an account? Login'
                  : 'Create a new account',
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingTile extends StatelessWidget {
  const _ListingTile({
    required this.listing,
    required this.saved,
    required this.onTap,
    required this.onSave,
  });

  final BoardingListing listing;
  final bool saved;
  final VoidCallback onTap;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: Color(listing.imageColor),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.home_work_rounded,
                    color: AppColors.teal,
                    size: 28,
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
                          fontWeight: FontWeight.w800,
                          fontSize: 14.5,
                          color: isDark
                              ? AppColors.darkPrimaryText
                              : AppColors.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${listing.location} • ${listing.price}/month',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: saved ? 'Remove from saved' : 'Save boarding',
                  onPressed: onSave,
                  icon: Icon(
                    saved
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: saved ? const Color(0xFFE11D48) : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF163E3B) : AppColors.softMint,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 46,
              color: isDark ? AppColors.darkPrimary : AppColors.teal,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              color: isDark
                  ? AppColors.darkSecondaryText
                  : AppColors.secondaryText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailingText,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF163E3B) : AppColors.softMint,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark ? AppColors.darkPrimary : AppColors.teal,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Text(
              trailingText!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.secondaryText,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color:
                isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
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
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: isDark ? AppColors.darkPrimary : AppColors.teal,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: isDark ? AppColors.darkPrimary : AppColors.teal,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _message(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Text(message),
        ),
      );

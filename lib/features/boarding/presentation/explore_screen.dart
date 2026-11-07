import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../home/data/boarding_listing.dart';
import 'boarding_screens.dart' show MapViewScreen;

class ExploreSearchScreen extends StatefulWidget {
  const ExploreSearchScreen({
    required this.saved,
    required this.onSaveChanged,
    required this.onListingTap,
    super.key,
  });
  final Set<String> saved;
  final ValueChanged<BoardingListing> onSaveChanged;
  final ValueChanged<BoardingListing> onListingTap;

  @override
  State<ExploreSearchScreen> createState() => _ExploreSearchScreenState();
}

class _ExploreSearchScreenState extends State<ExploreSearchScreen> {
  static const campuses = [
    'All Campuses',
    'SLIIT (Malabe)',
    'UoM (Moratuwa)',
    'NSBM (Homagama)',
    'USJ (Nugegoda)',
    'UOC (Colombo)',
    'Kelaniya Uni',
  ];
  static const locations = [
    'All areas',
    'Malabe',
    'Katubedda',
    'Pitipana',
    'Gangodawila',
    'Colombo 07',
    'Dalugama',
    'Kaduwela',
    'Thalahena',
    'Battaramulla',
    'Athurugiriya',
  ];
  static const roomTypes = [
    'Single Room',
    'Shared Room',
    'Annex',
    'Full House',
  ];
  static const facilities = [
    'Wi-Fi',
    'Attached Bathroom',
    'Kitchen',
    'AC',
    'Parking',
    'Furnished',
  ];
  final query = TextEditingController();
  String campus = 'All Campuses';
  String location = 'All areas';
  String sort = 'Newest First';
  bool map = false;
  double minRent = 0;
  double maxRent = 50000;
  final rooms = <String>{};
  final genders = <String>{};
  final selectedFacilities = <String>{};
  final availability = <String>{};

  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  List<BoardingListing> get results {
    final text = query.text.trim().toLowerCase();
    final values = sampleBoardings.where((item) {
      final searchable =
          '${item.name} ${item.location} ${item.address} ${item.campus}'
              .toLowerCase();
      return (text.isEmpty || searchable.contains(text)) &&
          (campus == 'All Campuses' || item.campus == campus) &&
          (location == 'All areas' || item.location == location) &&
          item.priceValue >= minRent &&
          item.priceValue <= maxRent &&
          (rooms.isEmpty || rooms.contains(item.roomType)) &&
          (genders.isEmpty || genders.contains(item.genderPreference)) &&
          (selectedFacilities.isEmpty ||
              selectedFacilities.every(item.facilities.contains)) &&
          (availability.isEmpty || availability.contains(item.availability));
    }).toList();
    values.sort((a, b) {
      if (sort == 'Price: Low to High') {
        return a.priceValue.compareTo(b.priceValue);
      }
      if (sort == 'Price: High to Low') {
        return b.priceValue.compareTo(a.priceValue);
      }
      return b.createdAt.compareTo(a.createdAt);
    });
    return values;
  }

  int get filterCount =>
      (campus != 'All Campuses' ? 1 : 0) +
      (minRent > 0 ? 1 : 0) +
      (maxRent < 50000 ? 1 : 0) +
      rooms.length +
      genders.length +
      selectedFacilities.length +
      availability.length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = results;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore Boarding',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
            letterSpacing: -0.3,
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
              tooltip: map ? 'List view' : 'Map view',
              onPressed: () => setState(() => map = !map),
              icon: Icon(
                map ? Icons.format_list_bulleted_rounded : Icons.map_outlined,
                size: 20,
                color: isDark ? AppColors.darkPrimary : AppColors.teal,
              ),
            ),
          ),
        ],
      ),
      body: map
          ? MapViewScreen(listings: items, onListingTap: widget.onListingTap)
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
              children: [
                Text(
                  'Find your perfect place to stay',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),

                // Search Input with clear button
                Container(
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.darkElevatedSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: query,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkPrimaryText
                          : AppColors.primaryText,
                    ),
                    decoration: InputDecoration(
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      hintText: 'Search location or boarding...',
                      hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.darkSecondaryText
                            : AppColors.secondaryText,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: isDark ? AppColors.darkPrimary : AppColors.teal,
                      ),
                      suffixIcon: query.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              onPressed: () {
                                query.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.clear_rounded, size: 18),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Campus / University Filter Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Campus / University',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: isDark
                            ? AppColors.darkPrimaryText
                            : AppColors.deepNavy,
                      ),
                    ),
                    if (campus != 'All Campuses')
                      GestureDetector(
                        onTap: () => setState(() => campus = 'All Campuses'),
                        child: Text(
                          'All campuses',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark ? AppColors.darkPrimary : AppColors.teal,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: campuses.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final item = campuses[index];
                      final isSelected = campus == item;
                      return ChoiceChip(
                        label: Text(item),
                        selected: isSelected,
                        onSelected: (_) => setState(() => campus = item),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),

                // Location Filter Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular locations',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: isDark
                            ? AppColors.darkPrimaryText
                            : AppColors.deepNavy,
                      ),
                    ),
                    if (location != 'All areas')
                      GestureDetector(
                        onTap: () => setState(() => location = 'All areas'),
                        child: Text(
                          'Show all',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark ? AppColors.darkPrimary : AppColors.teal,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: locations.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final item = locations[index];
                      final isSelected = location == item;
                      return ChoiceChip(
                        label: Text(item),
                        selected: isSelected,
                        onSelected: (_) => setState(() => location = item),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),

                // Filter & Sort Action Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: showFilters,
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.tune_rounded, size: 17),
                            if (filterCount > 0)
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: AppColors.gold,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        label: Text(
                          filterCount == 0
                              ? 'Filters'
                              : 'Filters ($filterCount)',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: filterCount > 0
                              ? (isDark
                                  ? const Color(0xFF1B4944)
                                  : AppColors.softMint)
                              : Colors.transparent,
                          side: BorderSide(
                            color: filterCount > 0
                                ? (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.teal)
                                : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.border),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: showSortOptions,
                        icon: const Icon(Icons.sort_rounded, size: 17),
                        label: Text(
                          sort.replaceFirst('Price: ', ''),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Results count and header
                Row(
                  children: [
                    Text(
                      'Available Boarding Places',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${items.length}',
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

                // Listings or Empty State
                if (items.isEmpty)
                  _EmptyExplore(onClear: reset)
                else
                  ...items.map(
                    (item) => _ExploreTile(
                      listing: item,
                      saved: widget.saved.contains(item.name),
                      onTap: () => widget.onListingTap(item),
                      onSave: () => widget.onSaveChanged(item),
                    ),
                  ),
              ],
            ),
    );
  }

  void reset() {
    query.clear();
    setState(() {
      campus = 'All Campuses';
      location = 'All areas';
      sort = 'Newest First';
      minRent = 0;
      maxRent = 50000;
      rooms.clear();
      genders.clear();
      selectedFacilities.clear();
      availability.clear();
    });
  }

  Future<void> showFilters() async {
    var low = minRent;
    var high = maxRent;
    final roomSelection = {...rooms};
    final genderSelection = {...genders};
    final facilitySelection = {...selectedFacilities};
    final availabilitySelection = {...availability};

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, update) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Filter boardings',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.darkPrimaryText
                                    : AppColors.deepNavy,
                              ),
                            ),
                            TextButton(
                              onPressed: () => update(() {
                                low = 0;
                                high = 50000;
                                roomSelection.clear();
                                genderSelection.clear();
                                facilitySelection.clear();
                                availabilitySelection.clear();
                              }),
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Rent Slider Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkElevatedSurface
                                : AppColors.warmIvory,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.border,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Monthly Rent Range',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF163E3B)
                                          : AppColors.softMint,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Rs. ${low.round()} - Rs. ${high.round()}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? AppColors.darkPrimary
                                            : AppColors.teal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              RangeSlider(
                                values: RangeValues(low, high),
                                min: 0,
                                max: 50000,
                                divisions: 10,
                                labels: RangeLabels(
                                  'Rs. ${low.round()}',
                                  'Rs. ${high.round()}',
                                ),
                                onChanged: (value) => update(() {
                                  low = value.start;
                                  high = value.end;
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        _filterChipsSection(
                          'Boarding type',
                          roomTypes,
                          roomSelection,
                          update,
                          isDark,
                        ),
                        const SizedBox(height: 18),
                        _filterChipsSection(
                          'Gender preference',
                          ['Male', 'Female', 'Any'],
                          genderSelection,
                          update,
                          isDark,
                        ),
                        const SizedBox(height: 18),
                        _filterChipsSection(
                          'Facilities',
                          facilities,
                          facilitySelection,
                          update,
                          isDark,
                        ),
                        const SizedBox(height: 18),
                        _filterChipsSection(
                          'Availability',
                          ['Available Now', 'Available Soon'],
                          availabilitySelection,
                          update,
                          isDark,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // Bottom Action Buttons
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: FilledButton(
                            onPressed: () {
                              setState(() {
                                minRent = low;
                                maxRent = high;
                                rooms
                                  ..clear()
                                  ..addAll(roomSelection);
                                genders
                                  ..clear()
                                  ..addAll(genderSelection);
                                selectedFacilities
                                  ..clear()
                                  ..addAll(facilitySelection);
                                availability
                                  ..clear()
                                  ..addAll(availabilitySelection);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Apply Filters'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _filterChipsSection(
    String title,
    List<String> options,
    Set<String> selected,
    void Function(void Function()) update,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              showCheckmark: true,
              onSelected: (value) => update(() {
                if (value) {
                  selected.add(option);
                } else {
                  selected.remove(option);
                }
              }),
            );
          }).toList(),
        ),
      ],
    );
  }

  void showSortOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                'Sort Listings',
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
                    'Price: Low to High',
                    'Price: High to Low',
                    'Newest First',
                  ].asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = sort == option;

                    return Column(
                      children: [
                        if (index > 0)
                          Divider(
                            height: 1,
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.border,
                          ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          leading: Icon(
                            isSelected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: isSelected
                                ? (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.teal)
                                : (isDark
                                    ? AppColors.darkSecondaryText
                                    : AppColors.secondaryText),
                          ),
                          title: Text(
                            option,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? (isDark
                                      ? AppColors.darkPrimaryText
                                      : AppColors.navy)
                                  : (isDark
                                      ? AppColors.darkSecondaryText
                                      : AppColors.primaryText),
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_rounded,
                                  color: isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.teal,
                                )
                              : null,
                          onTap: () {
                            setState(() => sort = option);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreTile extends StatelessWidget {
  const _ExploreTile({
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
    final isAvailableNow = listing.availability == 'Available Now';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.035),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image preview with verified & availability badge
                Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 104,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(listing.imageColor),
                            Color(listing.imageColor).withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.apartment_rounded,
                          size: 42,
                          color: AppColors.teal.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    if (listing.isVerified)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3.5),
                          decoration: BoxDecoration(
                            color: AppColors.deepNavy,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.verified_rounded,
                            size: 11,
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        listing.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: -0.2,
                          color: isDark
                              ? AppColors.darkPrimaryText
                              : AppColors.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Location & Distance
                      Row(
                        children: [
                          Icon(
                            Icons.place_outlined,
                            size: 13,
                            color: isDark
                                ? AppColors.darkSecondaryText
                                : AppColors.secondaryText,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              '${listing.location} • ${listing.campus} (${listing.walkTime})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.darkSecondaryText
                                    : AppColors.secondaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Status & Gender tag
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isAvailableNow
                                  ? AppColors.success
                                  : AppColors.warning,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            listing.availability,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isAvailableNow
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                          Text(
                            ' • ${listing.genderPreference}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkSecondaryText
                                  : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            listing.price,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.teal,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            '/month',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkSecondaryText
                                  : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions Column
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: isDark
                          ? AppColors.darkElevatedSurface
                          : AppColors.warmIvory,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onSave,
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: AnimatedScale(
                            scale: saved ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutBack,
                            child: Icon(
                              saved
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 18,
                              color: saved
                                  ? const Color(0xFFE11D48)
                                  : (isDark
                                      ? AppColors.darkSecondaryText
                                      : AppColors.secondaryText),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.secondaryText,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyExplore extends StatelessWidget {
  const _EmptyExplore({required this.onClear});
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF163E3B) : AppColors.softMint,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: isDark ? AppColors.darkPrimary : AppColors.teal,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No boarding places found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Try adjusting your search criteria, price range, or selecting a different location.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.secondaryText,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Clear All Filters'),
          ),
        ],
      ),
    );
  }
}

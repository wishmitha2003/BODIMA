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
  static const locations = [
    'All areas',
    'Malabe',
    'Kaduwela',
    'Thalahena',
    'Battaramulla',
    'Athurugiriya',
  ];
  static const roomTypes = [
    'Single Room',
    'Shared Room',
    'Annex',
    'Full House'
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
          '${item.name} ${item.location} ${item.address}'.toLowerCase();
      return (text.isEmpty || searchable.contains(text)) &&
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
      (minRent > 0 ? 1 : 0) +
      (maxRent < 50000 ? 1 : 0) +
      rooms.length +
      genders.length +
      selectedFacilities.length +
      availability.length;

  @override
  Widget build(BuildContext context) {
    final items = results;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Boarding',
            style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            tooltip: map ? 'List view' : 'Map view',
            onPressed: () => setState(() => map = !map),
            icon: Icon(map ? Icons.list_rounded : Icons.map_outlined),
          ),
        ],
      ),
      body: map
          ? MapViewScreen(listings: items, onListingTap: widget.onListingTap)
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              children: [
                Text('Find your perfect place to stay',
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 18),
                TextField(
                  controller: query,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search location or boarding...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: query.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            onPressed: () {
                              query.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear_rounded),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Popular locations',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: locations
                        .map((item) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(item),
                                selected: location == item,
                                onSelected: (_) =>
                                    setState(() => location = item),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: showFilters,
                        icon: const Icon(Icons.tune_rounded, size: 18),
                        label: Text(filterCount == 0
                            ? 'Filters'
                            : 'Filters ($filterCount)'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: showSortOptions,
                        icon: const Icon(Icons.sort_rounded, size: 18),
                        label: Text(sort.replaceFirst('Price: ', '')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Available Boarding Places (${items.length})',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                if (items.isEmpty)
                  _EmptyExplore(onClear: reset)
                else
                  ...items.map((item) => _ExploreTile(
                        listing: item,
                        saved: widget.saved.contains(item.name),
                        onTap: () => widget.onListingTap(item),
                        onSave: () => widget.onSaveChanged(item),
                      )),
              ],
            ),
    );
  }

  void reset() {
    query.clear();
    setState(() {
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
        builder: (context, update) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filter boardings',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text('Monthly rent: Rs. ${low.round()} - Rs. ${high.round()}',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                RangeSlider(
                  values: RangeValues(low, high),
                  min: 0,
                  max: 50000,
                  divisions: 10,
                  labels: RangeLabels('${low.round()}', '${high.round()}'),
                  onChanged: (value) => update(() {
                    low = value.start;
                    high = value.end;
                  }),
                ),
                _chips('Boarding type', roomTypes, roomSelection, update),
                _chips('Gender preference', ['Male', 'Female', 'Any'],
                    genderSelection, update),
                _chips('Facilities', facilities, facilitySelection, update),
                _chips('Availability', ['Available Now', 'Available Soon'],
                    availabilitySelection, update),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => update(() {
                        low = 0;
                        high = 50000;
                        roomSelection.clear();
                        genderSelection.clear();
                        facilitySelection.clear();
                        availabilitySelection.clear();
                      }),
                      child: const Text('Reset Filters'),
                    ),
                    const Spacer(),
                    FilledButton(
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chips(String title, List<String> options, Set<String> selected,
      void Function(void Function()) update) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        Wrap(
          spacing: 8,
          children: options
              .map((option) => FilterChip(
                    label: Text(option),
                    selected: selected.contains(option),
                    onSelected: (value) => update(() {
                      value ? selected.add(option) : selected.remove(option);
                    }),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void showSortOptions() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ['Price: Low to High', 'Price: High to Low', 'Newest First']
            .map((option) => ListTile(
                  leading: Icon(
                    sort == option
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: sort == option ? AppColors.teal : null,
                  ),
                  title: Text(option),
                  onTap: () {
                    setState(() => sort = option);
                    Navigator.pop(context);
                  },
                ))
            .toList(),
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
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 82,
                  height: 92,
                  decoration: BoxDecoration(
                    color: Color(listing.imageColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.house_rounded,
                      size: 38, color: AppColors.teal),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listing.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text('${listing.location} • ${listing.roomType}'),
                      Text(
                          '${listing.genderPreference} • ${listing.availability}',
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 6),
                      Text('${listing.price}/month',
                          style: const TextStyle(
                              color: AppColors.teal,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      tooltip: saved ? 'Remove from saved' : 'Save boarding',
                      onPressed: onSave,
                      icon: Icon(saved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded),
                      color: saved ? Colors.redAccent : null,
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

class _EmptyExplore extends StatelessWidget {
  const _EmptyExplore({required this.onClear});
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 70),
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded,
                size: 58, color: AppColors.teal),
            const SizedBox(height: 16),
            const Text('No boarding places found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Try changing your search or filters.',
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton(
                onPressed: onClear, child: const Text('Clear Filters')),
          ],
        ),
      );
}

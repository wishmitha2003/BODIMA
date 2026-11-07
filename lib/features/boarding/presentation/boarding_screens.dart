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
    final results = sampleBoardings.where((item) {
      final text = '${item.name} ${item.location}'.toLowerCase();
      return text.contains(_query.text.toLowerCase()) &&
          (_location == 'All areas' || item.location == _location);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore',
            style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            tooltip: 'Map view',
            onPressed: () => setState(() => _map = !_map),
            icon: Icon(_map ? Icons.list_rounded : Icons.map_outlined),
          ),
        ],
      ),
      body: _map
          ? MapViewScreen(listings: results, onListingTap: widget.onListingTap)
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
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
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['All areas', 'Malabe', 'Kaduwela', 'Thalahena']
                        .map((item) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(item),
                                selected: _location == item,
                                onSelected: (_) =>
                                    setState(() => _location = item),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(children: [
                  Text('${results.length} places found',
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _showFilters(context),
                    icon: const Icon(Icons.tune_rounded, size: 18),
                    label: const Text('Filters'),
                  ),
                ]),
                if (results.isEmpty)
                  const _EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No boardings found',
                    message: 'Try a different area or search term.',
                  )
                else
                  ...results.map((listing) => _ListingTile(
                        listing: listing,
                        saved: widget.saved.contains(listing.name),
                        onTap: () => widget.onListingTap(listing),
                        onSave: () => widget.onSaveChanged(listing),
                      )),
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
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Filter boardings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 12),
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
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply filters'),
          ),
        ]),
      ),
    );
  }
}

class SavedScreen extends StatelessWidget {
  const SavedScreen({
    required this.saved,
    required this.onRemove,
    required this.onListingTap,
    super.key,
  });
  final Set<String> saved;
  final ValueChanged<String> onRemove;
  final ValueChanged<BoardingListing> onListingTap;

  @override
  Widget build(BuildContext context) {
    final listings = sampleBoardings.where((item) => saved.contains(item.name));
    return Scaffold(
      appBar: AppBar(
          title: const Text('Saved places',
              style: TextStyle(fontWeight: FontWeight.w800))),
      body: listings.isEmpty
          ? const Center(
              child: _EmptyState(
                icon: Icons.favorite_border_rounded,
                title: 'Nothing saved yet',
                message: 'Save a boarding place to find it quickly later.',
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: listings
                  .map((item) => _ListingTile(
                        listing: item,
                        saved: true,
                        onTap: () => onListingTap(item),
                        onSave: () => onRemove(item.name),
                      ))
                  .toList(),
            ),
    );
  }
}

class BoardingDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: onSaveChanged,
            icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border)),
        IconButton(
            onPressed: () => _message(context, 'Share link copied'),
            icon: const Icon(Icons.share_outlined)),
      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: FilledButton.icon(
          onPressed: () => _message(
              context, 'Inquiry started. The owner will contact you soon.'),
          icon: const Icon(Icons.chat_bubble_outline_rounded),
          label: const Text('Contact owner'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Color(listing.imageColor),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.house_rounded,
                size: 92, color: AppColors.teal.withValues(alpha: .6)),
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
                child: Text(listing.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800))),
            const Icon(Icons.verified_rounded, color: AppColors.teal),
          ]),
          const SizedBox(height: 8),
          Text('${listing.location}  •  ${listing.distance ?? 'Nearby'}'),
          const SizedBox(height: 16),
          Text('${listing.price}/month',
              style: const TextStyle(
                  color: AppColors.teal,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 24),
          const Text('About this place',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text(
              'A comfortable, student-friendly boarding place with a safe environment and convenient access to universities, shops and public transport.'),
          const SizedBox(height: 24),
          const Text('Facilities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Wi-Fi',
                'Parking',
                'Kitchen',
                'Study area',
                'Water supply'
              ]
                  .map((item) => Chip(
                      avatar: const Icon(Icons.check, size: 16),
                      label: Text(item)))
                  .toList()),
          const SizedBox(height: 24),
          const ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text('Nearby landmarks'),
              subtitle: Text(
                  'SLIIT Malabe Campus and public transport within easy reach.')),
        ],
      ),
    );
  }
}

class MapViewScreen extends StatelessWidget {
  const MapViewScreen(
      {required this.listings, required this.onListingTap, super.key});
  final List<BoardingListing> listings;
  final ValueChanged<BoardingListing> onListingTap;

  @override
  Widget build(BuildContext context) => Stack(children: [
        Container(
          color: const Color(0xFFE5EFEB),
          child: const Center(
              child: Icon(Icons.map_outlined, size: 90, color: AppColors.teal)),
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Card(
              child: ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Search this area'),
                  trailing: const Icon(Icons.tune))),
        ),
        if (listings.isNotEmpty)
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Card(
              child: ListTile(
                title: Text(listings.first.name,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text(
                    '${listings.first.location} • ${listings.first.price}/month'),
                trailing: IconButton(
                    onPressed: () => onListingTap(listings.first),
                    icon: const Icon(Icons.arrow_forward_rounded)),
              ),
            ),
          ),
      ]);
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({required this.onOwnerDashboard, super.key});
  final VoidCallback onOwnerDashboard;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('Profile',
                style: TextStyle(fontWeight: FontWeight.w800))),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          const CircleAvatar(
              radius: 42, child: Icon(Icons.person_rounded, size: 44)),
          const SizedBox(height: 12),
          const Center(
              child: Text('Student User',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
          const Center(child: Text('student@example.com')),
          const SizedBox(height: 24),
          _ProfileAction(
              icon: Icons.edit_outlined,
              label: 'Edit profile',
              onTap: () => _message(
                  context, 'Profile editing is ready for your details.')),
          _ProfileAction(
              icon: Icons.home_work_outlined,
              label: 'Owner dashboard',
              onTap: onOwnerDashboard),
          _ProfileAction(
              icon: Icons.notifications_none_rounded,
              label: 'Notification settings',
              onTap: () => _message(context, 'Notification settings opened.')),
          _ProfileAction(
              icon: Icons.dark_mode_outlined,
              label: 'Theme',
              onTap: () => _message(context,
                  'Use the system theme setting to switch appearance.')),
          _ProfileAction(
              icon: Icons.help_outline_rounded,
              label: 'Help and support',
              onTap: () => _message(
                  context, 'Support is available for your questions.')),
          _ProfileAction(
              icon: Icons.logout_rounded,
              label: 'Log in / Register',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()))),
        ]),
      );
}

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('Owner dashboard',
                style: TextStyle(fontWeight: FontWeight.w800))),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ListingFormScreen())),
            icon: const Icon(Icons.add),
            label: const Text('Add listing')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          const Text('Welcome back, Owner!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          Row(children: const [
            _Metric(label: 'Active listings', value: '2'),
            SizedBox(width: 12),
            _Metric(label: 'Inquiries', value: '8')
          ]),
          const SizedBox(height: 24),
          const Text('My listings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ...sampleBoardings.take(2).map((item) => Card(
              child: ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.location} • ${item.price}'),
                  trailing: const Icon(Icons.more_vert)))),
        ]),
      );
}

class ListingFormScreen extends StatelessWidget {
  const ListingFormScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Add boarding')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          for (final field in [
            'Boarding title',
            'Description',
            'Monthly rent',
            'Address',
            'Contact number'
          ]) ...[
            TextField(decoration: InputDecoration(labelText: field)),
            const SizedBox(height: 14),
          ],
          DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Gender preference'),
              items: const [
                DropdownMenuItem(value: 'Any', child: Text('Any')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Male', child: Text('Male'))
              ],
              onChanged: (_) {}),
          const SizedBox(height: 22),
          FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _message(context, 'Listing saved as a draft.');
              },
              child: const Text('Save listing')),
        ]),
      );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _register = false;
  bool _obscure = true;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar:
            AppBar(title: Text(_register ? 'Create account' : 'Welcome back')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          if (_register)
            const TextField(
                decoration: InputDecoration(labelText: 'Full name')),
          if (_register) const SizedBox(height: 14),
          const TextField(decoration: InputDecoration(labelText: 'Email')),
          const SizedBox(height: 14),
          TextField(
              obscureText: _obscure,
              decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(_obscure
                          ? Icons.visibility
                          : Icons.visibility_off)))),
          if (_register) ...[
            const SizedBox(height: 14),
            const TextField(
                decoration: InputDecoration(labelText: 'Phone number'))
          ],
          const SizedBox(height: 22),
          FilledButton(
              onPressed: () => _message(
                  context, _register ? 'Account created.' : 'Login submitted.'),
              child: Text(_register ? 'Register' : 'Login')),
          TextButton(
              onPressed: () => setState(() => _register = !_register),
              child: Text(_register
                  ? 'Already have an account? Login'
                  : 'Create a new account')),
        ]),
      );
}

class _ListingTile extends StatelessWidget {
  const _ListingTile(
      {required this.listing,
      required this.saved,
      required this.onTap,
      required this.onSave});
  final BoardingListing listing;
  final bool saved;
  final VoidCallback onTap;
  final VoidCallback onSave;
  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          onTap: onTap,
          leading: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                  color: Color(listing.imageColor),
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.house_rounded, color: AppColors.teal)),
          title: Text(listing.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text('${listing.location} • ${listing.price}/month'),
          trailing: IconButton(
              onPressed: onSave,
              icon: Icon(saved ? Icons.favorite : Icons.favorite_border,
                  color: saved ? Colors.redAccent : null)),
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState(
      {required this.icon, required this.title, required this.message});
  final IconData icon;
  final String title;
  final String message;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 90),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: AppColors.teal),
          const SizedBox(height: 16),
          Text(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
        ],
      ));
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap);
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Expanded(
      child: Card(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.teal)),
                    Text(label)
                  ]))));
}

void _message(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));

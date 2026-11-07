import 'package:flutter/material.dart';

import '../../home/data/boarding_listing.dart';
import '../../home/presentation/home_screen.dart';
import '../../boarding/presentation/boarding_screens.dart';
import '../../boarding/presentation/explore_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final Set<String> _saved = {};

  void _openDetails(BoardingListing listing) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BoardingDetailsScreen(
          listing: listing,
          isSaved: _saved.contains(listing.name),
          onSaveChanged: () => setState(() {
            if (!_saved.add(listing.name)) _saved.remove(listing.name);
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        onListingTap: _openDetails,
        onExploreTap: () => setState(() => _index = 1),
        onProfileTap: () => setState(() => _index = 3),
      ),
      ExploreSearchScreen(
        saved: _saved,
        onSaveChanged: (listing) => setState(() {
          if (!_saved.add(listing.name)) _saved.remove(listing.name);
        }),
        onListingTap: _openDetails,
      ),
      SavedScreen(
        saved: _saved,
        onRemove: (name) => setState(() => _saved.remove(name)),
        onListingTap: _openDetails,
      ),
      ProfileScreen(onOwnerDashboard: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const OwnerDashboardScreen()),
        );
      }),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../boarding/presentation/boarding_screens.dart' show AuthScreen;
import '../../boarding/presentation/explore_screen.dart';
import '../../home/data/boarding_listing.dart';
import '../../home/presentation/home_screen.dart';
import '../../owner/presentation/owner_app_shell.dart';
import '../../shared/data/mock_repository.dart';
import '../../student/presentation/boarding_details_screen.dart';
import '../../student/presentation/map_screen.dart';
import '../../student/presentation/saved_screen.dart';
import '../../student/presentation/student_profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  UserRole _role = UserRole.student;
  bool _isLoggedIn = true;
  String _userName = 'Student User';
  String _userEmail = 'student@example.com';

  void _openDetails(BoardingListing listing) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BoardingDetailsScreen(
          listing: listing,
          isSaved: MockRepository.instance.isSaved(listing.name),
          onSaveChanged: () => setState(() {}),
        ),
      ),
    );
  }

  void _openAuth({bool isRegister = false}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AuthScreen(
          initialRegister: isRegister,
          onLoginSuccess: (name, email) => setState(() {
            _isLoggedIn = true;
            if (name.isNotEmpty) _userName = name;
            if (email.isNotEmpty) _userEmail = email;
            MockRepository.instance.isLoggedIn = true;
            MockRepository.instance.userName = _userName;
            MockRepository.instance.userEmail = _userEmail;
            _index = 4;
          }),
        ),
      ),
    );
  }

  void _handleProfileTap() {
    if (_isLoggedIn) {
      setState(() => _index = 4);
    } else {
      _openAuth(isRegister: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // If active role is Owner, render Owner Experience Shell
    if (_role == UserRole.owner) {
      return OwnerAppShell(
        onSwitchToStudent: () => setState(() {
          _role = UserRole.student;
          _index = 0;
        }),
        onLogout: () {
          setState(() {
            _isLoggedIn = false;
            _role = UserRole.student;
            _index = 4;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged out successfully.')),
          );
        },
      );
    }

    // Student 5-Tab Application Shell
    final pages = [
      HomeScreen(
        onListingTap: _openDetails,
        onExploreTap: () => setState(() => _index = 1),
        onProfileTap: _handleProfileTap,
        isLoggedIn: _isLoggedIn,
      ),
      ExploreSearchScreen(
        saved: MockRepository.instance.savedListingsNotifier.value,
        onSaveChanged: (listing) => setState(() {
          MockRepository.instance.toggleSave(listing.name);
        }),
        onListingTap: _openDetails,
      ),
      MapScreen(
        onListingTap: _openDetails,
      ),
      SavedScreen(
        onRemove: (name) => setState(() {
          MockRepository.instance.toggleSave(name);
        }),
        onListingTap: _openDetails,
        onExploreTap: () => setState(() => _index = 1),
      ),
      StudentProfileScreen(
        isLoggedIn: _isLoggedIn,
        userName: _userName,
        userEmail: _userEmail,
        onLoginTap: () => _openAuth(isRegister: false),
        onRegisterTap: () => _openAuth(isRegister: true),
        onSavedTap: () => setState(() => _index = 3),
        onSwitchToOwner: () {
          setState(() => _role = UserRole.owner);
        },
        onLogout: () {
          setState(() => _isLoggedIn = false);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'Logged out successfully. Log in anytime to access your profile.',
                ),
              ),
            );
        },
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.border,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: ValueListenableBuilder<Set<String>>(
            valueListenable: MockRepository.instance.savedListingsNotifier,
            builder: (context, savedSet, _) {
              return NavigationBar(
                selectedIndex: _index,
                onDestinationSelected: (index) =>
                    setState(() => _index = index),
                destinations: [
                  const NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.explore_outlined),
                    selectedIcon: Icon(Icons.explore_rounded),
                    label: 'Explore',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.map_outlined),
                    selectedIcon: Icon(Icons.map_rounded),
                    label: 'Map',
                  ),
                  NavigationDestination(
                    icon: savedSet.isEmpty
                        ? const Icon(Icons.favorite_border_rounded)
                        : Badge(
                            label: Text(
                              '${savedSet.length}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            backgroundColor: AppColors.teal,
                            child: const Icon(Icons.favorite_border_rounded),
                          ),
                    selectedIcon: savedSet.isEmpty
                        ? const Icon(Icons.favorite_rounded)
                        : Badge(
                            label: Text(
                              '${savedSet.length}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            backgroundColor: AppColors.teal,
                            child: const Icon(Icons.favorite_rounded),
                          ),
                    label: 'Saved',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.person_outline_rounded),
                    selectedIcon: Icon(Icons.person_rounded),
                    label: 'Profile',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

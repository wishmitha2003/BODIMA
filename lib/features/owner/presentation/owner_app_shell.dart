import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'owner_dashboard_screen.dart';
import 'owner_enquiries_screen.dart';
import 'owner_listings_screen.dart';
import 'owner_profile_screen.dart';

class OwnerAppShell extends StatefulWidget {
  const OwnerAppShell({
    required this.onSwitchToStudent,
    required this.onLogout,
    super.key,
  });

  final VoidCallback onSwitchToStudent;
  final VoidCallback onLogout;

  @override
  State<OwnerAppShell> createState() => _OwnerAppShellState();
}

class _OwnerAppShellState extends State<OwnerAppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = [
      OwnerDashboardScreen(
        onNavigateListings: () => setState(() => _index = 1),
        onNavigateEnquiries: () => setState(() => _index = 2),
        onSwitchToStudent: widget.onSwitchToStudent,
      ),
      const OwnerListingsScreen(),
      const OwnerEnquiriesScreen(),
      OwnerProfileScreen(
        onSwitchToStudent: widget.onSwitchToStudent,
        onLogout: widget.onLogout,
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
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (index) => setState(() => _index = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.holiday_village_outlined),
                selectedIcon: Icon(Icons.holiday_village_rounded),
                label: 'Listings',
              ),
              NavigationDestination(
                icon: Icon(Icons.mark_email_unread_outlined),
                selectedIcon: Icon(Icons.mark_email_unread_rounded),
                label: 'Enquiries',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

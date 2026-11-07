import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../shared/data/mock_repository.dart';
import 'notifications_screen.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({
    this.isLoggedIn = true,
    this.userName = 'Student User',
    this.userEmail = 'student@example.com',
    this.onLoginTap,
    this.onRegisterTap,
    this.onLogout,
    this.onSwitchToOwner,
    this.onSavedTap,
    super.key,
  });

  final bool isLoggedIn;
  final String userName;
  final String userEmail;
  final VoidCallback? onLoginTap;
  final VoidCallback? onRegisterTap;
  final VoidCallback? onLogout;
  final VoidCallback? onSwitchToOwner;
  final VoidCallback? onSavedTap;

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  void _showThemePicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Appearance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color:
                      isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.light_mode_rounded),
                title: const Text('Light Theme'),
                trailing: AppTheme.themeMode.value == ThemeMode.light
                    ? const Icon(Icons.check_rounded, color: AppColors.teal)
                    : null,
                onTap: () {
                  AppTheme.themeMode.value = ThemeMode.light;
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode_rounded),
                title: const Text('Dark Theme'),
                trailing: AppTheme.themeMode.value == ThemeMode.dark
                    ? const Icon(Icons.check_rounded, color: AppColors.teal)
                    : null,
                onTap: () {
                  AppTheme.themeMode.value = ThemeMode.dark;
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_auto_rounded),
                title: const Text('System Default'),
                trailing: AppTheme.themeMode.value == ThemeMode.system
                    ? const Icon(Icons.check_rounded, color: AppColors.teal)
                    : null,
                onTap: () {
                  AppTheme.themeMode.value = ThemeMode.system;
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameCtrl =
        TextEditingController(text: MockRepository.instance.userName);
    final phoneCtrl =
        TextEditingController(text: MockRepository.instance.userPhone);
    final uniCtrl =
        TextEditingController(text: MockRepository.instance.userUniversity);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Student Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Contact Phone'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: uniCtrl,
                decoration:
                    const InputDecoration(labelText: 'Campus / University'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                MockRepository.instance.userName = nameCtrl.text.trim();
                MockRepository.instance.userPhone = phoneCtrl.text.trim();
                MockRepository.instance.userUniversity = uniCtrl.text.trim();
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showMyEnquiries() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const _MyEnquiriesView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Logged-out / Guest View
    if (!widget.isLoggedIn) {
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
                  onPressed: widget.onLoginTap,
                  icon: const Icon(Icons.login_rounded, size: 18),
                  label: const Text('Log In'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: widget.onRegisterTap,
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

    // Authenticated Profile View
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Student Card Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
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
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
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
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.userName,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? AppColors.darkPrimaryText
                                  : AppColors.deepNavy,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: AppColors.gold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.userEmail,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkElevatedSurface
                              : AppColors.softMint,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          MockRepository.instance.userUniversity,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark ? AppColors.darkPrimary : AppColors.teal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit Profile',
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: _showEditProfileDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Role Switcher Banner (Student to Owner)
          Material(
            color: isDark
                ? AppColors.darkElevatedSurface
                : AppColors.softMint.withValues(alpha: 0.7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: isDark
                    ? AppColors.darkBorder
                    : AppColors.teal.withValues(alpha: 0.3),
              ),
            ),
            child: InkWell(
              onTap: widget.onSwitchToOwner,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.real_estate_agent_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Switch to Host / Owner Mode',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.darkPrimaryText
                                  : AppColors.deepNavy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Manage your properties and view student enquiries',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark
                                  ? AppColors.darkSecondaryText
                                  : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.teal,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Settings Group
          _profileGroup(
            isDark: isDark,
            title: 'Activity & Shortcuts',
            children: [
              _settingsTile(
                icon: Icons.mark_email_read_outlined,
                title: 'My Enquiries',
                subtitle: 'Track responses from boarding owners',
                onTap: _showMyEnquiries,
              ),
              _settingsTile(
                icon: Icons.favorite_border_rounded,
                title: 'Saved Places',
                subtitle: 'View your bookmarked accommodations',
                onTap: widget.onSavedTap,
              ),
              _settingsTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                subtitle: 'Listing alerts & enquiry updates',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          _profileGroup(
            isDark: isDark,
            title: 'Preferences & System',
            children: [
              _settingsTile(
                icon: Icons.palette_outlined,
                title: 'Appearance',
                subtitle: 'Switch light or dark theme',
                onTap: _showThemePicker,
              ),
              _settingsTile(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                subtitle: 'FAQ and student assistance',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Support email: support@bodima.lk'),
                    ),
                  );
                },
              ),
              _settingsTile(
                icon: Icons.info_outline_rounded,
                title: 'About BODIMA',
                subtitle: 'Version 1.0.0 (Production Release)',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'BODIMA',
                    applicationVersion: '1.0.0+1',
                    applicationLegalese:
                        '© 2026 BODIMA Sri Lanka. All rights reserved.',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Logout Button
          OutlinedButton.icon(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Log out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _profileGroup({
    required bool isDark,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppColors.darkSecondaryText
                  : AppColors.secondaryText,
            ),
          ),
        ),
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
        ),
      ],
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.teal, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }
}

class _MyEnquiriesView extends StatelessWidget {
  const _MyEnquiriesView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('My Enquiries'),
      ),
      body: ValueListenableBuilder<List<StudentEnquiry>>(
        valueListenable: MockRepository.instance.enquiriesNotifier,
        builder: (context, enquiries, _) {
          if (enquiries.isEmpty) {
            return const Center(child: Text('No enquiries sent yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: enquiries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final enq = enquiries[index];

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            enq.listingName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: enq.status == 'Accepted'
                                ? AppColors.success.withValues(alpha: 0.15)
                                : AppColors.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            enq.status,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: enq.status == 'Accepted'
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Move-in: ${enq.moveInDate} • Duration: ${enq.durationMonths} months',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark
                            ? AppColors.darkSecondaryText
                            : AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '"${enq.message}"',
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

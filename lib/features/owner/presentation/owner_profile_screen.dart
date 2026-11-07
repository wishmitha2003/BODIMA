import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../shared/data/mock_repository.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({
    this.onSwitchToStudent,
    this.onLogout,
    super.key,
  });

  final VoidCallback? onSwitchToStudent;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Host Profile',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: AppColors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 34,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              MockRepository.instance.userName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
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
                          MockRepository.instance.userEmail,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark
                                ? AppColors.darkSecondaryText
                                : AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Verified Landlord • ⭐ 4.9 Rating',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.teal,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Switch to Student Mode Banner
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
                onTap: onSwitchToStudent,
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
                          Icons.school_rounded,
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
                              'Switch to Student Mode',
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
                              'Explore campus accommodations as a university student',
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

            // Settings Container
            Material(
              color: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet_outlined),
                    title: const Text('Bank & Payout Details'),
                    subtitle: const Text('Direct deposits for rent'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Payout gateway configured: Commercial Bank'),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.verified_user_outlined),
                    title: const Text('Host Verification & Badges'),
                    subtitle: const Text(
                        'Identity & deed verification status: Verified'),
                    trailing: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.palette_outlined),
                    title: const Text('Appearance'),
                    subtitle: const Text('Switch light or dark mode'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      AppTheme.themeMode.value =
                          AppTheme.themeMode.value == ThemeMode.dark
                              ? ThemeMode.light
                              : ThemeMode.dark;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout
            OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Log out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

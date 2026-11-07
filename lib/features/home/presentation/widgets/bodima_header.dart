import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class BodimaHeader extends StatelessWidget {
  const BodimaHeader({
    this.onProfileTap,
    this.isLoggedIn = true,
    super.key,
  });

  final VoidCallback? onProfileTap;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Brand Mark & Title
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navy, AppColors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.holiday_village_rounded,
                color: AppColors.gold,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'BODIMA',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: isDark ? AppColors.darkPrimary : AppColors.navy,
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Verified Campus Stays',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        // Notification Pill
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkElevatedSurface : AppColors.warmIvory,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          child: Stack(
            children: [
              IconButton(
                tooltip: 'Notifications',
                onPressed: () => _showMessage(context, 'No new notifications'),
                icon: const Icon(Icons.notifications_none_rounded, size: 20),
                visualDensity: VisualDensity.compact,
              ),
              Positioned(
                top: 10,
                right: 11,
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
        ),
        // Profile Action (Shows Profile if logged in, otherwise Log in / Register)
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkElevatedSurface : AppColors.warmIvory,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          child: IconButton(
            tooltip: isLoggedIn ? 'Profile' : 'Login / Create Account',
            onPressed: onProfileTap,
            icon: const Icon(Icons.account_circle_outlined, size: 24),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }

  void _showMessage(BuildContext context, String message) {
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
  }
}

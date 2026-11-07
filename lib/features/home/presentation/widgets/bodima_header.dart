import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class BodimaHeader extends StatelessWidget {
  const BodimaHeader({this.onProfileTap, super.key});

  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'BODIMA',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Notifications',
          onPressed: () => _showMessage(context, 'No new notifications'),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        IconButton(
          tooltip: 'Profile',
          onPressed: onProfileTap,
          icon: const Icon(Icons.account_circle_outlined, size: 29),
        ),
      ],
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

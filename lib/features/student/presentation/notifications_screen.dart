import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../shared/data/mock_repository.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
        ),
      ),
      body: ValueListenableBuilder<List<AppNotificationItem>>(
        valueListenable: MockRepository.instance.notificationsNotifier,
        builder: (context, notifications, _) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 48,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.secondaryText,
                  ),
                  const SizedBox(height: 12),
                  const Text('No notifications yet'),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final notif = notifications[index];

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: notif.isRead
                      ? (isDark ? AppColors.darkSurface : Colors.white)
                      : (isDark
                          ? AppColors.darkElevatedSurface
                          : AppColors.softMint.withValues(alpha: 0.45)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: notif.isRead
                        ? (isDark ? AppColors.darkBorder : AppColors.border)
                        : (isDark ? AppColors.darkPrimary : AppColors.teal),
                    width: notif.isRead ? 1 : 1.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            _getTypeColor(notif.type).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getTypeIcon(notif.type),
                        size: 20,
                        color: _getTypeColor(notif.type),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                notif.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? AppColors.darkPrimaryText
                                      : AppColors.deepNavy,
                                ),
                              ),
                              Text(
                                notif.timeAgo,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppColors.darkSecondaryText
                                      : AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notif.message,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isDark
                                  ? AppColors.darkSecondaryText
                                  : AppColors.secondaryText,
                              height: 1.4,
                            ),
                          ),
                        ],
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

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'enquiry':
        return Icons.mark_email_read_rounded;
      case 'listing':
        return Icons.home_work_rounded;
      default:
        return Icons.campaign_rounded;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'enquiry':
        return AppColors.teal;
      case 'listing':
        return AppColors.gold;
      default:
        return AppColors.info;
    }
  }
}

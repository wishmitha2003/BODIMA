import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../home/data/boarding_listing.dart';
import '../../shared/data/mock_repository.dart';
import 'add_boarding_screen.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({
    this.onNavigateListings,
    this.onNavigateEnquiries,
    this.onSwitchToStudent,
    super.key,
  });

  final VoidCallback? onNavigateListings;
  final VoidCallback? onNavigateEnquiries;
  final VoidCallback? onSwitchToStudent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Host Dashboard',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        actions: [
          IconButton(
            tooltip: 'Add Property',
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddBoardingScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner with CTA
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navy, AppColors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Verified Boarding Host',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            MockRepository.instance.userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.home_work_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddBoardingScreen(),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.deepNavy,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text(
                        'List New Boarding Place',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Performance Metrics 2x2 Grid
            ValueListenableBuilder<List<BoardingListing>>(
              valueListenable: MockRepository.instance.listingsNotifier,
              builder: (context, listings, _) {
                final total = listings.length;
                final active = listings.where((l) => l.isAvailable).length;
                final occupied = total - active;

                return ValueListenableBuilder<List<StudentEnquiry>>(
                  valueListenable: MockRepository.instance.enquiriesNotifier,
                  builder: (context, enquiries, _) {
                    final totalEnquiries = enquiries.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overview & Analytics',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? AppColors.darkPrimaryText
                                : AppColors.deepNavy,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _MetricCard(
                              title: 'Total Listings',
                              value: '$total',
                              icon: Icons.holiday_village_rounded,
                              color: AppColors.teal,
                            ),
                            const SizedBox(width: 12),
                            _MetricCard(
                              title: 'Active / Vacant',
                              value: '$active',
                              icon: Icons.check_circle_outline_rounded,
                              color: AppColors.success,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _MetricCard(
                              title: 'Student Enquiries',
                              value: '$totalEnquiries',
                              icon: Icons.mark_email_unread_rounded,
                              color: AppColors.gold,
                              onTap: onNavigateEnquiries,
                            ),
                            const SizedBox(width: 12),
                            _MetricCard(
                              title: 'Occupied Units',
                              value: '$occupied',
                              icon: Icons.person_rounded,
                              color: AppColors.info,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Recent Student Inquiries Feed
            Text(
              'Recent Student Enquiries',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<StudentEnquiry>>(
              valueListenable: MockRepository.instance.enquiriesNotifier,
              builder: (context, enquiries, _) {
                if (enquiries.isEmpty) {
                  return const Center(child: Text('No student enquiries yet.'));
                }

                return Column(
                  children: enquiries.take(3).map((enq) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              isDark ? AppColors.darkBorder : AppColors.border,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                enq.studentName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.5,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: enq.status == 'Accepted'
                                      ? AppColors.success
                                          .withValues(alpha: 0.15)
                                      : AppColors.warning
                                          .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  enq.status,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: enq.status == 'Accepted'
                                        ? AppColors.success
                                        : AppColors.warning,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '🎓 ${enq.studentUniversity} • Looking for ${enq.listingName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkSecondaryText
                                  : AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '"${enq.message}"',
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Calling ${enq.studentPhone}...'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.phone_rounded, size: 16),
                                label: const Text('Call Student'),
                              ),
                              const SizedBox(width: 8),
                              if (enq.status != 'Accepted')
                                FilledButton(
                                  onPressed: () {
                                    MockRepository.instance.updateEnquiryStatus(
                                      enq.id,
                                      'Accepted',
                                    );
                                  },
                                  style: FilledButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  child: const Text('Accept'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Material(
        color: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: isDark
                            ? AppColors.darkPrimaryText
                            : AppColors.deepNavy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

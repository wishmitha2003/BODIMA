import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../shared/data/mock_repository.dart';

class OwnerEnquiriesScreen extends StatelessWidget {
  const OwnerEnquiriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Student Inquiries',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      body: ValueListenableBuilder<List<StudentEnquiry>>(
        valueListenable: MockRepository.instance.enquiriesNotifier,
        builder: (context, enquiries, _) {
          if (enquiries.isEmpty) {
            return const Center(
              child: Text('No student inquiries received yet.'),
            );
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            enq.studentName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: enq.status == 'Accepted'
                                ? AppColors.success.withValues(alpha: 0.15)
                                : AppColors.warning.withValues(alpha: 0.15),
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
                      'University: ${enq.studentUniversity} • Property: ${enq.listingName}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkSecondaryText
                            : AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Expected Move-In: ${enq.moveInDate} (${enq.durationMonths} months stay)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkElevatedSurface
                            : AppColors.warmIvory,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '"${enq.message}"',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Dialing ${enq.studentPhone}...'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.phone_rounded, size: 16),
                          label: const Text('Call Student'),
                        ),
                        const SizedBox(width: 8),
                        if (enq.status == 'Pending') ...[
                          FilledButton(
                            onPressed: () {
                              MockRepository.instance.updateEnquiryStatus(
                                enq.id,
                                'Accepted',
                              );
                            },
                            child: const Text('Accept'),
                          ),
                        ],
                      ],
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

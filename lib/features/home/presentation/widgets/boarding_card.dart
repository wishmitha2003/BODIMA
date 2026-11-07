import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/boarding_listing.dart';

class BoardingCard extends StatelessWidget {
  const BoardingCard({
    required this.listing,
    required this.isFavorite,
    required this.onFavoriteChanged,
    this.onTap,
    super.key,
  });

  final BoardingListing listing;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAvailableNow = listing.availability == 'Available Now';

    return Container(
      width: 255,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image & Badges Section
              Stack(
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(listing.imageColor),
                          Color(listing.imageColor).withValues(alpha: 0.75),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Soft interior illustration
                        Center(
                          child: Icon(
                            Icons.home_work_outlined,
                            size: 60,
                            color: AppColors.teal.withValues(alpha: 0.4),
                          ),
                        ),
                        // Bottom gradient shadow for readable tags
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 48,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.35),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        // Room type pill on image
                        Positioned(
                          left: 10,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              listing.roomType,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Top Left Badges: Verified / Availability
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (listing.isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.deepNavy,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  color: AppColors.gold,
                                  size: 13,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Top Right Favorite Button with micro-interaction
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.92),
                      shape: const CircleBorder(),
                      elevation: 1,
                      shadowColor: Colors.black.withValues(alpha: 0.15),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onFavoriteChanged,
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: AnimatedScale(
                            scale: isFavorite ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutBack,
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 18,
                              color: isFavorite
                                  ? const Color(0xFFE11D48)
                                  : AppColors.navy,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Content Details Section
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      listing.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: isDark
                            ? AppColors.darkPrimaryText
                            : AppColors.primaryText,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Location & Proximity
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 14,
                          color: isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.secondaryText,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${listing.location} • ${listing.distance ?? 'Nearby'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkSecondaryText
                                  : AppColors.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Availability Indicator
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isAvailableNow
                                ? AppColors.success
                                : AppColors.warning,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          listing.availability,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isAvailableNow
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                        const Spacer(),
                        // Gender indicator tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkElevatedSurface
                                : AppColors.warmIvory,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            listing.genderPreference,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkSecondaryText
                                  : AppColors.secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Divider
                    Container(
                      height: 1,
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    const SizedBox(height: 10),

                    // Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          listing.price,
                          style: TextStyle(
                            color:
                                isDark ? AppColors.darkPrimary : AppColors.teal,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '/month',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkSecondaryText
                                : AppColors.secondaryText,
                          ),
                        ),
                      ],
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
}

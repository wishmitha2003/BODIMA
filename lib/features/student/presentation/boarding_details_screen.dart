import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../home/data/boarding_listing.dart';
import '../../shared/data/mock_repository.dart';
import 'enquiry_screen.dart';

class BoardingDetailsScreen extends StatefulWidget {
  const BoardingDetailsScreen({
    required this.listing,
    this.isSaved,
    this.onSaveChanged,
    super.key,
  });

  final BoardingListing listing;
  final bool? isSaved;
  final VoidCallback? onSaveChanged;

  @override
  State<BoardingDetailsScreen> createState() => _BoardingDetailsScreenState();
}

class _BoardingDetailsScreenState extends State<BoardingDetailsScreen> {
  int _activeImageIndex = 0;
  late bool _savedState;

  @override
  void initState() {
    super.initState();
    _savedState =
        widget.isSaved ?? MockRepository.instance.isSaved(widget.listing.name);
  }

  void _handleSaveToggle() {
    setState(() => _savedState = !_savedState);
    MockRepository.instance.toggleSave(widget.listing.name);
    if (widget.onSaveChanged != null) {
      widget.onSaveChanged!();
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.flag_outlined, color: AppColors.error),
            SizedBox(width: 8),
            Text('Report Listing'),
          ],
        ),
        content: const Text(
          'If this listing violates community standards, provides inaccurate rent/photos, or is no longer available, our verification team will review it immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you. Listing reported for review.'),
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Submit Report'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final listing = widget.listing;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          listing.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
        actions: [
          IconButton(
            tooltip: 'Report Listing',
            icon: const Icon(Icons.flag_outlined),
            onPressed: _showReportDialog,
          ),
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Link copied for ${listing.name}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gallery Hero Area
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Color(listing.imageColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: Icon(
                      _activeImageIndex == 0
                          ? Icons.bed_rounded
                          : (_activeImageIndex == 1
                              ? Icons.shower_rounded
                              : Icons.kitchen_rounded),
                      size: 90,
                      color: AppColors.teal.withValues(alpha: 0.7),
                    ),
                  ),

                  // Verified Property Badge
                  if (listing.isVerified)
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.navy.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.7),
                            width: 1.2,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: AppColors.gold,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'BODIMA Verified',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Image Index Badge
                  Positioned(
                    bottom: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '${_activeImageIndex + 1}/3 Photos',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Mini Thumbnail Selectors
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: List.generate(3, (index) {
                  final isSelected = _activeImageIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeImageIndex = index),
                      child: Container(
                        height: 52,
                        margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                        decoration: BoxDecoration(
                          color: Color(listing.imageColor)
                              .withValues(alpha: isSelected ? 1.0 : 0.4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.teal)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          index == 0
                              ? Icons.bed_rounded
                              : (index == 1
                                  ? Icons.shower_rounded
                                  : Icons.kitchen_rounded),
                          size: 22,
                          color: AppColors.teal.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Title, Campus & Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campus Proximity Pill
                  if (listing.campus.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkElevatedSurface
                            : AppColors.softMint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.school_rounded,
                            size: 15,
                            color:
                                isDark ? AppColors.darkPrimary : AppColors.teal,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '🎓 ${listing.campus}${listing.walkTime.isNotEmpty ? ' • ${listing.walkTime}' : ''}',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  Text(
                    listing.name,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                      color: isDark
                          ? AppColors.darkPrimaryText
                          : AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.secondaryTeal,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          listing.location,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkSecondaryText
                                : AppColors.secondaryText,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: AppColors.gold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${listing.rating}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.darkPrimaryText
                                  : AppColors.deepNavy,
                            ),
                          ),
                          Text(
                            ' (${listing.reviewCount} reviews)',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkSecondaryText
                                  : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4-Tile Quick Specs Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _SpecTile(
                    icon: Icons.meeting_room_rounded,
                    label: 'Room Type',
                    value: listing.roomType,
                  ),
                  const SizedBox(width: 10),
                  _SpecTile(
                    icon: Icons.person_rounded,
                    label: 'Gender',
                    value: listing.gender,
                  ),
                  const SizedBox(width: 10),
                  _SpecTile(
                    icon: Icons.verified_user_rounded,
                    label: 'Status',
                    value: listing.isAvailable ? 'Vacant' : 'Occupied',
                    isAccent: listing.isAvailable,
                  ),
                  const SizedBox(width: 10),
                  const _SpecTile(
                    icon: Icons.payments_rounded,
                    label: 'Key Money',
                    value: '1 Month',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Facilities & Amenities
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Facilities & Amenities',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkPrimaryText
                          : AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: listing.amenities.map((facility) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface
                              : AppColors.warmIvory,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.border,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getFacilityIcon(facility),
                              size: 15,
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.teal,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              facility,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkPrimaryText
                                    : AppColors.primaryText,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // House Rules Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'House Rules & Policies',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkPrimaryText
                          : AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    child: Column(
                      children: [
                        _RuleRow(
                          icon: Icons.access_time_rounded,
                          title: 'Gate Curfew',
                          desc: 'Main gate closes at 10:30 PM on weekdays.',
                        ),
                        const Divider(height: 20),
                        _RuleRow(
                          icon: Icons.people_outline_rounded,
                          title: 'Visitor Policy',
                          desc: 'Visitors permitted in lobby area only.',
                        ),
                        const Divider(height: 20),
                        _RuleRow(
                          icon: Icons.smoke_free_rounded,
                          title: 'Strictly No Smoking / Alcohol',
                          desc: 'Quiet student environment maintained.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About this Boarding',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkPrimaryText
                          : AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    listing.description,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.55,
                      color: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Landlord / Owner Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: AppColors.softMint,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_rounded,
                          size: 28,
                          color: AppColors.navy,
                        ),
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
                                listing.ownerName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? AppColors.darkPrimaryText
                                      : AppColors.deepNavy,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified_rounded,
                                size: 14,
                                color: AppColors.gold,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Verified Property Host • ⭐ ${listing.ownerRating} Rating',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.secondaryTeal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Call Host',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Calling ${listing.ownerPhone}...'),
                          ),
                        );
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.teal.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.phone_rounded,
                          color: AppColors.teal,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Sticky Bottom Action Bar
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Price
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly Rent',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Text(
                    listing.price,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppColors.darkPrimary : AppColors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Favorite Button
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkElevatedSurface
                      : AppColors.warmIvory,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: IconButton(
                  onPressed: _handleSaveToggle,
                  icon: Icon(
                    _savedState
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color:
                        _savedState ? AppColors.error : AppColors.secondaryText,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Contact / Enquiry Button
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EnquiryScreen(listing: listing),
                        ),
                      );
                    },
                    icon: const Icon(Icons.mail_outline_rounded, size: 18),
                    label: const Text(
                      'Send Enquiry',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getFacilityIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('wi-fi') || lower.contains('wifi')) {
      return Icons.wifi_rounded;
    }
    if (lower.contains('ac') || lower.contains('air')) {
      return Icons.ac_unit_rounded;
    }
    if (lower.contains('bath')) {
      return Icons.bathtub_outlined;
    }
    if (lower.contains('parking')) {
      return Icons.directions_car_rounded;
    }
    if (lower.contains('meal') || lower.contains('kitchen')) {
      return Icons.restaurant_rounded;
    }
    if (lower.contains('study')) {
      return Icons.menu_book_rounded;
    }
    if (lower.contains('power') || lower.contains('generator')) {
      return Icons.bolt_rounded;
    }
    return Icons.check_circle_outline_rounded;
  }
}

class _SpecTile extends StatelessWidget {
  const _SpecTile({
    required this.icon,
    required this.label,
    required this.value,
    this.isAccent = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark ? AppColors.darkPrimary : AppColors.teal,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isAccent
                    ? AppColors.success
                    : (isDark ? AppColors.darkPrimaryText : AppColors.deepNavy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({
    required this.icon,
    required this.title,
    required this.desc,
  });

  final IconData icon;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 18, color: isDark ? AppColors.darkPrimary : AppColors.teal),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color:
                      isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

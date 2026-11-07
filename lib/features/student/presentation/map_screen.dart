import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../home/data/boarding_listing.dart';
import '../../shared/data/mock_repository.dart';
import 'boarding_details_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    this.onListingTap,
    super.key,
  });

  final ValueChanged<BoardingListing>? onListingTap;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BoardingListing? _selectedListing;
  String _selectedCampus = 'All Campuses';

  final List<String> _campuses = [
    'All Campuses',
    'SLIIT (Malabe)',
    'UoM (Moratuwa)',
    'NSBM (Homagama)',
    'USJ (Nugegoda)',
  ];

  @override
  void initState() {
    super.initState();
    final listings = MockRepository.instance.listingsNotifier.value;
    if (listings.isNotEmpty) {
      _selectedListing = listings.first;
    }
  }

  void _navigateToDetails(BoardingListing listing) {
    if (widget.onListingTap != null) {
      widget.onListingTap!(listing);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BoardingDetailsScreen(listing: listing),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final listings = MockRepository.instance.listingsNotifier.value;

    final filtered = _selectedCampus == 'All Campuses'
        ? listings
        : listings
            .where((l) => l.campus.toLowerCase().contains(
                  _selectedCampus
                      .split(' ')
                      .first
                      .toLowerCase()
                      .replaceAll('(', ''),
                ))
            .toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Campus Map View',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
        ),
        actions: [
          IconButton(
            tooltip: 'Center Location',
            icon: const Icon(Icons.my_location_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Centered to nearest university campus'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Custom Stylized Vector Map Surface
          Positioned.fill(
            child: CustomPaint(
              painter: _MapCanvasPainter(isDark: isDark),
            ),
          ),

          // Interactive Boarding Marker Pins
          ...List.generate(filtered.length, (index) {
            final item = filtered[index];
            final isSelected = _selectedListing?.name == item.name;

            // Generate deterministic map coordinates for demonstration
            final double left = 35.0 + ((index * 68) % 270);
            final double top = 90.0 + ((index * 84) % 360);

            return Positioned(
              left: left,
              top: top,
              child: GestureDetector(
                onTap: () => setState(() => _selectedListing = item),
                child: AnimatedScale(
                  scale: isSelected ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? AppColors.darkPrimary : AppColors.navy)
                          : (isDark ? AppColors.darkSurface : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.gold
                            : (isDark ? AppColors.darkBorder : AppColors.teal),
                        width: isSelected ? 2 : 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.35 : 0.12,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.home_rounded,
                          size: 13,
                          color: isSelected
                              ? AppColors.gold
                              : (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.teal),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.price,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                    ? AppColors.darkPrimaryText
                                    : AppColors.primaryText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          // Major University Campus Landmark Pins
          Positioned(
            left: 170,
            top: 270,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.teal,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 5),
                  Text(
                    'Campus Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Top Campus Filter Selector
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _campuses.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final campus = _campuses[index];
                  final isSelected = _selectedCampus == campus;
                  return ChoiceChip(
                    label: Text(campus),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCampus = campus);
                    },
                    selectedColor:
                        isDark ? AppColors.darkPrimary : AppColors.teal,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppColors.darkPrimaryText
                              : AppColors.primaryText),
                    ),
                  );
                },
              ),
            ),
          ),

          // Floating Bottom Preview Card
          if (_selectedListing != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _navigateToDetails(_selectedListing!),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.35 : 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(_selectedListing!.imageColor),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.home_work_rounded,
                            size: 38,
                            color: AppColors.teal.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  if (_selectedListing!.isVerified) ...[
                                    const Icon(
                                      Icons.verified_rounded,
                                      size: 14,
                                      color: AppColors.gold,
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                  Expanded(
                                    child: Text(
                                      _selectedListing!.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14.5,
                                        color: isDark
                                            ? AppColors.darkPrimaryText
                                            : AppColors.deepNavy,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${_selectedListing!.location} • ${_selectedListing!.campus}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.darkSecondaryText
                                      : AppColors.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    _selectedListing!.price,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.teal,
                                    ),
                                  ),
                                  const Text(
                                    ' / mo',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.darkElevatedSurface
                                          : AppColors.softMint,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'View',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: isDark
                                                ? AppColors.darkPrimary
                                                : AppColors.teal,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 12,
                                          color: isDark
                                              ? AppColors.darkPrimary
                                              : AppColors.teal,
                                        ),
                                      ],
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
              ),
            ),
        ],
      ),
    );
  }
}

class _MapCanvasPainter extends CustomPainter {
  const _MapCanvasPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF0F1E21) : const Color(0xFFEEF3F0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = isDark
          ? const Color(0xFF1B3135).withValues(alpha: 0.9)
          : const Color(0xFFFFFFFF)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final secondaryRoadPaint = Paint()
      ..color = isDark
          ? const Color(0xFF15272B).withValues(alpha: 0.7)
          : const Color(0xFFE2EBE6)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;

    // Main arteries
    final path1 = Path()
      ..moveTo(-20, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.38,
        size.width + 20,
        size.height * 0.28,
      );
    canvas.drawPath(path1, roadPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.52, -20)
      ..quadraticBezierTo(
        size.width * 0.48,
        size.height * 0.5,
        size.width * 0.6,
        size.height + 20,
      );
    canvas.drawPath(path2, roadPaint);

    // Cross roads
    for (double y = 80; y < size.height; y += 120) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + 30),
        secondaryRoadPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

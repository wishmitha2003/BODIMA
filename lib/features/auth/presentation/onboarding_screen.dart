import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    required this.onFinish,
    super.key,
  });

  final VoidCallback onFinish;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardSlide> _slides = const [
    _OnboardSlide(
      icon: Icons.school_rounded,
      badge: 'Campus Proximity',
      title: 'Find Boardings Near Any University',
      subtitle:
          'Discover top-rated boarding places, annexes, and hostels within walking distance of SLIIT, UoM, NSBM, USJ, UOC, Kelaniya, and more.',
      sinhalaNote: 'ඔබගේ කැම්පස් එක අසල පහසුම බෝඩිං පහසුවෙන්ම සොයාගන්න',
    ),
    _OnboardSlide(
      icon: Icons.verified_user_rounded,
      badge: '100% Verified',
      title: 'Verified Listings & Fair Student Rent',
      subtitle:
          'Explore clear monthly rents, authentic room photos, student amenities (Wi-Fi, AC, Attached Bath), and honest student reviews.',
      sinhalaNote: 'නියම පින්තූර සහ විනිවිදභාවයෙන් යුතු නිවැරදි මිල ගණන්',
    ),
    _OnboardSlide(
      icon: Icons.chat_bubble_rounded,
      badge: 'Zero Commission',
      title: 'Direct Landlord Connect & Quick Enquiries',
      subtitle:
          'Send direct enquiries, schedule room visits, and call genuine property owners directly without any broker or agent fees.',
      sinhalaNote: 'තැරැව්කරුවන් නැතිව සෘජුවම අයිතිකරු හා සම්බන්ධ වන්න',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: widget.onFinish,
            child: Text(
              'Skip',
              style: TextStyle(
                color: isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Large Stylized Visual Icon Box
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkElevatedSurface
                                : AppColors.softMint,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.teal.withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.teal.withValues(
                                  alpha: isDark ? 0.2 : 0.1,
                                ),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              slide.icon,
                              size: 56,
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.teal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Pill Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface
                                : AppColors.warmIvory,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            slide.badge,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Slide Title
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: isDark
                                ? AppColors.darkPrimaryText
                                : AppColors.deepNavy,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          slide.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppColors.darkSecondaryText
                                : AppColors.secondaryText,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Sinhala Note
                        Text(
                          slide.sinhalaNote,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppColors.darkSecondaryText
                                    .withValues(alpha: 0.8)
                                : AppColors.secondaryText
                                    .withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation & Indicator Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  // Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.teal)
                              : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.border),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () {
                        if (_currentIndex < _slides.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          widget.onFinish();
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            isDark ? AppColors.darkPrimary : AppColors.teal,
                        foregroundColor:
                            isDark ? AppColors.deepNavy : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _currentIndex == _slides.length - 1
                            ? 'Get Started  🚀'
                            : 'Continue',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardSlide {
  const _OnboardSlide({
    required this.icon,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.sinhalaNote,
  });

  final IconData icon;
  final String badge;
  final String title;
  final String subtitle;
  final String sinhalaNote;
}

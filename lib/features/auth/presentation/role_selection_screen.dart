import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../shared/data/mock_repository.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({
    required this.onRoleSelected,
    super.key,
  });

  final ValueChanged<UserRole> onRoleSelected;

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.student;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Choose Account Type',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How will you be using BODIMA?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                  color:
                      isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select your primary goal to personalize your experience.',
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 28),

              // Role Card 1: Student
              _RoleCard(
                role: UserRole.student,
                title: 'University Student',
                sinhalaTitle: 'විශ්වවිද්‍යාල සිසුවෙකු ලෙස',
                description:
                    'Find boarding places, check walk times to campus, shortlist favorites, and directly contact verified owners.',
                icon: Icons.school_rounded,
                isSelected: _selectedRole == UserRole.student,
                onTap: () => setState(() => _selectedRole = UserRole.student),
              ),
              const SizedBox(height: 16),

              // Role Card 2: Boarding Owner
              _RoleCard(
                role: UserRole.owner,
                title: 'Boarding Owner / Landlord',
                sinhalaTitle: 'බෝඩිං හිමිකරුවෙකු ලෙස',
                description:
                    'List your student rooms, manage active/vacant units, receive student enquiries, and reach thousands of verified scholars.',
                icon: Icons.home_work_rounded,
                isSelected: _selectedRole == UserRole.owner,
                onTap: () => setState(() => _selectedRole = UserRole.owner),
              ),

              const Spacer(),

              // Confirmation CTA
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    MockRepository.instance.currentRole = _selectedRole;
                    widget.onRoleSelected(_selectedRole);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        isDark ? AppColors.darkPrimary : AppColors.teal,
                    foregroundColor: isDark ? AppColors.deepNavy : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Continue with Selection',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.title,
    required this.sinhalaTitle,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final UserRole role;
  final String title;
  final String sinhalaTitle;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? (isDark ? AppColors.darkPrimary : AppColors.teal)
                  : (isDark ? AppColors.darkBorder : AppColors.border),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.teal.withValues(alpha: isDark ? 0.25 : 0.12)
                    : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: isSelected ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                          ? AppColors.darkPrimary.withValues(alpha: 0.2)
                          : AppColors.softMint)
                      : (isDark
                          ? AppColors.darkElevatedSurface
                          : AppColors.warmIvory),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 26,
                  color: isSelected
                      ? (isDark ? AppColors.darkPrimary : AppColors.teal)
                      : (isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.secondaryText),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.darkPrimaryText
                                  : AppColors.deepNavy,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.teal,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sinhalaTitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkPrimary : AppColors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
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
        ),
      ),
    );
  }
}

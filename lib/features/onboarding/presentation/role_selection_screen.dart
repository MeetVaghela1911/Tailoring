import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import '../../../core/utility/navigation_helper.dart';
import '../../../routes/app_router.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final AnimationController _fadeInController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeIn = CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeInOut,
    );

    _slideUp = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _fadeInController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeInController.forward();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = getThemeBaseColors(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Decorative purple corner
            Expanded(
              child: Stack(
                children: [
                  // Top-right purple circle decoration
                  Positioned(
                    right: -40,
                    top: -40,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.colorPrimary.withValues(alpha: 0.12),
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: SlideTransition(
                        position: _slideUp,
                        child: Column(
                          children: [
                            const SizedBox(height: 8),

                            // Hero illustration section
                            _buildHeroIllustration(colors, size),

                            const SizedBox(height: 32),

                            // Title
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Digital Tailoring\n',
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: colors.textDark,
                                      height: 1.2,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Management',
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: colors.colorPrimary,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Description
                            Text(
                              'Track orders, manage customers,\nand grow your business with zero\npaperwork.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: colors.gray,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Owner button
                            _buildRoleButton(
                              label: 'Get Started as Owner',
                              subtitle: 'Manage shop & orders',
                              icon: Icons.store_rounded,
                              isPrimary: true,
                              colors: colors,
                              onTap: () {
                                // TODO: Store role as 'owner' and navigate
                                NavigationHelper.navigateTo(
                                  context,
                                  AppRoutes.login,
                                );
                              },
                            ),

                            const SizedBox(height: 14),

                            // Worker button
                            _buildRoleButton(
                              label: 'Join as Worker',
                              subtitle: 'View tasks & schedule',
                              icon: Icons.people_rounded,
                              isPrimary: false,
                              colors: colors,
                              onTap: () {
                                // TODO: Store role as 'worker' and navigate
                                NavigationHelper.navigateTo(
                                  context,
                                  AppRoutes.login,
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            // Terms and login link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: colors.gray,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => NavigationHelper.navigateTo(
                                    context,
                                    AppRoutes.login,
                                  ),
                                  child: Text(
                                    'Log in',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: colors.colorPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Terms
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: colors.gray,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'By continuing, you agree to our ',
                                  ),
                                  TextSpan(
                                    text: 'Terms',
                                    style: TextStyle(
                                      color: colors.colorPrimary,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const TextSpan(text: ' & '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: colors.colorPrimary,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
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

  Widget _buildHeroIllustration(AppColorScheme colors, Size size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: size.height * 0.32,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: colors.grayLight,
            boxShadow: [
              BoxShadow(
                color: colors.colorPrimary.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.checkroom,
                      size: 80,
                      color: colors.colorPrimary.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tailoring',
                      style: GoogleFonts.poppins(
                        color: colors.colorPrimary.withValues(alpha: 0.3),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // "Easy Tracking" badge
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: colors.green, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Easy Tracking',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Floating scissors icon
        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            final offset = math.sin(_floatController.value * math.pi) * 6;
            return Positioned(
              left: 0,
              bottom: 40 + offset,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.background,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.content_cut,
                  color: colors.colorPrimary,
                  size: 20,
                ),
              ),
            );
          },
        ),

        // Floating grid/calendar icon
        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            final offset = math.cos(_floatController.value * math.pi) * 6;
            return Positioned(
              right: 0,
              top: 20 + offset,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.background,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: colors.colorPrimary,
                  size: 20,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRoleButton({
    required String label,
    required String subtitle,
    required IconData icon,
    required bool isPrimary,
    required AppColorScheme colors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isPrimary ? colors.colorPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPrimary
                  ? colors.colorPrimary
                  : colors.colorPrimary.withValues(alpha: 0.3),
              width: isPrimary ? 0 : 1.5,
            ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: colors.colorPrimary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isPrimary
                      ? Colors.white.withValues(alpha: 0.2)
                      : colors.colorPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isPrimary ? Colors.white : colors.colorPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isPrimary ? Colors.white : colors.textDark,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isPrimary
                            ? Colors.white.withValues(alpha: 0.7)
                            : colors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: isPrimary
                    ? Colors.white.withValues(alpha: 0.7)
                    : colors.colorPrimary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

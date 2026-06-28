import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utility/navigation_helper.dart';
import '../../../routes/app_router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final AnimationController _fadeInController;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeInOut,
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
    final l10n = AppLocalizations.of(context);
    // Light scheme base for naming but we use vibrant purple background
    final c = AppColors.light;

    return Scaffold(
      backgroundColor: c.background,
      body: Stack(
        children: [
          // Confetti background
          _ConfettiBackground(),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      children: [
                        const Spacer(),

                        // Mannequin Card (Hero Image)
                        FadeTransition(
                          opacity: _fadeIn,
                          child: ScaleTransition(
                            scale: CurvedAnimation(
                              parent: _fadeInController,
                              curve: Curves.easeOutBack,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.60,
                              height: MediaQuery.of(context).size.width * 0.60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: c.colorPrimary.withValues(alpha: 0.2),
                                    blurRadius: 40,
                                    offset: const Offset(0, 20),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: Image.asset(
                                  'assets/images/all_set_mannequin.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Title & Description
                        FadeTransition(
                          opacity: _fadeIn,
                          child: Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: c.textDark,
                                    height: 1.2,
                                  ),
                                  children: [
                                    TextSpan(text: l10n.welcomeTitlePart1),
                                    TextSpan(
                                      text: l10n.welcomeTitlePart2,
                                      style: TextStyle(
                                        color: c.textDark.withValues(alpha: 0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.welcomeSubtitle,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: c.textGray,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // CTA Button
                        FadeTransition(
                          opacity: _fadeIn,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: c.colorPrimary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 8,
                                    shadowColor: c.colorPrimary.withValues(alpha: 0.3),
                                  ),
                                  onPressed: () => NavigationHelper.navigateTo(
                                    context,
                                    AppRoutes.signup,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        l10n.getStarted,
                                        style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.arrow_forward, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Login link
                              GestureDetector(
                                onTap: () => NavigationHelper.navigateTo(
                                  context,
                                  AppRoutes.login,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: c.textDark.withValues(alpha: 0.6),
                                    ),
                                    children: [
                                      TextSpan(text: l10n.alreadyHaveAccount),
                                      TextSpan(
                                        text: l10n.login,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: c.colorPrimary,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfettiBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.light;
    final random = math.Random(42);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: List.generate(25, (index) {
            final left = random.nextDouble() * constraints.maxWidth;
            final top = random.nextDouble() * constraints.maxHeight;
            final size = random.nextDouble() * 10 + 4;
            final rotation = random.nextDouble() * math.pi;

            return Positioned(
              left: left,
              top: top,
              child: Transform.rotate(
                angle: rotation,
                child: Container(
                  width: size,
                  height: size * (random.nextBool() ? 1.5 : 1.0),
                  decoration: BoxDecoration(
                    color: (index % 2 == 0 ? c.colorPrimary : c.colorAccent)
                        .withValues(
                      alpha: random.nextDouble() * 0.1 + 0.05,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

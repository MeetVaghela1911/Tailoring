import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/common_methods.dart';
import '../../../routes/app_router.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';

class TutorialManualScreen extends StatefulWidget {
  const TutorialManualScreen({super.key});

  @override
  State<TutorialManualScreen> createState() => _TutorialManualScreenState();
}

class _TutorialManualScreenState extends State<TutorialManualScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = getThemeBaseColors(context);

    final steps = [
      _TutorialStep(
        title: l10n.step1ShopSetupTitle,
        description: l10n.step1ShopSetupDesc,
        icon: Icons.storefront,
        color: c.colorPrimary,
      ),
      _TutorialStep(
        title: l10n.step2TemplatesTitle,
        description: l10n.step2TemplatesDesc,
        icon: Icons.square_foot,
        color: Colors.orange,
      ),
      _TutorialStep(
        title: l10n.step3CustomersTitle,
        description: l10n.step3CustomersDesc,
        icon: Icons.people_outline,
        color: Colors.blue,
      ),
      _TutorialStep(
        title: l10n.step4CreateOrderTitle,
        description: l10n.step4CreateOrderDesc,
        icon: Icons.add_circle_outline,
        color: c.green,
      ),
      _TutorialStep(
        title: l10n.step5TrackOrdersTitle,
        description: l10n.step5TrackOrdersDesc,
        icon: Icons.track_changes,
        color: Colors.purple,
      ),
    ];

    return Scaffold(
      backgroundColor: c.background,
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: steps[_currentPage].color.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  l10n.quickStartGuide.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: c.gray,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'How it Works',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: c.textDark,
                  ),
                ),
                const SizedBox(height: 40),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      final step = steps[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: step.color.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                step.icon,
                                size: 80,
                                color: step.color,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              'Step ${index + 1}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: step.color,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              step.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: c.textDark,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              step.description,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: c.gray,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    steps.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? steps[index].color
                            : c.gray.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < steps.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.go(AppRoutes.home);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: steps[_currentPage].color,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _currentPage == steps.length - 1
                            ? 'Get Started'
                            : 'Next Step',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorialStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  _TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

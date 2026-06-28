import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import '../../../core/utils/snackbar_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/walkthrough_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_router.dart';

class HelpGuideScreen extends StatelessWidget {
  const HelpGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final topGradient = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.8)
        : c.colorAccent.withValues(alpha: 0.95);
    final midGradient = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.4)
        : c.colorAccent.withValues(alpha: 0.2);

    return Scaffold(
      backgroundColor: c.background,
      body: Stack(
        children: [
          // ── Gradient background ───────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.40,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    topGradient,
                    midGradient,
                    c.background.withValues(alpha: 0.0)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // ── Header ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark ? c.cardDark : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(Icons.arrow_back_ios_new,
                              color: c.textDark, size: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SUPPORT CENTER',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: c.textDark.withValues(alpha: 0.6),
                            ),
                          ),
                          Text(
                            'Help & Guides',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: c.textDark,
                              height: 1.15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Content ──
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    children: [
                      Text(
                        l10n.quickStartGuide,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: c.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildQuickStartStep(context, c, isDark, "1", l10n.step1ShopSetupTitle, l10n.step1ShopSetupDesc, Icons.storefront),
                      _buildQuickStartStep(context, c, isDark, "2", l10n.step2TemplatesTitle, l10n.step2TemplatesDesc, Icons.square_foot),
                      _buildQuickStartStep(context, c, isDark, "3", l10n.step3CustomersTitle, l10n.step3CustomersDesc, Icons.people_outline),
                      _buildQuickStartStep(context, c, isDark, "4", l10n.step4CreateOrderTitle, l10n.step4CreateOrderDesc, Icons.add_circle_outline),
                      _buildQuickStartStep(context, c, isDark, "5", l10n.step5TrackOrdersTitle, l10n.step5TrackOrdersDesc, Icons.track_changes),
                      const SizedBox(height: 24),
                      Text(
                        'Frequently Asked Questions',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: c.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFaqItem(
                        context,
                        c,
                        isDark,
                        'How do I create a new order?',
                        'Tap the "+" button on the Home screen or go to the Orders tab and tap "+". Follow the steps to select a customer, add garments, take measurements, and schedule the delivery.',
                      ),
                      _buildFaqItem(
                        context,
                        c,
                        isDark,
                        'What are Templates?',
                        'Templates help you save standard measurement fields for different garments (e.g., Shirt, Trouser). You can customize the fields to match exactly how you measure your customers.',
                      ),
                      _buildFaqItem(
                        context,
                        c,
                        isDark,
                        'How do I add a new customer?',
                        'Go to the Customers tab from the bottom navigation and tap the "+" button. You can save their name, phone number, and even a custom avatar color.',
                      ),
                      _buildFaqItem(
                        context,
                        c,
                        isDark,
                        'How can I contact a customer via WhatsApp?',
                        'On any order card or customer details screen, tap the WhatsApp icon next to their name. It will automatically open WhatsApp with their phone number if it is valid.',
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Interactive Tour',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: c.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [
                                    c.colorPrimary.withValues(alpha: 0.15),
                                    c.colorAccent.withValues(alpha: 0.05),
                                  ]
                                : [
                                    c.colorPrimary.withValues(alpha: 0.08),
                                    c.colorAccent.withValues(alpha: 0.02),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: c.colorPrimary.withValues(alpha: 0.15),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: c.colorPrimary.withValues(alpha: 0.03),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: c.colorPrimary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.explore_outlined,
                                      color: c.colorPrimary, size: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.walkthroughRestart,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: c.textDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Restart the step-by-step interactive guide to learn how to create your first customer, templates, and orders.',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: c.gray,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await context.read<WalkthroughCubit>().restartWalkthrough();
                                  if (context.mounted) {
                                    context.go(AppRoutes.home);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: c.colorPrimary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.refresh, size: 18),
                                label: Text(
                                  'Restart Now',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                      Text(
                        'Need more help?',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: c.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark ? c.cardDark : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        c.colorPrimary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.support_agent,
                                      color: c.colorPrimary, size: 24),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Contact Support',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: c.textDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Reach out to our support team at info.dev.meet@gmail.com for any queries or issues.',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: c.gray,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _sendEmail(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: c.colorPrimary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Send Email',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info.dev.meet@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Support Request: Stitch App',
      }),
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        if (context.mounted) {
          showAppSnackBar(context, message: 'Could not open email app', isError: true);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, message: 'Error opening email app', isError: true);
      }
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Widget _buildQuickStartStep(BuildContext context, AppColorScheme c, bool isDark, String number, String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: c.divider.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: c.colorPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: c.colorPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16, color: c.colorPrimary.withValues(alpha: 0.7)),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: c.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: c.gray,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, AppColorScheme c, bool isDark,
      String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            question,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: c.textDark,
            ),
          ),
          iconColor: c.colorPrimary,
          collapsedIconColor: c.gray,
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Text(
              answer,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: c.gray,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

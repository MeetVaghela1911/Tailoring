import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/snackbar_utils.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _appLock = false;
  bool _biometric = false;
  bool _autoBackup = true;

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    c.background.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
              children: [
                // ── Header ───────────────────────────────────────────────
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
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
                                offset: const Offset(0, 4))
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
                          'APP SETTINGS',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: c.textDark.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          'Privacy & Security',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: c.textDark,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Lock section ─────────────────────────────────────────
                _sectionHeader(c, 'App Lock'),
                _toggleTile(
                  c,
                  isDark,
                  icon: Icons.lock_outline,
                  title: 'App Lock',
                  subtitle: 'Require PIN to open the app',
                  value: _appLock,
                  onChanged: (v) => setState(() => _appLock = v),
                ),
                _toggleTile(
                  c,
                  isDark,
                  icon: Icons.fingerprint,
                  title: 'Biometric Login',
                  subtitle: 'Use fingerprint or face unlock',
                  value: _biometric,
                  onChanged: (v) => setState(() => _biometric = v),
                ),
                const SizedBox(height: 24),

                // ── Data section ─────────────────────────────────────────
                _sectionHeader(c, 'Data & Backup'),
                _toggleTile(
                  c,
                  isDark,
                  icon: Icons.backup_outlined,
                  title: 'Auto Backup',
                  subtitle: 'Automatically back up your data daily',
                  value: _autoBackup,
                  onChanged: (v) => setState(() => _autoBackup = v),
                ),
                _actionTile(
                  c,
                  isDark,
                  icon: Icons.download_outlined,
                  title: 'Export Data',
                  subtitle: 'Download all your orders & customers',
                  onTap: () {
                    showAppSnackBar(context, message: 'Data export coming soon!');
                  },
                ),
                const SizedBox(height: 24),

                // ── Password section ──────────────────────────────────────
                _sectionHeader(c, 'Password'),
                _actionTile(
                  c,
                  isDark,
                  icon: Icons.key_outlined,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () {
                    showAppSnackBar(context, message: 'Change password coming soon!');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(AppColorScheme c, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: c.gray,
        ),
      ),
    );
  }

  Widget _toggleTile(
    AppColorScheme c,
    bool isDark, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.gray.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: c.colorPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: c.colorPrimary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: c.textDark)),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: c.gray)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: c.colorPrimary,
          ),
        ],
      ),
    );
  }

  Widget _actionTile(
    AppColorScheme c,
    bool isDark, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? c.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.gray.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: c.colorPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: c.colorPrimary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: c.textDark)),
                  Text(subtitle,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: c.gray)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: c.gray, size: 18),
          ],
        ),
      ),
    );
  }
}

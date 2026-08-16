import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import '../../../routes/app_router.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          // ── Fully scrollable body ──────────────────────────────────────
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
              children: [
                // ── Header ───────────────────────────────────────────────
                Text(
                  l10n.myProfile.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: c.textDark.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  l10n.settings,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: c.textDark,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Profile card ──────────────────────────────────────────
                _buildProfileHeader(context, c, isDark),
                const SizedBox(height: 32),

                // ── Shop Management ──────────────────────────────────────
                _buildSectionHeader(c, l10n.shopManagement),
                _buildSettingsTile(
                  context,
                  c,
                  isDark,
                  Icons.storefront_outlined,
                  l10n.shopDetails,
                  onTap: () => context.push(AppRoutes.shopDetails),
                ),
                _buildSettingsTile(
                  context,
                  c,
                  isDark,
                  Icons.account_balance_wallet_outlined,
                  'Finance & Payments',
                  onTap: () => context.push(AppRoutes.financeManagement),
                ),
                // DO NOT REMOVE: Staff Members (hidden for now)
                // _buildSettingsTile(
                //   context, c, isDark,
                //   Icons.people_outline,
                //   'Staff Members',
                // ),
                // DO NOT REMOVE: Services (hidden for now)
                // _buildSettingsTile(
                //   context, c, isDark,
                //   Icons.business_center_outlined,
                //   'Services',
                // ),
                const SizedBox(height: 24),

                // DO NOT REMOVE: Subscription & Cloud (hidden for now)
                // _buildSectionHeader(c, l10n.dataStorage),
                // _buildSettingsTile(
                //   context,
                //   c,
                //   isDark,
                //   Icons.cloud_sync_outlined,
                //   l10n.subscriptionCloud,
                //   onTap: () => context.push(AppRoutes.subscription),
                // ),
                // const SizedBox(height: 24),

                // ── App Settings ──────────────────────────────────────────
                _buildSectionHeader(c, l10n.appSettings),
                // DO NOT REMOVE: Notifications (hidden for now)
                // _buildSettingsTile(
                //   context, c, isDark,
                //   Icons.notifications_none,
                //   'Notifications',
                // ),
                // DO NOT REMOVE: Privacy & Security (hidden for now)
                // _buildSettingsTile(
                //   context,
                //   c,
                //   isDark,
                //   Icons.lock_outline,
                //   l10n.privacySecurity,
                //   onTap: () => context.push(AppRoutes.privacySecurity),
                // ),
                _buildSettingsTile(
                  context,
                  c,
                  isDark,
                  Icons.help_outline,
                  'Help & Guides',
                  onTap: () => context.push(AppRoutes.helpGuide),
                ),
                _buildSettingsTile(
                  context,
                  c,
                  isDark,
                  Icons.language,
                  l10n.language,
                  onTap: () => context.push(AppRoutes.selectLanguage),
                ),
                const SizedBox(height: 24),

                // ── Log out ───────────────────────────────────────────────
                _buildSettingsTile(
                  context,
                  c,
                  isDark,
                  Icons.logout,
                  l10n.logOut,
                  color: c.red,
                  onTap: () => _showLogoutDialog(context, c, isDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppColorScheme c, bool isDark) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? c.cardDark : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.logOutTitle,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: c.textDark),
        ),
        content: Text(
          l10n.logOutConfirm,
          style: GoogleFonts.poppins(fontSize: 13, color: c.gray),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(l10n.cancel,
                style: GoogleFonts.poppins(
                    color: c.gray, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: c.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
              context.pop();
            },
            child: Text(l10n.logOut,
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, AppColorScheme c, bool isDark) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        String displayName = "User"; // Default or fallback
        String subtitle = l10n.tapToSetup;

        if (state is AuthAuthenticated) {
          final user = state.user;
          displayName = user.profile?.fullName ?? user.name ?? l10n.ownerNameLabel;
          final role = getLocalizedRole(user.profile?.role, l10n);
          final shopName = user.shop?.name ?? '';
          if (role.isNotEmpty && shopName.isNotEmpty) {
            subtitle = '$role · $shopName';
          } else if (role.isNotEmpty) {
            subtitle = role;
          } else if (shopName.isNotEmpty) {
            subtitle = shopName;
          } else {
            subtitle = l10n.tapToSetup;
          }
        }

        return GestureDetector(
          onTap: () => context.push(AppRoutes.profile),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? c.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                  color: c.colorPrimary.withValues(alpha: 0.15), width: 1.2),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: c.colorPrimary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: c.colorPrimary, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: c.textDark,
                        ),
                      ),
                      Text(
                        subtitle,
                        style:
                            GoogleFonts.poppins(fontSize: 13, color: c.gray),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: c.colorPrimary, size: 22),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(AppColorScheme c, String title) {
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

  Widget _buildSettingsTile(
    BuildContext context,
    AppColorScheme c,
    bool isDark,
    IconData icon,
    String title, {
    Color? color,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.gray.withValues(alpha: 0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(icon, color: color ?? c.textDark, size: 22),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color ?? c.textDark,
            ),
          ),
          trailing: Icon(Icons.chevron_right, color: color ?? c.gray, size: 18),
          onTap: onTap ?? () {},
        ),
      ),
    );
  }
}

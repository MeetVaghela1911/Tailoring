import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/data/models/profile_model.dart';
import '../../auth/domain/entities/auth_user.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_action_bar.dart';
import '../../../core/widgets/app_dropdown.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _isSaving = false;

  static const _roleKeys = [
    'Master Tailor',
    'Owner',
    'Shop Manager',
    'Tailor',
    'Assistant',
  ];
  String _selectedRole = 'Master Tailor';
  String _email = '';
  String _userId = '';
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _loadFromUser(authState.user);
    }
    // Always fetch fresh data from Supabase when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AuthBloc>().add(const RefreshUser());
    });
  }

  void _loadFromUser(AuthUser user) {
    _userId = user.id;
    _email = user.email;
    if (user.profile != null) {
      _nameController.text = user.profile!.fullName;
      _phoneController.text = user.profile!.phone ?? '';
      _selectedRole = user.profile!.role ?? 'Master Tailor';
    } else {
      _nameController.text = user.name ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() {
    final profile = ProfileModel(
      id: _userId,
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      role: _selectedRole,
      email: _email,
    );
    context.read<AuthBloc>().add(ProfileUpdated(profile));
  }

  void _onDelete(AppColorScheme c, bool isDark) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? c.cardDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteAccountTitle,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: c.textDark)),
        content: Text(
            l10n.deleteAccountConfirm,
            style: GoogleFonts.poppins(fontSize: 13, color: c.gray)),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(l10n.cancel, style: GoogleFonts.poppins(color: c.gray, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: c.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0),
            onPressed: () { context.pop(); context.pop(); },
            child: Text(l10n.delete, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final topGradient = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.8)
        : c.colorAccent.withValues(alpha: 0.95);
    final midGradient = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.4)
        : c.colorAccent.withValues(alpha: 0.2);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ProfileSaving) {
          setState(() => _isSaving = true);
        } else if (state is AuthAuthenticated) {
          if (_isSaving) {
            // Save was successful
            setState(() {
              _isSaving = false;
              _isEditing = false;
              _loadFromUser(state.user);
            });
            showAppSnackBar(context, message: l10n.profileSaved);
          } else if (!_isEditing) {
            setState(() => _loadFromUser(state.user));
          }
        } else if (state is AuthError) {
          setState(() => _isSaving = false);
          // Reload from the user carried in the error state
          if (state.user != null && !_isEditing) {
            setState(() => _loadFromUser(state.user!));
          }
          showAppSnackBar(context,
              message: 'Failed to save: ${state.message}', isError: true);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: c.background,
              body: Stack(
                children: [
                  Positioned(
                    top: 0, left: 0, right: 0,
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [topGradient, midGradient, c.background.withValues(alpha: 0.0)],
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
                        // ── Header ────────────────────────────────────────────
                        Row(
                          children: [
                            const AppBackButton(),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.myProfile.toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          fontSize: 11, fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2, color: c.textDark.withValues(alpha: 0.6))),
                                  Text(l10n.profile,
                                      style: GoogleFonts.poppins(
                                          fontSize: 26, fontWeight: FontWeight.bold,
                                          color: c.textDark, height: 1.15)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // ── Avatar ────────────────────────────────────────────
                        Center(
                          child: Container(
                            width: 100, height: 100,
                            decoration: BoxDecoration(
                              color: c.colorPrimary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                              border: Border.all(color: c.colorPrimary.withValues(alpha: 0.3), width: 2),
                            ),
                            child: Icon(Icons.person, color: c.colorPrimary, size: 48),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Info card ─────────────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? c.cardDark : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 16, offset: const Offset(0, 4))],
                            border: Border.all(color: c.divider.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Full Name
                              _buildTextField(c, isDark,
                                  label: l10n.fullName, controller: _nameController,
                                  icon: Icons.person_outline),
                              const SizedBox(height: 16),

                              // Role
                              _isEditing
                                  ? AppDropdown<String>(
                                      label: l10n.roleTitle,
                                      items: _roleKeys,
                                      itemLabelBuilder: (key) => _getLocalizedRole(key, l10n),
                                      initialItem: _selectedRole,
                                      onChanged: (v) {
                                        if (v != null) setState(() => _selectedRole = v);
                                      },
                                    )
                                  : _buildReadOnlyField(c, isDark,
                                      label: l10n.roleTitle,
                                      icon: Icons.badge_outlined,
                                      value: _getLocalizedRole(_selectedRole, l10n)),
                              const SizedBox(height: 16),

                              // Phone
                              _buildTextField(c, isDark,
                                  label: l10n.phoneNumber, controller: _phoneController,
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone),
                              const SizedBox(height: 16),

                              // Email — always locked
                              _buildLockedEmailField(c, isDark, l10n),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Action bar ────────────────────────────────────────
                        _isSaving
                            ? _buildSavingIndicator(c)
                            : AppActionBar(
                                isEditing: _isEditing,
                                editLabel: l10n.editProfile,
                                saveLabel: l10n.saveProfile,
                                onEditSaveTap: () {
                                  if (_isEditing) {
                                    _onSave();
                                  } else {
                                    setState(() => _isEditing = true);
                                  }
                                },
                                onDeleteTap: () => _onDelete(c, isDark),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Full-screen loading overlay while saving ──────────────────
            if (_isSaving)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.35),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                      decoration: BoxDecoration(
                        color: isDark ? c.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20, offset: const Offset(0, 8))
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: c.colorPrimary,
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 16),
                          Text(l10n.savingProfile,
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w600,
                                  color: c.textDark)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String _getLocalizedRole(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Master Tailor':
        return l10n.roleMasterTailor;
      case 'Owner':
        return l10n.roleOwner;
      case 'Shop Manager':
        return l10n.roleShopManager;
      case 'Tailor':
        return l10n.roleTailor;
      case 'Assistant':
        return l10n.roleAssistant;
      default:
        return key;
    }
  }

  Widget _buildSavingIndicator(AppColorScheme c) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: c.colorPrimary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 18, height: 18,
          child: CircularProgressIndicator(color: c.colorPrimary, strokeWidth: 2.5),
        ),
        const SizedBox(width: 12),
        Text(AppLocalizations.of(context).savingProfile,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w600, color: c.colorPrimary)),
      ],
    ),
  );

  Widget _buildLabel(AppColorScheme c, String text) => Text(
        text,
        style: GoogleFonts.poppins(
            fontSize: 11, color: c.gray,
            fontWeight: FontWeight.w600, letterSpacing: 0.5),
      );

  Widget _buildTextField(
    AppColorScheme c,
    bool isDark, {
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(c, label.toUpperCase()),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: _isEditing
                ? (isDark ? c.background.withValues(alpha: 0.3) : Colors.grey.shade50)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: _isEditing ? Border.all(color: c.divider) : null,
          ),
          child: TextField(
            controller: controller,
            enabled: _isEditing,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(
                fontSize: 15, color: c.textDark, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              prefixIcon: Icon(icon,
                  color: _isEditing ? c.colorPrimary : c.gray, size: 18),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            ),
          ),
        ),
        if (!_isEditing) Divider(color: c.divider.withValues(alpha: 0.5)),
      ],
    );
  }

  Widget _buildReadOnlyField(AppColorScheme c, bool isDark,
      {required String label, required IconData icon, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(c, label),
        const SizedBox(height: 6),
        Row(children: [
          Icon(icon, color: c.gray, size: 18),
          const SizedBox(width: 12),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w600, color: c.textDark)),
        ]),
        Divider(color: c.divider.withValues(alpha: 0.5)),
      ],
    );
  }

  Widget _buildLockedEmailField(AppColorScheme c, bool isDark, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(c, l10n.emailAddress.toUpperCase()),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: isDark
                ? c.background.withValues(alpha: 0.15)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.divider.withValues(alpha: 0.4)),
          ),
          child: Row(children: [
            Icon(Icons.email_outlined, color: c.gray, size: 18),
            const SizedBox(width: 12),
            Expanded(
                child: Text(_email,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: c.gray,
                        fontWeight: FontWeight.w500))),
            Icon(Icons.lock_outline, color: c.gray.withValues(alpha: 0.5), size: 16),
          ]),
        ),
        const SizedBox(height: 4),
        Text(l10n.emailLockTip,
            style: GoogleFonts.poppins(
                fontSize: 10, color: c.gray.withValues(alpha: 0.6))),
      ],
    );
  }
}

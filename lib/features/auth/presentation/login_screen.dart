import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import '../../../routes/app_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/services/plan_service.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/utility/dependency_injection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final c = getThemeBaseColors(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(systemNavigationBarColor: c.background),
    );
  }

  void _handleLogin() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(email: _emailCtrl.text.trim(), password: _passCtrl.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = getThemeBaseColors(context);

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is AuthError) {
            showAppSnackBar(ctx, message: state.message, isError: true);
          } else if (state is AuthAuthenticated) {
            // Sync plan from database on login
            final profilePlan = state.user.profile?.plan ?? 'free';
            getIt<PlanService>().syncPlanFromProfile(profilePlan);
            // Set user ID for page visit tracking
            getIt<AnalyticsService>().setUserId(state.user.id);
            if (state.user.shop != null) {
              ctx.go(AppRoutes.home);
            } else {
              ctx.go(AppRoutes.shopSetup);
            }
          }
        },
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (ctx, _) => CustomPaint(
                painter: _BgPainter(_controller.value, c),
                size: MediaQuery.of(ctx).size,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: c.cemiTransparent),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _logo(c),
                      const SizedBox(height: 24),
                      Text(
                        l10n.signInToAccount,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: c.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.welcomeBackSubtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 14, color: c.gray),
                      ),
                      const SizedBox(height: 32),
                      _card(c),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.dontHaveAccount,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: c.gray,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              context.pushReplacement(AppRoutes.signup);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                l10n.signup,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: c.colorPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logo(AppColorScheme c) => Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: c.colorPrimary.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        'assets/images/all_set_mannequin.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: c.colorPrimary.withValues(alpha: 0.1),
          child: Icon(
            Icons.cut_outlined,
            size: 40,
            color: c.colorPrimary,
          ),
        ),
      ),
    ),
  );

  Widget _card(AppColorScheme c) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: c.backGroundLayer1,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: c.divider.withValues(alpha: 0.3)),
      boxShadow: [
        BoxShadow(
          color: c.colorPrimary.withValues(alpha: 0.05),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        _field(
          _emailCtrl,
          l10n.email,
          Icons.email_outlined,
          c,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return l10n.emailRequired;
            }
            if (!RegExp(
              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
            ).hasMatch(v.trim())) {
              return l10n.invalidEmail;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _field(
          _passCtrl,
          l10n.password,
          Icons.lock_outline,
          c,
          obscure: _obscure,
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
              color: c.gray,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) {
              return l10n.passwordRequired;
            }
            if (v.length < 6) {
              return l10n.minPasswordLength;
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (ctx, state) {
            final loading = state is AuthLoading;
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.colorPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        l10n.login,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            );
          },
        ),
      ],
    ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String hint,
    IconData icon,
    AppColorScheme c, {
    bool obscure = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: ctrl,
    obscureText: obscure,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    validator: validator,
    style: GoogleFonts.poppins(fontSize: 15, color: c.textDark),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: c.gray),
      suffixIcon: suffixIcon,
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: c.gray, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c.colorPrimary, width: 1.5),
      ),
      filled: true,
      fillColor: c.grayLight,
      errorStyle: GoogleFonts.poppins(fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}

class _BgPainter extends CustomPainter {
  final double progress;
  final AppColorScheme c;
  _BgPainter(this.progress, this.c);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final shades = [
      c.colorPrimary.withValues(alpha: 0.15),
      c.colorSecond.withValues(alpha: 0.1),
      c.colorAccent.withValues(alpha: 0.12),
      c.colorPrimaryDark.withValues(alpha: 0.08),
    ];
    for (int i = 0; i < 4; i++) {
      final dx =
          (size.width / 2) +
          math.sin(progress * 2 * math.pi + i) * (100 + i * 20);
      final dy =
          (size.height / 2) +
          math.cos(progress * 2 * math.pi + i) * (150 + i * 25);
      paint.color = shades[i];
      canvas.drawCircle(Offset(dx, dy), 80 - i * 10.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BgPainter old) => old.progress != progress;
}

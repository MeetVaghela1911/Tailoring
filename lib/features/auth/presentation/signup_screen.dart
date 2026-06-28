import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignUpRequested(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        ),
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
              animation: _ctrl,
              builder: (ctx, _) => CustomPaint(
                painter: _Bg(_ctrl.value, c),
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
                      Text(
                        l10n.signUpTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: c.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.signUpSubtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 14, color: c.gray),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: c.backGroundLayer1,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: c.divider.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            _field(
                              _nameCtrl,
                              l10n.fullName,
                              Icons.person_outline,
                              c,
                              textInputAction: TextInputAction.next,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? l10n.nameRequired
                                  : null,
                            ),
                            const SizedBox(height: 16),
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
                                  _obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: c.gray,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return l10n.passwordRequired;
                                }
                                if (v.length < 6) {
                                  return l10n.min6Chars;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (ctx, state) {
                                final loading = state is AuthLoading;
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: loading ? null : _handleSignUp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: c.colorPrimary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
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
                                            l10n.signup,
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
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.alreadyHaveAccount,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: c.gray,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              context.pushReplacement(AppRoutes.login);
                            },
                            child: Text(
                              l10n.login,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: c.colorPrimary,
                                fontWeight: FontWeight.w600,
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
    ),
  );
}

class _Bg extends CustomPainter {
  final double p;
  final AppColorScheme c;
  _Bg(this.p, this.c);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      paint.color = [
        c.colorPrimary.withValues(alpha: 0.15),
        c.colorSecond.withValues(alpha: 0.1),
        c.colorAccent.withValues(alpha: 0.12),
        c.colorPrimaryDark.withValues(alpha: 0.08),
      ][i];
      canvas.drawCircle(
        Offset(
          (size.width / 2) + math.sin(p * 2 * math.pi + i) * (100 + i * 20),
          (size.height / 2) + math.cos(p * 2 * math.pi + i) * (150 + i * 25),
        ),
        80 - i * 10.0,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _Bg old) => old.p != p;
}

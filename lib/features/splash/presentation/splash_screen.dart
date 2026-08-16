import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import '../../../core/utility/dependency_injection.dart';
import '../../auth/domain/repositories/auth_repository.dart';
import '../../../core/services/app_update_service.dart';
import '../../../core/services/plan_service.dart';
import '../../../core/services/analytics_service.dart';
import '../../../routes/app_router.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _contentController;
  late final AnimationController _logoPulseController;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  bool _authCheckCompleted = false;
  StreamSubscription? _authSubscription;
  final int _minSplashMs = 2500;
  late final DateTime _startTime;

  bool _isUpdateForced = false;
  String? _cloudMinVersion;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _initializeAnimations();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkAppVersion();
    if (!_isUpdateForced) {
      _checkAuthenticationStatus();
    }
  }

  Future<void> _checkAppVersion() async {
    try {
      final supabaseClient = getIt<SupabaseClient>();
      final response = await supabaseClient
          .from('app_settings')
          .select('value')
          .eq('key', 'min_app_version')
          .maybeSingle();

      if (response != null && response['value'] != null) {
        final minVersionStr = response['value'].toString();

        final packageInfo = await PackageInfo.fromPlatform();
        final currentVersionStr = packageInfo.version;

        final currentVersion = Version.parse(currentVersionStr);
        final minVersion = Version.parse(minVersionStr);

        if (currentVersion < minVersion) {
          _isUpdateForced = true;
          getIt<AppUpdateService>().setUpdateRequired(minVersionStr);
        }

        if (mounted) {
          setState(() {
            _cloudMinVersion = minVersionStr;
          });
        }
      }
    } catch (e) {
      debugPrint("Version check failed: $e");
    }
  }

  void _initializeAnimations() {
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _logoPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _contentController,
            curve: const Interval(0.4, 0.9, curve: Curves.easeOutCubic),
          ),
        );

    _contentController.forward();
  }

  void _checkAuthenticationStatus() {
    try {
      final authBloc = context.read<AuthBloc>();
      final currentState = authBloc.state;

      if (currentState is AuthAuthenticated) {
        final profilePlan = currentState.user.profile?.plan ?? 'free';
        getIt<PlanService>().syncPlanFromProfile(profilePlan);
        _handleNavigation(AppRoutes.home);
        return;
      }

      if (currentState is AuthUnauthenticated || currentState is AuthError) {
        _handleNavigation(AppRoutes.welcome);
        return;
      }

      _setupAuthListener();
    } catch (e) {
      _handleNavigation(AppRoutes.welcome);
    }
  }

  void _setupAuthListener() {
    final authBloc = context.read<AuthBloc>();
    _authSubscription = authBloc.stream.listen((state) {
      if (_authCheckCompleted) return;

      if (state is AuthAuthenticated) {
        _authCheckCompleted = true;
        // Log app open for analytics
        getIt<AuthRepository>().trackAppOpen(state.user.id);
        // Sync plan from database (enables admin-controlled premium)
        final profilePlan = state.user.profile?.plan ?? 'free';
        getIt<PlanService>().syncPlanFromProfile(profilePlan);
        // Set user ID for page visit tracking
        getIt<AnalyticsService>().setUserId(state.user.id);
        _handleNavigation(AppRoutes.home);
      } else if (state is AuthUnauthenticated || state is AuthError) {
        _authCheckCompleted = true;
        _handleNavigation(AppRoutes.welcome);
      }
    });
  }

  void _handleNavigation(String route) {
    if (!mounted) return;
    final elapsed = DateTime.now().difference(_startTime).inMilliseconds;
    final delay = elapsed < _minSplashMs ? _minSplashMs - elapsed : 0;

    Timer(Duration(milliseconds: delay), () {
      if (mounted) context.go(route);
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _bgController.dispose();
    _contentController.dispose();
    _logoPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = getThemeBaseColors(context);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: colors.background,
      ),
    );

    Widget content = Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // Dynamic Animated Background
          _AnimatedBackground(controller: _bgController, colors: colors),

          Center(
            child: FadeTransition(
              opacity: _logoFade,
              child: ScaleTransition(
                scale: _logoScale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPremiumLogo(colors),
                    const SizedBox(height: 40),
                    _buildAnimatedText(colors),
                  ],
                ),
              ),
            ),
          ),

          // Footer
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _textFade,
              child: Column(
                children: [
                  Text(
                    'VERSION 2.0.0',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: const Color(0xFF2694B8).withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLoadingIndicator(colors),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (_isUpdateForced && _cloudMinVersion != null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Stack(
          children: [
            // Same Dynamic Animated Background as Splash
            _AnimatedBackground(controller: _bgController, colors: colors),

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Consistent Rounded Logo
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Transform.scale(
                            scale: 0.8 + (0.2 * value),
                            child: child,
                          ),
                        );
                      },
                      child: _buildPremiumLogo(colors),
                    ),
                    const SizedBox(height: 20),
                    // Same Animated Text as Splash
                    _buildAnimatedText(colors),

                    const SizedBox(height: 40),

                    // Update Content Card (Login Screen Style)
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOutBack,
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 40 * (1 - value)),
                          child: Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: colors.backGroundLayer1,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: colors.divider.withValues(alpha: 0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.colorPrimary.withValues(
                                alpha: 0.08,
                              ),
                              blurRadius: 30,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colors.colorPrimary.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.system_update_rounded,
                                size: 40,
                                color: colors.colorPrimary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Update Required',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: colors.textDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'A newer version of the app is available. Please update to continue using Stitch.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: colors.textGray,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.colorPrimary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Required: v$_cloudMinVersion',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: colors.colorPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _openStore,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.colorPrimary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  'Update Now',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return content;
  }

  Future<void> _openStore() async {
    // TODO: Replace with your actual Play Store / App Store URL
    const url =
        'https://play.google.com/store/apps/details?id=com.meet.tailoring';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildPremiumLogo(AppColorScheme colors) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: colors.colorPrimary.withValues(alpha: 0.1),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(
          'assets/images/all_set_mannequin.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: colors.colorPrimary.withValues(alpha: 0.1),
            child: Icon(
              Icons.cut_outlined,
              size: 60,
              color: colors.colorPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedText(AppColorScheme colors) {
    return SlideTransition(
      position: _textSlide,
      child: FadeTransition(
        opacity: _textFade,
        child: Column(
          children: [
            Text(
              'Tailoring',
              style: GoogleFonts.playfairDisplay(
                fontSize: 52,
                fontWeight: FontWeight.w900,
                color: colors.textDark,
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    color: colors.textDark.withValues(alpha: 0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colors.textDark.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Text(
                'CRAFTING PERFECTION',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2694B8).withValues(alpha: 0.8),
                  letterSpacing: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(AppColorScheme colors) {
    return SizedBox(
      width: 140,
      height: 2,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: colors.textDark.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return FractionallySizedBox(
                widthFactor: (_bgController.value * 2) % 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2694B8).withValues(alpha: 0.0),
                        const Color(0xFF2694B8).withValues(alpha: 0.4),
                        const Color(0xFF2694B8).withValues(alpha: 0.0),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AnimatedBackground extends StatelessWidget {
  final AnimationController controller;
  final AppColorScheme colors;

  const _AnimatedBackground({required this.controller, required this.colors});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Base Background
            Container(decoration: BoxDecoration(color: colors.background)),
            // Floating Blurred Blobs (Subtle Silver/Gray)
            ...List.generate(2, (index) {
              final angle =
                  (controller.value * 2 * math.pi) + (index * math.pi);
              final x = math.sin(angle) * 80;
              final y = math.cos(angle) * 120;

              return Positioned(
                left: (MediaQuery.of(context).size.width / 2) + x - 120,
                top: (MediaQuery.of(context).size.height / 2) + y - 120,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        [
                          const Color(0xFF2694B8),
                          const Color(0xFFA8D8E9),
                        ][index].withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

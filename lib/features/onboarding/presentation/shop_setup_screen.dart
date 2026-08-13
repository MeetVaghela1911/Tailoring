import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/data/models/profile_model.dart';
import '../../auth/data/models/shop_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import '../../../main.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../routes/app_router.dart';
import 'bloc/shop_setup_cubit.dart';
import 'bloc/shop_setup_state.dart';

class ShopSetupScreen extends StatefulWidget {
  const ShopSetupScreen({super.key});

  @override
  State<ShopSetupScreen> createState() => _ShopSetupScreenState();
}

class _ShopSetupScreenState extends State<ShopSetupScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  // Controllers
  final _shopNameCtrl = TextEditingController();
  final _ownerNameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _gstinCtrl = TextEditingController();

  late AnimationController _shimmerCtrl;

  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  final _step3FormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _pageController.dispose();
    _shopNameCtrl.dispose();
    _ownerNameCtrl.dispose();
    _addressCtrl.dispose();
    _gstinCtrl.dispose();
    super.dispose();
  }

  void _nextPage(BuildContext context, ShopSetupState state) {
    if (state.currentPage == 0) {
      if (!(_step1FormKey.currentState?.validate() ?? false)) {
        return;
      }
    }

    if (state.currentPage == 1) {
      if (!(_step2FormKey.currentState?.validate() ?? false)) {
        return;
      }
    }

    if (state.currentPage < 2) {
      _pageController.animateToPage(
        state.currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _saveDataAndNavigate(context, state);
    }
  }

  void _saveDataAndNavigate(BuildContext context, ShopSetupState state) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;

      // Save Profile
      final profile = ProfileModel(
        id: user.id,
        fullName: _ownerNameCtrl.text,
        email: user.email,
      );
      context.read<AuthBloc>().add(ProfileUpdated(profile));

      // Save Shop
      final shop = ShopModel(
        id: '',
        ownerId: user.id,
        name: _shopNameCtrl.text,
        ownerName: _ownerNameCtrl.text,
        address: _addressCtrl.text,
        capacity: state.capacity.toInt(),
        workingDays: state.workingDays,
        openTime: _formatTimeOfDay(state.openTime),
        closeTime: _formatTimeOfDay(state.closeTime),
        gstin: _gstinCtrl.text,
      );
      context.read<AuthBloc>().add(ShopUpdated(shop));
    }
    context.push(AppRoutes.allSet);
  }

  String _formatTimeOfDay(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  void _prevPage(BuildContext context, ShopSetupState state) {
    if (state.currentPage > 0) {
      _pageController.animateToPage(
        state.currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  Future<void> _getCurrentLocation(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          showAppSnackBar(
            context,
            message: 'Location permission is required.',
            isError: true,
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        showAppSnackBar(
          context,
          message:
              'Location permission is permanently denied. Please enable it from Settings.',
          isError: true,
        );
      }
      await Geolocator.openAppSettings();
      return;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (context.mounted) {
        showAppSnackBar(
          context,
          message: 'Please turn on Location services.',
          isError: true,
        );
      }
      await Geolocator.openLocationSettings();
      return;
    }

    if (context.mounted) {
      context.read<ShopSetupCubit>().setLoadingLocation(true);
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final address = [
          place.name,
          place.street,
          place.subLocality,
          place.locality,
          place.postalCode,
        ].where((value) => value != null && value.trim().isNotEmpty).join(', ');

        if (context.mounted) {
          _addressCtrl.text = address;
        }
      }
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(
          context,
          message: 'Could not fetch address.',
          isError: true,
        );
      }
    } finally {
      if (context.mounted) {
        context.read<ShopSetupCubit>().setLoadingLocation(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShopSetupCubit(),
      child: BlocBuilder<ShopSetupCubit, ShopSetupState>(
        builder: (context, state) {
          final l10n = AppLocalizations.of(context);
          final c = getThemeBaseColors(context);

          return Scaffold(
            backgroundColor: c.background,
            body: Column(
              children: [
                _buildHeader(context, c, l10n, state),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (idx) =>
                        context.read<ShopSetupCubit>().setPage(idx),
                    children: [
                      _buildStep1(context, c, l10n, state),
                      _buildStep2(context, c, l10n, state),
                      _buildStep3(context, c, l10n, state),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppColorScheme c,
    AppLocalizations l10n,
    ShopSetupState state,
  ) {
    String eyebrow = '';
    String title = '';
    String subtitle = '';
    if (state.currentPage == 0) {
      eyebrow = l10n.setupStep(1, 3).toUpperCase();
      title = l10n.shopDetailsTitle;
      subtitle = l10n.shopDetailsSubtitle;
    } else if (state.currentPage == 1) {
      eyebrow = l10n.setupStep(2, 3).toUpperCase();
      title = l10n.businessSettingsTitle;
      subtitle = l10n.businessSettingsSubtitle;
    } else {
      eyebrow = l10n.setupStep(3, 3).toUpperCase();
      title = l10n.finalSetupTitle;
      subtitle = l10n.finalSetupSubtitle;
    }

    final statusBarH = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: statusBarH + 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                c.colorAccent.withValues(alpha: 0.95),
                c.colorAccent.withValues(alpha: 0.2),
                c.background.withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(24, statusBarH + 16, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _prevPage(context, state),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: c.textDark,
                        size: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Step ${state.currentPage + 1} of 3',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: c.colorPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                eyebrow,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: c.textDark.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: c.textDark,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: c.textDark.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                      height: 5,
                      decoration: BoxDecoration(
                        color: index <= state.currentPage
                            ? c.colorPrimary
                            : c.colorPrimary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep1(
    BuildContext context,
    AppColorScheme c,
    AppLocalizations l10n,
    ShopSetupState state,
  ) {
    return Form(
      key: _step1FormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label(c, l10n.shopNameLabel),
            _textField(
              c,
              _shopNameCtrl,
              l10n.shopNameHint,
              Icons.store_outlined,
            ),
            const SizedBox(height: 24),
            _label(c, l10n.ownerNameLabel),
            _textField(
              c,
              _ownerNameCtrl,
              l10n.ownerNameHint,
              Icons.person_outline,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _label(c, l10n.shopAddressLabel),
                TextButton.icon(
                  onPressed: () => _getCurrentLocation(context),
                  icon: Icon(
                    Icons.my_location,
                    size: 16,
                    color: c.colorPrimary,
                  ),
                  label: Text(
                    l10n.useCurrentLocation,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: c.colorPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            state.isLoadingLocation
                ? _buildLocationSkeleton(c)
                : TextFormField(
                    controller: _addressCtrl,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Address is required';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLines: 3,
                    style: GoogleFonts.poppins(fontSize: 14, color: c.textDark),
                    decoration: InputDecoration(
                      hintText: l10n.shopAddressHint,
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: c.gray,
                      ),
                      filled: true,
                      fillColor: c.white,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: c.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: c.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: c.colorPrimary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 8),
            Text(
              l10n.addressTip,
              style: GoogleFonts.poppins(fontSize: 11, color: c.gray),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: c.colorPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: c.colorPrimary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.shopInfoTip,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: c.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildNextButton(context, c, l10n, state),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2(
    BuildContext context,
    AppColorScheme c,
    AppLocalizations l10n,
    ShopSetupState state,
  ) {
    return Form(
      key: _step2FormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label(c, l10n.dailyCapacityLabel),
            Text(
              l10n.dailyCapacitySub,
              style: GoogleFonts.poppins(fontSize: 13, color: c.gray),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: c.colorPrimary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: c.colorPrimary,
                        inactiveTrackColor: c.colorPrimary.withValues(
                          alpha: 0.1,
                        ),
                        thumbColor: c.colorPrimary,
                        overlayColor: c.colorPrimary.withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: state.capacity,
                        min: 1,
                        max: 50,
                        divisions: 49,
                        onChanged: (v) =>
                            context.read<ShopSetupCubit>().setCapacity(v),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: c.colorPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${state.capacity.toInt()} ${l10n.items}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _label(c, l10n.workingDaysLabel),
            Text(
              l10n.workingDaysSub,
              style: GoogleFonts.poppins(fontSize: 13, color: c.gray),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final localizedDays = [
                  l10n.dayMon,
                  l10n.dayTue,
                  l10n.dayWed,
                  l10n.dayThu,
                  l10n.dayFri,
                  l10n.daySat,
                  l10n.daySun,
                ];
                final day = localizedDays[index];
                final isSelected = state.workingDays.contains(index);
                return GestureDetector(
                  onTap: () =>
                      context.read<ShopSetupCubit>().toggleWorkingDay(index),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? c.colorPrimary : c.grayLight,
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: c.colorPrimary.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      day,
                      style: GoogleFonts.poppins(
                        color: isSelected ? c.white : c.gray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            _label(c, l10n.shopTimingsLabel),
            Text(
              l10n.shopTimingsSub,
              style: GoogleFonts.poppins(fontSize: 13, color: c.gray),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _timePicker(
                    context,
                    c,
                    l10n.opening,
                    state.openTime,
                    true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _timePicker(
                    context,
                    c,
                    l10n.closing,
                    state.closeTime,
                    false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            _buildNextButton(context, c, l10n, state),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3(
    BuildContext context,
    AppColorScheme c,
    AppLocalizations l10n,
    ShopSetupState state,
  ) {
    return Form(
      key: _step3FormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label(c, l10n.appLanguageLabel),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _langChip(context, c, state, 'English', 'en'),
                _langChip(context, c, state, 'हिंदी', 'hi'),
                _langChip(context, c, state, 'ગુજરાતી', 'gu'),
                _langChip(context, c, state, 'मराठी', 'mr'),
                _langChip(context, c, state, 'தமிழ்', 'ta'),
              ],
            ),
            const SizedBox(height: 32),
            _label(c, '${l10n.businessDetailsLabel} (${l10n.optional})'),
            _textField(
              c,
              _gstinCtrl,
              l10n.gstinHint,
              Icons.receipt_long_outlined,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                l10n.gstinTip,
                style: GoogleFonts.poppins(fontSize: 12, color: c.gray),
              ),
            ),
            const SizedBox(height: 40),
            _buildNextButton(context, c, l10n, state),
            const SizedBox(height: 24),
            Center(
              child: Text(
                l10n.termsConditionTip,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: c.gray,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(
    BuildContext context,
    AppColorScheme c,
    AppLocalizations l10n,
    ShopSetupState state,
  ) {
    return GestureDetector(
      onTap: () => _nextPage(context, state),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: c.colorPrimary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: c.colorPrimary.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.currentPage == 2 ? l10n.completeSetup : l10n.nextStep,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _timePicker(
    BuildContext context,
    AppColorScheme c,
    String label,
    TimeOfDay time,
    bool isOpening,
  ) {
    return GestureDetector(
      onTap: () async {
        final t = await showTimePicker(context: context, initialTime: time);
        if (t != null && context.mounted) {
          if (isOpening) {
            context.read<ShopSetupCubit>().setOpenTime(t);
          } else {
            context.read<ShopSetupCubit>().setCloseTime(t);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: c.divider),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: c.gray,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time.format(context),
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: c.textDark,
                  ),
                ),
                Icon(Icons.access_time, color: c.gray, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(AppColorScheme c, String text, {bool padding = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding ? 8 : 0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: c.textDark,
        ),
      ),
    );
  }

  Widget _textField(
    AppColorScheme c,
    TextEditingController ctrl,
    String hint,
    IconData? icon,
  ) {
    return TextFormField(
      controller: ctrl,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.poppins(fontSize: 14, color: c.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 14, color: c.gray),
        prefixIcon: icon != null ? Icon(icon, color: c.gray, size: 20) : null,
        filled: true,
        fillColor: c.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c.colorPrimary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildLocationSkeleton(AppColorScheme c) {
    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (context, child) {
        return Container(
          height: 90,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, _shimmerCtrl.value, 1.0],
              colors: [
                c.grayLight.withValues(alpha: 0.5),
                c.grayLight,
                c.grayLight.withValues(alpha: 0.5),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _langChip(
    BuildContext context,
    AppColorScheme c,
    ShopSetupState state,
    String name,
    String code,
  ) {
    final isSelected = state.language == name;
    return GestureDetector(
      onTap: () {
        context.read<ShopSetupCubit>().setLanguage(name);
        appLocaleProvider.setLocale(Locale(code));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? c.colorPrimary : c.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? c.colorPrimary : c.divider,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: c.colorPrimary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : c.textDark,
          ),
        ),
      ),
    );
  }
}

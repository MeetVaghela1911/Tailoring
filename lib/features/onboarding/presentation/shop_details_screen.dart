import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/data/models/shop_model.dart';
import '../../auth/domain/entities/auth_user.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_action_bar.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';

class ShopDetailsScreen extends StatefulWidget {
  const ShopDetailsScreen({super.key});

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  final _shopNameCtrl = TextEditingController();
  final _ownerNameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _gstinCtrl = TextEditingController();

  double _capacity = 12;
  List<int> _workingDays = [0, 1, 2, 3, 4, 5];
  String _userId = '';
  String? _shopId;
  final List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  TimeOfDay _openTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _closeTime = const TimeOfDay(hour: 20, minute: 0);
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      _userId = user.id;
      if (user.shop != null) {
        _loadShop(user.shop!);
      } else {
        _shopNameCtrl.text = 'My Shop'; // Default, will be localized in first build if needed
        _ownerNameCtrl.text = user.name ?? '';
      }
    }
    // Always fetch fresh data from Supabase when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AuthBloc>().add(const RefreshUser());
    });
  }

  void _loadShop(ShopModel shop) {
    _shopId = shop.id;
    _shopNameCtrl.text = shop.name;
    _ownerNameCtrl.text = shop.ownerName;
    _addressCtrl.text = shop.address;
    _gstinCtrl.text = shop.gstin ?? '';
    _capacity = shop.capacity.toDouble();
    _workingDays = List.from(shop.workingDays);
    _openTime = _parseTime(shop.openTime);
    _closeTime = _parseTime(shop.closeTime);
  }

  void _loadFromUser(AuthUser user) {
    _userId = user.id;
    if (user.shop != null) {
      _loadShop(user.shop!);
    }
  }

  TimeOfDay _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      if (parts[1] == 'PM' && hour < 12) hour += 12;
      if (parts[1] == 'AM' && hour == 12) hour = 0;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return const TimeOfDay(hour: 10, minute: 0);
    }
  }

  @override
  void dispose() {
    _shopNameCtrl.dispose();
    _ownerNameCtrl.dispose();
    _addressCtrl.dispose();
    _gstinCtrl.dispose();
    super.dispose();
  }

  void _onSave() {
    final shop = ShopModel(
      id: _shopId ?? '',
      ownerId: _userId,
      name: _shopNameCtrl.text.trim(),
      ownerName: _ownerNameCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      capacity: _capacity.toInt(),
      workingDays: _workingDays,
      openTime: _fmtTime(_openTime),
      closeTime: _fmtTime(_closeTime),
      gstin: _gstinCtrl.text.trim(),
    );
    context.read<AuthBloc>().add(ShopUpdated(shop));
  }

  void _onReset(AppColorScheme c, bool isDark) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? c.cardDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.resetShopDetailsTitle,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: c.textDark)),
        content: Text(l10n.resetShopDetailsConfirm,
            style: GoogleFonts.poppins(fontSize: 13, color: c.gray)),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(l10n.cancel, style: GoogleFonts.poppins(color: c.gray, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: c.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
            onPressed: () => context.pop(),
            child: Text(l10n.reset, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime(bool isOpen) async {
    final t = await showTimePicker(
        context: context, initialTime: isOpen ? _openTime : _closeTime);
    if (t != null) setState(() => isOpen ? _openTime = t : _closeTime = t);
  }

  String _fmtTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

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

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        final l10n = AppLocalizations.of(context);
        if (state is ShopSaving) {
          setState(() => _isSaving = true);
        } else if (state is AuthAuthenticated) {
          if (_isSaving) {
            // Save was successful
            setState(() {
              _isSaving = false;
              _isEditing = false;
              _loadFromUser(state.user);
            });
            showAppSnackBar(context, message: l10n.shopDetailsSaved);
          } else if (!_isEditing) {
            setState(() => _loadFromUser(state.user));
          }
        } else if (state is AuthError) {
          setState(() => _isSaving = false);
          if (state.user != null && !_isEditing) {
            setState(() => _loadFromUser(state.user!));
          }
          showAppSnackBar(context,
              message: '${l10n.error}: ${state.message}', isError: true);
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
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
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
                      children: [
                        // ── Header ─────────────────────────────────────────────
                        Row(
                          children: [
                            const AppBackButton(),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(l10n.shopManagement.toUpperCase(),
                                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2, color: c.textDark.withValues(alpha: 0.6))),
                                Text(l10n.shopDetails,
                                    style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold,
                                        color: c.textDark, height: 1.15)),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // ── Shop icon ──────────────────────────────────────────
                        Center(
                          child: Container(
                            width: 90, height: 90,
                            decoration: BoxDecoration(
                              color: c.colorPrimary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: c.colorPrimary.withValues(alpha: 0.3), width: 2),
                            ),
                            child: Icon(Icons.storefront_outlined, color: c.colorPrimary, size: 48),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ═══ SECTION 1 — Basic Info ════════════════════════════
                        _sectionHeader(c, Icons.store_outlined, l10n.basicInformation),
                        const SizedBox(height: 16),
                        _card(c, isDark, children: [
                          _buildField(c, isDark, label: l10n.shopNameLabel.toUpperCase(), ctrl: _shopNameCtrl,
                              icon: Icons.store_outlined, l10n: l10n),
                          const SizedBox(height: 16),
                          _buildField(c, isDark, label: l10n.ownerNameLabel.toUpperCase(), ctrl: _ownerNameCtrl,
                              icon: Icons.person_outline, l10n: l10n),
                          const SizedBox(height: 16),
                          // Address
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(l10n.shopAddressLabel.toUpperCase(), style: _labelStyle(c)),
                            if (_isEditing)
                              GestureDetector(
                                onTap: () {},
                                child: Row(children: [
                                  Icon(Icons.my_location, color: c.colorPrimary, size: 14),
                                  const SizedBox(width: 4),
                                  Text(l10n.useCurrentLocation, style: GoogleFonts.poppins(
                                      fontSize: 11, color: c.colorPrimary, fontWeight: FontWeight.w600)),
                                ]),
                              ),
                          ]),
                          const SizedBox(height: 6),
                          _isEditing
                              ? TextField(
                                  controller: _addressCtrl, maxLines: 3,
                                  style: GoogleFonts.poppins(fontSize: 14, color: c.textDark),
                                  decoration: InputDecoration(
                                    hintText: 'Shop No., Street, Landmark, City – Pincode',
                                    hintStyle: GoogleFonts.poppins(fontSize: 13, color: c.gray),
                                    filled: true,
                                    fillColor: isDark ? c.background.withValues(alpha: 0.3) : Colors.grey.shade50,
                                    contentPadding: const EdgeInsets.all(14),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: c.divider)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: c.divider)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: c.colorPrimary, width: 1.5)),
                                  ),
                                )
                              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(
                                    _addressCtrl.text.isEmpty ? '—  ${l10n.notAdded}' : _addressCtrl.text,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, fontWeight: FontWeight.w500,
                                        color: _addressCtrl.text.isEmpty ? c.gray : c.textDark,
                                        height: 1.5),
                                  ),
                                  Divider(color: c.divider.withValues(alpha: 0.5)),
                                ]),
                        ]),
                        const SizedBox(height: 24),

                        // ═══ SECTION 2 — Business Settings ═══════════════════
                        _sectionHeader(c, Icons.business_center_outlined, l10n.businessSettings),
                        const SizedBox(height: 16),
                        _card(c, isDark, children: [
                          // Capacity
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(l10n.dailyCapacity,
                                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold,
                                      color: c.textDark)),
                              Text(l10n.maxOrdersPerDay,
                                  style: GoogleFonts.poppins(fontSize: 11, color: c.gray)),
                            ]),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                  color: c.colorPrimary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Text(_capacity.toInt().toString(),
                                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold,
                                        color: c.colorPrimary)),
                                const SizedBox(width: 4),
                                Text(l10n.items,
                                    style: GoogleFonts.poppins(fontSize: 11, color: c.colorPrimary)),
                              ]),
                            ),
                          ]),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: _isEditing ? c.colorPrimary : c.gray,
                              inactiveTrackColor: c.divider,
                              thumbColor: _isEditing ? c.colorPrimary : c.gray,
                              overlayColor: c.colorPrimary.withValues(alpha: 0.2),
                              trackHeight: 4,
                            ),
                            child: Slider(
                              value: _capacity, min: 5, max: 50, divisions: 45,
                              onChanged: _isEditing ? (v) => setState(() => _capacity = v) : null,
                            ),
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('5', style: GoogleFonts.poppins(fontSize: 11, color: c.gray)),
                            Text('50', style: GoogleFonts.poppins(fontSize: 11, color: c.gray)),
                          ]),
                          const SizedBox(height: 24),

                          // Working days
                          Text(l10n.workingDaysLabel,
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold,
                                  color: c.textDark)),
                          Text(l10n.workingDaysSub,
                              style: GoogleFonts.poppins(fontSize: 11, color: c.gray)),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(7, (i) {
                              final isSel = _workingDays.contains(i);
                              return GestureDetector(
                                onTap: _isEditing
                                    ? () => setState(() {
                                          if (isSel && _workingDays.length > 1) {
                                            _workingDays.remove(i);
                                          } else if (!isSel) {
                                            _workingDays.add(i);
                                          }
                                        })
                                    : null,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 38, height: 38,
                                  decoration: BoxDecoration(
                                    color: isSel ? c.colorPrimary
                                        : (isDark ? c.background.withValues(alpha: 0.3) : Colors.grey.shade100),
                                    shape: BoxShape.circle,
                                    boxShadow: isSel
                                        ? [BoxShadow(color: c.colorPrimary.withValues(alpha: 0.4),
                                            blurRadius: 8, offset: const Offset(0, 4))]
                                        : [],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(_dayLabels[i],
                                      style: GoogleFonts.poppins(
                                          color: isSel ? Colors.white : c.gray,
                                          fontWeight: FontWeight.w600, fontSize: 13)),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 24),

                          // Timings
                          Text(l10n.shopTimings,
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold,
                                  color: c.textDark)),
                          Text(l10n.shopTimingsSub,
                              style: GoogleFonts.poppins(fontSize: 11, color: c.gray)),
                          const SizedBox(height: 14),
                          Row(children: [
                            Expanded(child: _timeTile(c, isDark, l10n.opening, _openTime, () => _pickTime(true))),
                            const SizedBox(width: 12),
                            Expanded(child: _timeTile(c, isDark, l10n.closing, _closeTime, () => _pickTime(false))),
                          ]),
                        ]),
                        const SizedBox(height: 24),

                        // ═══ SECTION 3 — GSTIN ═══════════════════════════════
                        _sectionHeader(c, Icons.receipt_long_outlined, l10n.businessDetails),
                        const SizedBox(height: 16),
                        _card(c, isDark, children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(l10n.gstinNumber, style: _labelStyle(c)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                  color: isDark ? c.background.withValues(alpha: 0.3) : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(l10n.optional, style: GoogleFonts.poppins(
                                  fontSize: 10, color: c.gray, fontWeight: FontWeight.w600)),
                            ),
                          ]),
                          const SizedBox(height: 8),
                          _isEditing
                              ? TextField(
                                  controller: _gstinCtrl,
                                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600,
                                      color: c.textDark),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. 27AAPFU0939F1ZV',
                                    hintStyle: GoogleFonts.poppins(fontSize: 13, color: c.gray),
                                    filled: true,
                                    fillColor: isDark ? c.background.withValues(alpha: 0.3) : Colors.grey.shade50,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: c.divider)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: c.divider)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: c.colorPrimary, width: 1.5)),
                                  ),
                                )
                              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(
                                    _gstinCtrl.text.isEmpty ? '—  ${l10n.notAdded}' : _gstinCtrl.text,
                                    style: GoogleFonts.poppins(
                                        fontSize: 15, fontWeight: FontWeight.w600,
                                        color: _gstinCtrl.text.isEmpty ? c.gray : c.textDark),
                                  ),
                                  Divider(color: c.divider.withValues(alpha: 0.5)),
                                ]),
                          if (_isEditing) ...[
                            const SizedBox(height: 6),
                            Row(children: [
                              Icon(Icons.info, color: c.gray, size: 13),
                              const SizedBox(width: 6),
                              Text(l10n.usedOnInvoices,
                                  style: GoogleFonts.poppins(fontSize: 11, color: c.gray)),
                            ]),
                          ],
                        ]),
                        const SizedBox(height: 28),

                        // ── Action bar ────────────────────────────────────────
                        _isSaving
                            ? _buildSavingIndicator(c, l10n)
                            : AppActionBar(
                                isEditing: _isEditing,
                                editLabel: l10n.editShopDetails,
                                saveLabel: l10n.saveShopDetails,
                                onEditSaveTap: () {
                                  if (_isEditing) {
                                    _onSave();
                                  } else {
                                    setState(() => _isEditing = true);
                                  }
                                },
                                onDeleteTap: () => _onReset(c, isDark),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Full-screen loading overlay ────────────────────────────────
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
                          Text(l10n.savingShopDetails,
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

  Widget _buildSavingIndicator(AppColorScheme c, AppLocalizations l10n) => Container(
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
        Text(l10n.saving,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w600, color: c.colorPrimary)),
      ],
    ),
  );

  TextStyle _labelStyle(AppColorScheme c) => GoogleFonts.poppins(
      fontSize: 11, color: c.gray, fontWeight: FontWeight.w600, letterSpacing: 0.5);

  Widget _sectionHeader(AppColorScheme c, IconData icon, String title) =>
      Row(children: [
        Icon(icon, color: c.colorPrimary, size: 18),
        const SizedBox(width: 8),
        Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold,
            color: c.textDark)),
      ]);

  Widget _card(AppColorScheme c, bool isDark, {required List<Widget> children}) =>
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? c.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14, offset: const Offset(0, 4))],
          border: Border.all(color: c.divider.withValues(alpha: 0.3)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );

  Widget _buildField(AppColorScheme c, bool isDark,
      {required String label, required TextEditingController ctrl, required IconData icon, required AppLocalizations l10n}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: _labelStyle(c)),
      const SizedBox(height: 6),
      _isEditing
          ? TextField(
              controller: ctrl,
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: c.textDark),
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: c.colorPrimary, size: 18),
                filled: true,
                fillColor: isDark ? c.background.withValues(alpha: 0.3) : Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: c.divider)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: c.divider)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: c.colorPrimary, width: 1.5)),
              ),
            )
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(icon, color: c.gray, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ctrl.text.isEmpty ? '—  ${l10n.notAdded}' : ctrl.text,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600,
                        color: ctrl.text.isEmpty ? c.gray : c.textDark),
                  ),
                ),
              ]),
              Divider(color: c.divider.withValues(alpha: 0.5)),
            ]),
    ]);
  }

  Widget _timeTile(AppColorScheme c, bool isDark, String label, TimeOfDay time, VoidCallback onTap) =>
      GestureDetector(
        onTap: _isEditing ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? c.background.withValues(alpha: 0.3) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: _isEditing ? c.colorPrimary.withValues(alpha: 0.4) : c.divider.withValues(alpha: 0.4)),
          ),
          child: Column(children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold,
                letterSpacing: 0.8, color: c.gray)),
            const SizedBox(height: 6),
            Text(_fmtTime(time),
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold,
                    color: _isEditing ? c.colorPrimary : c.textDark)),
            if (_isEditing) ...[const SizedBox(height: 4), Icon(Icons.edit_calendar, color: c.colorPrimary, size: 14)],
          ]),
        ),
      );
}

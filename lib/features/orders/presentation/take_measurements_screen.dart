import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../routes/app_router.dart';
import '../../templates/presentation/bloc/template_bloc.dart';
import '../../templates/presentation/bloc/template_state.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';


import '../data/order_form_data.dart';
import '../../../core/utility/dependency_injection.dart';
import 'bloc/order_wizard_bloc.dart';

// ─────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────
class _MeasurementField {
  final String label;
  final IconData icon;

  const _MeasurementField(this.label, this.icon);
}

const _garmentMeasurements = <String, List<_MeasurementField>>{
  'Blouse': [
    _MeasurementField('BUST', Icons.horizontal_rule),
    _MeasurementField('WAIST', Icons.arrow_upward),
    _MeasurementField('SHOULDERS', Icons.arrow_upward),
    _MeasurementField('SLEEVE', Icons.power_input),
    _MeasurementField('ARM HOLE', Icons.radio_button_unchecked),
    _MeasurementField('FULL LENGTH', Icons.height),
    _MeasurementField('FRONT NECK DEPTH', Icons.cut),
    _MeasurementField('BACK NECK DEPTH', Icons.cut),
  ],
  'Kurta': [
    _MeasurementField('CHEST', Icons.horizontal_rule),
    _MeasurementField('WAIST', Icons.arrow_upward),
    _MeasurementField('HIP', Icons.arrow_downward),
    _MeasurementField('FULL LENGTH', Icons.height),
    _MeasurementField('SLEEVE', Icons.power_input),
    _MeasurementField('SHOULDER', Icons.arrow_upward),
    _MeasurementField('NECK', Icons.radio_button_unchecked),
    _MeasurementField('SLIT', Icons.cut),
  ],
  'Bottoms': [
    _MeasurementField('WAIST', Icons.arrow_upward),
    _MeasurementField('HIP', Icons.arrow_downward),
    _MeasurementField('LENGTH', Icons.height),
    _MeasurementField('THIGH', Icons.horizontal_rule),
    _MeasurementField('KNEE', Icons.horizontal_rule),
    _MeasurementField('ANKLE', Icons.horizontal_rule),
  ],
  'Lehenga': [
    _MeasurementField('WAIST', Icons.arrow_upward),
    _MeasurementField('HIP', Icons.arrow_downward),
    _MeasurementField('LENGTH', Icons.height),
    _MeasurementField('FLARE', Icons.rotate_right),
  ],
  'Saree Blouse': [
    _MeasurementField('BUST', Icons.horizontal_rule),
    _MeasurementField('WAIST', Icons.arrow_upward),
    _MeasurementField('SHOULDERS', Icons.arrow_upward),
    _MeasurementField('SLEEVE', Icons.power_input),
    _MeasurementField('ARM HOLE', Icons.radio_button_unchecked),
    _MeasurementField('BLOUSE LENGTH', Icons.height),
    _MeasurementField('BACK DEPTH', Icons.cut),
  ],
};

// ─────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────
class TakeMeasurementsScreen extends StatefulWidget {
  final List<String> garmentTypes;

  /// When true, Save button navigates forward to Schedule in the order flow
  final bool isOrderFlow;
  final OrderFormData? initialData;

  const TakeMeasurementsScreen({
    super.key,
    this.garmentTypes = const ['Blouse'],
    this.isOrderFlow = false,
    this.initialData,
  });

  @override
  State<TakeMeasurementsScreen> createState() => _TakeMeasurementsScreenState();
}

class _TakeMeasurementsScreenState extends State<TakeMeasurementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, Map<String, TextEditingController>> _controllers;
  late Map<String, List<_MeasurementField>> _garmentFields;
  bool _unitIsInches = true;
  bool _setAsDefault = false;
  int _activeGarmentIndex = 0;
  late Map<String, TextEditingController> _notesControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.garmentTypes.length,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _activeGarmentIndex = _tabController.index);
      }
    });
    _notesControllers = {};
    _initControllers();
  }

  void _initControllers() {
    _controllers = {};
    _garmentFields = {};
    final templateState = context.read<TemplateBloc>().state;

    for (final garment in widget.garmentTypes) {
      List<_MeasurementField> fields = _garmentMeasurements[garment] ?? [];

      // If not in standard measurements, check custom templates
      if (fields.isEmpty && templateState is TemplatesLoaded) {
        final template = templateState.templates.firstWhere(
          (t) => t.name == garment,
          orElse: () => throw Exception('Template not found: $garment'),
        );
        fields = template.fields
            .map((f) => _MeasurementField(f, Icons.straighten))
            .toList();
      }

      _garmentFields[garment] = fields;
      
      // Pre-fill from initial measurements if available
      final Map<String, TextEditingController> garmentCtrls = {};
      final OrderFormData? sourceData = widget.isOrderFlow 
          ? getIt<OrderWizardBloc>().state.formData 
          : widget.initialData;

      final initialMeasurementsStr = sourceData?.measurements[garment] ?? '';
      final Map<String, String> initialValues = {};
      
      if (initialMeasurementsStr.isNotEmpty) {
        final parts = initialMeasurementsStr.split(', ');
        for (var part in parts) {
          final kv = part.split(':');
          if (kv.length == 2) {
            initialValues[kv[0]] = kv[1];
          }
        }
      }

      for (final f in fields) {
        garmentCtrls[f.label] = TextEditingController(text: initialValues[f.label] ?? '');
      }
      _controllers[garment] = garmentCtrls;
      
      // Initialize notes controller for this garment
      _notesControllers[garment] = TextEditingController(
        text: sourceData?.measurementNotes[garment] ?? '',
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final ctrl in _notesControllers.values) {
      ctrl.dispose();
    }
    for (final map in _controllers.values) {
      for (final ctrl in map.values) {
        ctrl.dispose();
      }
    }
    super.dispose();
  }

  String get _activeGarment => widget.garmentTypes[_activeGarmentIndex];

  // ─────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Same gradient as other create-order screens
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
          // ── Background gradient (same as schedule / items screens) ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
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

          // ── Main content ──
          SafeArea(
            child: Column(
              children: [
                _buildHeader(c, isDark),
                // Garment tabs (only when multiple garments)
                if (widget.garmentTypes.length > 1)
                  _buildGarmentTabs(c, isDark),
                // Fields
                Expanded(
                  child: widget.garmentTypes.length > 1
                      ? TabBarView(
                          controller: _tabController,
                          children: widget.garmentTypes
                              .map((g) => _buildMeasurementBody(c, isDark, g))
                              .toList(),
                        )
                      : _buildMeasurementBody(c, isDark, _activeGarment),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Header — exactly matches schedule / items header style
  // ─────────────────────────────────────────────
  Widget _buildHeader(AppColorScheme c, bool isDark) {
    final stepIndex = 2; // step 3 of 5 (0-based = 2)
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back / title / unit-toggle row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button — same style as schedule / items
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: c.textDark, size: 20),
                  onPressed: () => context.pop(),
                ),
              ),

              // ORDER #xxxx  label in center
              Text(
                (widget.isOrderFlow ? getIt<OrderWizardBloc>().state.formData : widget.initialData)?.isEditing == true
                    ? '${AppLocalizations.of(context).order.toUpperCase()} #${(widget.isOrderFlow ? getIt<OrderWizardBloc>().state.formData : widget.initialData)?.existingOrderRef?.substring(0, 8).toUpperCase()}'
                    : AppLocalizations.of(context).newOrder,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: c.textDark.withValues(alpha: 0.7),
                ),
              ),

              // Unit toggle: in / cm — styled as small segmented pill
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _unitChip(c, isDark, 'in', true),
                    _unitChip(c, isDark, 'cm', false),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Screen title
          Text(
            AppLocalizations.of(context).takeMeasurements,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: c.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context).enterGarmentMeasurements(getLocalizedTemplateName(_activeGarment, _activeGarment, AppLocalizations.of(context))),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: c.textDark.withValues(alpha: 0.8),
            ),
          ),

          const SizedBox(height: 20),

          // Progress (step 3 of 5)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).step3of5,
                style: GoogleFonts.poppins(fontSize: 12, color: c.textDark),
              ),
              Text(
                '60%',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: c.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                  height: 5,
                  decoration: BoxDecoration(
                    color: index <= stepIndex
                        ? c.colorPrimary
                        : c.colorPrimary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _unitChip(AppColorScheme c, bool isDark, String label, bool isInches) {
    final selected = _unitIsInches == isInches;
    return GestureDetector(
      onTap: () => setState(() => _unitIsInches = isInches),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? c.colorPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : c.textDark.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Garment tab bar (theme-consistent chips)
  // ─────────────────────────────────────────────
  Widget _buildGarmentTabs(AppColorScheme c, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(widget.garmentTypes.length, (i) {
            final sel = _activeGarmentIndex == i;
            return GestureDetector(
              onTap: () {
                _tabController.animateTo(i);
                setState(() => _activeGarmentIndex = i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: sel ? c.colorPrimary : Colors.transparent,
                  border: Border.all(color: sel ? c.colorPrimary : c.divider),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  getLocalizedTemplateName(widget.garmentTypes[i], widget.garmentTypes[i], AppLocalizations.of(context)),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: sel ? FontWeight.bold : FontWeight.w500,
                    color: sel ? Colors.white : c.textDark,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Measurement body — white cards, themed input
  // ─────────────────────────────────────────────
  Widget _buildMeasurementBody(AppColorScheme c, bool isDark, String garment) {
    final l10n = AppLocalizations.of(context);
    final fields = _garmentFields[garment] ?? [];
    final ctrls = _controllers[garment] ?? {};

    // Exclude neck fields from main grid
    final mainFields = fields
        .where(
          (f) => f.label != 'FRONT NECK DEPTH' && f.label != 'BACK NECK DEPTH',
        )
        .toList();
    final hasNeckFields = garment == 'Blouse' || garment == 'Saree Blouse';
    final frontCtrl = ctrls['FRONT NECK DEPTH'];
    final backCtrl = ctrls['BACK NECK DEPTH'];

    // Pair into two-column rows
    final pairs = <List<_MeasurementField>>[];
    for (int i = 0; i < mainFields.length; i += 2) {
      pairs.add(
        mainFields.sublist(
          i,
          i + 2 <= mainFields.length ? i + 2 : mainFields.length,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2-column grid
          ...pairs.map(
            (pair) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(child: _measurementCard(c, isDark, pair[0], ctrls)),
                  if (pair.length > 1) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: _measurementCard(c, isDark, pair[1], ctrls),
                    ),
                  ] else
                    const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ),

          // Neck depth section
          if (hasNeckFields && (frontCtrl != null || backCtrl != null)) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? c.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: c.divider.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
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
                      Icon(Icons.cut, color: c.colorPrimary, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context).neckDepthDetails,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: c.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _neckInput(c, isDark, l10n.frontNeckDepth, frontCtrl),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _neckInput(c, isDark, l10n.backNeckDepth, backCtrl)),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Additional Notes section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? c.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.divider.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
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
                    Icon(Icons.notes, color: c.colorPrimary, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context).additionalNotes,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: c.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _notesControllers[garment],
                  maxLines: 3,
                  style: GoogleFonts.poppins(fontSize: 13, color: c.textDark),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).notesHint,
                    hintStyle: GoogleFonts.poppins(fontSize: 13, color: c.gray),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: c.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: c.divider.withValues(alpha: 0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: c.colorPrimary, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Set as Default toggle ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? c.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.divider.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.bookmark_border, color: c.colorPrimary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).setAsDefaultProfile,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: c.textDark,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).reuseForFutureOrders(getLocalizedTemplateName(garment, garment, AppLocalizations.of(context))),
                        style: GoogleFonts.poppins(fontSize: 11, color: c.gray),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _setAsDefault,
                  onChanged: (v) => setState(() => _setAsDefault = v),
                  activeThumbColor: c.colorPrimary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Save / Continue button ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: c.colorPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () {
                final Map<String, String> formattedMeasurements = {};
                for (final garment in widget.garmentTypes) {
                  final map = _controllers[garment] ?? {};
                  final buffer = StringBuffer();
                  map.forEach((label, ctrl) {
                    buffer.write('$label:${ctrl.text}, ');
                  });
                  var str = buffer.toString();
                  if (str.endsWith(', ')) str = str.substring(0, str.length - 2);
                  formattedMeasurements[garment] = str;
                }

                if (widget.isOrderFlow) {
                  final currentData = getIt<OrderWizardBloc>().state.formData;
                  final updated = currentData.copyWith(
                    measurements: formattedMeasurements,
                    measurementNotes: Map.fromIterables(
                      widget.garmentTypes,
                      widget.garmentTypes.map((g) => _notesControllers[g]!.text.trim()),
                    ),
                  );
                  getIt<OrderWizardBloc>().add(UpdateOrderData(updated));
                  context.push(AppRoutes.createOrderSchedule);
                } else {
                  context.pop();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.isOrderFlow
                        ? AppLocalizations.of(context).saveAndContinue
                        : AppLocalizations.of(context).saveMeasurements,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  if (widget.isOrderFlow) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _measurementCard(
    AppColorScheme c,
    bool isDark,
    _MeasurementField field,
    Map<String, TextEditingController> ctrls,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.divider.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row
          Row(
            children: [
              Icon(field.icon, size: 13, color: c.colorPrimary),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  getLocalizedMeasurementField(field.label, AppLocalizations.of(context)).toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: c.textDark.withValues(alpha: 0.55),
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Value row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: ctrls[field.label],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: c.textDark,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintText: '0.0',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  _unitIsInches ? 'in' : 'cm',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: c.gray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _neckInput(
    AppColorScheme c,
    bool isDark,
    String label,
    TextEditingController? ctrl,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: c.textDark.withValues(alpha: 0.55),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: ctrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: c.textDark,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintText: '0.0',
                ),
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                _unitIsInches ? 'in' : 'cm',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: c.gray,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

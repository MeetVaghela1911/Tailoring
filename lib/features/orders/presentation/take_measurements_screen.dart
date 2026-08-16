import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../routes/app_router.dart';
import '../../templates/presentation/bloc/template_bloc.dart';
import '../../templates/presentation/bloc/template_state.dart';
import '../../templates/domain/entities/template.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';


import '../data/order_form_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utility/dependency_injection.dart';
import 'bloc/order_wizard_bloc.dart';

import '../../../core/constants/default_templates.dart';

// ─────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────
class _MeasurementField {
  final String label;
  final IconData icon;

  const _MeasurementField(this.label, this.icon);
}

IconData _getIconForField(String label) {
  final l = label.toLowerCase();
  if (l.contains('length') || l.contains('height')) return Icons.height;
  if (l.contains('waist')) return Icons.arrow_upward;
  if (l.contains('hip')) return Icons.arrow_downward;
  if (l.contains('bust') || l.contains('chest')) return Icons.horizontal_rule;
  if (l.contains('shoulder')) return Icons.arrow_upward;
  if (l.contains('sleeve') || l.contains('arm')) return Icons.power_input;
  if (l.contains('neck') || l.contains('depth')) return Icons.cut;
  return Icons.straighten;
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
  bool _setAsDefault = true;
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
      List<_MeasurementField> fields = [];

      // 1. Check loaded templates from TemplateBloc FIRST
      Template? matchedTemplate;
      if (templateState is TemplatesLoaded) {
        matchedTemplate = templateState.templates.where(
          (t) =>
              t.id == garment ||
              t.name == garment ||
              t.id.toLowerCase() == garment.toLowerCase() ||
              t.name.toLowerCase() == garment.toLowerCase(),
        ).firstOrNull;

        if (matchedTemplate != null && matchedTemplate.fields.isNotEmpty) {
          fields = matchedTemplate.fields
              .map((f) => _MeasurementField(f, _getIconForField(f)))
              .toList();
        }
      }

      // 2. Check DefaultTemplates if not found in custom templates
      if (fields.isEmpty) {
        final defMatch = DefaultTemplates.all.where(
          (t) =>
              t.id == garment ||
              t.name == garment ||
              t.id.toLowerCase() == garment.toLowerCase() ||
              t.name.toLowerCase() == garment.toLowerCase(),
        ).firstOrNull;

        if (defMatch != null && defMatch.fields.isNotEmpty) {
          fields = defMatch.fields
              .map((f) => _MeasurementField(f, _getIconForField(f)))
              .toList();
        }
      }

      // 3. Fallback to hardcoded _garmentMeasurements
      if (fields.isEmpty) {
        fields = List.from(_garmentMeasurements[garment] ??
            _garmentMeasurements.entries
                .where((e) => e.key.toLowerCase() == garment.toLowerCase())
                .firstOrNull
                ?.value ??
            []);
      }

      // Pre-fill from initial measurements if available
      final Map<String, TextEditingController> garmentCtrls = {};
      final OrderFormData? sourceData = widget.isOrderFlow
          ? getIt<OrderWizardBloc>().state.formData
          : widget.initialData;

      String initialMeasurementsStr = sourceData?.measurements[garment] ?? '';
      if (initialMeasurementsStr.isEmpty && matchedTemplate != null) {
        initialMeasurementsStr = sourceData?.measurements[matchedTemplate.id] ??
            sourceData?.measurements[matchedTemplate.name] ??
            '';
      }

      if (initialMeasurementsStr.isEmpty && sourceData?.measurements != null) {
        for (var entry in sourceData!.measurements.entries) {
          final k = entry.key.trim().toLowerCase();
          final g = garment.trim().toLowerCase();
          if (k == g || (matchedTemplate != null && (k == matchedTemplate.id.toLowerCase() || k == matchedTemplate.name.toLowerCase()))) {
            initialMeasurementsStr = entry.value;
            break;
          }
        }
      }

      // Fallback to default profile saved in SharedPreferences if available
      final customerId = sourceData?.customerId;
      final prefs = getIt.isRegistered<SharedPreferences>() ? getIt<SharedPreferences>() : null;
      if (prefs != null) {
        bool hasDefault = false;
        if (customerId != null && customerId.isNotEmpty) {
          hasDefault = prefs.containsKey('default_measurements_${customerId}_$garment');
          if (initialMeasurementsStr.isEmpty) {
            initialMeasurementsStr = prefs.getString('default_measurements_${customerId}_$garment') ?? '';
          }
        }
        if (initialMeasurementsStr.isEmpty) {
          initialMeasurementsStr = prefs.getString('default_measurements_global_$garment') ?? '';
        }
        if (hasDefault) {
          _setAsDefault = true;
        }
      }

      final Map<String, String> initialValues = {};
      if (initialMeasurementsStr.isNotEmpty) {
        final parts = initialMeasurementsStr.split(RegExp(r',\s*'));
        for (var part in parts) {
          final kv = part.split(':');
          if (kv.length == 2) {
            final key = kv[0].trim();
            var val = kv[1].trim();
            if (key == '__UNIT__') {
              _unitIsInches = (val.toLowerCase() != 'cm');
            } else {
              val = val.replaceAll(RegExp(r'\s*(in|cm)$', caseSensitive: false), '').trim();
              initialValues[key] = val;
            }
          }
        }
      }

      // 4. If fields list is STILL empty (e.g. template was deleted), extract field names dynamically from initialValues!
      if (fields.isEmpty && initialValues.isNotEmpty) {
        fields = initialValues.keys
            .map((k) => _MeasurementField(k, _getIconForField(k)))
            .toList();
      }

      _garmentFields[garment] = fields;

      for (final f in fields) {
        final val = initialValues[f.label] ??
            initialValues.entries
                .where((e) => e.key.trim().toLowerCase() == f.label.trim().toLowerCase())
                .firstOrNull
                ?.value ??
            '';
        garmentCtrls[f.label] = TextEditingController(text: val);
      }
      _controllers[garment] = garmentCtrls;

      // Initialize notes controller for this garment
      String noteText = sourceData?.measurementNotes[garment] ??
          (matchedTemplate != null ? (sourceData?.measurementNotes[matchedTemplate.id] ?? sourceData?.measurementNotes[matchedTemplate.name] ?? '') : '');
      if (noteText.isEmpty && customerId != null && customerId.isNotEmpty && prefs != null) {
        noteText = prefs.getString('default_notes_${customerId}_$garment') ?? '';
      }
      _notesControllers[garment] = TextEditingController(text: noteText);
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
              onPressed: () async {
                final unitStr = _unitIsInches ? 'in' : 'cm';
                final Map<String, String> formattedMeasurements = {};
                final Map<String, String> formattedNotes = {};
                final templateState = context.read<TemplateBloc>().state;

                for (final garment in widget.garmentTypes) {
                  final map = _controllers[garment] ?? {};
                  final buffer = StringBuffer();
                  map.forEach((label, ctrl) {
                    final val = ctrl.text.trim();
                    if (val.isNotEmpty) {
                      buffer.write('$label:$val $unitStr, ');
                    }
                  });
                  buffer.write('__UNIT__:$unitStr, ');
                  var str = buffer.toString();
                  if (str.endsWith(', ')) str = str.substring(0, str.length - 2);

                  formattedMeasurements[garment] = str;
                  final note = _notesControllers[garment]?.text.trim() ?? '';
                  formattedNotes[garment] = note;

                  if (templateState is TemplatesLoaded) {
                    final matched = templateState.templates.where(
                      (t) =>
                          t.id == garment ||
                          t.name == garment ||
                          t.id.toLowerCase() == garment.toLowerCase() ||
                          t.name.toLowerCase() == garment.toLowerCase(),
                    ).firstOrNull;

                    if (matched != null) {
                      formattedMeasurements[matched.id] = str;
                      formattedMeasurements[matched.name] = str;
                      formattedNotes[matched.id] = note;
                      formattedNotes[matched.name] = note;
                    }
                  }
                }

                final prefs = getIt.isRegistered<SharedPreferences>() ? getIt<SharedPreferences>() : null;
                final customerId = getIt<OrderWizardBloc>().state.formData.customerId;
                if (prefs != null) {
                  for (final garment in widget.garmentTypes) {
                    if (_setAsDefault) {
                      if (formattedMeasurements[garment] != null) {
                        if (customerId != null && customerId.isNotEmpty) {
                          await prefs.setString('default_measurements_${customerId}_$garment', formattedMeasurements[garment]!);
                          await prefs.setString('default_notes_${customerId}_$garment', _notesControllers[garment]?.text.trim() ?? '');
                        }
                        await prefs.setString('default_measurements_global_$garment', formattedMeasurements[garment]!);
                      }
                    } else {
                      if (customerId != null && customerId.isNotEmpty) {
                        await prefs.remove('default_measurements_${customerId}_$garment');
                        await prefs.remove('default_notes_${customerId}_$garment');
                      }
                    }
                  }
                }

                if (!mounted) return;
                if (widget.isOrderFlow) {
                  final currentData = getIt<OrderWizardBloc>().state.formData;
                  final updated = currentData.copyWith(
                    measurements: formattedMeasurements,
                    measurementNotes: formattedNotes,
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
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: c.textDark,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintText: '0.0',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: c.gray,
                    ),
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
                textInputAction: TextInputAction.next,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: c.textDark,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintText: '0.0',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: c.gray,
                  ),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_icons.dart';
import '../../../core/utils/snackbar_utils.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_action_bar.dart';
import '../domain/entities/template.dart';
import 'bloc/template_bloc.dart';
import 'bloc/template_event.dart';
import 'bloc/template_state.dart';

// Icons moved to AppIcons.presetIcons

const _detailPresetFields = [
  'BUST',
  'WAIST',
  'HIP',
  'SHOULDER',
  'SLEEVE',
  'LENGTH',
  'CHEST',
  'FLARE',
  'THIGH',
  'KNEE',
  'ANKLE',
  'NECK',
  'SLIT',
  'ARM HOLE',
  'BACK DEPTH',
  'FRONT DEPTH',
];

class TemplateDetailScreen extends StatefulWidget {
  final Template template;

  const TemplateDetailScreen({super.key, required this.template});

  @override
  State<TemplateDetailScreen> createState() => _TemplateDetailScreenState();
}

class _TemplateDetailScreenState extends State<TemplateDetailScreen> {
  bool _isEditing = false;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _categoryCtrl;
  late int _iconIndex;
  late List<String> _fields;
  final _priceCtrl = TextEditingController();
  final _customFieldCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initFields();
  }

  void _initFields() {
    _nameCtrl = TextEditingController(text: widget.template.name);
    _categoryCtrl = TextEditingController(text: widget.template.category);
    _priceCtrl.text = widget.template.basePrice.toStringAsFixed(0);
    _fields = List.from(widget.template.fields);

    _iconIndex = AppIcons.presetIcons.indexWhere(
      (ic) => ic.codePoint == widget.template.iconCodePoint,
    );
    if (_iconIndex < 0) _iconIndex = 0;
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _nameCtrl.text = widget.template.name;
      _categoryCtrl.text = widget.template.category;
      _priceCtrl.text = widget.template.basePrice.toStringAsFixed(0);
      _fields = List.from(widget.template.fields);
      _customFieldCtrl.clear();

      _iconIndex = AppIcons.presetIcons.indexWhere(
        (ic) => ic.codePoint == widget.template.iconCodePoint,
      );
      if (_iconIndex < 0) _iconIndex = 0;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _priceCtrl.dispose();
    _customFieldCtrl.dispose();
    super.dispose();
  }

  void _addPresetField(String field) {
    if (_fields.contains(field)) return;
    setState(() => _fields.add(field));
  }

  void _addCustomField() {
    final text = _customFieldCtrl.text.trim().toUpperCase();
    if (text.isEmpty || _fields.contains(text)) return;
    setState(() {
      _fields.add(text);
      _customFieldCtrl.clear();
    });
  }

  void _removeField(int index) => setState(() => _fields.removeAt(index));

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _fields.removeAt(oldIndex);
      _fields.insert(newIndex, item);
    });
  }

  void _onSave(AppColorScheme c) {
    if (_nameCtrl.text.trim().isEmpty) {
      showAppSnackBar(
        context,
        message: AppLocalizations.of(context).templateNameEmpty,
        isError: true,
      );
      return;
    }

    final updated = widget.template.copyWith(
      name: _nameCtrl.text.trim(),
      category: _categoryCtrl.text.trim(),
      iconCodePoint: AppIcons.presetIcons[_iconIndex].codePoint,
      iconFontFamily: AppIcons.presetIcons[_iconIndex].fontFamily,
      fields: List.from(_fields),
      basePrice: double.tryParse(_priceCtrl.text.trim()) ?? 0.0,
    );

    context.read<TemplateBloc>().add(UpdateTemplate(updated));
  }

  void _onDelete(AppColorScheme c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? c.cardDark
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLocalizations.of(context).deleteTemplateTitle,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: c.textDark,
            fontSize: 16,
          ),
        ),
        content: Text(
          AppLocalizations.of(
            context,
          ).deleteTemplateConfirm(widget.template.name),
          style: GoogleFonts.poppins(fontSize: 13, color: c.gray),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              AppLocalizations.of(context).cancel,
              style: GoogleFonts.poppins(color: c.gray),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              context.read<TemplateBloc>().add(
                DeleteTemplate(widget.template.id),
              );
              context.pop();
            },
            child: Text(
              AppLocalizations.of(context).delete,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

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

    return BlocListener<TemplateBloc, TemplateState>(
      listener: (context, state) {
        if (state is TemplateUpdateSuccess) {
          if (_isEditing) {
            setState(() => _isEditing = false);
            showAppSnackBar(
              context,
              message: AppLocalizations.of(context).templateUpdated,
            );
          }
        } else if (state is TemplateDeleteSuccess) {
          context.pop();
          showAppSnackBar(
            context,
            message: AppLocalizations.of(context).templateDeleted,
          );
        } else if (state is TemplateError) {
          showAppSnackBar(context, message: state.message, isError: true);
        }
      },
      child: Scaffold(
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
              child: Column(
                children: [
                  _buildHeader(c, isDark, l10n),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildNameField(c, isDark),
                          const SizedBox(height: 20),
                          _buildCategoryField(c, isDark),
                          const SizedBox(height: 20),
                          _buildPriceField(c, isDark),
                          const SizedBox(height: 24),
                          _buildSectionTitle(c, 'Icon'),
                          const SizedBox(height: 12),
                          _buildIconPicker(c),
                          const SizedBox(height: 24),
                          _buildSectionTitle(c, l10n.measurementFields),
                          const SizedBox(height: 4),
                          Text(
                            _isEditing
                                ? l10n.dragToReorder
                                : l10n.fieldsCount(_fields.length),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: c.gray,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (_isEditing) _buildQuickAddChips(c),
                          _buildFieldsList(c, isDark),
                          if (_isEditing) ...[
                            const SizedBox(height: 8),
                            _buildCustomFieldInput(c, isDark),
                          ],
                          const SizedBox(height: 24),
                          BlocBuilder<TemplateBloc, TemplateState>(
                            builder: (context, state) {
                              final isLoading = state is TemplateLoading;
                              return AppActionBar(
                                isEditing: _isEditing,
                                editLabel: l10n.editTemplate,
                                saveLabel: isLoading
                                    ? l10n.saving
                                    : l10n.saveChanges,
                                onEditSaveTap: () {
                                  if (isLoading) return;
                                  if (_isEditing) {
                                    _onSave(c);
                                  } else {
                                    setState(() => _isEditing = true);
                                  }
                                },
                                onDeleteTap: () {
                                  if (isLoading) return;
                                  _onDelete(c);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(AppColorScheme c, bool isDark, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          AppBackButton(
            onTap: _isEditing ? _cancelEditing : () => context.pop(),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.templates.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: c.textDark.withValues(alpha: 0.6),
                ),
              ),
              Text(
                _isEditing ? l10n.editTemplate : l10n.templateDetails,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: c.textDark,
                  height: 1.2,
                ),
              ),
            ],
          ),
          if (_isEditing) ...[
            const Spacer(),
            TextButton(
              onPressed: _cancelEditing,
              child: Text(
                l10n.cancel,
                style: GoogleFonts.poppins(fontSize: 13, color: c.gray),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(AppColorScheme c, String t) => Text(
    t,
    style: GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: c.textDark,
    ),
  );

  // ── Fields (name / category) ──────────────────────────────────────────────
  Widget _buildNameField(AppColorScheme c, bool isDark) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(c, l10n.templateName),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDark ? c.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.divider.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _nameCtrl,
            enabled: _isEditing,
            style: GoogleFonts.poppins(fontSize: 14, color: c.textDark),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.edit_outlined, color: c.gray, size: 20),
              border: InputBorder.none,
              hintText: _isEditing
                  ? null
                  : getLocalizedTemplateName(
                      widget.template.id,
                      widget.template.name,
                      l10n,
                    ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField(AppColorScheme c, bool isDark) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(c, l10n.category),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDark ? c.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.divider.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: _isEditing
              ? TextField(
                  controller: _categoryCtrl,
                  style: GoogleFonts.poppins(fontSize: 14, color: c.textDark),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.category_outlined,
                      color: c.gray,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.category_outlined, color: c.gray, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        getLocalizedCategory(_categoryCtrl.text, l10n),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: c.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildPriceField(AppColorScheme c, bool isDark) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(c, l10n.basePrice),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDark ? c.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.divider.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _priceCtrl,
            enabled: _isEditing,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: GoogleFonts.poppins(fontSize: 14, color: c.textDark),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.currency_rupee_outlined,
                color: c.gray,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Icon picker ───────────────────────────────────────────────────────────
  Widget _buildIconPicker(AppColorScheme c) {
    if (!_isEditing) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: c.colorPrimary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.divider.withValues(alpha: 0.3)),
        ),
        child: Icon(
          AppIcons.presetIcons[_iconIndex],
          color: c.colorPrimary,
          size: 28,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.colorPrimary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.divider.withValues(alpha: 0.3)),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: AppIcons.presetIcons.length,
        itemBuilder: (context, i) {
          final sel = _iconIndex == i;

          return GestureDetector(
            onTap: () => setState(() => _iconIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: sel ? c.colorPrimary : c.grayLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: sel ? c.colorPrimary : Colors.transparent,
                  width: 2,
                ),
                boxShadow: sel
                    ? [
                        BoxShadow(
                          color: c.colorPrimary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                AppIcons.presetIcons[i],
                color: sel ? Colors.white : c.gray,
                size: 20,
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Quick-add chips (edit mode only) ──────────────────────────────────────
  Widget _buildQuickAddChips(AppColorScheme c) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _detailPresetFields.map((field) {
          final added = _fields.contains(field);
          return GestureDetector(
            onTap: () => _addPresetField(field),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: added
                    ? c.colorPrimary
                    : c.colorPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: added
                      ? c.colorPrimary
                      : c.colorPrimary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (added)
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.check, color: Colors.white, size: 11),
                    ),
                  Text(
                    getLocalizedMeasurementField(field, l10n),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: added ? Colors.white : c.colorPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Fields list ───────────────────────────────────────────────────────────
  Widget _buildFieldsList(AppColorScheme c, bool isDark) {
    final l10n = AppLocalizations.of(context);
    if (_fields.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            _isEditing ? l10n.noFieldsYet : l10n.noFieldsDefined,
            style: GoogleFonts.poppins(fontSize: 13, color: c.gray),
          ),
        ),
      );
    }

    if (!_isEditing) {
      // View-only: simple wrap of tag pills
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _fields
            .map(
              (f) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: c.colorPrimary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  getLocalizedMeasurementField(f, l10n),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: c.colorPrimary,
                  ),
                ),
              ),
            )
            .toList(),
      );
    }

    // Edit mode: reorderable list
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _fields.length,
      onReorder: _onReorder,
      proxyDecorator: (child, _, animation) {
        return Material(color: Colors.transparent, child: child);
      },
      itemBuilder: (context, index) {
        final field = _fields[index];

        return Container(
          key: ValueKey('$field-$index'),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isDark ? c.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.divider.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 2,
              ),
              leading: Icon(
                Icons.drag_handle,
                color: c.gray.withValues(alpha: 0.6),
              ),
              title: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: c.colorPrimary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  getLocalizedMeasurementField(field, l10n),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: c.colorPrimary,
                  ),
                ),
              ),
              trailing: GestureDetector(
                onTap: () => _removeField(index),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.red.shade400,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Custom field input (edit mode) ────────────────────────────────────────
  Widget _buildCustomFieldInput(AppColorScheme c, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.divider.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            AppIcons.presetIcons[_iconIndex],
            color: c.colorPrimary,
            size: 28,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _customFieldCtrl,
              textCapitalization: TextCapitalization.characters,
              style: GoogleFonts.poppins(fontSize: 13, color: c.textDark),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).addCustomField,
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: c.gray),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (_) => _addCustomField(),
            ),
          ),
          GestureDetector(
            onTap: _addCustomField,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: c.colorPrimary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

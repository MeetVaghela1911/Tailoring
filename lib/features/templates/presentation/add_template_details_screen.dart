import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import '../../../routes/app_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Preset icon options (expanded set of tailoring-relevant icons)
// ─────────────────────────────────────────────────────────────────────────────

// Preset icons moved to AppIcons.presetIcons


// ─────────────────────────────────────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────────────────────────────────────

class AddTemplateDetailsScreen extends StatefulWidget {
  const AddTemplateDetailsScreen({super.key});

  @override
  State<AddTemplateDetailsScreen> createState() =>
      _AddTemplateDetailsScreenState();
}

class _AddTemplateDetailsScreenState extends State<AddTemplateDetailsScreen> {
  final _nameCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  int _iconIndex = 0;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _nameCtrl.text.trim().isNotEmpty &&
      _categoryCtrl.text.trim().isNotEmpty &&
      _priceCtrl.text.trim().isNotEmpty;

  void _onContinue() {
    if (!_canContinue) return;
    context.push(
      AppRoutes.addTemplateFields,
      extra: {
        'name': _nameCtrl.text.trim(),
        'category': _categoryCtrl.text.trim(),
        'iconCodePoint': AppIcons.presetIcons[_iconIndex].codePoint,
        'iconFontFamily': AppIcons.presetIcons[_iconIndex].fontFamily,
        'basePrice': double.tryParse(_priceCtrl.text.trim()) ?? 0.0,
      },
    );
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

    return Scaffold(
      backgroundColor: c.background,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
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
            child: Column(
              children: [
                _buildHeader(c, isDark),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                          c, isDark,
                          controller: _nameCtrl,
                          label: AppLocalizations.of(context).templateName,
                          hint: AppLocalizations.of(context).templateNameHint,
                          icon: Icons.edit_outlined,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          c, isDark,
                          controller: _categoryCtrl,
                          label: AppLocalizations.of(context).category,
                          hint: AppLocalizations.of(context).categoryHint,
                          icon: Icons.category_outlined,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          c, isDark,
                          controller: _priceCtrl,
                          label: AppLocalizations.of(context).basePrice,
                          hint: AppLocalizations.of(context).basePriceHint,
                          icon: Icons.currency_rupee_outlined,
                          isNumber: true,
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle(c, 'Icon'),
                        const SizedBox(height: 12),
                        _buildIconPicker(c),
                        const SizedBox(height: 28),
                        _buildPreviewCard(c, isDark),
                        const SizedBox(height: 32),
                        _buildContinueButton(c),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(AppColorScheme c, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              Text(
                AppLocalizations.of(context).createTemplate,
                style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600, color: c.textDark,
                ),
              ),
              const SizedBox(width: 44),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).templateDetails,
                style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w500, color: c.textDark,
                ),
              ),
              Text(
                AppLocalizations.of(context).step1of2,
                style: GoogleFonts.poppins(fontSize: 12, color: c.textDark.withValues(alpha: 0.7)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(2, (i) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 1 ? 6 : 0),
                height: 5,
                decoration: BoxDecoration(
                  color: i == 0 ? c.colorPrimary : c.colorPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(AppColorScheme c, String title) => Text(
    title,
    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: c.textDark),
  );

  // ── Text field ────────────────────────────────────────────────────────────
  Widget _buildTextField(
    AppColorScheme c,
    bool isDark, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(c, label),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDark ? c.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
            border: Border.all(color: c.divider.withValues(alpha: 0.4)),
          ),
          child: TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            style: GoogleFonts.poppins(fontSize: 14, color: c.textDark),
            keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(fontSize: 14, color: c.gray),
              prefixIcon: Icon(icon, color: c.gray, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  // ── Icon picker ───────────────────────────────────────────────────────────
  Widget _buildIconPicker(AppColorScheme c) {
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
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: sel ? c.colorPrimary : Colors.transparent,
                  width: 2,
                ),
                boxShadow: sel
                    ? [BoxShadow(
                        color: c.colorPrimary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )]
                    : [],
              ),
              child: Icon(
                AppIcons.presetIcons[i],
                color: sel ? Colors.white : c.gray,
                size: 22,
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Preview card ──────────────────────────────────────────────────────────
  Widget _buildPreviewCard(AppColorScheme c, bool isDark) {
    final selectedIcon = AppIcons.presetIcons[_iconIndex];
    final name = _nameCtrl.text.trim().isEmpty ? AppLocalizations.of(context).templateName : _nameCtrl.text.trim();
    final category = _categoryCtrl.text.trim().isEmpty ? AppLocalizations.of(context).category : _categoryCtrl.text.trim();
    final isEmpty = _nameCtrl.text.trim().isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(c, AppLocalizations.of(context).preview),
        const SizedBox(height: 12),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: isDark ? c.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 14, offset: const Offset(0, 4))],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -28, right: -28,
                child: Container(
                  width: 96, height: 96,
                  decoration: BoxDecoration(color: c.colorPrimary.withValues(alpha: 0.08), shape: BoxShape.circle),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 66, height: 66,
                      decoration: BoxDecoration(color: c.colorPrimary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
                      child: Icon(selectedIcon, color: c.colorPrimary, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(child: Text(name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: isEmpty ? c.gray : c.textDark))),
                            Icon(Icons.chevron_right, color: c.gray.withValues(alpha: 0.5), size: 22),
                          ]),
                          const SizedBox(height: 4),
                          Text(category, style: GoogleFonts.poppins(fontSize: 12.5, color: c.gray)),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: c.colorPrimary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
                            child: Text(AppLocalizations.of(context).customTemplate, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: c.colorPrimary)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Continue button ───────────────────────────────────────────────────────
  Widget _buildContinueButton(AppColorScheme c) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _canContinue ? c.colorPrimary : c.gray,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: _canContinue ? _onContinue : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context).continueToFields, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uuid/uuid.dart';
import '../../onboarding/presentation/utils/walkthrough_keys.dart';

import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import '../../../routes/app_router.dart';
import '../domain/entities/template.dart';
import 'bloc/template_bloc.dart';
import 'bloc/template_event.dart';
import 'bloc/template_state.dart';
import '../../../core/constants/default_templates.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/app_empty_state.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  String _searchQuery = '';
  String _filterCategory = 'All'; // Should probably be localized or kept as ID

  @override
  void initState() {
    super.initState();
    context.read<TemplateBloc>().add(LoadTemplates());
  }

  List<String> _getFilterOptions(List<Template> templates) {
    final cats = templates.map((t) => t.category).toSet().toList()..sort();
    return ['All', ...cats];
  }

  List<Template> _filter(List<Template> templates) {
    return templates.where((t) {
      final matchCat = _filterCategory == 'All' || t.category == _filterCategory;
      final matchQ = _searchQuery.isEmpty ||
          t.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchQ;
    }).toList();
  }

  void _openDetail(Template template) async {
    await context.push(AppRoutes.templateDetail, extra: template);
  }

  void _addSuggested(Template template) {
    // We add it with a new unique ID to distinguish from the static default
    final newTemplate = template.copyWith(
      id: const Uuid().v4(),
    );
    context.read<TemplateBloc>().add(AddTemplate(newTemplate));
    showAppSnackBar(context, message: AppLocalizations.of(context).addedToTemplates(template.name));
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

    return Scaffold(
      backgroundColor: c.background,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0,
            height: MediaQuery.of(context).size.height * 0.42,
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
            child: BlocBuilder<TemplateBloc, TemplateState>(
              builder: (context, state) {
                if (state is TemplateLoading) {
                  return Center(child: CircularProgressIndicator(color: c.colorPrimary));
                } else if (state is TemplatesLoaded) {
                  final filterOptions = _getFilterOptions(state.templates);
                  final filtered = _filter(state.templates);
                  
                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.stitchBusiness,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11, fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2, color: c.textDark.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(l10n.templates, style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: c.textDark, height: 1.15)),
                              Text(l10n.yourCustomTemplates, style: GoogleFonts.poppins(fontSize: 13, color: c.gray)),
                              const SizedBox(height: 18),

                              Container(
                                decoration: BoxDecoration(
                                  color: isDark ? c.cardDark : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
                                ),
                                child: TextField(
                                  onChanged: (v) => setState(() => _searchQuery = v),
                                  style: GoogleFonts.poppins(fontSize: 13, color: c.textDark),
                                  decoration: InputDecoration(
                                    hintText: l10n.searchTemplates,
                                    hintStyle: GoogleFonts.poppins(fontSize: 13, color: c.gray),
                                    prefixIcon: Icon(Icons.search, color: c.gray, size: 20),
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(Icons.close, color: c.gray, size: 18),
                                            onPressed: () => setState(() => _searchQuery = ''),
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              if (filterOptions.length > 1)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: filterOptions.map((cat) {
                                      final sel = _filterCategory == cat;
                                      final label = (cat == 'All' || cat == 'सभी') ? l10n.all : getLocalizedCategory(cat, l10n);
                                      return GestureDetector(
                                        onTap: () => setState(() => _filterCategory = cat),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          margin: const EdgeInsets.only(right: 10),
                                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                                          decoration: BoxDecoration(
                                            color: sel ? c.colorPrimary : Colors.transparent,
                                            border: Border.all(color: sel ? c.colorPrimary : c.divider),
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          child: Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: sel ? Colors.white : c.textDark)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                               const SizedBox(height: 20),
                               
                               _buildSuggestedSection(c, isDark),
                               
                               const SizedBox(height: 24),
                               Text(
                                 l10n.yourCollection,
                                 style: GoogleFonts.poppins(
                                   fontSize: 16,
                                   fontWeight: FontWeight.bold,
                                   color: c.textDark,
                                 ),
                               ),
                               const SizedBox(height: 12),
                             ],
                           ),
                         ),
                       ),

                      if (state.templates.isEmpty)
                        SliverToBoxAdapter(child: _buildEmptyState(c, Icons.checkroom_outlined, l10n.noTemplatesYet, l10n.createFirstTemplate))
                      else if (filtered.isEmpty)
                        SliverToBoxAdapter(child: _buildEmptyState(c, Icons.search_off, l10n.noMatchingTemplates, l10n.trySearchingDifferent))
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildTemplateCard(c, isDark, filtered[index]),
                              childCount: filtered.length,
                            ),
                          ),
                        ),
                      
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  );
                } else if (state is TemplateError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          Positioned(
            bottom: 24,
            right: 20,
            child: Showcase(
              key: WalkthroughKeys.templatesAddButton,
              description: l10n.walkthroughTemplatesAdd,
              targetBorderRadius: BorderRadius.circular(20),
              targetPadding: const EdgeInsets.all(4),
              child: GestureDetector(
                onTap: () async {
                  await context.push(AppRoutes.addTemplate);
                },
                child: Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: c.colorPrimary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: c.colorPrimary.withValues(alpha: 0.45), blurRadius: 18, offset: const Offset(0, 6))],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppColorScheme c, IconData icon, String title, String subtitle) {
    return AppEmptyState(
      icon: icon,
      title: title,
      message: subtitle,
    );
  }

  Widget _buildTemplateCard(AppColorScheme c, bool isDark, Template t) {
    final l10n = AppLocalizations.of(context);
    final tagBg = c.colorPrimary.withValues(alpha: 0.08);
    final displayTags = t.fields.take(3).map((f) => getLocalizedMeasurementField(f, l10n)).toList();
    final extra = t.fields.length - displayTags.length;
    final iconData = AppIcons.getIcon(t.iconCodePoint);

    return GestureDetector(
      onTap: () => _openDetail(t),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: isDark ? c.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 14, offset: const Offset(0, 4))],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -28, right: -28,
              child: Container(
                width: 96, height: 96,
                decoration: BoxDecoration(color: c.colorPrimary.withValues(alpha: 0.07), shape: BoxShape.circle),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: c.colorPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(iconData, color: c.colorPrimary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getLocalizedCategory(t.category, l10n), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: c.gray, letterSpacing: 0.5)),
                        Text(getLocalizedTemplateName(t.id, t.name, l10n), style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: c.textDark, height: 1.2)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            ...displayTags.map((tag) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(6)),
                              child: Text(tag, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: c.colorPrimary)),
                            )),
                            if (extra > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(l10n.moreFields(extra), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: c.gray)),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: c.gray.withValues(alpha: 0.35),
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSuggestedSection(AppColorScheme c, bool isDark) {
    final l10n = AppLocalizations.of(context);
    final suggested = DefaultTemplates.all;
    return Showcase(
      key: WalkthroughKeys.templatesQuickStart,
      description: l10n.walkthroughQuickStartTemplates,
      targetBorderRadius: BorderRadius.circular(16),
      targetPadding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.quickStartTemplates,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: c.colorPrimary,
                ),
              ),
              Icon(Icons.auto_awesome, color: c.colorPrimary, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: suggested.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final t = suggested[index];
                return _buildSuggestedCard(c, isDark, t, l10n);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedCard(AppColorScheme c, bool isDark, Template t, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => _addSuggested(t),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? c.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.colorPrimary.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: c.colorPrimary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                AppIcons.getIcon(t.iconCodePoint),
                color: c.colorPrimary,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              getLocalizedTemplateName(t.id, t.name, l10n),
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: c.textDark,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              AppLocalizations.of(context).fieldsCount(t.fields.length),
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: c.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/locale/locale_provider.dart';
import '../../../core/theme/common_methods.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../main.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  late String _selectedLanguage;

  final _languages = const [
    _LangItem(code: 'en', name: 'English', subtitle: 'Default', icon: 'EN'),
    _LangItem(code: 'hi', name: 'Hindi', subtitle: 'हिंदी', icon: 'अ'),
    _LangItem(code: 'gu', name: 'Gujarati', subtitle: 'ગુજરાતી', icon: 'ગ'),
    _LangItem(code: 'mr', name: 'Marathi', subtitle: 'मराठी', icon: 'म'),
    _LangItem(code: 'ta', name: 'Tamil', subtitle: 'தமிழ்', icon: 'த'),
    _LangItem(code: 'te', name: 'Telugu', subtitle: 'తెలుగు', icon: 'త'),
    _LangItem(code: 'kn', name: 'Kannada', subtitle: 'ಕನ್ನಡ', icon: 'ಕ'),
    _LangItem(code: 'bn', name: 'Bengali', subtitle: 'বাংলা', icon: 'ব'),
    _LangItem(code: 'pa', name: 'Punjabi', subtitle: 'ਪੰਜਾਬੀ', icon: 'ਪ'),
    _LangItem(code: 'ur', name: 'Urdu', subtitle: 'اردو', icon: 'ا'),
  ];

  @override
  void initState() {
    super.initState();
    // Pre-select current language
    _selectedLanguage = appLocaleProvider.locale.languageCode;
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
          // ── Gradient background ───────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.40,
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

          // ── Fully scrollable body ──────────────────────────────────────
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
              children: [
                // ── Header ───────────────────────────────────────────────
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark ? c.cardDark : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(Icons.arrow_back_ios_new,
                            color: c.textDark, size: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.selectLanguageTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: c.textDark.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          l10n.language,
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: c.textDark,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 52),
                  child: Text(
                    l10n.chooseLanguage,
                    style: GoogleFonts.poppins(fontSize: 13, color: c.gray),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Language options ──────────────────────────────────────
                ..._languages.map(
                  (lang) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildLangOption(c, isDark, lang),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Save button ───────────────────────────────────────────
                GestureDetector(
                  onTap: () async {
                    await appLocaleProvider.setLocale(Locale(_selectedLanguage));
                    if (context.mounted) {
                      final name = LocaleProvider.codeToName[_selectedLanguage] ?? _selectedLanguage;
                      showAppSnackBar(context, message: '${l10n.language}: $name');
                      context.pop();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: c.colorPrimary,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: c.colorPrimary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      l10n.saveLanguage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  Widget _buildLangOption(
      dynamic c, bool isDark, _LangItem lang) {
    final isSel = _selectedLanguage == lang.code;

    return GestureDetector(
      onTap: () => setState(() => _selectedLanguage = lang.code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSel
              ? c.colorPrimary.withValues(alpha: 0.06)
              : (isDark ? c.cardDark : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSel ? c.colorPrimary : c.divider.withValues(alpha: 0.4),
            width: isSel ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (!isSel)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSel
                    ? c.colorPrimary.withValues(alpha: 0.1)
                    : c.gray.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                lang.icon,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSel ? c.colorPrimary : c.gray,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.name,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: c.textDark,
                    ),
                  ),
                  Text(
                    lang.subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isSel ? c.colorPrimary : c.gray,
                    ),
                  ),
                ],
              ),
            ),
            if (isSel)
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: c.colorPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              )
            else
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: c.divider),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LangItem {
  final String code;
  final String name;
  final String subtitle;
  final String icon;
  const _LangItem({
    required this.code,
    required this.name,
    required this.subtitle,
    required this.icon,
  });
}

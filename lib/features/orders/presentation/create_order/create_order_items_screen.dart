import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../routes/app_router.dart';
import '../../../templates/presentation/bloc/template_bloc.dart';
import '../../../templates/presentation/bloc/template_event.dart';
import '../../../templates/presentation/bloc/template_state.dart';
import '../../../templates/domain/entities/template.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';

import '../../../../core/utils/snackbar_utils.dart';

import '../../../../core/utility/dependency_injection.dart';
import '../bloc/order_wizard_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../onboarding/presentation/bloc/walkthrough_cubit.dart';
import '../../../onboarding/presentation/utils/walkthrough_keys.dart';

class CreateOrderItemsScreen extends StatefulWidget {
  const CreateOrderItemsScreen({super.key});

  @override
  State<CreateOrderItemsScreen> createState() => _CreateOrderItemsScreenState();
}

class _CreateOrderItemsScreenState extends State<CreateOrderItemsScreen> {
  late Set<String> _selectedGarments;
  late Map<String, int> _garmentQuantities;
  late String _specialInstructions;
  List<Template> _allTemplates = [];
  File? _imageFile;
  String? _remoteImagePath;
  final TextEditingController _instructionsCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool _hasShownQuantityGuide = false;

  @override
  void initState() {
    super.initState();
    context.read<TemplateBloc>().add(LoadTemplates());
    final d = getIt<OrderWizardBloc>().state.formData;
    _selectedGarments = Set.from(d.garmentTypes);
    _garmentQuantities = Map.from(d.garmentQuantities);
    // Ensure all selected garments have at least qty 1
    for (var g in _selectedGarments) {
      _garmentQuantities.putIfAbsent(g, () => 1);
    }
    _specialInstructions = d.specialInstructions;
    _instructionsCtrl.text = _specialInstructions;
    _imageFile = d.referenceImageFile;
    _remoteImagePath = d.referenceImagePath;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walkthroughState = context.read<WalkthroughCubit>().state;
      if (walkthroughState is WalkthroughStepCreateOrder) {
        ShowcaseView.get().startShowCase([
          WalkthroughKeys.createOrderSelectGarments,
        ]);
      }
    });
  }

  @override
  void dispose() {
    _instructionsCtrl.dispose();
    ShowcaseView.get().dismiss();
    super.dispose();
  }

  Future<File> _saveToLocalFolder(File originalFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final String fileName = path.basename(originalFile.path);
    final String localPath = path.join(directory.path, fileName);
    return originalFile.copy(localPath);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final savedFile = await _saveToLocalFolder(File(pickedFile.path));
        setState(() {
          _imageFile = savedFile;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _openMeasurements() {
    if (_selectedGarments.isEmpty) {
      showAppSnackBar(
        context,
        message: AppLocalizations.of(context).selectAtLeastOneGarment,
      );
      return;
    }

    double calculatedTotal = 0;

    final currentData = getIt<OrderWizardBloc>().state.formData;

    Map<String, double> existingPrices = Map.from(currentData.garmentPrices);
    Map<String, double> garmentPrices = {};
    Map<String, int> garmentQuantities = {};

    for (final templateId in _selectedGarments) {
      final qty = _garmentQuantities[templateId] ?? 1;
      final template = _allTemplates.firstWhere(
        (t) => t.id == templateId || t.name == templateId,
        orElse: () => Template(
          id: templateId,
          name: templateId,
          category: 'Other',
          iconCodePoint: 0,
          fields: const [],
          basePrice: 0.0,
        ),
      );
      final name = template.name;

      garmentQuantities[name] = qty;

      if (!existingPrices.containsKey(name) && !existingPrices.containsKey(templateId)) {
        garmentPrices[name] = template.basePrice * qty;
      } else {
        final existingPrice = existingPrices[name] ?? existingPrices[templateId] ?? (template.basePrice * qty);
        final oldQty = currentData.garmentQuantities[name] ?? currentData.garmentQuantities[templateId] ?? 1;
        if (qty != oldQty && oldQty > 0) {
          final unitPrice = existingPrice / oldQty;
          garmentPrices[name] = unitPrice * qty;
        } else {
          garmentPrices[name] = existingPrice;
        }
      }

      calculatedTotal += garmentPrices[name]!;
    }

    final selectedTemplateNames = _selectedGarments.map((id) {
      final template = _allTemplates.firstWhere(
        (t) => t.id == id || t.name == id,
        orElse: () => Template(
          id: id,
          name: id,
          category: 'Other',
          iconCodePoint: 0,
          fields: const [],
          basePrice: 0.0,
        ),
      );
      return template.name;
    }).toList();

    final updated = currentData.copyWith(
      garmentTypes: selectedTemplateNames,
      garmentPrices: garmentPrices,
      garmentQuantities: garmentQuantities,
      specialInstructions: _instructionsCtrl.text.trim(),
      referenceImageFile: _imageFile,
      totalAmount: calculatedTotal,
    );

    getIt<OrderWizardBloc>().add(UpdateOrderData(updated));

    context.push(
      AppRoutes.createOrderMeasurements,
      extra: {'garmentTypes': selectedTemplateNames, 'isOrderFlow': true},
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);

    final topGradientColor = Theme.of(context).brightness == Brightness.dark
        ? c.colorPrimaryDark.withValues(alpha: 0.8)
        : c.colorAccent.withValues(alpha: 0.95);
    final midGradientColor = Theme.of(context).brightness == Brightness.dark
        ? c.colorPrimaryDark.withValues(alpha: 0.4)
        : c.colorAccent.withValues(alpha: 0.2);

    return Scaffold(
      backgroundColor: c.background,
      body: Stack(
        children: [
          // Smooth fade-out background gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    topGradientColor,
                    midGradientColor,
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
                _buildHeader(c),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    children: [
                      BlocConsumer<TemplateBloc, TemplateState>(
                        listener: (context, state) {
                          if (state is TemplatesLoaded) {
                            _allTemplates = state.templates;
                          }
                        },
                        builder: (context, templateState) {
                          List<Template> templates = [];

                          if (templateState is TemplatesLoaded) {
                            templates = templateState.templates;
                          }

                          return _buildItemSection(c, templates);
                        },
                      ),
                      const SizedBox(height: 32),
                      _buildNextStepButton(c),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppColorScheme c) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                getIt<OrderWizardBloc>().state.formData.isEditing
                    ? '${AppLocalizations.of(context).order.toUpperCase()} #${getIt<OrderWizardBloc>().state.formData.existingOrderRef?.substring(0, 8).toUpperCase()}'
                    : AppLocalizations.of(context).newOrder,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: c.textDark.withValues(alpha: 0.7),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.more_horiz, color: c.textDark, size: 20),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context).addOrderItems,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: c.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).selectGarmentsDesign,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: c.textDark.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).step2of5,
                style: GoogleFonts.poppins(fontSize: 12, color: c.textDark),
              ),
              Text(
                '40%',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: c.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress Bar (Shop Setup Style)
          Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                  height: 5,
                  decoration: BoxDecoration(
                    color: index <= 1
                        ? c.colorPrimary
                        : c.colorPrimary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildItemSection(AppColorScheme c, List<Template> garmentOptions) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : c.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: c.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: c.divider.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.checkroom, color: c.colorPrimary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).itemX(1),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: c.textDark,
                    ),
                  ),
                ],
              ),
              // We only have 1 item, so hide Remove button
              // Text('Remove', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: c.red)),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context).garmentTypeCap,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: c.textDark.withValues(alpha: 0.6),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context).selectAllApply,
            style: GoogleFonts.poppins(fontSize: 12, color: c.gray),
          ),
          const SizedBox(height: 12),
          Showcase(
            key: WalkthroughKeys.createOrderSelectGarments,
            description: AppLocalizations.of(context).walkthroughSelectGarments,
            targetBorderRadius: BorderRadius.circular(16),
            targetPadding: const EdgeInsets.all(6),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: garmentOptions.map((garment) {
                final isSelected = _selectedGarments.contains(garment.id);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedGarments.remove(garment.id);
                        _garmentQuantities.remove(garment.id);
                      } else {
                        _selectedGarments.add(garment.id);
                        _garmentQuantities[garment.id] = 1;

                        // Trigger quantity guide if walkthrough is active and we haven't shown it yet
                        final walkthroughState = context
                            .read<WalkthroughCubit>()
                            .state;
                        if (walkthroughState is WalkthroughStepCreateOrder &&
                            !_hasShownQuantityGuide) {
                          _hasShownQuantityGuide = true;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ShowcaseView.get().startShowCase([
                              WalkthroughKeys.createOrderSetQuantities,
                            ]);
                          });
                        }
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? c.colorPrimary
                          : (isDark ? c.cardDark : c.background),
                      border: Border.all(
                        color: isSelected ? c.colorPrimary : c.divider,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected) ...[
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          getLocalizedTemplateName(
                            garment.id,
                            garment.name,
                            AppLocalizations.of(context),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected ? Colors.white : c.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (_selectedGarments.isNotEmpty) ...[
            const SizedBox(height: 24),
            Showcase(
              key: WalkthroughKeys.createOrderSetQuantities,
              description: AppLocalizations.of(
                context,
              ).walkthroughSetQuantities,
              targetBorderRadius: BorderRadius.circular(16),
              targetPadding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).quantitiesCap,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: c.textDark.withValues(alpha: 0.6),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._selectedGarments.map((templateId) {
                    final template = garmentOptions.firstWhere(
                      (t) => t.id == templateId || t.name == templateId,
                      orElse: () => Template(
                        id: templateId,
                        name: templateId,
                        category: 'Other',
                        iconCodePoint: 0,
                        fields: const [],
                        basePrice: 0.0,
                      ),
                    );

                    final qty = _garmentQuantities[templateId] ?? 1;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? c.background
                            : c.grayLight.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: c.divider.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.checkroom,
                            size: 18,
                            color: c.colorPrimary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              getLocalizedTemplateName(
                                template.id,
                                template.name,
                                AppLocalizations.of(context),
                              ),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: c.textDark,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  size: 20,
                                  color: qty > 1 ? c.colorPrimary : c.gray,
                                ),
                                onPressed: qty > 1
                                    ? () {
                                        setState(
                                          () => _garmentQuantities[templateId] =
                                              qty + 1,
                                        );
                                      }
                                    : null,
                              ),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  qty.toString(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: c.textDark,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                  color: c.colorPrimary,
                                ),
                                onPressed: () {
                                  setState(
                                    () => _garmentQuantities[templateId] =
                                        qty + 1,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Measurements button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openMeasurements,
                icon: Icon(Icons.straighten, color: c.colorPrimary, size: 18),
                label: Text(
                  AppLocalizations.of(
                    context,
                  ).takeMeasurementsWithCount(_selectedGarments.length),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.colorPrimary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: c.colorPrimary.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          Text(
            AppLocalizations.of(context).designDetails,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: c.textDark,
            ),
          ),
          const SizedBox(height: 16),
          // Dotted Box
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: isDark ? c.cardDark : c.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) => _buildImagePickerBottomSheet(c),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: _imageFile != null
                  ? EdgeInsets.zero
                  : const EdgeInsets.all(24),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: c.colorPrimaryLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: c.colorPrimary.withValues(alpha: 0.3),
                  style: BorderStyle.solid,
                ),
              ),
              child: _imageFile != null
                  ? Stack(
                      children: [
                        Image.file(
                          _imageFile!,
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: InkWell(
                            onTap: () => setState(() {
                              _imageFile = null;
                              _remoteImagePath = null;
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : _remoteImagePath != null
                  ? Stack(
                      children: [
                        Image.network(
                          _remoteImagePath!,
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, _, _) => Container(
                            width: double.infinity,
                            height: 150,
                            color: c.divider.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: c.gray,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: InkWell(
                            onTap: () => setState(() {
                              _imageFile = null;
                              _remoteImagePath = null;
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: c.colorPrimaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: c.colorPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            AppLocalizations.of(context).addReferencePhoto,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: c.colorPrimaryDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context).uploadPatternHint,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: c.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context).specialInstructionsCap,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: c.textDark.withValues(alpha: 0.6),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _instructionsCtrl,
            maxLines: 4,
            style: GoogleFonts.poppins(fontSize: 14, color: c.textDark),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).specialInstructionsHint,
              hintStyle: GoogleFonts.poppins(fontSize: 13, color: c.gray),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: c.divider.withValues(alpha: 0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: c.divider.withValues(alpha: 0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: c.colorPrimary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerBottomSheet(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).addReferencePhoto,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: c.textDark,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPickerOption(
                c,
                Icons.camera_alt,
                AppLocalizations.of(context).camera,
                () {
                  context.pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              _buildPickerOption(
                c,
                Icons.photo_library,
                AppLocalizations.of(context).gallery,
                () {
                  context.pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPickerOption(
    AppColorScheme c,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.colorPrimaryLight.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: c.colorPrimary, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: c.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepButton(AppColorScheme c) {
    return SizedBox(
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
          _openMeasurements();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _selectedGarments.isNotEmpty
                  ? AppLocalizations.of(context).nextMeasurements
                  : AppLocalizations.of(context).nextStep,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

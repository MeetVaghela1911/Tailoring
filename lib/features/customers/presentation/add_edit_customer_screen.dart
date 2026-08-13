import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:uuid/uuid.dart';

import '../../../core/utils/snackbar_utils.dart';

import '../../../core/service/storage_service.dart';
import '../../../core/utility/dependency_injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_action_bar.dart';
import '../domain/entities/customer.dart';
import 'bloc/customer_bloc.dart';
import 'bloc/customer_event.dart';
import 'bloc/customer_state.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../onboarding/presentation/utils/walkthrough_keys.dart';
import '../../onboarding/presentation/bloc/walkthrough_cubit.dart';
import '../../orders/presentation/bloc/order_bloc.dart';
import '../../orders/presentation/bloc/order_event.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final Customer? customer;

  const AddEditCustomerScreen({super.key, this.customer});

  @override
  State<AddEditCustomerScreen> createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _notesCtrl;
  File? _imageFile;
  final _picker = ImagePicker();
  bool _isUploading = false;

  bool get _isEditing => widget.customer != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.customer?.name);
    _phoneCtrl = TextEditingController(text: widget.customer?.phoneNumber);
    _emailCtrl = TextEditingController(text: widget.customer?.email);
    _addressCtrl = TextEditingController(text: widget.customer?.address);
    _notesCtrl = TextEditingController(text: widget.customer?.notes);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted && !_isEditing) {
        final walkthroughState = context.read<WalkthroughCubit>().state;
        if (walkthroughState is WalkthroughStepCreateCustomer) {
          ShowcaseView.get().startShowCase([
            WalkthroughKeys.addCustomerNameField,
            WalkthroughKeys.addCustomerPhoneField,
            WalkthroughKeys.addCustomerSaveButton,
          ]);
        }
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    ShowcaseView.get().dismiss();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imageFile = File(image.path));
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);
    String? imageUrl = widget.customer?.profileImageUrl;

    try {
      if (_imageFile != null) {
        final storage = getIt<StorageService>();
        final fileName = 'customer_${DateTime.now().millisecondsSinceEpoch}.jpg';
        imageUrl = await storage.uploadImage(
          file: _imageFile!,
          bucket: 'customer_profiles',
          fileName: fileName,
        );
      }

      final customer = Customer(
        id: _isEditing ? widget.customer!.id : const Uuid().v4(),
        name: _nameCtrl.text.trim(),
        phoneNumber: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        address: _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        createdAt: _isEditing ? widget.customer!.createdAt : DateTime.now(),
        colorHex: _isEditing ? widget.customer!.colorHex : _generateRandomColorHex(),
        profileImageUrl: imageUrl,
      );

      if (!mounted) return;
      if (_isEditing) {
        context.read<CustomerBloc>().add(UpdateCustomer(customer));
      } else {
        context.read<CustomerBloc>().add(AddCustomer(customer));
      }
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(context, message: 'Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  String _generateRandomColorHex() {
    final colors = ['#FFCCBC', '#C8E6C9', '#BBDEFB', '#E1BEE7', '#F8BBD0', '#FFD180'];
    return colors[DateTime.now().millisecond % colors.length];
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

    return BlocListener<CustomerBloc, CustomerState>(
      listener: (context, state) {
        if (state is CustomerAddSuccess || state is CustomerUpdateSuccess || state is CustomerDeleteSuccess) {
          final l10n = AppLocalizations.of(context);
          String message = 'Operation successful';
          if (state is CustomerAddSuccess) message = l10n.customerAdded;
          if (state is CustomerUpdateSuccess) {
            message = l10n.customerUpdated;
            context.read<OrderBloc>().add(LoadOrders());
          }
          if (state is CustomerDeleteSuccess) {
            message = l10n.customerDeleted;
            context.read<OrderBloc>().add(LoadOrders());
          }
          
          showAppSnackBar(context, message: message);
          context.pop(true);
        } else if (state is CustomerError) {
          showAppSnackBar(context, message: state.message, isError: true);
        }
      },
      child: Scaffold(
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
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Center(
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: c.colorPrimary.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: c.colorPrimary, width: 2),
                                        image: _imageFile != null
                                            ? DecorationImage(
                                                image: FileImage(_imageFile!),
                                                fit: BoxFit.cover,
                                              )
                                            : (widget.customer?.profileImageUrl != null
                                                ? DecorationImage(
                                                    image: NetworkImage(widget.customer!.profileImageUrl!),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null),
                                      ),
                                      child: _imageFile == null && widget.customer?.profileImageUrl == null
                                          ? Icon(Icons.person_add_alt_1_outlined, size: 40, color: c.colorPrimary)
                                          : null,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: c.colorPrimary,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                        child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildField(
                              label: l10n.fullName,
                              controller: _nameCtrl,
                              hint: 'e.g. John Doe',
                              icon: Icons.person_outline,
                              validator: (v) => v == null || v.isEmpty ? l10n.nameRequired : null,
                              c: c,
                              isDark: isDark,
                              showcaseKey: WalkthroughKeys.addCustomerNameField,
                              showcaseDesc: l10n.walkthroughCustName,
                            ),
                            const SizedBox(height: 20),
                            _buildField(
                              label: l10n.phone,
                              controller: _phoneCtrl,
                              hint: 'e.g. +91 98765 43210',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (v) => v == null || v.isEmpty ? l10n.phoneRequired : null,
                              c: c,
                              isDark: isDark,
                              showcaseKey: WalkthroughKeys.addCustomerPhoneField,
                              showcaseDesc: l10n.walkthroughCustPhone,
                            ),
                            const SizedBox(height: 20),
                            _buildField(
                              label: AppLocalizations.of(context).emailOptional,
                              controller: _emailCtrl,
                              hint: 'e.g. john@example.com',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              c: c,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 20),
                            _buildField(
                              label: AppLocalizations.of(context).addressOptional,
                              controller: _addressCtrl,
                              hint: 'e.g. 123 Street, City',
                              icon: Icons.location_on_outlined,
                              maxLines: 2,
                              c: c,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 20),
                            _buildField(
                              label: AppLocalizations.of(context).notesOptional,
                              controller: _notesCtrl,
                              hint: 'e.g. Preferred delivery time 5 PM',
                              icon: Icons.note_alt_outlined,
                              maxLines: 3,
                              c: c,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 40),
                            BlocBuilder<CustomerBloc, CustomerState>(
                              builder: (context, state) {
                                final bool isLoading = state is CustomerLoading || _isUploading;
                                if (_isEditing) {
                                  return AppActionBar(
                                    isEditing: true,
                                    saveLabel: AppLocalizations.of(context).updateCustomer,
                                    onEditSaveTap: () {
                                      if (isLoading) return;
                                      _onSave();
                                    },
                                    onDeleteTap: () {
                                      if (isLoading) return;
                                      _onDelete();
                                    },
                                  );
                                } else {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: Showcase(
                                      key: WalkthroughKeys.addCustomerSaveButton,
                                      description: l10n.walkthroughCustSave,
                                      targetBorderRadius: BorderRadius.circular(18),
                                      targetPadding: const EdgeInsets.all(6),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: c.colorPrimary,
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18)),
                                          elevation: 0,
                                        ),
                                        onPressed: isLoading ? null : _onSave,
                                        child: isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                              )
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.check, color: Colors.white, size: 20),
                                                  const SizedBox(width: 8),
                                                  Text(AppLocalizations.of(context).saveCustomer,
                                                      style: GoogleFonts.poppins(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white)),
                                                ],
                                              ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
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

  void _onDelete() {
    final c = getThemeBaseColors(context);
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? c.cardDark
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.customerDeletedTitle, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: c.textDark)),
        content: Text(
          l10n.customerDeleteConfirm(widget.customer!.name),
          style: GoogleFonts.poppins(fontSize: 13, color: c.gray),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(l10n.cancel, style: GoogleFonts.poppins(color: c.gray)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              context.read<CustomerBloc>().add(DeleteCustomer(widget.customer!.id));
              context.pop();
            },
            child: Text(l10n.delete, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppColorScheme c, bool isDark) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          const AppBackButton(),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.customers.toUpperCase(), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: c.textDark.withValues(alpha: 0.6))),
              Text(_isEditing ? AppLocalizations.of(context).editCustomer : AppLocalizations.of(context).addCustomer, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: c.textDark, height: 1.2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required AppColorScheme c,
    required bool isDark,
    GlobalKey? showcaseKey,
    String? showcaseDesc,
  }) {
    Widget inputField = Container(
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.poppins(fontSize: 14, color: c.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(fontSize: 13, color: c.gray.withValues(alpha: 0.5)),
          prefixIcon: Icon(icon, color: c.gray, size: 20),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          isDense: true,
        ),
      ),
    );

    if (showcaseKey != null && showcaseDesc != null) {
      inputField = Showcase(
        key: showcaseKey,
        description: showcaseDesc,
        targetBorderRadius: BorderRadius.circular(16),
        targetPadding: const EdgeInsets.all(6),
        child: inputField,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: c.textDark.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        inputField,
      ],
    );
  }
}

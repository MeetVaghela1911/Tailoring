import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/common_methods.dart';
import '../../../../core/widgets/app_back_button.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../routes/app_router.dart';
import '../../../../core/utility/dependency_injection.dart';
import '../bloc/order_wizard_bloc.dart';
import '../../../../core/utils/snackbar_utils.dart';

class CreateOrderScheduleScreen extends StatefulWidget {
  const CreateOrderScheduleScreen({super.key});

  @override
  State<CreateOrderScheduleScreen> createState() =>
      _CreateOrderScheduleScreenState();
}

class _CreateOrderScheduleScreenState extends State<CreateOrderScheduleScreen> {
  late int _priorityIndex;
  late DateTime? _selectedDate;
  late String _selectedTailor;
  bool _applySurcharge = false;

  @override
  void initState() {
    super.initState();
    final d = getIt<OrderWizardBloc>().state.formData;
    _priorityIndex = d.priorityIndex;
    _selectedDate = d.deliveryDate;
    _selectedTailor = d.assignedTailor;
    _applySurcharge = d.externalCharges > 0;
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
                      _buildScheduleSection(c),
                      const SizedBox(height: 24),
                      _buildPrioritySection(c),
                      const SizedBox(height: 24),
                      // _buildTailorSection(c),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppBackButton(onTap: () => context.pop()),
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
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context).scheduleAndAssign,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: c.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).setDeliveryExpectations,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: c.textDark.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).step4of5,
                style: GoogleFonts.poppins(fontSize: 12, color: c.textDark),
              ),
              Text(
                '80%',
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
                    color: index <= 3
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

  Widget _buildScheduleSection(AppColorScheme c) {
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
            children: [
              Icon(Icons.calendar_today, color: c.colorPrimary, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).estimatedDelivery,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: c.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() => _selectedDate = date);
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? c.black.withValues(alpha: 0.2) : c.grayLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month, color: c.gray, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null
                            ? AppLocalizations.of(context).selectDeliveryDate
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: _selectedDate == null
                              ? FontWeight.w500
                              : FontWeight.bold,
                          color: _selectedDate == null
                              ? c.gray
                              : c.colorPrimary,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.edit_calendar, color: c.colorPrimary, size: 20),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 16),
          // Container(
          //   padding: const EdgeInsets.all(12),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFFFF3E0),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Icon(
          //         Icons.warning_amber_rounded,
          //         color: Colors.orange,
          //         size: 18,
          //       ),
          //       const SizedBox(width: 8),
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               AppLocalizations.of(context).highCapacityDay,
          //               style: GoogleFonts.poppins(
          //                 fontSize: 12,
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.orange[800],
          //               ),
          //             ),
          //             Text(
          //               AppLocalizations.of(context).shopFloorLoadHint,
          //               style: GoogleFonts.poppins(
          //                 fontSize: 11,
          //                 color: Colors.orange[700],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPrioritySection(AppColorScheme c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.speed, color: c.colorPrimary, size: 20),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).priorityLevel,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: c.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _priorityChip(c, 1, AppLocalizations.of(context).normal),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _priorityChip(
                c,
                2,
                AppLocalizations.of(context).high,
                color: c.colorPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _priorityChip(
                c,
                3,
                AppLocalizations.of(context).urgent,
                color: c.red,
              ),
            ),
          ],
        ),
        if (_priorityIndex > 1) ...[
          const SizedBox(height: 12),
          InkWell(
            onTap: () => setState(() => _applySurcharge = !_applySurcharge),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? c.black.withValues(alpha: 0.2)
                    : c.grayLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _applySurcharge
                      ? c.colorPrimary
                      : c.divider.withValues(alpha: 0.4),
                  width: _applySurcharge ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Checkbox(
                      value: _applySurcharge,
                      onChanged: (v) =>
                          setState(() => _applySurcharge = v ?? false),
                      activeColor: c.colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add 15% Priority Surcharge',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: c.textDark,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(
                            context,
                          ).highPrioritySurchargeHint,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: c.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _priorityChip(
    AppColorScheme c,
    int index,
    String label, {
    Color? color,
  }) {
    bool isSelected = _priorityIndex == index;
    Color primary = color ?? c.textDark;
    return GestureDetector(
      onTap: () => setState(() => _priorityIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? primary : c.divider,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? primary : c.textDark.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildTailorSection(AppColorScheme c) {
    final tailors = [
      'Unassigned',
      'Ramesh (Master)',
      'Suresh (Stitcher)',
      'Anita (Finisher)',
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_outline, color: c.colorPrimary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Assign to Tailor',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: c.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? c.black.withValues(alpha: 0.2) : c.grayLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: tailors.contains(_selectedTailor)
                  ? _selectedTailor
                  : 'Unassigned',
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: c.colorPrimary),
              dropdownColor: isDark ? c.background : Colors.white,
              items: tailors.map((t) {
                return DropdownMenuItem(
                  value: t,
                  child: Text(
                    t,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: c.textDark,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedTailor = v);
              },
            ),
          ),
        ),
      ],
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
          if (_selectedDate == null) {
            showAppSnackBar(
              context,
              message: AppLocalizations.of(context).pleaseSelectDeliveryDate,
              isError: true,
            );
            return;
          }
          final currentData = getIt<OrderWizardBloc>().state.formData;
          double surchargeAmount = 0.0;
          if (_priorityIndex > 1 && _applySurcharge) {
            double itemSum = 0.0;
            currentData.garmentPrices.forEach((key, price) {
              final qty = currentData.garmentQuantities[key] ?? 1;
              itemSum += (price * qty);
            });
            surchargeAmount = itemSum * 0.15;
          }

          final updated = currentData.copyWith(
            priorityIndex: _priorityIndex,
            deliveryDate: _selectedDate,
            assignedTailor: _selectedTailor,
            externalCharges: surchargeAmount,
          );
          getIt<OrderWizardBloc>().add(UpdateOrderData(updated));
          context.push(AppRoutes.createOrderPayment);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).nextStep,
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

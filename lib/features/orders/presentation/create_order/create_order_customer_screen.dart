import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../routes/app_router.dart';
import '../../data/order_form_data.dart';
import '../../../../core/utility/dependency_injection.dart';
import '../bloc/order_wizard_bloc.dart';
import '../../../../features/customers/presentation/bloc/customer_bloc.dart';
import '../../../../features/customers/presentation/bloc/customer_event.dart';
import '../../../../features/customers/presentation/bloc/customer_state.dart';
import '../../../../features/customers/domain/entities/customer.dart';
import '../../../onboarding/presentation/bloc/walkthrough_cubit.dart';
import '../../../onboarding/presentation/utils/walkthrough_keys.dart';
import '../../../../core/utils/snackbar_utils.dart';
import 'package:showcaseview/showcaseview.dart';

class CreateOrderCustomerScreen extends StatefulWidget {
  const CreateOrderCustomerScreen({super.key});

  @override
  State<CreateOrderCustomerScreen> createState() =>
      _CreateOrderCustomerScreenState();
}

class _CreateOrderCustomerScreenState extends State<CreateOrderCustomerScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  late OrderFormData _formData;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _formData = getIt<OrderWizardBloc>().state.formData;
    context.read<CustomerBloc>().add(LoadCustomers());
    _searchCtrl.addListener(() {
      setState(() {
        _searchQuery = _searchCtrl.text.toLowerCase();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getIt<OrderWizardBloc>().state.formData.isEditing) {
        context.push(AppRoutes.createOrderItems);
      }
    });
  }

  void _selectCustomer(Customer customer) {
    final updated = _formData.copyWith(
      customerName: customer.name,
      customerPhone: customer.phoneNumber,
      customerId: customer.id,
    );
    getIt<OrderWizardBloc>().add(UpdateOrderData(updated));
    context.push(AppRoutes.createOrderItems);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    ShowcaseView.get().dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final topGradientColor = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.8)
        : c.colorAccent.withValues(alpha: 0.95);
    final midGradientColor = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.4)
        : c.colorAccent.withValues(alpha: 0.2);

    return Scaffold(
      backgroundColor: c.background,
      body: Stack(
        children: [
          // Smooth fade-out background gradient like Home Dashboard
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
                  child: BlocListener<CustomerBloc, CustomerState>(
                    listener: (context, state) {
                      if (state is CustomersLoaded) {
                        if (state.customers.isEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showAppSnackBar(
                              context,
                              message: AppLocalizations.of(context).addFirstCustomer,
                              isError: true,
                            );
                            context.replace(AppRoutes.addCustomer);
                          });
                        } else {
                          final walkthroughState = context.read<WalkthroughCubit>().state;
                          if (walkthroughState is WalkthroughStepCreateOrder) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ShowcaseView.get().startShowCase([WalkthroughKeys.createOrderSelectCustomer]);
                            });
                          }
                        }
                      }
                    },
                    child: RefreshIndicator(
                    color: c.colorPrimary,
                    onRefresh: () async {
                      final bloc = context.read<CustomerBloc>();
                      bloc.add(LoadCustomers());
                      await bloc.stream.firstWhere(
                        (s) => s is CustomersLoaded || s is CustomerError,
                      );
                    },
                    child: BlocBuilder<CustomerBloc, CustomerState>(
                      builder: (context, state) {
                        if (state is CustomerLoading) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                          );
                        } else if (state is CustomersLoaded) {
                          final filteredCustomers = state.customers.where((cust) {
                            return cust.name.toLowerCase().contains(_searchQuery) ||
                                cust.phoneNumber.contains(_searchQuery);
                          }).toList();

                          if (filteredCustomers.isEmpty) {
                            return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.4,
                                child: _buildEmptyState(c),
                              ),
                            );
                          }

                          return ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 24,
                            ),
                            itemCount: filteredCustomers.length + (getIt<OrderWizardBloc>().state.formData.customerId != null ? 2 : 1),
                            itemBuilder: (context, index) {
                              if (index == 0 && getIt<OrderWizardBloc>().state.formData.customerId != null) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).selectedCustomer,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: c.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildSelectedCustomerCard(c, getIt<OrderWizardBloc>().state.formData),
                                    const SizedBox(height: 24),
                                  ],
                                );
                              }
                              final headerIndex = getIt<OrderWizardBloc>().state.formData.customerId != null ? 1 : 0;
                              if (index == headerIndex) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: _buildRecentCustomersHeader(c),
                                );
                              }
                              final customer = filteredCustomers[index - (headerIndex + 1)];
                              return _buildCustomerCard(c, customer);
                            },
                          );
                        } else if (state is CustomerError) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Center(child: Text(state.message)),
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(),
                        );
                      },
                    ),
                  ),
                ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildCreateNewCustomerButton(c),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppColorScheme c) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: c.gray.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).noCustomersFound,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: c.textDark,
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
              AppBackButton(onTap: () => context.pop()),
              Text(
                getIt<OrderWizardBloc>().state.formData.isEditing
                    ? '${AppLocalizations.of(context).order.toUpperCase()} #${getIt<OrderWizardBloc>().state.formData.existingOrderRef?.substring(0, 8).toUpperCase()}'
                    : AppLocalizations.of(context).newOrder,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: c.textDark,
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).selectCustomer,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: c.textDark,
                ),
              ),
              Text(
                AppLocalizations.of(context).step1of5,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: c.textDark.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                  height: 5,
                  decoration: BoxDecoration(
                    color: index <= 0
                        ? c.colorPrimary
                        : c.colorPrimary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          // Search Bar
          Showcase(
            key: WalkthroughKeys.createOrderSelectCustomer,
            description: AppLocalizations.of(context).selectCustomer,
            targetBorderRadius: BorderRadius.circular(16),
            targetPadding: const EdgeInsets.all(6),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? c.cardDark : c.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: c.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: c.divider.withValues(alpha: 0.3)),
              ),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).searchCustomerHint,
                  hintStyle: GoogleFonts.poppins(color: c.gray, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: c.gray),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCustomersHeader(AppColorScheme c) {
    return Text(
      AppLocalizations.of(context).recentCustomers,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: c.textDark,
      ),
    );
  }

  Widget _buildCustomerCard(AppColorScheme c, Customer customer) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isSelected = _formData.customerId == customer.id;
    String initials = customer.name.isNotEmpty 
        ? customer.name.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : c.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? c.colorPrimary : c.divider.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected ? c.colorPrimary.withValues(alpha: 0.1) : c.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: c.colorPrimary.withValues(alpha: 0.2),
            radius: 24,
            child: Text(
              initials,
              style: GoogleFonts.poppins(
                color: c.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            customer.name,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: c.textDark,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                Icon(Icons.phone, size: 12, color: c.gray),
                const SizedBox(width: 4),
                Text(
                  customer.phoneNumber,
                  style: GoogleFonts.poppins(fontSize: 12, color: c.gray),
                ),
              ],
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? c.colorPrimary.withValues(alpha: 0.1) : c.grayLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSelected ? Icons.check : Icons.arrow_forward_ios,
              size: 12,
              color: isSelected ? c.colorPrimary : c.gray,
            ),
          ),
          onTap: () => _selectCustomer(customer),
        ),
      ),
    );
  }

  Widget _buildSelectedCustomerCard(AppColorScheme c, OrderFormData data) {
    String initials = data.customerName != null && data.customerName!.isNotEmpty 
        ? data.customerName!.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return Container(
      decoration: BoxDecoration(
        color: c.colorPrimary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.colorPrimary.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: c.colorPrimary,
            radius: 24,
            child: Text(
              initials,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            data.customerName ?? AppLocalizations.of(context).unknown,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: c.textDark,
            ),
          ),
          subtitle: Text(
            data.customerPhone ?? '',
            style: GoogleFonts.poppins(fontSize: 12, color: c.gray),
          ),
          trailing: TextButton(
            onPressed: () {
              // Already selected, just move to next step
              context.push(AppRoutes.createOrderItems);
            },
            child: Text(
              AppLocalizations.of(context).keepSelected,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: c.colorPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateNewCustomerButton(AppColorScheme c) {
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
          context.push(AppRoutes.addCustomer);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).createNewCustomer,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

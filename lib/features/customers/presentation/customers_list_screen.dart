import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import '../../../routes/app_router.dart';
import '../domain/entities/customer.dart';
import 'bloc/customer_bloc.dart';
import 'bloc/customer_event.dart';
import 'bloc/customer_state.dart';
import '../../../core/widgets/app_empty_state.dart';

class CustomersListScreen extends StatefulWidget {
  const CustomersListScreen({super.key});

  @override
  State<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(LoadCustomers());
  }

  List<Customer> _filter(List<Customer> customers) {
    if (_searchQuery.isEmpty) return customers;
    return customers
        .where(
          (c) =>
              c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              c.phoneNumber.contains(_searchQuery),
        )
        .toList();
  }

  void _openAddCustomer() async {
    await context.push(AppRoutes.addCustomer);
  }

  void _openEditCustomer(Customer customer) async {
    await context.push(AppRoutes.editCustomer, extra: customer);
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'STITCH · BUSINESS',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: c.textDark.withValues(alpha: 0.6),
                                ),
                              ),
                              Text(
                                l10n.customers,
                                style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: c.textDark,
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 44),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? c.cardDark : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (v) => setState(() => _searchQuery = v),
                          style: GoogleFonts.poppins(fontSize: 14, color: c.textDark),
                          decoration: InputDecoration(
                            hintText: '${l10n.search}...',
                            hintStyle: GoogleFonts.poppins(color: c.gray, fontSize: 13),
                            prefixIcon: Icon(Icons.search, color: c.gray, size: 20),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<CustomerBloc, CustomerState>(
                    builder: (context, state) {
                      if (state is CustomerLoading) {
                        return Center(child: CircularProgressIndicator(color: c.colorPrimary));
                      } else if (state is CustomersLoaded) {
                        final filtered = _filter(state.customers);
                        
                        if (state.customers.isEmpty) {
                          return _buildEmptyState(c, l10n, Icons.people_outline, l10n.noCustomersFound, l10n.addFirstCustomer);
                        }

                        if (filtered.isEmpty) {
                          return _buildEmptyState(c, l10n, Icons.search_off, l10n.noCustomersFound, l10n.noMatchingCustomers);
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final customer = filtered[index];
                            return _CustomerCard(
                              customer: customer,
                              c: c,
                              isDark: isDark,
                              onTap: () => _openEditCustomer(customer),
                            );
                          },
                        );
                      } else if (state is CustomerError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 24,
            right: 20,
            child: GestureDetector(
              onTap: _openAddCustomer,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: c.colorPrimary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: c.colorPrimary.withValues(alpha: 0.45),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppColorScheme c, AppLocalizations l10n, IconData icon, String title, String subtitle) {
    return AppEmptyState(
      icon: icon,
      title: title,
      message: subtitle,
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Customer customer;
  final AppColorScheme c;
  final bool isDark;
  final VoidCallback onTap;

  const _CustomerCard({
    required this.customer,
    required this.c,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarColor = customer.colorHex != null 
        ? Color(int.parse(customer.colorHex!.replaceFirst('#', '0xFF'))) 
        : c.colorPrimary;
    
    final initials = customer.name.isNotEmpty 
        ? customer.name.trim().split(' ').where((s) => s.isNotEmpty).map((l) => l[0]).take(2).join().toUpperCase()
        : '?';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: isDark ? c.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -28, right: -28,
              child: Container(
                width: 96, height: 96,
                decoration: BoxDecoration(
                  color: avatarColor.withValues(alpha: 0.07),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      color: avatarColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: avatarColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                customer.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: c.textDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.chevron_right, color: c.gray.withValues(alpha: 0.5), size: 22),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          customer.phoneNumber,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: c.gray,
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (customer.email != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            customer.email!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: c.gray.withValues(alpha: 0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
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
}

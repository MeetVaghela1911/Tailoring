import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/common_methods.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/utility/dependency_injection.dart';
import '../../../../core/services/plan_service.dart';
import '../../../sync/domain/services/cloud_sync_service.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isLoading = false;
  late AppPlan _currentPlan;
  
  @override
  void initState() {
    super.initState();
    _currentPlan = getIt<PlanService>().currentPlan;
  }

  Future<void> _upgradeToPremium() async {
    setState(() => _isLoading = true);

    // Capture context-dependent values before async gap
    final authState = context.read<AuthBloc>().state;

    try {
      // 1. In a real app, integrate RevenueCat / Stripe here to buy the plan
      await Future.delayed(const Duration(seconds: 1)); // simulate purchasing...
      
      // 2. Update plan in Supabase database
      if (authState is AuthAuthenticated) {
        final client = getIt<supabase.SupabaseClient>();
        await client.from('profiles').update({'plan': 'premium'}).eq('id', authState.user.id);
      }
      
      // 3. Sync plan locally
      await getIt<PlanService>().setPlan(AppPlan.premium);
      
      // 4. Trigger data migration to cloud
      await getIt<CloudSyncService>().migrateLocalDataToCloud();
      
      setState(() {
        _currentPlan = AppPlan.premium;
        _isLoading = false;
      });

      if (!mounted) return;
      showAppSnackBar(context, message: 'Upgraded to Premium! Data Synced.');
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      showAppSnackBar(context, message: 'Failed to Upgrade: $e', isError: true);
    }
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Row(
                    children: [
                      const AppBackButton(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SUBSCRIPTION',
                                style: GoogleFonts.poppins(
                                    fontSize: 11, fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2, color: c.textDark.withValues(alpha: 0.6))),
                            Text('Data & Sync',
                                style: GoogleFonts.poppins(
                                    fontSize: 26, fontWeight: FontWeight.bold,
                                    color: c.textDark, height: 1.15)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildPlanCard(c, isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(color: c.colorPrimary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(AppColorScheme c, bool isDark) {
    final isPremium = _currentPlan == AppPlan.premium;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isPremium ? c.colorAccent : c.gray.withValues(alpha: 0.2), 
            width: isPremium ? 2 : 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16, offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isPremium ? 'Premium Plan' : 'Free Plan',
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: c.textDark),
              ),
              if (isPremium)
                Icon(Icons.cloud_done, color: c.colorAccent, size: 28)
              else 
                Icon(Icons.phone_android, color: c.gray, size: 28),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isPremium 
              ? 'Your data is safely synced to the cloud and available across all your linked devices.'
              : 'Your data is saved locally on this device only. If you uninstall the app or lose the device, your data will be lost.',
            style: GoogleFonts.poppins(fontSize: 14, color: c.gray, height: 1.5),
          ),
          const SizedBox(height: 24),
          
          if (!isPremium) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: c.colorPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: c.colorPrimary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Upgrade to Premium to unlock Cloud Sync, Unlimited Storage, and Multi-Device Support.',
                      style: GoogleFonts.poppins(fontSize: 13, color: c.colorPrimaryDark, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.colorPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: _upgradeToPremium,
                child: Text('Upgrade to Premium (\$9.99/mo)', 
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ] else ...[
             Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Active Subscription. Data is currently syncing to Supabase Cloud.',
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.green.shade800, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}

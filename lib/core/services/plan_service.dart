import 'package:shared_preferences/shared_preferences.dart';

enum AppPlan {
  free,
  premium,
}

class PlanService {
  final SharedPreferences _prefs;
  
  static const String _planKey = 'user_subscription_plan';

  PlanService(this._prefs);

  AppPlan get currentPlan {
    final planString = _prefs.getString(_planKey);
    if (planString == AppPlan.premium.name) {
      return AppPlan.premium;
    }
    return AppPlan.free;
  }

  bool get isPremium => currentPlan == AppPlan.premium;

  Future<void> setPlan(AppPlan plan) async {
    await _prefs.setString(_planKey, plan.name);
  }

  /// Sync the plan from the database profile value.
  /// Call this after fetching the user profile from Supabase.
  Future<void> syncPlanFromProfile(String planValue) async {
    final plan = planValue == 'premium' ? AppPlan.premium : AppPlan.free;
    await setPlan(plan);
  }
}

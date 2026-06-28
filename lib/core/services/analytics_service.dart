import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utility/dependency_injection.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_state.dart';

/// Tracks page visits by logging them to Supabase.
/// Works for all plans (free & premium).
class AnalyticsService {
  final SupabaseClient _client;
  String? _currentUserId;

  AnalyticsService(this._client);

  /// Set the current user ID (call on login/app open).
  void setUserId(String? userId) {
    _currentUserId = userId;
  }

  /// Log a page visit to Supabase.
  /// Fires silently — never blocks navigation or throws to the UI.
  Future<void> trackPageVisit(String pageName) async {
    // If ID is missing, try to get it from AuthBloc
    if (_currentUserId == null) {
      final authState = getIt<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        _currentUserId = authState.user.id;
      }
    }

    if (_currentUserId == null) {
      debugPrint('📊 Analytics: Skipping log for $pageName (No User ID)');
      return;
    }

    try {
      debugPrint('📊 Analytics: Logging page visit -> $pageName');
      await _client.from('page_visit_logs').insert({
        'user_id': _currentUserId,
        'page_name': pageName,
      });
    } catch (e) {
      debugPrint('❌ Analytics Error: Failed to log $pageName: $e');
    }
  }
}

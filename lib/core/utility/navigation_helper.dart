import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation helper that adapts based on platform
/// - Web: Uses context.go() to update browser URL
/// - Mobile: Uses context.push() for proper stack navigation
class NavigationHelper {
  static final Map<String, List<VoidCallback>> _webCallbacks = {};

  /// Navigate to a route with platform-aware behavior
  static void navigateTo(BuildContext context, String route) {
    if (kIsWeb) {
      context.go(route);
    } else {
      context.push(route);
    }
  }

  /// Navigate to a route and execute callback on return
  static Future<void> navigateToWithCallback(
    BuildContext context,
    String route,
    VoidCallback? onReturn,
  ) async {
    if (kIsWeb) {
      final currentRoute = GoRouterState.of(context).matchedLocation;
      if (onReturn != null) {
        _webCallbacks.putIfAbsent(currentRoute, () => []).add(onReturn);
      }
      context.go(route);
    } else {
      await context.push(route);
      onReturn?.call();
    }
  }

  /// Execute pending callbacks for the current route (Web only)
  static void executePendingCallbacks(BuildContext context) {
    if (!kIsWeb) return;

    final currentRoute = GoRouterState.of(context).matchedLocation;
    final callbacks = _webCallbacks.remove(currentRoute);

    if (callbacks != null) {
      for (final callback in callbacks) {
        callback();
      }
    }
  }

  /// Navigate and replace current route
  static void navigateReplace(BuildContext context, String route) {
    context.pushReplacement(route);
  }

  /// Go back to previous route
  static void goBack(BuildContext context) {
    context.pop();
  }

  /// Clear all pending callbacks
  static void clearAllCallbacks() {
    _webCallbacks.clear();
  }
}

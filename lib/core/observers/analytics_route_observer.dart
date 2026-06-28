import 'package:flutter/material.dart';
import '../services/analytics_service.dart';

/// A NavigatorObserver that automatically logs every page visit
/// to the cloud via AnalyticsService.
class AnalyticsRouteObserver extends NavigatorObserver {
  final AnalyticsService analyticsService;

  AnalyticsRouteObserver(this.analyticsService);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    debugPrint('🧐 Observer: didPush -> ${route.settings.name}');
    _logRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint('🧐 Observer: didReplace -> ${newRoute?.settings.name}');
    if (newRoute != null) _logRoute(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    debugPrint('🧐 Observer: didPop (Returning to) -> ${previousRoute?.settings.name}');
    if (previousRoute != null) _logRoute(previousRoute);
  }

  void _logRoute(Route<dynamic> route) {
    // Try Name first, then fallback to Path/Uri if available
    final pageName = route.settings.name ?? route.settings.arguments?.toString();
    
    debugPrint('📝 Observer: Attempting to log -> $pageName');

    if (pageName != null && pageName.isNotEmpty) {
      analyticsService.trackPageVisit(pageName);
    } else {
      debugPrint('⚠️ Observer: Ignored route (No name found)');
    }
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailoring_flutter/features/splash/presentation/splash_screen.dart';
import 'package:tailoring_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:tailoring_flutter/features/auth/bloc/auth_event.dart';
import 'package:tailoring_flutter/features/auth/bloc/auth_state.dart';
import 'package:tailoring_flutter/core/utility/dependency_injection.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState, AuthUser;
import 'package:tailoring_flutter/core/services/app_update_service.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tailoring_flutter/features/auth/domain/entities/auth_user.dart';

import '../../../test_helpers.dart';

void main() {
  const tUser = AuthUser(id: '1', email: 'test@example.com');

  setUp(() {
    getIt.reset();
    PackageInfo.setMockInitialValues(
      appName: 'Stitch',
      packageName: 'com.example.stitch',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider<AuthBloc>.value(
            value: authBloc,
            child: const SplashScreen(),
          ),
        ),
        GoRoute(path: '/home', builder: (context, state) => const Scaffold(body: Text('Home Page'))),
        GoRoute(path: '/welcome', builder: (context, state) => const Scaffold(body: Text('Welcome Page'))),
      ],
    );
  }

  testWidgets('renders SplashScreen and navigates to welcome when unauthenticated', (WidgetTester tester) async {
    final fakeAuthBloc = FakeAuthBloc(AuthUnauthenticated());
    final fakeSupabase = FakeSupabaseClient();
    final router = createRouter(fakeAuthBloc);
    
    getIt.registerSingleton<SupabaseClient>(fakeSupabase);
    getIt.registerSingleton<AppUpdateService>(FakeAppUpdateService());
    getIt.registerSingleton<AuthBloc>(fakeAuthBloc);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      
      expect(find.text('Tailoring'), findsOneWidget);
      
      // Wait for delay
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();
      
      expect(find.text('Welcome Page'), findsOneWidget);
    });
  });

  testWidgets('navigates to home when authenticated', (WidgetTester tester) async {
    final fakeAuthBloc = FakeAuthBloc(AuthAuthenticated(tUser));
    final fakeSupabase = FakeSupabaseClient();
    final router = createRouter(fakeAuthBloc);
    
    getIt.registerSingleton<SupabaseClient>(fakeSupabase);
    getIt.registerSingleton<AppUpdateService>(FakeAppUpdateService());
    getIt.registerSingleton<AuthBloc>(fakeAuthBloc);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();
      
      expect(find.text('Home Page'), findsOneWidget);
    });
  });

  testWidgets('shows update required screen when version is old', (WidgetTester tester) async {
    final fakeAuthBloc = FakeAuthBloc(AuthInitial());
    final fakeSupabase = FakeSupabaseClient(versionResponse: {'value': '9.9.9'});
    final router = createRouter(fakeAuthBloc);
    
    getIt.registerSingleton<SupabaseClient>(fakeSupabase);
    getIt.registerSingleton<AppUpdateService>(FakeAppUpdateService());
    getIt.registerSingleton<AuthBloc>(fakeAuthBloc);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      
      // Wait for async version check
      for(int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text('Update Required'), findsOneWidget);
      expect(find.text('Required: v9.9.9'), findsOneWidget);
    });
  });

  testWidgets('handles version check timeout gracefully by proceeding to welcome', (WidgetTester tester) async {
    final fakeAuthBloc = FakeAuthBloc(AuthUnauthenticated());
    final router = createRouter(fakeAuthBloc);
    
    getIt.registerSingleton<SupabaseClient>(FakeSupabaseClientWithError(TestHelper.timeoutError));
    getIt.registerSingleton<AppUpdateService>(FakeAppUpdateService());
    getIt.registerSingleton<AuthBloc>(fakeAuthBloc);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      
      // Wait for async version check and splash delay
      for(int i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Should bypass update screen and proceed to welcome
      expect(find.text('Welcome Page'), findsOneWidget);
    });
  });

  testWidgets('handles malformed version response gracefully', (WidgetTester tester) async {
    final fakeAuthBloc = FakeAuthBloc(AuthUnauthenticated());
    final router = createRouter(fakeAuthBloc);

    // Missing 'value' key
    getIt.registerSingleton<SupabaseClient>(FakeSupabaseClient(versionResponse: {'key': 'min_app_version'}));
    getIt.registerSingleton<AppUpdateService>(FakeAppUpdateService());
    getIt.registerSingleton<AuthBloc>(fakeAuthBloc);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      
      for(int i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text('Welcome Page'), findsOneWidget);
    });
  });
}

// --- Fakes ---

class FakeAuthBloc extends Fake implements AuthBloc {
  final AuthState _state;
  FakeAuthBloc(this._state);

  @override
  AuthState get state => _state;

  @override
  Stream<AuthState> get stream => const Stream.empty();

  @override
  void add(AuthEvent event) {}

  @override
  Future<void> close() async {}
}

class FakeAppUpdateService extends Fake implements AppUpdateService {
  String? updateRequiredVersion;
  @override
  void setUpdateRequired(String? version) {
    updateRequiredVersion = version;
  }
}

class FakeSupabaseClient extends Fake implements SupabaseClient {
  final Map<String, dynamic>? versionResponse;
  FakeSupabaseClient({this.versionResponse});

  @override
  SupabaseQueryBuilder from(String table) => FakeSupabaseQueryBuilder(versionResponse);
}

class FakeSupabaseQueryBuilder extends Fake implements SupabaseQueryBuilder {
  final Map<String, dynamic>? versionResponse;
  FakeSupabaseQueryBuilder(this.versionResponse);

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> select([String? columns]) => 
      FakePostgrestFilterBuilder(versionResponse);
}

class FakePostgrestFilterBuilder extends Fake implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {
  final Map<String, dynamic>? versionResponse;
  FakePostgrestFilterBuilder(this.versionResponse);

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> eq(String column, Object value) => this;
  
  @override
  PostgrestTransformBuilder<Map<String, dynamic>?> maybeSingle() => 
      FakePostgrestTransformBuilder<Map<String, dynamic>?>(versionResponse);
}

class FakePostgrestTransformBuilder<T> extends Fake implements PostgrestTransformBuilder<T> {
  final T _value;
  FakePostgrestTransformBuilder(this._value);



  @override
  Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError}) {
    return Future.value(_value).then(onValue, onError: onError);
  }
}

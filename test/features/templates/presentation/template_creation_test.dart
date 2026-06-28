import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailoring_flutter/features/templates/presentation/add_template_details_screen.dart';
import 'package:tailoring_flutter/features/templates/presentation/add_template_fields_screen.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_bloc.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_event.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_state.dart';
import 'package:tailoring_flutter/features/templates/domain/entities/template.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:tailoring_flutter/routes/app_router.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../../test_helpers.dart';

void main() {
  late MockTemplateBloc mockTemplateBloc;

  setUpAll(() {
    registerFallbackValue(LoadTemplates());
    registerFallbackValue(AddTemplate(const Template(id: '', name: '', category: '', iconCodePoint: 0, basePrice: 0, fields: [])));
  });

  setUp(() {
    mockTemplateBloc = MockTemplateBloc();
    when(() => mockTemplateBloc.state).thenReturn(TemplateInitial());
  });

  Widget wrapWithBloc(Widget child, {GoRouter? router}) {
    if (router != null) {
      return BlocProvider<TemplateBloc>.value(
        value: mockTemplateBloc,
        child: MaterialApp.router(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          routerConfig: router,
        ),
      );
    }

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: BlocProvider<TemplateBloc>.value(
        value: mockTemplateBloc,
        child: child,
      ),
    );
  }

  group('AddTemplateDetailsScreen', () {
    testWidgets('validation and navigation to fields', (tester) async {
      final router = GoRouter(
        initialLocation: AppRoutes.addTemplate,
        routes: [
          GoRoute(
            path: AppRoutes.addTemplate,
            builder: (context, state) => const AddTemplateDetailsScreen(),
          ),
          GoRoute(
            path: AppRoutes.addTemplateFields,
            builder: (context, state) => const Scaffold(body: Text('Fields Screen')),
          ),
        ],
      );

      await tester.pumpWidget(wrapWithBloc(const SizedBox(), router: router));
      await tester.pumpAndSettle();

      // Find by type and index since hintText matching failed
      await tester.enterText(find.byType(TextField).at(0), 'Shirt');
      await tester.enterText(find.byType(TextField).at(1), 'Men');
      await tester.enterText(find.byType(TextField).at(2), '500');
      await tester.pumpAndSettle();
      
      final continueButton = find.text('Continue to Fields');
      await tester.ensureVisible(continueButton);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      
      expect(find.text('Fields Screen'), findsOneWidget);
    });
  });

  group('AddTemplateFieldsScreen', () {
    testWidgets('adding and removing fields', (tester) async {
      final router = GoRouter(
        initialLocation: AppRoutes.addTemplateFields,
        routes: [
          GoRoute(
            path: AppRoutes.addTemplateFields,
            builder: (context, state) => const AddTemplateFieldsScreen(
              templateName: 'Shirt',
              category: 'Men',
              iconCodePoint: 0,
              basePrice: 500,
            ),
          ),
        ],
      );

      await tester.pumpWidget(wrapWithBloc(const SizedBox(), router: router));
      await tester.pumpAndSettle();

      // Add a preset field (e.g. BUST)
      final bustFinder = find.text('BUST');
      await tester.ensureVisible(bustFinder);
      await tester.tap(bustFinder);
      await tester.pumpAndSettle();
      
      expect(find.text('BUST'), findsWidgets);
      
      // Add custom field
      await tester.enterText(find.byType(TextField).last, 'COLLAR');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      
      expect(find.text('COLLAR'), findsOneWidget);
      
      // Remove field
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();
      
      expect(find.text('BUST'), findsOneWidget); // Only in preset list now
    });

    testWidgets('saving template dispatches event', (tester) async {
      final stateController = StreamController<TemplateState>();
      whenListen(
        mockTemplateBloc,
        stateController.stream,
        initialState: TemplateInitial(),
      );

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: AppRoutes.addTemplate, builder: (context, state) => const AddTemplateDetailsScreen()),
          GoRoute(
            path: AppRoutes.addTemplateFields,
            builder: (context, state) => const AddTemplateFieldsScreen(
              templateName: 'Shirt',
              category: 'Men',
              iconCodePoint: 0,
              basePrice: 500,
            ),
          ),
          GoRoute(path: '/', builder: (context, state) => const Scaffold(body: Text('Home'))),
        ],
      );

      await tester.pumpWidget(wrapWithBloc(const SizedBox(), router: router));
      await tester.pumpAndSettle();
      router.push(AppRoutes.addTemplate);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Shirt');
      await tester.enterText(find.byType(TextField).at(1), 'Men');
      await tester.enterText(find.byType(TextField).at(2), '500');
      await tester.pumpAndSettle();
      
      final continueButton = find.text('Continue to Fields');
      await tester.ensureVisible(continueButton);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      expect(find.byType(AddTemplateFieldsScreen), findsOneWidget, reason: 'Should be on Fields screen after tapping Continue');

      // Add field
      final bustFinder = find.text('BUST');
      await tester.ensureVisible(bustFinder);
      await tester.tap(bustFinder);
      await tester.pumpAndSettle();

      // Tap Save
      final saveFinder = find.text('Save Template');
      await tester.ensureVisible(saveFinder);
      await tester.tap(saveFinder);
      
      // Emit success state to trigger pop
      stateController.add(const TemplateAddSuccess([], Template(id: '1', name: 'Shirt', category: 'Men', iconCodePoint: 0, basePrice: 500, fields: ['BUST'])));
      await tester.pumpAndSettle();
      
      // Verify event is dispatched
      verify(() => mockTemplateBloc.add(any(that: isA<AddTemplate>()))).called(1);
      
      // Verify we are back home
      expect(find.text('Home'), findsOneWidget);

      stateController.close();
    });
  });
}

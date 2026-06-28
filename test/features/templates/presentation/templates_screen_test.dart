import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tailoring_flutter/features/templates/presentation/templates_screen.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_bloc.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_event.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_state.dart';
import 'package:tailoring_flutter/features/templates/domain/entities/template.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../test_helpers.dart';

void main() {
  late FakeTemplateBloc fakeTemplateBloc;

  setUpAll(() {
    TestHelper.registerFallbackValues();
  });

  setUp(() {
    fakeTemplateBloc = FakeTemplateBloc(TemplateInitial());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: ShowCaseWidget(
        builder: (context) => BlocProvider<TemplateBloc>.value(
          value: fakeTemplateBloc,
          child: const TemplatesScreen(),
        ),
      ),
    );
  }

  const tTemplates = [
    Template(
      id: '1',
      name: 'Custom Men Suit',
      category: 'Men',
      iconCodePoint: 123,
      fields: ['Length'],
    ),
    Template(
      id: '2',
      name: 'Special Blouse',
      category: 'Women',
      iconCodePoint: 456,
      fields: ['Length'],
    ),
  ];

  testWidgets('renders empty state when no templates', (WidgetTester tester) async {
    fakeTemplateBloc.emit(const TemplatesLoaded([]));
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('No templates yet'), findsOneWidget);
  });

  testWidgets('renders list of templates', (WidgetTester tester) async {
    fakeTemplateBloc.emit(const TemplatesLoaded(tTemplates));
    await tester.pumpWidget(createWidgetUnderTest());
    
    expect(find.text('Custom Men Suit'), findsOneWidget);
    expect(find.text('Special Blouse'), findsOneWidget);
  });

  testWidgets('filters templates based on search', (WidgetTester tester) async {
    fakeTemplateBloc.emit(const TemplatesLoaded(tTemplates));
    await tester.pumpWidget(createWidgetUnderTest());
    
    await tester.enterText(find.byType(TextField), 'Custom');
    await tester.pump();

    expect(find.text('Custom Men Suit'), findsOneWidget);
    expect(find.text('Special Blouse'), findsNothing);
  });

  testWidgets('shows no templates found for non-matching search', (WidgetTester tester) async {
    fakeTemplateBloc.emit(const TemplatesLoaded(tTemplates));
    await tester.pumpWidget(createWidgetUnderTest());
    
    await tester.enterText(find.byType(TextField), 'Random');
    await tester.pump();

    expect(find.text('No templates match.'), findsOneWidget);
  });
}

class FakeTemplateBloc extends Fake implements TemplateBloc {
  TemplateState _state;
  final List<TemplateEvent> addedEvents = [];

  FakeTemplateBloc(this._state);

  @override
  TemplateState get state => _state;

  @override
  Stream<TemplateState> get stream => Stream.value(_state);

  @override
  void emit(TemplateState newState) {
    _state = newState;
  }

  @override
  void add(TemplateEvent event) {
    addedEvents.add(event);
  }

  @override
  Future<void> close() async {}
}

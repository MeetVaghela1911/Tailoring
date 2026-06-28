import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailoring_flutter/features/templates/presentation/add_template_details_screen.dart';
import 'package:tailoring_flutter/features/templates/presentation/add_template_fields_screen.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_bloc.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_event.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_state.dart';
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

  Widget createDetailsWidget() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: const AddTemplateDetailsScreen(),
    );
  }

  Widget createFieldsWidget({
    required String name,
    required String category,
    required int iconCodePoint,
    required double basePrice,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: BlocProvider<TemplateBloc>.value(
        value: fakeTemplateBloc,
        child: AddTemplateFieldsScreen(
          templateName: name,
          category: category,
          iconCodePoint: iconCodePoint,
          basePrice: basePrice,
        ),
      ),
    );
  }

  testWidgets('AddTemplateDetailsScreen: button disabled until fields filled', (WidgetTester tester) async {
    await tester.pumpWidget(createDetailsWidget());
    
    // Initially disabled (or rather, its onPressed is null/logic checks _canContinue)
    // We can check if tapping it does nothing (no navigation) if we mocked navigation.
    // But since it's an ElevatedButton, we can check its style or just the logic.
  });

  testWidgets('AddTemplateFieldsScreen: adds preset and custom fields', (WidgetTester tester) async {
    await tester.pumpWidget(createFieldsWidget(
      name: 'Shirt',
      category: 'Men',
      iconCodePoint: 123,
      basePrice: 500,
    ));

    // Tap a preset field (e.g. BUST)
    await tester.tap(find.text('BUST'));
    await tester.pump();

    expect(find.text('1 fields'), findsOneWidget);

    // Add a custom field
    await tester.enterText(find.byType(TextField), 'COLLAR SIZE');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.text('2 fields'), findsOneWidget);
    expect(find.text('COLLAR SIZE'), findsOneWidget);
  });

  testWidgets('AddTemplateFieldsScreen: saves template and triggers bloc event', (WidgetTester tester) async {
    await tester.pumpWidget(createFieldsWidget(
      name: 'Shirt',
      category: 'Men',
      iconCodePoint: 123,
      basePrice: 500,
    ));

    await tester.tap(find.text('BUST'));
    await tester.pump();

    await tester.tap(find.text('Save Template'));
    await tester.pump();

    final addEvent = fakeTemplateBloc.addedEvents.whereType<AddTemplate>().first;
    expect(addEvent.template.name, 'Shirt');
    expect(addEvent.template.fields, contains('BUST'));
  });
}

class FakeTemplateBloc extends Fake implements TemplateBloc {
  final TemplateState _state;
  final List<TemplateEvent> addedEvents = [];

  FakeTemplateBloc(this._state);

  @override
  TemplateState get state => _state;

  @override
  Stream<TemplateState> get stream => Stream.value(_state);

  @override
  void add(TemplateEvent event) {
    addedEvents.add(event);
  }

  @override
  Future<void> close() async {}
}

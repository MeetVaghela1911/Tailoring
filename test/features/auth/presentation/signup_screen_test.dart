import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailoring_flutter/features/auth/presentation/signup_screen.dart';
import 'package:tailoring_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:tailoring_flutter/features/auth/bloc/auth_event.dart';
import 'package:tailoring_flutter/features/auth/bloc/auth_state.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  late FakeAuthBloc fakeAuthBloc;

  setUp(() {
    fakeAuthBloc = FakeAuthBloc(AuthInitial());
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
      home: BlocProvider<AuthBloc>.value(
        value: fakeAuthBloc,
        child: const SignupScreen(),
      ),
    );
  }

  testWidgets('renders signup screen correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Create an account'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3)); // Name, Email, Password
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('shows validation errors when fields are empty', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Enter password'), findsOneWidget);
  });

  testWidgets('dispatches SignUpRequested when form is valid', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(fakeAuthBloc.addedEvents.length, 1);
    expect(fakeAuthBloc.addedEvents.first, isA<SignUpRequested>());
    final signupEvent = fakeAuthBloc.addedEvents.first as SignUpRequested;
    expect(signupEvent.name, 'Test User');
    expect(signupEvent.email, 'test@example.com');
    expect(signupEvent.password, 'password123');
  });

  testWidgets('shows snackbar when state is AuthError', (WidgetTester tester) async {
    final controller = StreamController<AuthState>.broadcast();
    fakeAuthBloc = FakeAuthBloc(AuthInitial(), stream: controller.stream);
    
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    controller.add(const AuthError('Email already in use'));
    await tester.pump(); // Trigger listener
    
    expect(find.text('Email already in use'), findsOneWidget);
    
    await controller.close();
  });
}

class FakeAuthBloc extends Fake implements AuthBloc {
  final AuthState _state;
  final Stream<AuthState> _stream;
  final List<AuthEvent> addedEvents = [];

  FakeAuthBloc(this._state, {Stream<AuthState>? stream}) 
    : _stream = stream ?? const Stream.empty();

  @override
  AuthState get state => _state;

  @override
  Stream<AuthState> get stream => _stream;

  @override
  void add(AuthEvent event) {
    addedEvents.add(event);
  }

  @override
  Future<void> close() async {}
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailoring_flutter/features/auth/presentation/login_screen.dart';
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
        child: const LoginScreen(),
      ),
    );
  }

  testWidgets('renders login screen correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Use pump instead of pumpAndSettle due to repeat() animation

    expect(find.text('Sign in to your account'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('shows validation errors when fields are empty', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Enter password'), findsOneWidget);
  });

  testWidgets('dispatches LoginRequested when form is valid', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(fakeAuthBloc.addedEvents.length, 1);
    expect(fakeAuthBloc.addedEvents.first, isA<LoginRequested>());
    final loginEvent = fakeAuthBloc.addedEvents.first as LoginRequested;
    expect(loginEvent.email, 'test@example.com');
    expect(loginEvent.password, 'password123');
  });
  testWidgets('shows loading indicator when state is AuthLoading', (WidgetTester tester) async {
    fakeAuthBloc = FakeAuthBloc(AuthLoading());
    
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Login'), findsNothing);
  });

  testWidgets('shows snackbar when state is AuthError', (WidgetTester tester) async {
    final controller = StreamController<AuthState>.broadcast();
    fakeAuthBloc = FakeAuthBloc(AuthInitial(), stream: controller.stream);
    
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    controller.add(const AuthError('Invalid credentials'));
    await tester.pump(); // Trigger listener
    
    expect(find.text('Invalid credentials'), findsOneWidget);
    
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

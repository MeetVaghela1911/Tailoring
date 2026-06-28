import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:tailoring_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:tailoring_flutter/features/auth/bloc/auth_event.dart';
import 'package:tailoring_flutter/features/auth/bloc/auth_state.dart';
import 'package:tailoring_flutter/features/auth/domain/entities/auth_user.dart';
import 'package:tailoring_flutter/core/error/failures.dart';
import '../../../test_helpers.dart';

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockSignUpUseCase mockSignUpUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockAuthRepository mockAuthRepository;

  const tUser = AuthUser(id: '1', email: 'test@example.com');
  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tName = 'Test User';

  setUpAll(() {
    TestHelper.registerFallbackValues();
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSignUpUseCase = MockSignUpUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockAuthRepository = MockAuthRepository();

    // Default stub for the repository listener
    when(() => mockAuthRepository.onAuthStateChanged).thenAnswer((_) => const Stream.empty());

    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      signUpUseCase: mockSignUpUseCase,
      logoutUseCase: mockLogoutUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  test('initial state should be AuthInitial', () {
    expect(authBloc.state, isA<AuthInitial>());
  });

  group('AuthStatusChanged', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthAuthenticated] when user is not null',
      build: () => authBloc,
      act: (bloc) => bloc.add(const AuthStatusChanged(tUser)),
      expect: () => [AuthAuthenticated(tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthUnauthenticated] when user is null',
      build: () => authBloc,
      act: (bloc) => bloc.add(const AuthStatusChanged(null)),
      expect: () => [AuthUnauthenticated()],
    );
  });

  group('LoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login is successful',
      build: () {
        when(() => mockLoginUseCase(any())).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(email: tEmail, password: tPassword)),
      expect: () => [
        AuthLoading(),
        AuthAuthenticated(tUser),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockLoginUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Login failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(email: tEmail, password: tPassword)),
      expect: () => [
        AuthLoading(),
        const AuthError('Login failed'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] with "Invalid credentials" when password is wrong',
      build: () {
        when(() => mockLoginUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Invalid login credentials')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(email: tEmail, password: tPassword)),
      expect: () => [
        AuthLoading(),
        const AuthError('Invalid login credentials'),
      ],
    );
  });

  group('SignUpRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when signup is successful',
      build: () {
        when(() => mockSignUpUseCase(any())).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const SignUpRequested(email: tEmail, password: tPassword, name: tName)),
      expect: () => [
        AuthLoading(),
        AuthAuthenticated(tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when signup fails',
      build: () {
        when(() => mockSignUpUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Signup failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const SignUpRequested(email: tEmail, password: tPassword, name: tName)),
      expect: () => [
        AuthLoading(),
        const AuthError('Signup failed'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when email is already in use',
      build: () {
        when(() => mockSignUpUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('User already exists')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const SignUpRequested(email: tEmail, password: tPassword, name: tName)),
      expect: () => [
        AuthLoading(),
        const AuthError('User already exists'),
      ],
    );
  });

  group('SignOutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthUnauthenticated] when signout is successful',
      build: () {
        when(() => mockLogoutUseCase(any())).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignOutRequested()),
      expect: () => [
        AuthUnauthenticated(),
      ],
    );
  });
}

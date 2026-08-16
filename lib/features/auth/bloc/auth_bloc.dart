import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/auth_user.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/signup_usecase.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/services/plan_service.dart';
import '../../../../core/utility/dependency_injection.dart';
import '../../sync/domain/services/sync_manager.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthRepository _authRepository;
  StreamSubscription<AuthUser?>? _authSubscription;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required SignUpUseCase signUpUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _signUpUseCase = signUpUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<ProfileUpdated>(_onProfileUpdated);
    on<ShopUpdated>(_onShopUpdated);
    on<RefreshUser>(_onRefreshUser);

    // Listen to auth state changes from repository
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    _authSubscription = _authRepository.onAuthStateChanged.listen((user) {
      add(AuthStatusChanged(user));
    });
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signUpUseCase(SignUpParams(
      email: event.email,
      password: event.password,
      name: event.name,
    ));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _loginUseCase(LoginParams(
      email: event.email,
      password: event.password,
    ));
    await result.fold(
      (failure) async => emit(AuthError(failure.message)),
      (user) async {
        final profilePlan = user.profile?.plan ?? 'free';
        await getIt<PlanService>().syncPlanFromProfile(profilePlan);
        await getIt<SyncManager>().syncData();
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) async {
    if (event.user != null) {
      final profilePlan = event.user!.profile?.plan ?? 'free';
      await getIt<PlanService>().syncPlanFromProfile(profilePlan);
      await getIt<SyncManager>().syncData();
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onRefreshUser(
    RefreshUser event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCurrentUserUseCase(NoParams());
    await result.fold(
      (failure) async => null, // silently ignore refresh failures
      (user) async {
        if (user != null) {
          final profilePlan = user.profile?.plan ?? 'free';
          await getIt<PlanService>().syncPlanFromProfile(profilePlan);
          await getIt<SyncManager>().syncData();
          emit(AuthAuthenticated(user));
        }
      },
    );
  }

  Future<void> _onProfileUpdated(
    ProfileUpdated event,
    Emitter<AuthState> emit,
  ) async {
    final currentUser = state is AuthAuthenticated
        ? (state as AuthAuthenticated).user
        : null;
    if (currentUser != null) emit(ProfileSaving(currentUser));

    // Step 1: persist the profile
    final saveResult = await _authRepository.updateProfile(event.profile);
    // Use fold() only to extract a failure synchronously
    final saveFailure = saveResult.fold((f) => f, (_) => null);
    if (saveFailure != null) {
      emit(AuthError(saveFailure.message, user: currentUser));
      return;
    }

    // Step 2: reload the full user (with updated profile+shop from Supabase)
    final userResult = await _getCurrentUserUseCase(NoParams());
    final userFailure = userResult.fold((f) => f, (_) => null);
    if (userFailure != null) {
      emit(AuthError(userFailure.message, user: currentUser));
      return;
    }
    final freshUser = userResult.fold((_) => null, (u) => u);
    if (freshUser != null && !emit.isDone) emit(AuthAuthenticated(freshUser));
  }

  Future<void> _onShopUpdated(
    ShopUpdated event,
    Emitter<AuthState> emit,
  ) async {
    final currentUser = state is AuthAuthenticated
        ? (state as AuthAuthenticated).user
        : state is ShopSaving
            ? (state as ShopSaving).user
            : null;
    if (currentUser != null) emit(ShopSaving(currentUser));

    // Step 1: persist the shop
    final saveResult = await _authRepository.updateShop(event.shop);
    final saveFailure = saveResult.fold((f) => f, (_) => null);
    if (saveFailure != null) {
      emit(AuthError(saveFailure.message, user: currentUser));
      return;
    }

    // Step 2: reload the full user
    final userResult = await _getCurrentUserUseCase(NoParams());
    final userFailure = userResult.fold((f) => f, (_) => null);
    if (userFailure != null) {
      emit(AuthError(userFailure.message, user: currentUser));
      return;
    }
    final freshUser = userResult.fold((_) => null, (u) => u);
    if (freshUser != null && !emit.isDone) emit(AuthAuthenticated(freshUser));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}

// Extension or modification to AuthState/AuthEvent might be needed if they depend on Firebase User
// Let's check those files.

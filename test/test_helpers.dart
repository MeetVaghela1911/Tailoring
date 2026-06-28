import 'dart:async';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState, AuthUser;
import 'package:tailoring_flutter/features/onboarding/presentation/bloc/walkthrough_cubit.dart';
import 'package:tailoring_flutter/core/services/app_update_service.dart';
import 'package:tailoring_flutter/core/services/analytics_service.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_bloc.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_event.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_state.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_event.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_state.dart';
import 'package:tailoring_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:tailoring_flutter/core/service/storage_service.dart';
import 'package:tailoring_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:tailoring_flutter/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tailoring_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:tailoring_flutter/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tailoring_flutter/features/auth/domain/usecases/signup_usecase.dart';
import 'package:tailoring_flutter/features/customers/domain/entities/customer.dart';
import 'package:tailoring_flutter/features/customers/domain/repositories/customer_repository.dart';
import 'package:tailoring_flutter/features/customers/domain/usecases/add_customer_usecase.dart';
import 'package:tailoring_flutter/features/customers/domain/usecases/delete_customer_usecase.dart';
import 'package:tailoring_flutter/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:tailoring_flutter/features/customers/domain/usecases/update_customer_usecase.dart';
import 'package:tailoring_flutter/core/usecase/usecase.dart';
import 'package:tailoring_flutter/features/auth/domain/entities/auth_user.dart' as entity;
import 'package:tailoring_flutter/features/templates/domain/entities/template.dart';
import 'package:tailoring_flutter/features/templates/domain/repositories/template_repository.dart';
import 'package:tailoring_flutter/features/templates/domain/usecases/add_template_usecase.dart';
import 'package:tailoring_flutter/features/templates/domain/usecases/delete_template_usecase.dart';
import 'package:tailoring_flutter/features/templates/domain/usecases/get_templates_usecase.dart';
import 'package:tailoring_flutter/features/templates/domain/usecases/update_template_usecase.dart';
import 'package:tailoring_flutter/features/orders/domain/entities/order_entity.dart';
import 'package:tailoring_flutter/features/orders/domain/repositories/order_repository.dart';
import 'package:tailoring_flutter/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:tailoring_flutter/features/orders/domain/usecases/delete_order_usecase.dart';
import 'package:tailoring_flutter/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:tailoring_flutter/features/orders/domain/usecases/update_order_usecase.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_wizard_bloc.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_bloc.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_event.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_state.dart';

// --- Supabase Mocks ---
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockPostgrestFilterBuilder<T> extends Mock implements PostgrestFilterBuilder<T> {}
class MockPostgrestTransformBuilder<T> extends Mock implements PostgrestTransformBuilder<T> {}

class FakePostgrestTransformBuilder<T> extends Fake implements PostgrestTransformBuilder<T> {
  final T _value;
  FakePostgrestTransformBuilder(this._value);

  @override
  Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError}) {
    return Future.value(_value).then(onValue);
  }
}

// --- Service Mocks ---
class MockAppUpdateService extends Mock implements AppUpdateService {}

// --- Bloc Mocks ---
class MockAuthBloc extends Mock implements AuthBloc {}

// --- Router Mocks ---
class MockGoRouter extends Mock implements GoRouter {}
class MockStorageService extends Mock implements StorageService {}
class MockAnalyticsService extends Mock implements AnalyticsService {}
class MockCustomerBloc extends MockBloc<CustomerEvent, CustomerState> implements CustomerBloc {}
class MockTemplateBloc extends MockBloc<TemplateEvent, TemplateState> implements TemplateBloc {}

// --- Auth Mocks ---
class MockAuthRepository extends Mock implements AuthRepository {}
class MockCustomerRepository extends Mock implements CustomerRepository {}
class MockTemplateRepository extends Mock implements TemplateRepository {}
class MockOrderRepository extends Mock implements OrderRepository {}

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockSignUpUseCase extends Mock implements SignUpUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockGetCustomersUseCase extends Mock implements GetCustomersUseCase {}
class MockAddCustomerUseCase extends Mock implements AddCustomerUseCase {}
class MockUpdateCustomerUseCase extends Mock implements UpdateCustomerUseCase {}
class MockDeleteCustomerUseCase extends Mock implements DeleteCustomerUseCase {}

class MockGetTemplatesUseCase extends Mock implements GetTemplatesUseCase {}
class MockAddTemplateUseCase extends Mock implements AddTemplateUseCase {}
class MockUpdateTemplateUseCase extends Mock implements UpdateTemplateUseCase {}
class MockDeleteTemplateUseCase extends Mock implements DeleteTemplateUseCase {}

class MockCreateOrderUseCase extends Mock implements CreateOrderUseCase {}
class MockDeleteOrderUseCase extends Mock implements DeleteOrderUseCase {}
class MockGetOrdersUseCase extends Mock implements GetOrdersUseCase {}
class MockUpdateOrderUseCase extends Mock implements UpdateOrderUseCase {}
class MockOrderWizardBloc extends MockBloc<OrderWizardEvent, OrderWizardState> implements OrderWizardBloc {}
class MockOrderBloc extends MockBloc<OrderEvent, OrderState> implements OrderBloc {}
class FakeAuthUser extends Fake implements entity.AuthUser {}

// --- Test Utilities ---
class TestHelper {
  static const String timeoutError = 'Connection timeout';
  static const String malformedError = 'Malformed response';
  
  static void registerFallbackValues() {
    registerFallbackValue(LoginParams(email: '', password: ''));
    registerFallbackValue(SignUpParams(email: '', password: '', name: ''));
    registerFallbackValue(NoParams());
    registerFallbackValue(Customer(
      id: '1', 
      name: '', 
      phoneNumber: '', 
      createdAt: DateTime.now()
    ));
    registerFallbackValue(const Template(
      id: '1',
      name: '',
      category: '',
      iconCodePoint: 0,
      fields: [],
    ));
    registerFallbackValue(OrderEntity(
      id: '1',
      garmentTypes: const [],
      specialInstructions: '',
      measurements: const {},
      priorityIndex: 0,
      assignedTailor: '',
      totalAmount: 0,
      advancePaid: 0,
      paymentMode: 0,
      status: '',
      createdAt: DateTime.now(),
    ));
    registerFallbackValue(LoadOrders());
    registerFallbackValue(UpdateOrder(OrderEntity(
      id: '1',
      garmentTypes: const [],
      specialInstructions: '',
      measurements: const {},
      priorityIndex: 0,
      assignedTailor: '',
      totalAmount: 0,
      advancePaid: 0,
      paymentMode: 0,
      status: '',
      createdAt: DateTime.now(),
    )));
    registerFallbackValue(File(''));
  }
}

class FakeSupabaseClientWithError extends Fake implements SupabaseClient {
  final String errorMessage;
  FakeSupabaseClientWithError(this.errorMessage);

  @override
  SupabaseQueryBuilder from(String table) => throw AuthException(errorMessage);
}

class FakeWalkthroughCubit extends Fake implements WalkthroughCubit {
  WalkthroughState _state;
  FakeWalkthroughCubit([WalkthroughState? initialState]) : _state = initialState ?? WalkthroughInitial();

  @override
  WalkthroughState get state => _state;

  @override
  Stream<WalkthroughState> get stream => Stream.value(_state);

  @override
  void emit(WalkthroughState newState) {
    _state = newState;
  }

  @override
  bool isCustomerShown = false;
  @override
  bool isTemplateTabShown = false;
  @override
  bool isTemplateScreenShown = false;
  @override
  bool isOrderTabShown = false;
  @override
  bool isOrderScreenShown = false;

  @override
  Future<void> checkWalkthroughState({
    required int customersCount,
    required int templatesCount,
    required int ordersCount,
  }) async {}

  @override
  Future<void> markCustomerShown() async {}

  @override
  Future<void> markTemplateTabShown() async {}

  @override
  Future<void> markTemplateScreenShown() async {}

  @override
  Future<void> markOrderTabShown() async {}

  @override
  Future<void> markOrderScreenShown() async {}

  @override
  Future<void> restartWalkthrough() async {}

  @override
  Future<void> close() async {}
}

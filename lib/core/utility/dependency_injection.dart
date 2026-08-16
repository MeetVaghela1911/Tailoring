import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';

import '../../core/database/local_database.dart';
import '../../core/services/plan_service.dart';
import '../../core/services/app_update_service.dart';
import '../../core/services/analytics_service.dart';

import '../../features/customers/data/datasources/customer_remote_data_source.dart';
import '../../features/customers/data/datasources/customer_local_data_source.dart';
import '../../features/customers/data/repositories/customer_repository_impl.dart';
import '../../features/customers/domain/repositories/customer_repository.dart';
import '../../features/customers/domain/usecases/add_customer_usecase.dart';
import '../../features/customers/domain/usecases/delete_customer_usecase.dart';
import '../../features/customers/domain/usecases/get_customers_usecase.dart';
import '../../features/customers/domain/usecases/update_customer_usecase.dart';

import '../../features/templates/data/datasources/template_remote_data_source.dart';
import '../../features/templates/data/datasources/template_local_data_source.dart';
import '../../features/templates/data/repositories/template_repository_impl.dart';
import '../../features/templates/domain/repositories/template_repository.dart';
import '../../features/templates/domain/usecases/add_template_usecase.dart';
import '../../features/templates/domain/usecases/delete_template_usecase.dart';
import '../../features/templates/domain/usecases/get_templates_usecase.dart';
import '../../features/templates/domain/usecases/update_template_usecase.dart';

import '../../features/orders/data/datasources/order_remote_data_source.dart';
import '../../features/orders/data/datasources/order_local_data_source.dart';
import '../../features/orders/data/datasources/lookup_remote_data_source.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/orders/domain/usecases/create_order_usecase.dart';
import '../../features/orders/domain/usecases/delete_order_usecase.dart';
import '../../features/orders/domain/usecases/get_orders_usecase.dart';
import '../../features/orders/domain/usecases/update_order_usecase.dart';

import '../../features/customers/presentation/bloc/customer_bloc.dart';
import '../../features/templates/presentation/bloc/template_bloc.dart';
import '../../features/orders/presentation/bloc/order_bloc.dart';
import '../../features/orders/presentation/bloc/order_wizard_bloc.dart';
import '../../features/onboarding/presentation/bloc/walkthrough_cubit.dart';

import '../../features/sync/domain/services/cloud_sync_service.dart';
import '../../features/sync/domain/services/sync_manager.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/network/network_info.dart';
import '../../features/payments/data/datasources/payment_local_data_source.dart';
import '../../features/payments/data/datasources/payment_remote_data_source.dart';
import '../../features/payments/data/repositories/payment_repository_impl.dart';
import '../../features/payments/domain/repositories/payment_repository.dart';
import '../../features/payments/presentation/bloc/payment_bloc.dart';

import '../../firebase_options.dart';
import '../service/auth_service.dart';
import '../service/storage_service.dart';
import 'supabase_config.dart';

import '../services/notification_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // 💾 Initialize Local Storage & Preferences
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  
  final localDb = LocalDatabase();
  await localDb.init();
  getIt.registerLazySingleton<LocalDatabase>(() => localDb);

  // 🔔 Initialize Notification Service
  final notificationService = NotificationService();
  await notificationService.init();
  getIt.registerLazySingleton<NotificationService>(() => notificationService);

  // 🔑 Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🚀 Initialize Supabase
  await supabase.Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // --- External ---
  final supabaseClient = supabase.Supabase.instance.client;
  getIt.registerLazySingleton<supabase.SupabaseClient>(() => supabaseClient);
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  // --- DataSources ---
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => SupabaseAuthRemoteDataSource(getIt<supabase.SupabaseClient>(), getIt<SharedPreferences>()));
  
  getIt.registerLazySingleton<CustomerRemoteDataSource>(() => SupabaseCustomerRemoteDataSource(getIt<supabase.SupabaseClient>()));
  getIt.registerLazySingleton<CustomerLocalDataSource>(() => CustomerLocalDataSourceImpl(localDb: getIt<LocalDatabase>()));

  getIt.registerLazySingleton<TemplateRemoteDataSource>(() => SupabaseTemplateRemoteDataSource(getIt<supabase.SupabaseClient>()));
  getIt.registerLazySingleton<TemplateLocalDataSource>(() => TemplateLocalDataSourceImpl(localDb: getIt<LocalDatabase>()));

  getIt.registerLazySingleton<OrderRemoteDataSource>(() => SupabaseOrderRemoteDataSource(getIt<supabase.SupabaseClient>()));
  getIt.registerLazySingleton<OrderLocalDataSource>(() => OrderLocalDataSourceImpl(localDb: getIt<LocalDatabase>()));
  getIt.registerLazySingleton<LookupRemoteDataSource>(() => SupabaseLookupRemoteDataSource(getIt<supabase.SupabaseClient>()));

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt<Connectivity>()));
  getIt.registerLazySingleton<PaymentLocalDataSource>(() => PaymentLocalDataSourceImpl(localDb: getIt<LocalDatabase>()));
  getIt.registerLazySingleton<PaymentRemoteDataSource>(() => PaymentRemoteDataSourceImpl(supabaseClient: getIt<supabase.SupabaseClient>()));

  // --- Services ---
  getIt.registerLazySingleton<AppUpdateService>(() => AppUpdateService());
  getIt.registerLazySingleton<PlanService>(() => PlanService(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<FirebaseAuth>()));
  getIt.registerLazySingleton<StorageService>(() => SupabaseStorageService(getIt<supabase.SupabaseClient>()));
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService(getIt<supabase.SupabaseClient>()));
  
  getIt.registerLazySingleton<CloudSyncService>(() => CloudSyncService(
        customerLocal: getIt<CustomerLocalDataSource>(),
        customerRemote: getIt<CustomerRemoteDataSource>(),
        templateLocal: getIt<TemplateLocalDataSource>(),
        templateRemote: getIt<TemplateRemoteDataSource>(),
        orderLocal: getIt<OrderLocalDataSource>(),
        orderRemote: getIt<OrderRemoteDataSource>(),
        planService: getIt<PlanService>(),
      ));

  getIt.registerLazySingleton<SyncManager>(() => SyncManager(
        customerLocal: getIt<CustomerLocalDataSource>(),
        customerRemote: getIt<CustomerRemoteDataSource>(),
        templateLocal: getIt<TemplateLocalDataSource>(),
        templateRemote: getIt<TemplateRemoteDataSource>(),
        orderLocal: getIt<OrderLocalDataSource>(),
        orderRemote: getIt<OrderRemoteDataSource>(),
        planService: getIt<PlanService>(),
      ));
  
  // Initialize SyncManager
  getIt<SyncManager>().init();

  // --- Repositories ---
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: getIt<AuthRemoteDataSource>(),
        localDatabase: getIt<LocalDatabase>(),
      ));
  getIt.registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImpl(
        remoteDataSource: getIt<CustomerRemoteDataSource>(),
        localDataSource: getIt<CustomerLocalDataSource>(),
        planService: getIt<PlanService>(),
        syncManager: getIt<SyncManager>(),
      ));
  getIt.registerLazySingleton<TemplateRepository>(() => TemplateRepositoryImpl(
        remoteDataSource: getIt<TemplateRemoteDataSource>(),
        localDataSource: getIt<TemplateLocalDataSource>(),
        planService: getIt<PlanService>(),
        syncManager: getIt<SyncManager>(),
      ));
  getIt.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(
        remoteDataSource: getIt<OrderRemoteDataSource>(),
        localDataSource: getIt<OrderLocalDataSource>(),
        planService: getIt<PlanService>(),
        syncManager: getIt<SyncManager>(),
        paymentLocalDataSource: getIt<PaymentLocalDataSource>(),
        paymentRemoteDataSource: getIt<PaymentRemoteDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ));
  getIt.registerLazySingleton<PaymentRepository>(() => PaymentRepositoryImpl(
        localDataSource: getIt<PaymentLocalDataSource>(),
        remoteDataSource: getIt<PaymentRemoteDataSource>(),
        orderLocalDataSource: getIt<OrderLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ));

  // --- UseCases ---
  // Auth
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt<AuthRepository>()));

  // Customers
  getIt.registerLazySingleton(() => GetCustomersUseCase(getIt<CustomerRepository>()));
  getIt.registerLazySingleton(() => AddCustomerUseCase(getIt<CustomerRepository>()));
  getIt.registerLazySingleton(() => UpdateCustomerUseCase(getIt<CustomerRepository>()));
  getIt.registerLazySingleton(() => DeleteCustomerUseCase(getIt<CustomerRepository>()));

  // Templates
  getIt.registerLazySingleton(() => GetTemplatesUseCase(getIt<TemplateRepository>()));
  getIt.registerLazySingleton(() => AddTemplateUseCase(getIt<TemplateRepository>()));
  getIt.registerLazySingleton(() => UpdateTemplateUseCase(getIt<TemplateRepository>()));
  getIt.registerLazySingleton(() => DeleteTemplateUseCase(getIt<TemplateRepository>()));

  // Orders
  getIt.registerLazySingleton(() => GetOrdersUseCase(getIt<OrderRepository>()));
  getIt.registerLazySingleton(() => CreateOrderUseCase(getIt<OrderRepository>()));
  getIt.registerLazySingleton(() => UpdateOrderUseCase(getIt<OrderRepository>()));
  getIt.registerLazySingleton(() => DeleteOrderUseCase(getIt<OrderRepository>()));

  // --- Blocs ---
  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory<CustomerBloc>(
    () => CustomerBloc(
      getCustomersUseCase: getIt<GetCustomersUseCase>(),
      addCustomerUseCase: getIt<AddCustomerUseCase>(),
      updateCustomerUseCase: getIt<UpdateCustomerUseCase>(),
      deleteCustomerUseCase: getIt<DeleteCustomerUseCase>(),
    ),
  );

  getIt.registerFactory<TemplateBloc>(
    () => TemplateBloc(
      getTemplatesUseCase: getIt<GetTemplatesUseCase>(),
      addTemplateUseCase: getIt<AddTemplateUseCase>(),
      updateTemplateUseCase: getIt<UpdateTemplateUseCase>(),
      deleteTemplateUseCase: getIt<DeleteTemplateUseCase>(),
    ),
  );

  getIt.registerFactory<OrderBloc>(
    () => OrderBloc(
      getOrdersUseCase: getIt<GetOrdersUseCase>(),
      createOrderUseCase: getIt<CreateOrderUseCase>(),
      updateOrderUseCase: getIt<UpdateOrderUseCase>(),
      deleteOrderUseCase: getIt<DeleteOrderUseCase>(),
    ),
  );

  getIt.registerFactory<PaymentBloc>(
    () => PaymentBloc(
      repository: getIt<PaymentRepository>(),
    ),
  );

  getIt.registerLazySingleton<OrderWizardBloc>(
    () => OrderWizardBloc(),
  );

  getIt.registerLazySingleton<WalkthroughCubit>(
    () => WalkthroughCubit(),
  );
}

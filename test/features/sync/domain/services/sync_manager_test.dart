import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tailoring_flutter/core/services/plan_service.dart';
import 'package:tailoring_flutter/features/customers/data/datasources/customer_local_data_source.dart';
import 'package:tailoring_flutter/features/customers/data/datasources/customer_remote_data_source.dart';
import 'package:tailoring_flutter/features/orders/data/datasources/order_local_data_source.dart';
import 'package:tailoring_flutter/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:tailoring_flutter/features/sync/domain/services/sync_manager.dart';
import 'package:tailoring_flutter/features/templates/data/datasources/template_local_data_source.dart';
import 'package:tailoring_flutter/features/templates/data/datasources/template_remote_data_source.dart';

class MockCustomerLocalDataSource extends Mock implements CustomerLocalDataSource {}
class MockCustomerRemoteDataSource extends Mock implements CustomerRemoteDataSource {}
class MockTemplateLocalDataSource extends Mock implements TemplateLocalDataSource {}
class MockTemplateRemoteDataSource extends Mock implements TemplateRemoteDataSource {}
class MockOrderLocalDataSource extends Mock implements OrderLocalDataSource {}
class MockOrderRemoteDataSource extends Mock implements OrderRemoteDataSource {}
class MockPlanService extends Mock implements PlanService {}
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late SyncManager syncManager;
  late MockCustomerLocalDataSource customerLocal;
  late MockCustomerRemoteDataSource customerRemote;
  late MockTemplateLocalDataSource templateLocal;
  late MockTemplateRemoteDataSource templateRemote;
  late MockOrderLocalDataSource orderLocal;
  late MockOrderRemoteDataSource orderRemote;
  late MockPlanService planService;
  late MockConnectivity connectivity;

  setUp(() {
    customerLocal = MockCustomerLocalDataSource();
    customerRemote = MockCustomerRemoteDataSource();
    templateLocal = MockTemplateLocalDataSource();
    templateRemote = MockTemplateRemoteDataSource();
    orderLocal = MockOrderLocalDataSource();
    orderRemote = MockOrderRemoteDataSource();
    planService = MockPlanService();
    connectivity = MockConnectivity();

    syncManager = SyncManager(
      customerLocal: customerLocal,
      customerRemote: customerRemote,
      templateLocal: templateLocal,
      templateRemote: templateRemote,
      orderLocal: orderLocal,
      orderRemote: orderRemote,
      planService: planService,
      connectivity: connectivity,
    );
  });

  group('SyncManager.syncData', () {
    test('should abort if plan is free', () async {
      // Arrange
      when(() => planService.currentPlan).thenReturn(AppPlan.free);

      // Act
      await syncManager.syncData();

      // Assert
      verifyNever(() => connectivity.checkConnectivity());
    });

    test('should abort if offline', () async {
      // Arrange
      when(() => planService.currentPlan).thenReturn(AppPlan.premium);
      when(() => connectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.none]);

      // Act
      await syncManager.syncData();

      // Assert
      verify(() => connectivity.checkConnectivity()).called(1);
      verifyNever(() => customerLocal.getUnsyncedCustomers());
    });

    test('should perform full two-way sync if premium and online', () async {
      // Arrange
      when(() => planService.currentPlan).thenReturn(AppPlan.premium);
      when(() => connectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);

      // Mock push methods
      when(() => customerLocal.getUnsyncedCustomers()).thenAnswer((_) async => []);
      when(() => templateLocal.getUnsyncedTemplates()).thenAnswer((_) async => []);
      when(() => orderLocal.getUnsyncedOrders()).thenAnswer((_) async => []);

      // Mock pull methods
      when(() => customerRemote.getCustomers()).thenAnswer((_) async => []);
      when(() => templateRemote.getTemplates()).thenAnswer((_) async => []);
      when(() => orderRemote.getOrders()).thenAnswer((_) async => []);

      // Act
      await syncManager.syncData();

      // Assert
      verify(() => customerLocal.getUnsyncedCustomers()).called(1);
      verify(() => templateLocal.getUnsyncedTemplates()).called(1);
      verify(() => orderLocal.getUnsyncedOrders()).called(1);
      
      verify(() => customerRemote.getCustomers()).called(1);
      verify(() => templateRemote.getTemplates()).called(1);
      verify(() => orderRemote.getOrders()).called(1);
    });

    test('should catch exceptions during pull and continue without crashing', () async {
      // Arrange
      when(() => planService.currentPlan).thenReturn(AppPlan.premium);
      when(() => connectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);

      when(() => customerLocal.getUnsyncedCustomers()).thenAnswer((_) async => []);
      when(() => templateLocal.getUnsyncedTemplates()).thenAnswer((_) async => []);
      when(() => orderLocal.getUnsyncedOrders()).thenAnswer((_) async => []);

      when(() => customerRemote.getCustomers()).thenThrow(Exception('Network error'));
      when(() => templateRemote.getTemplates()).thenAnswer((_) async => []);
      when(() => orderRemote.getOrders()).thenAnswer((_) async => []);

      // Act
      await syncManager.syncData();

      // Assert
      verify(() => customerRemote.getCustomers()).called(1);
      verify(() => templateRemote.getTemplates()).called(1);
      verify(() => orderRemote.getOrders()).called(1);
    });
  });
}

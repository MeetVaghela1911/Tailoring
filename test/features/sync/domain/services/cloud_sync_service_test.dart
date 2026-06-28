import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tailoring_flutter/core/services/plan_service.dart';
import 'package:tailoring_flutter/features/customers/data/datasources/customer_local_data_source.dart';
import 'package:tailoring_flutter/features/customers/data/datasources/customer_remote_data_source.dart';
import 'package:tailoring_flutter/features/customers/data/models/customer_model.dart';
import 'package:tailoring_flutter/features/customers/data/models/customer_local_model.dart';
import 'package:tailoring_flutter/features/orders/data/datasources/order_local_data_source.dart';
import 'package:tailoring_flutter/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:tailoring_flutter/features/orders/data/models/order_model.dart';
import 'package:tailoring_flutter/features/orders/data/models/order_local_model.dart';
import 'package:tailoring_flutter/features/sync/domain/services/cloud_sync_service.dart';
import 'package:tailoring_flutter/features/templates/data/datasources/template_local_data_source.dart';
import 'package:tailoring_flutter/features/templates/data/datasources/template_remote_data_source.dart';
import 'package:tailoring_flutter/features/templates/data/models/template_model.dart';
import 'package:tailoring_flutter/features/templates/data/models/template_local_model.dart';

class MockCustomerLocalDataSource extends Mock implements CustomerLocalDataSource {}
class MockCustomerRemoteDataSource extends Mock implements CustomerRemoteDataSource {}
class MockTemplateLocalDataSource extends Mock implements TemplateLocalDataSource {}
class MockTemplateRemoteDataSource extends Mock implements TemplateRemoteDataSource {}
class MockOrderLocalDataSource extends Mock implements OrderLocalDataSource {}
class MockOrderRemoteDataSource extends Mock implements OrderRemoteDataSource {}
class MockPlanService extends Mock implements PlanService {}

class FakeCustomerModel extends Fake implements CustomerModel {}
class FakeTemplateModel extends Fake implements TemplateModel {}
class FakeOrderModel extends Fake implements OrderModel {}

void main() {
  late CloudSyncService syncService;
  late MockCustomerLocalDataSource customerLocal;
  late MockCustomerRemoteDataSource customerRemote;
  late MockTemplateLocalDataSource templateLocal;
  late MockTemplateRemoteDataSource templateRemote;
  late MockOrderLocalDataSource orderLocal;
  late MockOrderRemoteDataSource orderRemote;
  late MockPlanService planService;

  setUpAll(() {
    registerFallbackValue(FakeCustomerModel());
    registerFallbackValue(FakeTemplateModel());
    registerFallbackValue(FakeOrderModel());
  });

  setUp(() {
    customerLocal = MockCustomerLocalDataSource();
    customerRemote = MockCustomerRemoteDataSource();
    templateLocal = MockTemplateLocalDataSource();
    templateRemote = MockTemplateRemoteDataSource();
    orderLocal = MockOrderLocalDataSource();
    orderRemote = MockOrderRemoteDataSource();
    planService = MockPlanService();

    syncService = CloudSyncService(
      customerLocal: customerLocal,
      customerRemote: customerRemote,
      templateLocal: templateLocal,
      templateRemote: templateRemote,
      orderLocal: orderLocal,
      orderRemote: orderRemote,
      planService: planService,
    );
  });

  group('CloudSyncService.migrateLocalDataToCloud', () {
    test('should migrate empty lists successfully and update plan to premium', () async {
      // Arrange
      when(() => customerLocal.getUnsyncedCustomers()).thenAnswer((_) async => []);
      when(() => templateLocal.getUnsyncedTemplates()).thenAnswer((_) async => []);
      when(() => orderLocal.getUnsyncedOrders()).thenAnswer((_) async => []);
      when(() => planService.setPlan(AppPlan.premium)).thenAnswer((_) async {});

      // Act
      await syncService.migrateLocalDataToCloud();

      // Assert
      verify(() => customerLocal.getUnsyncedCustomers()).called(1);
      verify(() => templateLocal.getUnsyncedTemplates()).called(1);
      verify(() => orderLocal.getUnsyncedOrders()).called(1);
      verify(() => planService.setPlan(AppPlan.premium)).called(1);

      verifyNever(() => customerRemote.addCustomer(any()));
      verifyNever(() => templateRemote.addTemplate(any()));
      verifyNever(() => orderRemote.createOrder(any()));
    });

    test('should migrate unsynced data to remote and mark as synced', () async {
      // Arrange
      final customer = CustomerLocalModel()
        ..remoteId = 'cust1'
        ..name = 'Test Cust'
        ..phoneNumber = '123'
        ..createdAt = DateTime.now();

      final template = TemplateLocalModel()
        ..remoteId = 'temp1'
        ..name = 'Test Temp'
        ..category = 'Men'
        ..iconCodePoint = 1
        ..iconFontFamily = 'font'
        ..fields = ['field1']
        ..basePrice = 10.0;

      final order = OrderLocalModel()
        ..remoteId = 'ord1'
        ..customerId = 'cust1'
        ..customerName = 'Test Cust'
        ..customerPhone = '123'
        ..garmentTypes = ['temp1']
        ..measurementsJson = '{"field1":"10"}'
        ..deliveryDate = DateTime.now()
        ..priorityIndex = 1
        ..totalAmount = 100
        ..advancePaid = 10
        ..paymentMode = 1
        ..status = 'Pending'
        ..createdAt = DateTime.now();

      when(() => customerLocal.getUnsyncedCustomers()).thenAnswer((_) async => [customer]);
      when(() => customerRemote.addCustomer(any())).thenAnswer((_) async => CustomerModel(
        id: 'cust1', name: 'Test Cust', phoneNumber: '123', createdAt: customer.createdAt,
      ));
      when(() => customerLocal.markAsSynced(any())).thenAnswer((_) async {});

      when(() => templateLocal.getUnsyncedTemplates()).thenAnswer((_) async => [template]);
      when(() => templateRemote.addTemplate(any())).thenAnswer((_) async => TemplateModel(
        id: 'temp1', name: 'Test Temp', category: 'Men', iconCodePoint: 1, fields: ['field1'], basePrice: 10.0,
      ));
      when(() => templateLocal.markAsSynced(any())).thenAnswer((_) async {});

      when(() => orderLocal.getUnsyncedOrders()).thenAnswer((_) async => [order]);
      when(() => orderLocal.getOrderById('ord1')).thenAnswer((_) async => OrderModel(
        id: 'ord1', customerId: 'cust1', customerName: 'Test Cust', customerPhone: '123',
        garmentTypes: ['temp1'], measurements: {'field1': '10'}, deliveryDate: order.deliveryDate,
        priorityIndex: 1, totalAmount: 100, advancePaid: 10, paymentMode: 1, status: 'Pending', createdAt: order.createdAt, specialInstructions: '', assignedTailor: '',
      ));
      when(() => orderRemote.createOrder(any())).thenAnswer((_) async => OrderModel(
        id: 'ord1', customerId: 'cust1', customerName: 'Test Cust', customerPhone: '123',
        garmentTypes: ['temp1'], measurements: {'field1': '10'}, deliveryDate: order.deliveryDate,
        priorityIndex: 1, totalAmount: 100, advancePaid: 10, paymentMode: 1, status: 'Pending', createdAt: order.createdAt, specialInstructions: '', assignedTailor: '',
      ));
      when(() => orderLocal.markAsSynced(any())).thenAnswer((_) async {});

      when(() => planService.setPlan(AppPlan.premium)).thenAnswer((_) async {});

      // Act
      await syncService.migrateLocalDataToCloud();

      // Assert
      verify(() => customerRemote.addCustomer(any())).called(1);
      verify(() => customerLocal.markAsSynced('cust1')).called(1);

      verify(() => templateRemote.addTemplate(any())).called(1);
      verify(() => templateLocal.markAsSynced('temp1')).called(1);

      verify(() => orderRemote.createOrder(any())).called(1);
      verify(() => orderLocal.markAsSynced('ord1')).called(1);
      
      verify(() => planService.setPlan(AppPlan.premium)).called(1);
    });

    test('should throw exception and abort migration if any operation fails', () async {
      // Arrange
      final customer = CustomerLocalModel()
        ..remoteId = 'cust1'
        ..name = 'Test Cust'
        ..phoneNumber = '123'
        ..createdAt = DateTime.now();

      when(() => customerLocal.getUnsyncedCustomers()).thenAnswer((_) async => [customer]);
      when(() => customerRemote.addCustomer(any())).thenThrow(Exception('Network error'));
      
      // Act & Assert
      expect(
        () => syncService.migrateLocalDataToCloud(),
        throwsA(isA<Exception>())
      );

      // Verify that further steps are not executed
      verifyNever(() => customerLocal.markAsSynced(any()));
      verifyNever(() => templateLocal.getUnsyncedTemplates());
      verifyNever(() => planService.setPlan(AppPlan.premium));
    });
  });
}

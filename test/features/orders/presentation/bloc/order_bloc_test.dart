import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_bloc.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_event.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_state.dart';
import 'package:tailoring_flutter/features/orders/domain/entities/order_entity.dart';
import 'package:tailoring_flutter/core/error/failures.dart';
import '../../../../test_helpers.dart';

void main() {
  late OrderBloc orderBloc;
  late MockGetOrdersUseCase mockGetOrdersUseCase;
  late MockCreateOrderUseCase mockCreateOrderUseCase;
  late MockUpdateOrderUseCase mockUpdateOrderUseCase;
  late MockDeleteOrderUseCase mockDeleteOrderUseCase;

  final tOrder = OrderEntity(
    id: '1',
    customerName: 'John',
    garmentTypes: const ['Shirt'],
    specialInstructions: 'None',
    measurements: const {'Length': '40'},
    priorityIndex: 0,
    assignedTailor: 'Tailor 1',
    totalAmount: 1000,
    advancePaid: 500,
    paymentMode: 0,
    status: 'Pending',
    createdAt: DateTime.now(),
  );
  final tOrders = [tOrder];

  setUpAll(() {
    TestHelper.registerFallbackValues();
  });

  setUp(() {
    mockGetOrdersUseCase = MockGetOrdersUseCase();
    mockCreateOrderUseCase = MockCreateOrderUseCase();
    mockUpdateOrderUseCase = MockUpdateOrderUseCase();
    mockDeleteOrderUseCase = MockDeleteOrderUseCase();

    orderBloc = OrderBloc(
      getOrdersUseCase: mockGetOrdersUseCase,
      createOrderUseCase: mockCreateOrderUseCase,
      updateOrderUseCase: mockUpdateOrderUseCase,
      deleteOrderUseCase: mockDeleteOrderUseCase,
    );
  });

  tearDown(() {
    orderBloc.close();
  });

  test('initial state should be OrderInitial', () {
    expect(orderBloc.state, isA<OrderInitial>());
  });

  group('LoadOrders', () {
    blocTest<OrderBloc, OrderState>(
      'emits [OrderLoading, OrdersLoaded] when successful',
      build: () {
        when(() => mockGetOrdersUseCase(any())).thenAnswer((_) async => Right(tOrders));
        return orderBloc;
      },
      act: (bloc) => bloc.add(LoadOrders()),
      expect: () => [
        OrderLoading(),
        OrdersLoaded(tOrders),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emits [OrderLoading, OrderError] when failure occurs',
      build: () {
        when(() => mockGetOrdersUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Fail')));
        return orderBloc;
      },
      act: (bloc) => bloc.add(LoadOrders()),
      expect: () => [
        OrderLoading(),
        const OrderError('Fail'),
      ],
    );
  });

  group('CreateOrder (Optimistic)', () {
    blocTest<OrderBloc, OrderState>(
      'emits [OrdersLoaded (optimistic), OrderCreateSuccess] when successful',
      build: () {
        when(() => mockCreateOrderUseCase(any())).thenAnswer((_) async => Right(tOrder));
        return orderBloc;
      },
      seed: () => const OrdersLoaded([]),
      act: (bloc) => bloc.add(CreateOrder(tOrder)),
      expect: () => [
        OrdersLoaded([tOrder]),
        OrderCreateSuccess([tOrder], tOrder),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emits [OrdersLoaded (optimistic), OrderError, OrdersLoaded (reverted)] when failure occurs',
      build: () {
        when(() => mockCreateOrderUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Create failed')));
        return orderBloc;
      },
      seed: () => const OrdersLoaded([]),
      act: (bloc) => bloc.add(CreateOrder(tOrder)),
      expect: () => [
        OrdersLoaded([tOrder]),
        const OrderError('Create failed'),
        const OrdersLoaded([]),
      ],
    );
  });

  group('UpdateOrder (Optimistic)', () {
    final updatedOrder = OrderEntity(
      id: '1',
      customerName: 'John Updated',
      garmentTypes: const ['Shirt'],
      specialInstructions: 'None',
      measurements: const {'Length': '40'},
      priorityIndex: 0,
      assignedTailor: 'Tailor 1',
      totalAmount: 1000,
      advancePaid: 500,
      paymentMode: 0,
      status: 'Completed',
      createdAt: tOrder.createdAt,
    );

    blocTest<OrderBloc, OrderState>(
      'emits [OrdersLoaded (optimistic), OrderUpdateSuccess] when successful',
      build: () {
        when(() => mockUpdateOrderUseCase(any())).thenAnswer((_) async => Right(updatedOrder));
        return orderBloc;
      },
      seed: () => OrdersLoaded(tOrders),
      act: (bloc) => bloc.add(UpdateOrder(updatedOrder)),
      expect: () => [
        OrdersLoaded([updatedOrder]),
        OrderUpdateSuccess([updatedOrder], updatedOrder),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emits [OrdersLoaded (optimistic), OrderError, OrdersLoaded (reverted)] when failure occurs',
      build: () {
        when(() => mockUpdateOrderUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Update failed')));
        return orderBloc;
      },
      seed: () => OrdersLoaded(tOrders),
      act: (bloc) => bloc.add(UpdateOrder(updatedOrder)),
      expect: () => [
        OrdersLoaded([updatedOrder]),
        const OrderError('Update failed'),
        OrdersLoaded(tOrders),
      ],
    );
  });

  group('DeleteOrder (Optimistic)', () {
    blocTest<OrderBloc, OrderState>(
      'emits [OrdersLoaded (optimistic), OrderDeleteSuccess] when successful',
      build: () {
        when(() => mockDeleteOrderUseCase(any())).thenAnswer((_) async => const Right(null));
        return orderBloc;
      },
      seed: () => OrdersLoaded(tOrders),
      act: (bloc) => bloc.add(const DeleteOrder('1')),
      expect: () => [
        const OrdersLoaded([]),
        const OrderDeleteSuccess([], '1'),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emits [OrdersLoaded (optimistic), OrderError, OrdersLoaded (reverted)] when failure occurs',
      build: () {
        when(() => mockDeleteOrderUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Delete failed')));
        return orderBloc;
      },
      seed: () => OrdersLoaded(tOrders),
      act: (bloc) => bloc.add(const DeleteOrder('1')),
      expect: () => [
        const OrdersLoaded([]),
        const OrderError('Delete failed'),
        OrdersLoaded(tOrders),
      ],
    );
  });
}

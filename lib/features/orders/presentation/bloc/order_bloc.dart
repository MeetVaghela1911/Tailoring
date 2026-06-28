import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/delete_order_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/update_order_usecase.dart';
import '../../../../core/usecase/usecase.dart';
import 'order_event.dart';
import 'order_state.dart';
import '../../domain/entities/order_entity.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrdersUseCase getOrdersUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final UpdateOrderUseCase updateOrderUseCase;
  final DeleteOrderUseCase deleteOrderUseCase;

  OrderBloc({
    required this.getOrdersUseCase,
    required this.createOrderUseCase,
    required this.updateOrderUseCase,
    required this.deleteOrderUseCase,
  }) : super(OrderInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<CreateOrder>(_onCreateOrder);
    on<UpdateOrder>(_onUpdateOrder);
    on<DeleteOrder>(_onDeleteOrder);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await getOrdersUseCase(NoParams());
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    final currentState = state;
    List<OrderEntity> currentOrders = [];
    if (currentState is OrdersLoaded) {
      currentOrders = List<OrderEntity>.from(currentState.orders);
    }

    // Optimistic Update
    final optimisticList = List<OrderEntity>.from(currentOrders)..add(event.order);
    emit(OrdersLoaded(optimisticList));

    final result = await createOrderUseCase(event.order);
    result.fold(
      (failure) {
        // Revert on failure
        emit(OrderError(failure.message));
        emit(OrdersLoaded(currentOrders));
      },
      (_) => emit(OrderCreateSuccess(optimisticList, event.order)),
    );
  }

  Future<void> _onUpdateOrder(
    UpdateOrder event,
    Emitter<OrderState> emit,
  ) async {
    final currentState = state;
    List<OrderEntity> currentOrders = [];
    if (currentState is OrdersLoaded) {
      currentOrders = List<OrderEntity>.from(currentState.orders);
    }

    // Optimistic Update
    final optimisticList = currentOrders.map<OrderEntity>((o) {
      return o.id == event.order.id ? event.order : o;
    }).toList();
    emit(OrdersLoaded(optimisticList));

    final result = await updateOrderUseCase(event.order);
    result.fold(
      (failure) {
        // Revert on failure
        emit(OrderError(failure.message));
        emit(OrdersLoaded(currentOrders));
      },
      (_) => emit(OrderUpdateSuccess(optimisticList, event.order)),
    );
  }

  Future<void> _onDeleteOrder(
    DeleteOrder event,
    Emitter<OrderState> emit,
  ) async {
    final currentState = state;
    List<OrderEntity> currentOrders = [];
    if (currentState is OrdersLoaded) {
      currentOrders = List<OrderEntity>.from(currentState.orders);
    }

    // Optimistic Update
    final optimisticList = currentOrders.where((o) => o.id != event.id).toList();
    emit(OrdersLoaded(optimisticList));

    final result = await deleteOrderUseCase(event.id);
    result.fold(
      (failure) {
        // Revert on failure
        emit(OrderError(failure.message));
        emit(OrdersLoaded(currentOrders));
      },
      (_) => emit(OrderDeleteSuccess(optimisticList, event.id)),
    );
  }
}

import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<OrderEntity> orders;
  final String? message;
  const OrdersLoaded(this.orders, {this.message});

  @override
  List<Object?> get props => [orders, message];
}

class OrderCreateSuccess extends OrdersLoaded {
  final OrderEntity order;
  const OrderCreateSuccess(super.orders, this.order);
  @override
  List<Object?> get props => [orders, order];
}

class OrderUpdateSuccess extends OrdersLoaded {
  final OrderEntity order;
  const OrderUpdateSuccess(super.orders, this.order);
  @override
  List<Object?> get props => [orders, order];
}

class OrderDeleteSuccess extends OrdersLoaded {
  final String id;
  const OrderDeleteSuccess(super.orders, this.id);
  @override
  List<Object?> get props => [orders, id];
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}

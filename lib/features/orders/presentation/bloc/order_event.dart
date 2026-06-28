import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrderEvent {}

class CreateOrder extends OrderEvent {
  final OrderEntity order;
  const CreateOrder(this.order);

  @override
  List<Object> get props => [order];
}

class UpdateOrder extends OrderEvent {
  final OrderEntity order;
  const UpdateOrder(this.order);

  @override
  List<Object> get props => [order];
}

class DeleteOrder extends OrderEvent {
  final String id;
  const DeleteOrder(this.id);

  @override
  List<Object> get props => [id];
}

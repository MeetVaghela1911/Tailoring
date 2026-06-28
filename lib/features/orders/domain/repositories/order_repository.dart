import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders();
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order);
  Future<Either<Failure, OrderEntity>> updateOrder(OrderEntity order);
  Future<Either<Failure, void>> deleteOrder(String id);
  Future<Either<Failure, OrderEntity?>> getOrderById(String id);
}

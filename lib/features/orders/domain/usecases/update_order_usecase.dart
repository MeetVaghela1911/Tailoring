import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class UpdateOrderUseCase implements UseCase<OrderEntity, OrderEntity> {
  final OrderRepository repository;

  UpdateOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(OrderEntity order) async {
    return await repository.updateOrder(order);
  }
}
